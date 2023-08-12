public without sharing class callFlowOnTransfer {

    @AuraEnabled
    public static void callflow(string appointmentId){
        system.debug('callFLow');
        list<string> recIdList = new list<string>{appointmentId};
        start(recIdList);
    } 
    
    @InvocableMethod
    public static void start(list<string> appId) {
        system.debug('start');
        try{
            Map<String, Object> myMap = new Map<String, Object>();
      		myMap.put('recordId', appId);
     		Flow.Interview.Send_Email_On_Transfer myFlow = new Flow.Interview.Send_Email_On_Transfer(myMap);
		    myFlow.start();
        }catch(exception e){
            system.debug('Inside the exception');
            system.debug(e);
        }
        
   }
}