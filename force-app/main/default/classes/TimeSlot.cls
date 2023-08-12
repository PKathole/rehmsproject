public without sharing  class TimeSlot {
    
    @Auraenabled(cacheable=true)
    public static string getTimeSlotId(string doctorId,string weekDays){
        
        Time_Slot__c t=[SELECT Id from Time_Slot__c where Doctor__c=:doctorId AND Week_Days__c=:weekDays];
        return t.Id;
    }

}