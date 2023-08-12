public without sharing class sendEmailToAdmin {
    
    @AuraEnabled
    public static void sendEmail(string fname , string lname , string phone , string email , string qualification , Integer exp , 
                                 Integer fees , string specialization , string address){
                                     
        system.debug('Inside apex class ');
        system.debug('fname :: '+fname + lname + phone + 'email :'+email + qualification + exp +fees + specialization + address);
        
        profile pId = [select id from Profile Where Name='System Administrator' LIMIT 1] ;                             
        
        user u = [SELECT Email from user where ProfileId=:pId.Id] ;
		system.debug('user Email :: '+u.email);
        list<string> adminEmail = new list<string>{u.Email} ;
        system.debug('adminEmail :: '+adminEmail);
                                     
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.toAddresses = adminEmail ;
		message.subject = 'Request to edit the my profile \n\n';
        							 string body = 'Dear Admin ,\n\n';
        							 body = body + 'I am writing to request changes to my profile .\n' ;
        							 body = body + 'I have included a table below with the relevant details .\n\n';
                                     body = body + 'Note : (If in the below table Experience and Fees field have value as 0 that means \'No Change\')\n\n\n';
                                     body = body + 'FIRST NAME		: '+fname+'\n';
                                     body = body + 'LAST NAME		: '+lname+'\n';
                                     body = body + 'MOBILE NUMBER	: '+phone+'\n';
                                     body = body + 'EMAIL			: '+email+'\n';
                                     body = body + 'QUALIFICATION	: '+qualification+'\n';
                                     body = body + 'EXPERIENCE		: '+exp+'\n';
                                     body = body + 'FEES			: '+fees+'\n';
                                     body = body + 'SPECIALIZATION	: '+specialization+'\n';
                                     body = body + 'ADDRESS			: '+address +'\n\n\n';
                                     body = body + 'Please update my profile with the changes listed above . \n';
                                     body = body + 'If you require any additional information or have any questions ,\n';
                                     body = body + 'Please let me know .\n';
                                     body = body + 'Thank you for your attention to this matter .\n\n';
                                     body = body + 'Best regards ' + fname +' '+ lname ;
		message.plainTextBody = body ;
		Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

		if (results[0].success) {
    		System.debug('The email was sent successfully.');
		} else {
		    System.debug('The email failed to send: ' + results[0].errors[0].message);
			}
    	}
    
    
    @AuraEnabled(cacheable=true)
    public static void sendEmailOnTransfer(string appId , string doctorName ,string patientId ,string patientName ,string specialization ,string appDate , string bookedSlot , string phone){
        system.debug('Inside trasfer email');
        
        profile pId = [select id from Profile Where Name='System Administrator' LIMIT 1] ;                             
        
        user u = [SELECT Email from user where ProfileId=:pId.Id] ;
		system.debug('user Email :: '+u.email);
        list<string> adminEmail = new list<string>{u.Email} ;
        system.debug('adminEmail :: '+adminEmail);
        try{                             
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.toAddresses = adminEmail ;

        message.subject = 'Request for Appointment Transfer - '+appId+' \n\n';
        							 string body = 'Dear Admin ,\n\n';
        							 body = body + 'I hope this email finds you well. I am writing to request a transfer of an upcoming appointment for a patient under my care to another doctor. The details of the appointment transfer are as follows: \n' ;
        							 body = body + 'Transfer Initiated By:'+doctorName+'\n\n';
                                     body = body + 'Patient ID: '+patientId+'\n';
                                     body = body + 'Patient Name	: '+patientName+'\n';
                                     body = body + 'Specialization	: '+specialization+'\n';
                                     body = body + 'Appointment Date: '+appDate+'\n';
                                     body = body + 'Appointment Time: '+bookedSlot+'\n';
                                     body = body + 'Due to unforeseen circumstances, it is necessary to reschedule this appointment. I kindly request your assistance in transferring this appointment to a new doctor who specializes in '+ specialization +'\n';
                                     body = body + 'Please coordinate with time slots of the doctors to ensure a smooth transition of care for the patient.\n';
                                     body = body + 'Once the transfer is confirmed, kindly inform the patient, and provide them with the updated details of the appointment, including the new doctors name, specialization, and the rescheduled date and time.  \n';
                                     body = body + 'I appreciate your prompt attention to this matter. If you need more information or have questions about the transfer process, please contact me. \n';
                                     body = body + 'Thank you for your cooperation and for facilitating the transfer of care for our patient. \n\n';
                                     body = body + 'Best regards, \n';
                                     body = body +'Dr. '+ doctorName +'\n';
                                     body = body +phone+ '\n';
        
		message.plainTextBody = body ;
		Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        
		if (results[0].success) {
    		System.debug('The email was sent successfully.');
		} else {
		    System.debug('The email failed to send: ' + results[0].errors[0].message);
			}
            
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    	
    } 
    

}