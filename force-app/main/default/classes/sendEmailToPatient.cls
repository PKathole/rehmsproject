public without sharing class sendEmailToPatient {

    @AuraEnabled
    public static void sendCancelAppEmail(string patientEmail  , string patientName , Date appDate , string appTime ){
        
        list<string> emails = new list<string>{patientEmail};
        system.debug('Emails Apex :: '+emails);
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.toAddresses = emails ;
        message.subject = 'Appointment Cancelled \n\n';
        string body = 'Dear '+patientName+',\n\n';
        body = body +'This mail is being sent to confirm the cancellation of your appointment with <Doctors Name> scheduled for.'+appDate+'  '+appTime+'\n\n';
        body = body + 'We understand that sometimes it becomes necessary to reschedule or cancel appointments due to unforeseen circumstances. However, we would like to remind you that cancelling an appointment may affect your treatment plan and may result in delays in receiving care. \n\n';
        body = body + 'We hope that you will be able to reschedule your appointment soon. If you would like to do so, please let us know at your earliest convenience, and we will be happy to arrange another appointment time that suits you. \n\n';
        body = body + 'If you have any questions or concerns, please do not hesitate to contact us, we are always here to assist you in any way we can. \n\n\n';
        body = body + 'Thank you \n';
        body = body + 'Best Regards,\n';
        body = body + 'Moeka Hospitals.';
        
        message.plainTextBody = body ;
		Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

		if (results[0].success) {
    		System.debug('The email sent successfully.');
		} else {
		    System.debug('The email failed to send: ' + results[0].errors[0].message);
		}
    }
}