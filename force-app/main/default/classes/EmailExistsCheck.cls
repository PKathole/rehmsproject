public with sharing class EmailExistsCheck {
    
    @AuraEnabled
    public static void checkEmailExists(String email) {
        try {
            List<User> existingUsers = [SELECT Id FROM User WHERE Email = :email LIMIT 1];
            if (!existingUsers.isEmpty()) {
                throw new AuraHandledException('Email already exists.');
            }
        } catch (Exception e) {
            throw new AuraHandledException('An error occurred while checking the email.');
        }
    }
}