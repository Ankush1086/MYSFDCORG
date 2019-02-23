@RestResource(urlMapping='/AccountService/*')
global with sharing class CustomService_Cls {
    
    
    @HttpGet
    global static AccountWrapper searchCustomer() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String customerID = RestContext.request.params.get('customerId');
       // String customerID = String.escapeSingleQuotes(customerIDParam);
        String recordLimit = RestContext.request.params.get('limit');
        //String recordLimit = String.escapeSingleQuotes(recordLimitParam);
        AccountWrapper finalResult =  new   AccountWrapper();
        AccountWrapper.results invalidRequest =  new   AccountWrapper.results();
        String jsonString ='';
        system.debug('customerID-->'+customerID);
        system.debug('recordLimit-->'+recordLimit);
        WebServiceControllerHepler service = new WebServiceControllerHepler();   
        if(customerID !=null && customerID.isNumeric()) {
            finalResult= service.getCoustomerRecords(customerID,'');
        } else if(recordLimit !=null && recordLimit.isNumeric()) {
            
            finalResult= service.getCoustomerRecords('',recordLimit);
        } else {
            
            invalidRequest.ErrorCode='Invalid Request';
            invalidRequest.Message=System.Label.ParametercheckMsg;//'Please check parameter';
            invalidRequest.Status='Failed ';
            finalResult.results =invalidRequest;
            
        }
        jsonString = system.JSON.serialize(finalResult);
        jsonString = jsonString.replaceAll('"\"',jsonString);
        system.debug('RequestWrapper-->'+finalResult);
        return finalResult;
    }
    
    
    @HttpPost
    global static ResponceHandlerController createAccount() {
        RestRequest     request    = RestContext.request;
        RestResponse    response   = RestContext.response;    
        response.addHeader('Content-Type','applicatin/json');
        system.debug('RESPONCE'+request.requestBody.toString());
        AccountWrapper RequestWrapper = new AccountWrapper();
        RequestWrapper= AccountWrapper.parse(request.requestBody.toString());
        system.debug('RES '+RequestWrapper );
        WebServiceControllerHepler service = new WebServiceControllerHepler();
        ResponceHandlerController finalResult = service.validateRequest(RequestWrapper.accounts);
        
        
        return finalResult;
    }
}