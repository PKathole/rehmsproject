public without sharing class PatientLoginController {
 
    @AuraEnabled
    public static string doPatientLogin(String username, String password){
        try {
          
            String startUrl = 'https://moekahospitals-dev-ed.develop.my.site.com/patientprofile';
        ApexPages.PageReference pageRef = Site.login(username, password, startUrl);
        if(pageRef != null) {
            User currentUser = [SELECT Id,Profile.Name FROM User WHERE username = :username LIMIT 1];
            if(currentUser.Profile.Name== 'Patient Portal Profile') {
                return pageRef.getUrl();
            } else {
                return 'Doctor';
            }
        }
 
      return null;

        } catch (Exception e) {
            system.debug('e.getMessagelogin+   '+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
 }