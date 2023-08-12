public without sharing class AddPrescription {
    
    @AuraEnabled
    public static string prescription(String appointmentId,String Patient_Diagnosis, String BP_temp, String medication1, String medication2, String medication3, String medication4, String medication5, String medication6, String medication7, String medication8, String medication9, String medication10, String tests){
        try{
           
            Prescription__c newPrescription=new Prescription__c(
            	
                Book_Appointment__c=appointmentId,
                Patient_Diagnosis__c=Patient_Diagnosis,
                BP_Temperature__c=BP_temp,
            	Medication_1__c=medication1,
                Medication_2__c=medication2,
                Medication_3__c=medication3,
                Medication_4__c=medication4,
                Medication_5__c=medication5,
                Medication_6__c=medication6,
                Medication_7__c=medication7,
                Medication_8__c=medication8,
                Medication_9__c=medication9,
                Medication_10__c=medication10
                
            );
            insert newPrescription;
            return newPrescription.Book_Appointment__c;
        }
        catch (Exception e) {
            system.debug('e.getMessagelogin+'+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @Auraenabled(cacheable=true)
    public static string getPrescriptionId(string appointmentId){
        
        Prescription__c p1=[SELECT Id,Patient_Diagnosis__c,BP_Temperature__c,Book_Appointment__c,Medication_1__c, Medication_2__c, Medication_3__c, Medication_4__c, Medication_5__c, Medication_6__c, Medication_7__c, Medication_8__c, Medication_9__c, Medication_10__c, Tests__c 
                            FROM Prescription__c where Book_Appointment__c=:appointmentId];
        
        return p1.Id;
        
    }
    
    @Auraenabled(cacheable=true)
    public static Prescription__c  getPrescription(string appointmentId){
        
        Prescription__c p1=[SELECT Id,Patient_Diagnosis__c,BP_Temperature__c,Book_Appointment__c,Medication_1__c, Medication_2__c, Medication_3__c, Medication_4__c, Medication_5__c, Medication_6__c, Medication_7__c, Medication_8__c, Medication_9__c, Medication_10__c, Tests__c 
                            FROM Prescription__c where Book_Appointment__c=:appointmentId];
        
        return p1;
        
    }
   
}