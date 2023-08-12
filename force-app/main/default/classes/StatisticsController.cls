public with sharing class StatisticsController {
	
    @AuraEnabled(cacheable=true)
    public static AppointmentStatisticsData getStatistics() {
        AppointmentStatisticsData statistics = new AppointmentStatisticsData();

        // Calculate the counts
        statistics.totalPatientsTreated = [SELECT COUNT() FROM Book_Appointment__c WHERE Appointment_Status__c = 'Completed'];
        statistics.totalDoctors = [SELECT COUNT() FROM Doctor__c WHERE IsActive__c = true];
        statistics.totalDoctorsRemoved = [SELECT COUNT() FROM Doctor__c WHERE IsActive__c = false];
        statistics.totalAppointments = [SELECT COUNT() FROM Book_Appointment__c];
        statistics.totalAppointmentsCancelled = [SELECT COUNT() FROM Book_Appointment__c WHERE Appointment_Status__c = 'Cancelled'];

        return statistics;
    }
    public class AppointmentStatisticsData {
        @AuraEnabled public Integer totalPatientsTreated { get; set; }
        @AuraEnabled public Integer totalDoctors { get; set; }
        @AuraEnabled public Integer totalDoctorsRemoved { get; set; }
        @AuraEnabled public Integer totalAppointments { get; set; }
        @AuraEnabled public Integer totalAppointmentsCancelled { get; set; }
    }
}