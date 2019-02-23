/*****************************************************
Class Name    : SendEmailBatch
Author        : ANkush Dubey
Description   : SendEmail to email with Unique Customer created in DB to email id Configure in custome seeting 
Created Date  : 2 Sept 2018
*********************************************************/

global with sharing class SendEmailBatch implements Database.batchable<Account>, Database.Stateful{
	
    Set<String> accountIds = new Set<String>();
    String CustomerDIList = '';
	global Iterable<Account> start(Database.batchableContext batchableContext){
		
		List<Account> acocuntList = fetchAllRec();
        system.debug('acocuntList-->'+acocuntList.size());
        system.debug('acocuntList-->'+acocuntList);
		if(acocuntList!=null && acocuntList.size() > 0){
			return acocuntList;
		}
		
		return new List<Account>();
	}
	
	public List<Account> fetchAllRec(){
    	
    	try{
            Integer count = Limits.getLimitQueryRows() - Limits.getQueryRows();
            system.debug('count'+count);
            
            DateTime previousDate = SendEmailBatchController.parseDate(String.valueOf(Date.today().addDays(-1)),true);
            system.debug('previousDate'+previousDate);
    		return [select CustomerID__c from Account WHERE createdDate <= :previousDate LIMIT :count];
    	}catch(Exception e){
    		system.debug('Error'+e);
    	}
    	return null;
    }
    
    global void execute(Database.BatchableContext bc, List<Account> recordList){
        System.debug('accountIds exec size-->'+recordList.size());
        try{
            for(Account account: recordList){
                if(account.CustomerID__c != null){
                 	accountIds.add(account.CustomerID__c);   
                }
            }
             system.debug('accountIds'+accountIds);
            if(accountIds.size() >0) {
            	for(String rs:accountIds) {
            		CustomerDIList += rs+',';	
            	}
            	
            }
            
          system.debug('CustomerDIList'+CustomerDIList);
            
        }catch(Exception e){
            system.debug('Error-->'+e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('accountIds finish-->'+accountIds.size());
        if(accountIds != null && accountIds.size() > 0){
            SendEmailBatchController.sendStatusEmail(String.valueOf(CustomerDIList));
        }
    }
       
}