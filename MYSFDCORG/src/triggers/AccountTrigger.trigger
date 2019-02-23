trigger AccountTrigger on Account (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
     
       /* Map<String,Integer> resultMap = new Map<String,Integer>(); 
       resultMap =AccountTriggerHepler.rescrictDublicteCustomerIDcreation(Trigger.new);
       Integer thresouldCount = 2;
        for(Account rs:Trigger.new) {
        
            if(resultMap.containsKey(rs.CustomerID__c)) {
                if(resultMap.get(rs.CustomerID__c) > thresouldCount) { 
                    rs.addError(System.Label.CustomerIDErrorMsg);

                }
            }
        }*/
        
        
    //    try {
  String[] sendTo = new String[]{'ankush.dubey@wolterskluwer.com','ankush.dubey1086@gmail.com','dubey.ankush9@gmail.com'};
      
 Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
 Messaging.reserveSingleEmailCapacity(40);
system.debug('TestAnkush');
mail.setToAddresses(sendTo);
        

mail.setSenderDisplayName('sometext');

mail.setSubject('Subject');

mail.setPlainTextBody('body text here...');

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

 
//} catch (Exception e) {
    // From Winter '14, this code is now executed.
   // System.debug('You have used up your daily allowance of mails');
//}

    }   
}