/*****************************************************
Class Name    : WebServiceControllerHepler
Author        : ANkush Dubey
Description   : All Webservice Hepler Method Present Here 
Created Date  : 1 Sept 2018
*********************************************************/


public with sharing  class WebServiceControllerHepler {
    public List<ResponceHandlerController.results> responceList {get;set;}
    public map<String,Integer> resCustomerIDCount = new map<String,Integer>();
    
    public WebServiceControllerHepler(){
        responceList = new List<ResponceHandlerController.results>();
        
    }
    
    /*****************************************************
Method Name    : validateRequest
Author        : ANkush Dubey
Description   :Validate and send responce to Create Account service 
Param		  : Acceptig List of Account Wrapper 
Created Date  : 1 Sept 2018
*********************************************************/
    public ResponceHandlerController validateRequest(List<AccountWrapper.accounts> requestInput) {
        
        ResponceHandlerController finalResult = new  ResponceHandlerController();
        List<AccountWrapper.accounts> insertAccountList = new  List<AccountWrapper.accounts> ();
        system.debug('requestInput'+requestInput);
        List<ResponceHandlerController.results> responcelisttemp = new List<ResponceHandlerController.results>();
        for(AccountWrapper.accounts rs: requestInput) {
            ResponceHandlerController.results  resultSingle = new ResponceHandlerController.results();
            AccountWrapper.accounts singleAccount= new AccountWrapper.accounts();
            
            if((String.isNotEmpty(rs.Name)) && (String.isNotEmpty(rs.CustomerID)) && (UtilController.validatePhone(rs.Phone)) ) 
            {
                if(resCustomerIDCount.containsKey(rs.CustomerID) ){
                    resCustomerIDCount.put(rs.CustomerID,resCustomerIDCount.get(rs.CustomerID)+1);
                }
                else{
                    resCustomerIDCount.put(rs.CustomerID,1); 
                }
                singleAccount.Name =rs.Name;
                singleAccount.CustomerID =rs.CustomerID;
                singleAccount.Phone=rs.Phone;
                insertAccountList.add(singleAccount);                
            } else if((String.isNotEmpty(rs.Name)) && (String.isNotEmpty(rs.CustomerID)) && (!UtilController.validatePhone(rs.Phone))) { 
                
                 resultSingle.ErrorCode='In Valid Phone';
                resultSingle.Message='Please endter valid phone no'; 
                resultSingle.Status='Failed';
                resultSingle.CustomerID=rs.CustomerID;
            }
            
            else {
                resultSingle.ErrorCode=System.Label.RequiredMissing_msg;
                resultSingle.Message=System.Label.RequiredMessage_Desc; 
                resultSingle.Status='Failed';
                resultSingle.CustomerID=rs.CustomerID;
                
                responceList.add(resultSingle);
            }
        }
        system.debug('resCustomerIDCount-->'+resCustomerIDCount);
        system.debug('insertAccountList-->'+insertAccountList);
        if(insertAccountList.size()>0) {
            responcelisttemp = insertAccountRecords(insertAccountList); 
        }
        
        system.debug('responcelisttemp-->'+responcelisttemp);
        responceList.addall(responcelisttemp);
        system.debug('responceList Ankush-->'+responceList);
        if(responceList.size()>0)
            finalResult.results =responceList;
        
        return finalResult;
    }
    
    /*****************************************************
Method Name    : insertAccountRecords
Author        : ANkush Dubey
Description   :Insert unique account to DB
Param		  : Acceptig List of Account Wrapper 
Created Date  : 1 Sept 2018
*********************************************************/  
    @TestVisible 
    private List<ResponceHandlerController.results> insertAccountRecords(List<AccountWrapper.accounts> recordList) {
        
        List<Account> accountList = new List<Account>();
        List<ResponceHandlerController.results> responceList = new List<ResponceHandlerController.results>();
        List<ResponceHandlerController.results> insertaccountResponce = new List<ResponceHandlerController.results>();
        Map<String,Integer> resultMap = new Map<String,Integer>();
        set<String> setCustomerID = new  set<String>();
        
        for(AccountWrapper.accounts rs:recordList) {
            setCustomerID.add(rs.CustomerID);
        }
        system.debug('setCustomerID-->'+setCustomerID);
        if(setCustomerID.size()>0) {
            resultMap =  getDuplicateCustomerID(setCustomerID);
        }
        system.debug('resultMap-->'+resultMap); 
        for(AccountWrapper.accounts rs:recordList) {
            String result = evaluateAccount((resCustomerIDCount.containsKey(rs.CustomerID) ? resCustomerIDCount.get(rs.CustomerID) : 0)
                                            ,(resultMap.containsKey(rs.CustomerID) ? resultMap.get(rs.CustomerID) : 0));
            System.debug('result-->'+result);
            ResponceHandlerController.results  resulttemp1 = new ResponceHandlerController.results(); 
            if(!result.equalsIgnoreCase('Success')) {//if(resultMap.size() >0) {
                
                system.debug('A-->'+rs.CustomerID); 
                
                resulttemp1.ErrorCode='Insert Fail';
                resulttemp1.Message=result;
                resulttemp1.Status='Failed ';
                resulttemp1.CustomerID=rs.CustomerID;
                
                responceList.add(resulttemp1); 
                
                
                
            } else {
                
                
                system.debug('else');
                Account tempAcc = new Account (Name =rs.Name,CustomerID__c = rs.CustomerID,Phone=rs.Phone);  
                accountList.add(tempAcc);  
                
            }  
            
        }
        system.debug('responceList-->'+responceList);
        system.debug('accountList-->'+accountList);
        if(accountList.size()> 0)
            insertaccountResponce = insertUniqueAccount(accountList);
        if(insertaccountResponce.size()>0)
            responceList.addall(insertaccountResponce);
        
        return responceList; 
    }
    
    /*****************************************************
Method Name    : evaluateAccount
Author        : ANkush Dubey
Description   :Check Customer ID count in exisntin records and Input Request 
Param		  : dbCount, requestCount
Created Date  : 1 Sept 2018
*********************************************************/  
    @TestVisible 
    private String evaluateAccount(Integer requestCount,Integer dbCount) {
        String result='Success';
        system.debug('requestCount-->'+requestCount);
        system.debug('dbCount-->'+dbCount);
        system.debug('Final-->'+(requestCount+dbCount));
        String CustomerIDDubcheck = System.Label.CustomerIDDubcheck;
        
        if(requestCount >Integer.ValueOf(CustomerIDDubcheck)) {
            result = System.Label.CustomerIDInputReqMsg;//'Duplicate found in Input Request';
        } else if(dbCount >Integer.ValueOf(CustomerIDDubcheck)) {
            result = System.Label.CustomerIDErrorMsg;//'Duplicate found in Database';
        } else if((requestCount+dbCount) >Integer.ValueOf(CustomerIDDubcheck)) {
            
            result = System.Label.MsgDupinputReq; //'Duplicate found in Database and Input Request';
        } 
        return result;  
    }
    
    /*****************************************************
Method Name    : insertUniqueAccount
Author        : ANkush Dubey
Description   :Hepler Method of insertAccountRecords to Insert records in DB
Param		  : dbCount, requestCount
Created Date  : 1 Sept 2018
*********************************************************/     
    @TestVisible 
    private List<ResponceHandlerController.results> insertUniqueAccount(List<Account> accountList) {
        set<String> accountID = new  set<String>();
        map<String,String> accountCustomerID = new map<String,String>();
        List<ResponceHandlerController.results>  responceListReturn = new List<ResponceHandlerController.results>();
        if(accountList.size()>0) {
            List<ResponceHandlerController.results>  responceListtemp = new List<ResponceHandlerController.results>();
            
            try {
                if(Schema.SObjectType.Account.isCreateable() && (Schema.sObjectType.Account.fields.CustomerID__c.isCreateable()))
                {
                    Database.SaveResult[] saveResultLst = Database.insert(accountList, false);
                    
                    for(Integer i=0;i<saveResultLst.size();i++){
                        ResponceHandlerController.results  resulttemp2 = new ResponceHandlerController.results();
                        system.debug('saveResultLst'+saveResultLst);
                        if (saveResultLst.get(i).isSuccess()) {
                            resulttemp2.ErrorCode='';
                            resulttemp2.CustomerID=saveResultLst.get(i).getId();
                            resulttemp2.Message=System.Label.RecordAddedMsg;//'Record Added successfully ';
                            resulttemp2.Status='Success';
                            system.debug('Message'+i);
                            accountID.add(saveResultLst.get(i).getId());
                            responceListtemp.add(resulttemp2); 
                        } else {
                            resulttemp2.ErrorCode='Insert Fail';
                            resulttemp2.CustomerID=saveResultLst.get(i).getId();
                            resulttemp2.Message=System.Label.ErrorinInserting;//'Error in Inseerting';
                            resulttemp2.Status='Failed ';
                            accountID.add(saveResultLst.get(i).getId());
                            responceListtemp.add(resulttemp2); 
                            
                        }
                        
                    }
                    
                }
                
            }  catch (exception e) {
                system.debug('Message'+e.getMessage()+e.getLineNumber());
                
            }
            // Get CustomerID from Account ID 
            if(responceListtemp.size()>0 && accountID.size()>0) {
                accountCustomerID = getCustomerIDByAccount(accountID);
                
                for(ResponceHandlerController.results rs:responceListtemp) {
                    ResponceHandlerController.results  resTemp = new ResponceHandlerController.results(); 
                    resTemp.ErrorCode=rs.ErrorCode;
                    resTemp.CustomerID=accountCustomerID.get(rs.CustomerID);
                    resTemp.Message=rs.Message;
                    resTemp.Status=rs.Status;
                    responceListReturn.add(resTemp);
                }
            }
            
        } 
        
        return responceListReturn;        
    }
    
    
    
    /*****************************************************
Method Name    : getDuplicateCustomerID
Author        : ANkush Dubey
Description   : Preapred map for duplicate customer id for 2 times 
Param		  : setcustomerID
Created Date  : 1 Sept 2018
*********************************************************/    
    public Map<String,Integer> getDuplicateCustomerID(set<String> setcustomerID) {
        
        system.debug('resCustomerIDCountAAA'+resCustomerIDCount);
        Map<String,Integer> resultMap = new Map<String,Integer>();
        //if(UtilController.hasReadAccess('Account')) {
        try {
        AggregateResult[] aggResult = [SELECT CustomerId__c,COUNT(Id) FROM Account WHERE CustomerId__c IN :setcustomerID GROUP BY CustomerId__c];
        for(AggregateResult ar : aggResult){
            Transient String tmpCustId = String.valueOf(ar.get('CustomerId__c'));
            Transient Integer tmpCnt = Integer.valueOf(ar.get('expr0'));
           
            resultMap.put(tmpCustId,tmpCnt);
            
            //} 
            
        }
      }catch (Exception e) {
            system.debug('Message'+e.getMessage()+e.getLineNumber());
        }
        
        
        
        system.debug('resCustomerIDCountAAA'+resultMap);
        return resultMap;    
    }
    
    /*****************************************************
Method Name    : getCustomerIDByAccount
Author        : ANkush Dubey
Description   : Fetch Customer ID bt SF record id to replace responce in Responce body
Param		  : accountID set of string or account id
Created Date  : 1 Sept 2018
*********************************************************/    
    
    public Map<String,String> getCustomerIDByAccount(set<String> accountID) {
        Map<String,String> resultMap = new Map<String,String>();
        List<Account> accountIDRS =  new  List<Account>();
        if(UtilController.hasReadAccess('Account')) {
            accountIDRS = [SELECT CustomerId__c,Id FROM Account WHERE Id IN :accountID ];
            for(Account rs : accountIDRS){
                resultMap.put(String.valueOf(rs.id),String.valueOf(rs.CustomerId__c));
            } 
        }
        return resultMap;    
    }
    
    /*****************************************************
Method Name    : getCoustomerRecords
Author        : ANkush Dubey
Description   : Method used in Get Webservice to fetch accounts 
Param		  : CustomerID,recordLimit 
Created Date  : 1 Sept 2018
*********************************************************/  
    
    public AccountWrapper  getCoustomerRecords(String CustomerID,String recordLimit) {
        
        AccountWrapper finalResult =  new   AccountWrapper();
        List<AccountWrapper.accounts> searchResultRes =  new   List<AccountWrapper.accounts>();
        AccountWrapper.results errorResponce =  new   AccountWrapper.results();
        List<Account> dbResult  = new  List<Account>();
        ResponceHandlerController.results errorResponce1 = new ResponceHandlerController.results();
        String jsonString ='';
        system.debug('recordLimit ANJ-->'+recordLimit);
        if(UtilController.validateString(recordLimit)) { //&& Integer.Valueof(recordLimit) < 10000) {
            if(Integer.Valueof(recordLimit) < 10000) {
            system.debug('recordLimit NN-->'+recordLimit);
            dbResult = getCustomerDetails('',recordLimit);
            system.debug('dbResult-->'+dbResult);
            if(dbResult.size()>0) {
                for(Account rs:dbResult){
                    AccountWrapper.accounts tempList= new AccountWrapper.accounts();
                    tempList.Name =rs.Name;
                    tempList.CustomerID =rs.CustomerID__c;
                    searchResultRes.add(tempList);
                    
                }
            } else {
                errorResponce.ErrorCode='No Result ';
                errorResponce.Message=System.Label.NoResultMsg;//'Not Result Found';
                errorResponce.Status='Success';
            }
            
            }  else {
            
            errorResponce.ErrorCode='Limit Exceed';
            errorResponce.Message=System.Label.RecordLimitExceed;//'Max Limit is set to 10000 at a time';
            errorResponce.Status='Failed ';
            
            
        	}
        } 
        
        
        if(UtilController.validateString(CustomerID)) {
            
            system.debug('CustomerID-->'+CustomerID);
            dbResult = getCustomerDetails(CustomerID,'');
            if(dbResult.size()>0) {  
                for(Account rs:dbResult){
                    AccountWrapper.accounts tempList= new AccountWrapper.accounts();
                    tempList.Name =rs.Name;
                    tempList.CustomerID =rs.CustomerID__c;
                    searchResultRes.add(tempList);
                    
                }
            } else {
                errorResponce.ErrorCode=System.Label.CustomerIDMsg;//'Customer ID Not Found ';
                errorResponce.Message=System.Label.NoResultMsg;//'Not Result Found';
                errorResponce.Status='Success';
            }
            
        } 
        system.debug('searchResultRes'+searchResultRes);
        if(searchResultRes.size() >0) {
            finalResult.Accounts=searchResultRes;
            //jsonString  = system.JSON.serialize(searchResultRes);
        } else if(errorResponce !=null) {
            finalResult.results = errorResponce;
            // jsonString  = system.JSON.serialize(errorResponce); 
        }
        //system.debug('jsonString'+jsonString);
        return finalResult; 
    }
    
    /*****************************************************
Method Name    : getCustomerDetails
Author        : ANkush Dubey
Description   : Hepler Method for getCustomerDetails 
Param		  : CustomerID,recordLimit 
Created Date  : 1 Sept 2018
*********************************************************/    
    
    public List<Account> getCustomerDetails(String CustomerID,String recordLimit) {
        
        system.debug('HI Ankush'+recordLimit);
        List<Account> searchResult  = new List<Account>();
        List<Account> recordResult  = new List<Account>();
        try {
            
            if(UtilController.validateString(CustomerID)) {
               if(Schema.SObjectType.Account.isAccessible()) {
                    searchResult = [Select Name,CustomerID__c,Phone from Account where CustomerID__c =:String.escapeSingleQuotes(CustomerID) Limit 10];
                }
            } else if(recordLimit !=null)  {
               // if(Schema.SObjectType.Account.isAccessible()) {
                    system.debug('HI Ankush');
                Integer count = Limits.getLimitQueryRows() - Limits.getQueryRows();
            	system.debug('count'+count);
                    Integer limitval =Integer.ValueOf(recordLimit);
                    searchResult = [Select Name,CustomerID__c,Phone from Account where CustomerID__c !=null Limit :limitval]; 
               // }
            }
            system.debug('Limit searchResult'+searchResult);
            if(searchResult.size()>0) {
                for(Account rs:searchResult){
                    Account tempList= new Account();
                    tempList.Name =rs.Name;
                    tempList.CustomerID__c =rs.CustomerID__c;
                    tempList.Phone =rs.Phone;
                    recordResult.add(tempList);
                    
                }
            }
        }
        catch (Exception e) {
            system.debug('Message'+e.getMessage()+e.getLineNumber());
        }
        return searchResult;  
    } 
    
    
}