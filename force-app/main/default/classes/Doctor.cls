public  without sharing class Doctor {
	@Auraenabled(cacheable=true)
    public static Id getDoctorId(string email){
        
        Doctor__c doc=[SELECT Id from Doctor__c where Email__c=:email];
        return doc.Id;
    }
}