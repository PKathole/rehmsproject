public class patientRegisterController {

    @AuraEnabled(cacheable=false)
    public static Patient__c registerpatient(string fname , string lname , string phone ,string email , string bloodGroup ){
        
            Patient__c p =new Patient__c() ;
            p.Name = fname;
            p.Last_Name__c = lname ;
            p.Email__c = email ;
            //p.DOB__c = dob ;
            p.Mobile__c = phone;
		
            system.debug('Name :: '+p.Name+ ' LastName :: '+ p.Last_Name__c + ' Email :: '+p.Email__c+' Mobile :: '+p.Mobile__c);
           // patientList.add(p);
            Insert p ;
            return p ;
        
    } 
    
    
}