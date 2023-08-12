public without sharing class TomorrowSchedule {
    
      @AuraEnabled
    public static List<string> getTomorrowSchedule(String AppointmentDate, String doctorId) {
        List<string> bookedSlots = new List<string>();
        
        // Convert the date string to the format 'yyyy-MM-dd'
        String formattedDate = AppointmentDate.substring(6, 10) + '-' + AppointmentDate.substring(3, 5) + '-' + AppointmentDate.substring(0, 2);
        String status1 = 'Confirmed';
        String status2='Waiting';
        List<Book_Appointment__c> lstBookApp = [SELECT Booked_Slot__c 
                                        FROM Book_Appointment__c 
                                        WHERE Appointment_Date__c = :Date.valueOf(formattedDate) 
                                        AND Doctor__c = :doctorId 
                                        AND (Appointment_Status__c = :status1 OR Appointment_Status__c = :status2)];

        
        for (Book_Appointment__c ba : lstBookApp) {
            bookedSlots.add(ba.Booked_Slot__c);
        }
        
        System.debug(bookedSlots);
        return bookedSlots;
    }
    
     @AuraEnabled
    public static List<String> getTomorrowAvailableSchedule(String AppointmentDate,string weekDay,string doctorId){
        
         List<String> bookedSlots = TomorrowSchedule.getTomorrowSchedule(AppointmentDate, doctorId);

    Time_Slot__c getTimeSlot = [SELECT Available_Time_Slots__c 
                                FROM Time_Slot__c 
                                WHERE Week_Days__c = :weekDay AND Doctor__c = :doctorId];
            
        String stringTimeSlots = getTimeSlot.Available_Time_Slots__c;
        List<String> lstSlots = stringTimeSlots.split(';');
        List<string> remSlots=new List<string>();
            for(string availableslot:lstSlots){
                if(!bookedSlots.contains(availableslot)){
                      remSlots.add(availableslot);
                }
            }
           return remSlots;
        }

}