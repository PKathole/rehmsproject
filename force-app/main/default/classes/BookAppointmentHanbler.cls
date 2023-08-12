public class BookAppointmentHanbler {
	public static void sendEmails(List<Book_Appointment__c> records) {
        // Collect the record IDs for the updated records
        Set<Id> recordIds = new Set<Id>();

        for (Book_Appointment__c record : records){
            Id recordId = Id.valueOf(record.Id);
            Book_Appointment__c oldRecord = (Book_Appointment__c)Trigger.oldMap.get(recordId);
            // Check if the lookup field has changed
            if (record.Doctor__c != oldRecord.Doctor__c){
                recordIds.add(record.Id);
            }
        }

        // Query the records with updated lookup field and their email addresses
        List<Book_Appointment__c> recordsWithEmails = [SELECT Id,Doctor__r.Name,Appointment_Status__c,Name, Patient_Email__c,Specializtion__c,Patient__r.Name,patient_name__c, Appointment_Date__c, Booked_Slot__c
                                                 FROM Book_Appointment__c
                                                 WHERE Id IN :recordIds];
       
		
        // Send emails
        for (Book_Appointment__c record : recordsWithEmails) {
            String toAddress = record.Patient_Email__c;
            String subject = 'Your Appointment Has Been Transferred to a New Doctor';
            String body = 'Dear '+ record.patient_name__c+', \n'+
                			'We regret to inform you that your scheduled appointment On '+record.Appointment_Date__c +' and ' + record.Booked_Slot__c+ ' \n'+
                			'has been transferred to a new doctor due to unforeseen\n circumstances.\n\n'+
                            'Your new doctor is '+ record.Doctor__r.Name +', who is also a qualified medical professional and \n'+
                			'will provide you with the same high-quality care you expect from us. Your appointment details \n'+ 'remain unchanged.\n\n'+
                            
                           	'BID (Booking ID) : '+record.Name+'\n'+
                            'Patient ID : '+record.Patient__r.Name+'\n'+
                            'Patient Name : '+record.patient_name__c+'\n'+
                            'Specialization : '+record.Specializtion__c+'\n'+
                            'Time Slot : '+record.Booked_Slot__c+'\n'+
                            'Date : '+record.Appointment_Date__c + '\n'+
                            
                            '		If you have any questions or concerns, please do not hesitate to contact us at\n'+ ' moekahospitals@gmail.com'+
                			'. Thank you for your understanding.\n\n'+
               
                            
                            'Best Regards.\n'+
                            'Moeka Hospitals.';
            
            				// update the status
                            record.Appointment_Status__c='Completed';
                            update record;
            
            				EmailUtility.sendEmail(toAddress, subject, body);
        }
    }
}