public without sharing class TodaySchedule {
    
    @AuraEnabled
    public static List<string> getTodaySchedule(String AppointmentDate, String doctorId) {
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
    public static List<String> getAvailableSchedule(String AppointmentDate,string weekDay,string doctorId){
        
         List<String> bookedSlots = TodaySchedule.getTodaySchedule(AppointmentDate, doctorId);

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
        DateTime currentDateTime = System.now();
        Time currentTime = currentDateTime.time();

        Datetime dummyDate = DateTime.newInstance(
            Date.today(), 
            currentTime
        );

        String currentTimeNow = dummyDate.format('h:mm a');
        
    for (Integer i = remSlots.size() - 1; i >= 0; i--) {
    String timeSlot = remSlots[i];
    String[] slotParts = timeSlot.split(' to ');
    String startTime = slotParts[0];
    
    // Extract the hour and minute values from the current time and start time
    Integer currentHour = Integer.valueOf(currentTimeNow.split(':')[0]);
    Integer currentMinute = Integer.valueOf(currentTimeNow.split(':')[1].split(' ')[0]);
    Integer startHour = Integer.valueOf(startTime.split(':')[0]);
    Integer startMinute = Integer.valueOf(startTime.split(':')[1].split(' ')[0]);
    
    // Convert the time to 24-hour format
    if (currentTimeNow.contains('PM') && currentHour < 12) {
        currentHour += 12;
    }
    if (startTime.contains('PM') && startHour < 12) {
        startHour += 12;
    }
    
    if (currentHour > startHour || (currentHour == startHour && currentMinute >= startMinute)) {
        remSlots.remove(i);
    }
}
    return remSlots;
        }
    }