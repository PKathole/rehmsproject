public without sharing class BookAppointment {
    
    @AuraEnabled
    public static Id bookAppoint(String doctorId, String patientId, String appointmentDate, String appointmentTime) {
        String formattedDate = appointmentDate.substring(6, 10) + '-' + appointmentDate.substring(3, 5) + '-' + appointmentDate.substring(0, 2);
          
        String[] timeSlots = appointmentTime.split(' to ');
        
        String[] startTimeParts = timeSlots[0].split(':| ');
        Integer s1 = Integer.valueOf(startTimeParts[0]);
        if (timeSlots[0].contains('PM') && s1 != 12) {
            s1 += 12;
        }
        Integer s2 = Integer.valueOf(startTimeParts[1]);

        String[] endTimeParts = timeSlots[1].split(':| ');
        Integer e1 = Integer.valueOf(endTimeParts[0]);
        if (timeSlots[1].contains('PM') && e1 != 12) {
            e1 += 12;
        }
        Integer e2 = Integer.valueOf(endTimeParts[1]);
        
        Book_Appointment__c b1 = new Book_Appointment__c();
        b1.Appointment_Date__c = Date.valueOf(formattedDate);
        b1.Doctor__c = doctorId;
        b1.Patient__c = patientId;
        b1.Appointment_Status__c = 'Waiting';
        Time startTime = Time.newInstance(s1, s2, 0, 0);  
        Time endTime = Time.newInstance(e1, e2, 0, 0);
        b1.Start_Time__c = startTime;
        b1.End_Time__c = endTime;
        insert b1;
        
        return b1.Patient__c;
    }
    
     @Auraenabled(cacheable=true)
    public static  List<Book_Appointment__c> getWaitingAppointments(string patientId){
        
         List<Book_Appointment__c> getAppointment=[Select Patient_Id__c,patient_name__c,Patient_Email__c,Patient_Number__c,Doctor_Name__c,Specializtion__c,Appointment_Date__c,Booked_Slot__c 
                                                   FROM Book_Appointment__c where Patient__c=:patientId AND Appointment_Status__c='Waiting' AND Appointment_Date__c >=Today];
        
        return getAppointment;
    }
    
     @Auraenabled
    public static Id cancelAppointment(string appointmentId){
        
        Book_Appointment__c getcancelApp=[SELECT Appointment_Status__c from Book_Appointment__c where Id=:appointmentId];
        
        getcancelApp.Appointment_Status__c='Waiting Cancelled';
        update getcancelApp;
        return getcancelApp.Id;
        
    }
    
     @Auraenabled
     public static string confirmedAppointment(string appointmentId){
         
        /* Book_Appointment__c getAlreadyBooked=[SELECT Booked_Slot__c FROM Book_Appointment__c where Appointment_Date__c=:Date.valueOf(AppointmentDate)];
         system.debug(getAlreadyBooked.Booked_Slot__c);
         if(getAlreadyBooked.Booked_Slot__c==bookedslot){
             return 'Already Booked';
} else {}*/
        
        Book_Appointment__c getconfirmApp=[SELECT Appointment_Status__c from Book_Appointment__c where Id=:appointmentId LIMIT 1];
        
        getconfirmApp.Appointment_Status__c='Confirmed';
        update getconfirmApp;
        return 'Appointment Confirmed';
         
        
    }
    
}