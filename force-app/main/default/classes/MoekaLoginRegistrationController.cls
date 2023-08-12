public without sharing class MoekaLoginRegistrationController {
    
    @AuraEnabled
    public static string registerUser(string firstName, string lastName, string email,string gender,date dateofBirth,string phone,string bloodGroup,string address){
        try {
            List<User> existingUsers = [SELECT Id FROM User WHERE Email = :email LIMIT 1];
            if (!existingUsers.isEmpty()) {
                throw new AuraHandledException('Email already exists.');
            }
            
            Account acc = [SELECT Id from Account where Name='Moeka Hospital' LIMIT 1];

          
            Contact c = new Contact(
                firstName = firstName,
                LastName = lastName,
                Email = email,
                AccountId = acc.Id
            );
            upsert c;

          
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name='Patient Portal Profile' LIMIT 1];
            Integer randomNum = (Integer)(Math.random() * Math.pow(10, 12 - 11) + Math.pow(10, 11));
           
            User user1 = new User(
                UserName = email,
                FirstName = firstName,
                LastName = lastName,
                Alias = firstName.substring(0, 3).toLowerCase() + lastName.substring(0, 3).toLowerCase(),
                email = email,
                ContactId = c.Id,
                ProfileId = portalProfile.Id,
                EmailEncodingKey = 'UTF-8',
                CommunityNickname = lastName + randomNum,
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert user1;
            
            Patient__c p1=new Patient__c();
            p1.First_Name__c=firstName;
            p1.Last_Name__c=lastName;
            p1.Email__c=email;
            p1.Gender__c=gender;
            p1.Date_Of_Birth__c=dateofBirth;
            p1.Phone_Number__c=string.valueOf(phone);
            p1.Blood_Group__c=bloodGroup;
            p1.Address__c=address;
            p1.OwnerId=user1.Id;
            
            insert p1;
            
            return p1.Email__c;
            
        } catch (Exception e) {
            system.debug('e.getMessagelogin+'+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
}