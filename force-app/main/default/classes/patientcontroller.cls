public with sharing class patientcontroller {
	@AuraEnabled(cacheable=true)
    public static Patient__c getUserRecordByEmail(String email) {
        return [SELECT Id, First_Name__c, Last_Name__c FROM Patient__C WHERE Email__c = :email LIMIT 1];
    }
}