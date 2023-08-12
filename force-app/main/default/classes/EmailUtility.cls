/**************************************************************************************
@Name           EmailUtility class
@Author         Pasula shashank
@Date           21/01/2023
@Description    EmailUtility
***************************************************************************************
Modification Log
Verssion    Developer           Date             Description
----------------------------------------------------------------------------------------
1.0       Pasula shashank    21/01/2023         Created class                                           
***************************************************************************************/
public class EmailUtility{
    
    public static void sendEmail(String toAddress, String subject, String body) {
        try{
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{ toAddress });
        email.setSubject(subject);
        email.setPlainTextBody(body);
        
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
    	}
        catch (Exception e) {            
            throw new AuraHandledException(e.getMessage());
        }
    }
}