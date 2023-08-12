/**************************************************************************************
@Name           DoctorEmailService class
@Author         Pasula shashank
@Date           26/05/2023
@Description    Send Email to the doctor When the admin upadate doctor record.
***************************************************************************************
Modification Log
Verssion    Developer           Date             Description
----------------------------------------------------------------------------------------
1.0       Pasula shashank    26/05/2023        Created class , created sendEmails method                                         
***************************************************************************************/
public class DoctorEmailService {
    public static void sendEmails(List<Doctor__c> doctors) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        Set<Id> lastModifierIds = new Set<Id>();
        for (Doctor__c doc : doctors) {
            lastModifierIds.add(doc.LastModifiedById);
        }
        
        Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Email FROM User WHERE Id IN :lastModifierIds]);
        
        for (Doctor__c doc : doctors) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            // Set the email properties
            email.setToAddresses(new List<String>{doc.Email__c});
            email.setSubject('Profile Update Confirmation');
            email.setPlainTextBody('Dear ' + doc.Last_Name__c + ',\n\n'+
                                   'We are pleased to inform you that your profile has been successfully updated by our administrative team. Your updated information is now available in our system, ensuring that patients have access to the most accurate and comprehensive details regarding your practice.\n\n'
                                   +'We appreciate your cooperation in promptly providing the necessary updates, as this ensures that our records remain up-to-date and facilitates efficient communication between you and your profile. Should you have any questions or require further assistance, please feel free to contact us.\n\n'
                                   +'Thanking you for your continued commitment to providing exceptional care to our patients. Should you have any questions or require further assistance, please feel free to contact us.\n\n'
                                   +'Best regards,\nAdmin\n' + userMap.get(doc.LastModifiedById).Email);
            
            emails.add(email);
        }
        
        // Send the emails
        Messaging.sendEmail(emails);
    }
}