public without sharing class SelectDoctor {
    
    @Auraenabled(cacheable=true)
    public static List<Doctor__c> getDoctors(string specialization){
        
        List<Doctor__c> listofDoctors=[SELECT Name,Specialization__c,Achievements__c,Experience__c,Consultant_Fee__c
                                       from Doctor__c where Specialization__c=:specialization AND IsActive__c=true];
        return listofDoctors;
    }

}