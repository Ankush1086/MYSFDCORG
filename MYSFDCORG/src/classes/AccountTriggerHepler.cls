public class AccountTriggerHepler {
    public AccountTriggerHepler() {
        
    }
    
    public static Map<String,Integer>  rescrictDublicteCustomerIDcreation(List<Account> newAccount) {
        set<String> customerIDset = new set<String>();
        WebServiceControllerHepler objHelper = new WebServiceControllerHepler();
        Map<String,Integer> resultMap = new Map<String,Integer>();
        
        system.debug('newAccount'+newAccount);
        for(Account rs:newAccount) {
            customerIDset.add(rs.CustomerID__c);
        }
        system.debug('customerIDset'+customerIDset);
        if(customerIDset.size()>0) {
            
           resultMap = objHelper.getDuplicateCustomerID(customerIDset); 
        }
         system.debug('resultMap'+resultMap);
        
   
   return resultMap;
}
}