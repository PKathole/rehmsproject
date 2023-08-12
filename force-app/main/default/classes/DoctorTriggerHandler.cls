/********************************************************************************************
@Name           DoctorTriggerHandler class
@Author         Pasula shashank
@Date           26/05/2023
@Description    Doctor Object Trigger Handler
*********************************************************************************************
Modification Log
Verssion    Developer           Date             Description
---------------------------------------------------------------------------------------------
1.0       Pasula shashank    26/05/2023         Created class,created handleAfterUpdate method 
2.0		  Pasula shashank	 30/05/2023			created updateAssociatedUserEmail method
*********************************************************************************************/
public class DoctorTriggerHandler {
    public static void handleAfterUpdate(List<Doctor__c> updatedDoctors, Map<Id, Doctor__c> oldMap) {
        List<Doctor__c> updatedRecords = new List<Doctor__c>();

        for (Doctor__c doc : updatedDoctors) {
            Doctor__c oldDoctor = oldMap.get(doc.Id);
            if (doc.LastModifiedDate!= oldDoctor.LastModifiedDate && doc.IsActive__c==true) {
                updatedRecords.add(doc);
            }
        }

        if (!updatedRecords.isEmpty()) {
            DoctorEmailService.sendEmails(updatedRecords);
        }
    }
    
    public static void updateAssociatedUserEmail(List<Doctor__c> newDoctors, Map<Id, Doctor__c> oldDoctorMap) {
        List<User> usersToUpdate = new List<User>();

        for (Doctor__c newDoctor : newDoctors) {
            Doctor__c oldDoctor = oldDoctorMap.get(newDoctor.Id);

            // Check if the email field has been changed
            if (!newDoctor.Email__c.equalsIgnoreCase(oldDoctor.Email__c)) {
                String newEmail = newDoctor.Email__c;

                // Find the associated User record based on the email field
                List<User> matchingUsers = [SELECT Id, Email FROM User WHERE Email = :oldDoctor.Email__c];
                if (!matchingUsers.isEmpty()) {
                    for (User user : matchingUsers) {
                        // Update the email field in the User object
                        user.Email = newEmail;
                        usersToUpdate.add(user);
                    }
                }
            }
        }

        if (!usersToUpdate.isEmpty()) {
            update usersToUpdate;
        }
    }
    
   
    
}