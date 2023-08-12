public without sharing class Patient {
    
    @Auraenabled(cacheable=true)
    public static Id getPatientId(string email){
        
        Patient__c pt=[SELECT Id from Patient__c where Email__c=:email];
        return pt.Id;
    }
    
    @Auraenabled
    public static string changePassword(string email){
        
        try{
            user u1=[Select Id,Email from user where Email=:email LIMIT 1];
            System.resetPassword(u1.Id,true);
            return u1.Email;
        }
        catch(Exception e) {
            system.debug('e.getMessagelogin+   '+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

}