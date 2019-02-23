/*****************************************************
Class Name    : CreateAccountController
Author        : ANkush Dubey
Description   : Create Account from VF Page Controller   
Created Date  : 2 Sept 2018
*********************************************************/

public with sharing class CreateAccountController {
    
    public Account newAccountObj {get;set;}
    
    public CreateAccountController() {
       newAccountObj = new Account();
    }
    
    
    /*****************************************************
Method Name    : save
Author        : ANkush Dubey
Description   : Save Method to Create Account   
Created Date  : 2 Sept 2018
*********************************************************/
    public PageReference save() {
        
        WebServiceControllerHepler webServiceHelper = new WebServiceControllerHepler();
        Map<String, Integer> dupCheckMap = new Map<String, Integer>();
        Boolean isDuplicate = false;
        String CustomerIDDubcheck = System.Label.CustomerIDDubcheck;
        system.debug('acct-->'+newAccountObj);
        try {
            if(!UtilController.validateString(newAccountObj.Name) && !UtilController.validateString(newAccountObj.CustomerID__c)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter Account Name and Customer ID'));
            }
			
                if(newAccountObj !=null) 
                    insertAccountDB(newAccountObj);
        } 
        catch (Exception e) {
            system.debug('Message'+e.getMessage()+e.getLineNumber());
        }
        
        return null;
        
    }
    
    /*****************************************************
Method Name    : insertAccountDB
Author        : ANkush Dubey
Description   : Hepler Method save Account 
Created Date  : 2 Sept 2018
*********************************************************/ 
    private void insertAccountDB(Account acct) {
        try {
            Database.SaveResult sr = null;
            if(UtilController.hasCreateAccess('Account')){
                sr = Database.insert(acct);
                if(sr.isSuccess()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Record Created Successfully'));
                    newAccountObj = new Account();
                }
            }
        }catch (Exception e) {
            system.debug('Message'+e.getMessage()+e.getLineNumber());
        }
        
        
        
    }
}