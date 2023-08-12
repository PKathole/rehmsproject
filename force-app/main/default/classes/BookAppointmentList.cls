public without sharing class BookAppointmentList {
    
    @Auraenabled(cacheable=true)
    public static List<Book_Appointment__c> getAppointmentsInfo(String doctorId){
        Time currentTime = Time.newInstance(System.now().hour(), System.now().minute(), System.now().second(), 0);

        List<Book_Appointment__c> lstBookApp = [SELECT Patient_Age__c,patient_name__c,Patient_Number__c,Booked_Slot__c,Appointment_Date__c
                                                FROM Book_Appointment__c 
                                                where Start_Time__c>=:currentTime AND Appointment_Status__c='Confirmed' AND Appointment_Date__c=TODAY AND Doctor__c=:doctorId];
        
        List<Book_Appointment__c> lstBookApp1 = [SELECT Patient_Age__c,patient_name__c,Patient_Number__c,Booked_Slot__c,Appointment_Date__c
                                                FROM Book_Appointment__c 
                                                where Appointment_Status__c='Confirmed' AND Appointment_Date__c>TODAY AND Doctor__c=:doctorId];
        
        lstBookApp.addAll(lstBookApp1);
        return lstBookApp;
    }
     @Auraenabled(cacheable=true)
    public static List<Book_Appointment__c> getCurrentAppointments(String doctorId){
      Time currentTime = Time.newInstance(System.now().hour(), System.now().minute(), System.now().second(), 0);
      Time targetStartTime = Time.newInstance(currentTime.hour(), 0, 0, 0);
      Time targetEndTime = targetStartTime.addHours(1);

      List<Book_Appointment__c> lstCurrentBookApp = [SELECT Patient_Age__c, patient_name__c, Patient_Number__c, Booked_Slot__c, Appointment_Date__c
                                                FROM Book_Appointment__c 
                                                WHERE Start_Time__c >=:targetStartTime
                                                AND Start_Time__c < :targetEndTime
                                                AND Appointment_Status__c = 'Confirmed' 
                                                AND Appointment_Date__c = TODAY 
                                                AND Doctor__c =:doctorId];

        return lstCurrentBookApp;
   

    }
    
    @Auraenabled
    public static Id completeAppointment(string appointmentId){
        
        Book_Appointment__c getApp=[SELECT Appointment_Status__c from Book_Appointment__c where Id=:appointmentId];
        
        getApp.Appointment_Status__c='Completed';
        update getApp;
        return getApp.Id;
        
    }
    
    @Auraenabled(cacheable=true)
    public static  List<Book_Appointment__c>  getcompletedAppointment(string doctorId){
        
       List<Book_Appointment__c> getcompletedApp=[SELECT Patient_Age__c, patient_name__c, Patient_Number__c, Booked_Slot__c, Appointment_Date__c,Appointment_Status__c
                                                FROM Book_Appointment__c where Doctor__c=:doctorId AND Appointment_Status__c = 'Completed'];
        return getcompletedApp;
        
    }
    
    @Auraenabled
    public static Id cancelAppointment(string appointmentId){
        
        Book_Appointment__c getcancelApp=[SELECT Appointment_Status__c from Book_Appointment__c where Id=:appointmentId];
        
        getcancelApp.Appointment_Status__c='Cancelled';
        update getcancelApp;
        return getcancelApp.Id;
        
    }
    
    @AuraEnabled
    public static Book_Appointment__c getAppointmentValues(String appointmentId){
        if (String.isNotBlank(appointmentId)){
            return [SELECT patient_name__c, Name, Booked_Slot__c, Appointment_Date__c,Appointment_Status__c FROM Book_Appointment__c WHERE Id=:appointmentId];
        }
        else{
            return null;
        }
    }

    @AuraEnabled
    public static void updateAppointments(Map<String, Object> updatedFields) {
    String recordId = (String) updatedFields.get('recordId');
    String patientName = (String) updatedFields.get('patientName');
    String bookedSlot = (String) updatedFields.get('bookedSlot');
    Date appointmentDate = (Date) updatedFields.get('appointmentDate');
    
    // Perform your update logic using the provided field values
    // Example: Update the Book_Appointment__c record with the provided values
    
    Book_Appointment__c appointment = [SELECT Id, patient_name__c, Booked_Slot__c, Appointment_Date__c FROM Book_Appointment__c WHERE Id = :recordId];
    
    if (appointment != null) {
        //appointment.patient_name__c = patientName;
        appointment.Booked_Slot__c = bookedSlot;
        appointment.Appointment_Date__c = appointmentDate;

        update appointment;
    }
}

	@Auraenabled(cacheable=true)
    public static List<Book_Appointment__c> getPatientAppointment(string PatientId){
        
        List<Book_Appointment__c> lstBookApp = [SELECT patient_name__c,Patient_Age__c,Booked_Slot__c,Appointment_Date__c,Appointment_Status__c,Doctor_Name__c
                                                FROM Book_Appointment__c 
                                                WHERE Appointment_Status__c!='Cancelled' AND Appointment_Date__c>TODAY AND Patient__c =:PatientId ];
		system.debug('lstBookApp');
        system.debug(lstBookApp);
        
        return lstBookApp ;
    }	
    
    
    @Auraenabled(cacheable=true)
    public static  List<Book_Appointment__c> getCompletedAppointments(string patientId){
        
         List<Book_Appointment__c> getAppointment=[Select Name,Patient_Id__c,Patient_Age__c,patient_name__c,Patient_Email__c,Patient_Number__c,Doctor_Name__c,Specializtion__c,Appointment_Date__c,Booked_Slot__c,Appointment_Status__c
                                                   FROM Book_Appointment__c where Patient__c=:patientId AND Appointment_Status__c='Completed'];
        
        return getAppointment;
    }
 
    @Auraenabled(cacheable=true)
    public static  Book_Appointment__c getAppointmentDetails(string appointmentId){
        Book_Appointment__c app = [SELECT Id,Patient_Id__c,Doctor_Name__c,Specializtion__c,Appointment_Date__c,Booked_Slot__c,patient_name__c,
                                   Doctor_Phone__c FROM Book_Appointment__c WHERE Id=:appointmentId ];
        
        return app ;
    }
    
    @Auraenabled
    public static Id transferAppointment(string appointmentId){
        
        Book_Appointment__c getApp=[SELECT Appointment_Status__c from Book_Appointment__c where Id=:appointmentId];
        
        getApp.Appointment_Status__c='Transfer';
        update getApp;
        return getApp.Id;
        
    }
}