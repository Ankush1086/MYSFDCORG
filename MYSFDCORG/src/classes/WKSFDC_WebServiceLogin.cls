/*****************************************************
Class Name    : WKSFDC_WebServiceLogin
Author        : ANkush Dubey
Description   : Webservice API Layer  
Created Date  : 10 Jan 2018
*********************************************************/ 

public with sharing class WKSFDC_WebServiceLogin { 
    
    
/*****************************************************
Class Name    : procressPostRequestInputRequest
Author        : ANkush Dubey
Description   : Generate Post Request of Webservice  
Created Date  : 10 Jan 2018
*********************************************************/   
    
    public static Map<String,String> procressPostRequestInputRequest(String inputRequestBody,Map<String,String> objectIdMap,Map<String,String> existingValueMap) {
    
            Map<String,String> jsonMap = new Map<String,String>();
            Map<String,Map<String,String>> objectWSlabelFieldnameMapping = new Map<String,Map<String,String>>();
            Set<String> tempFields=new Set<String>();
            String body = inputRequestBody;

              List<String> tokens = body.trim().split(',');
                
                for(String row : tokens)
                {
                    //system.debug('row'+row);
                    List<String> splitByColon = row.trim().split(':');
                    // system.debug('splitByColon'+splitByColon);
                    
                    List<String> splitByFullstop = splitByColon[1].trim().split('\\.');
                    // system.debug('splitByFullstop'+splitByFullstop);
                    if(splitByFullstop.size() == 2)
                    {
                        if(objectWSlabelFieldnameMapping.get(splitByFullstop[0].trim()) == null)
                            
                        {
                            objectWSlabelFieldnameMapping.put(splitByFullstop[0].trim(), new Map<String,String>());
                            objectWSlabelFieldnameMapping.get(splitByFullstop[0].trim()).put(splitByColon[0].trim(),splitByFullstop[1].trim());
                        }
                        else
                        {
                            objectWSlabelFieldnameMapping.get(splitByFullstop[0].trim()).put(splitByColon[0].trim(),splitByFullstop[1].trim());
                        }
                        
                        
                    }
                    else if(splitByFullstop.size() == 3) 
                    {
                        if(objectWSlabelFieldnameMapping.get(splitByFullstop[0].trim()) == null)
                            
                        {
                            objectWSlabelFieldnameMapping.put(splitByFullstop[0].trim(), new Map<String,String>());
                            objectWSlabelFieldnameMapping.get(splitByFullstop[0].trim()).put(splitByColon[0].trim(),splitByFullstop[1].trim()+'.'+splitByFullstop[2].trim());
                        }
                        else
                        {
                            objectWSlabelFieldnameMapping.get(splitByFullstop[0].trim()).put(splitByColon[0].trim(),splitByFullstop[1].trim()+'.'+splitByFullstop[2].trim());
                        }
                    }
                    else
                    {
                        jsonMap.put(splitByColon[0].trim(),splitByColon[1].trim());
                    } 
                    
                }
                
                jsonMap = createJSONMap(objectWSlabelFieldnameMapping,jsonMap , objectIdMap);
                
                jsonMap.putAll(existingValueMap);
                system.debug(jsonMap);
                
                
         return jsonMap;
    

    
    }
 /*****************************************************
Class Name    : procressGetRequestInputRequest
Author        : ANkush Dubey
Description   : Generate Get Request of Webservice  
Created Date  : 10 Jan 2018
*********************************************************/
    
    public static String  procressGetRequestInputRequest(WebService__mdt serviceDetails,Map<String,String> existingValueMap)
    {
        String url =serviceDetails.ServiceEndPoint__c;
        String finalURL ='';
        //system.debug('url'+url);
        String urlParameters = '?';
        for(String key : existingValueMap.keySet()){
        //userId=demoacl5&pass=demoacl5
        urlParameters += key + '=' + existingValueMap.get(key)+'&';
        }
        urlParameters = urlParameters.substring(0, urlParameters.length() - 1);
        //system.debug('urlParameters'+urlParameters);
        finalURL = url+ urlParameters;
    
     return finalURL;
    }
    

/*****************************************************
Class Name    : setHttpCallGET
Author        : ANkush Dubey
Description   : Send Http Get Request  
Created Date  : 10 Jan 2018
*********************************************************/
    
     //Description - Create Request for GET Call
    public static String  setHttpCallGET(String finalEndPointUrl,Webservice__mdt ServiceDetails)
    {
        String Serviceresponce = '';
        Http http = new HTTP();
        HttpRequest request = new HttpRequest();
        
        if(WKSFDC_Util.validateString(finalEndPointUrl)) {
        
            request.setEndpoint(finalEndPointUrl);
            request.setMethod('GET');
            request.setHeader('Content-Type','text/html');
            if(serviceDetails.TimeOutPeriod__c != null){
            request.setTimeout(Integer.valueOf(serviceDetails.TimeOutPeriod__c));     
            } 
            HttpResponse response = http.send(request);
            //system.debug('response>233>>'+response);
            
        
            if (response.getStatusCode() == 200)
            {
                // Deserialize the JSON string into collections of primitive data types.
                //system.debug('Response 1 => ' + response);
               Serviceresponce = response.getBody();  
              
            } else {
              Serviceresponce = 'Server Down or Not Responding';
              
            //  WKSFDC_Logger.log('WKSFDC_WebServiceLogin', 'SetHttpGetRequestMethod ', '', '',response.getBody());      
             
            }
        }
        return Serviceresponce;
    }
    


/*****************************************************
Class Name    : setHttpCallPOST
Author        : ANkush Dubey
Description   : Send Http Post Request  
Created Date  : 10 Jan 2018
*********************************************************/
    public static String setHttpCallPOST(String JSONString, Webservice__mdt ServiceDetails){
        
        String username = serviceDetails.ClientUsername__c;
        String password = serviceDetails.ClientPassword__c;
        String nameCredential = ServiceDetails.SFNameCredential__c;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        if(serviceDetails.TimeOutPeriod__c != null){
            req.setTimeout(Integer.valueOf(serviceDetails.TimeOutPeriod__c));     
        } 
        
        
        Blob headerValue = Blob.valueOf(username +':' +password);
        // *PREVIOUS String authorizationHeader = 'Bearer ' + EncodingUtil.base64Encode(headerValue);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        //system.debug('Encoder Value >>>>>' + EncodingUtil.base64Encode(headerValue));
        // *PREVIOUS req.setBody(EncodingUtil.urlEncode(JSONString,'UTF-8'));
        req.setBody(JSONString);
        req.setMethod(serviceDetails.RequestType__c);
        if(nameCredential!=null) {
        req.setEndpoint('callout:'+NameCredential);
    	} else {
         req.setEndpoint(serviceDetails.ServiceEndPoint__c);
          if(WKSFDC_Util.validateString(serviceDetails.ContentType__c)){
            req.setHeader('Authorization', authorizationHeader);
          }
        
    	}
        
      
        // *PREVIOUS req.setHeader('content-type','application/x-www-form-urlencoded');
        req.setHeader('content-type','application/json');
        
        HttpResponse res = new HttpResponse();
        res = h.send(req);
        if(res.getStatusCode() == 200)
        {
		
		     // Log Responce in case to Success //
			 if(ServiceDetails.isLogEnabled__c) {
                 // We have call Logger method here //
			}
            return res.getBody();
        }
        else
        {
		     // Log Responce in case to Failer //
            if(ServiceDetails.isLogEnabled__c) {
                 // We have call Logger method here //
			}
			
            return res.getBody();
        }
        
    }  
    
/*****************************************************
Class Name    : dynamicPostCalloutMapResponse
Author        : ANkush Dubey
Description   : Generate Dynamic Request from Custom Metadata for Http Post Request  
Created Date  : 10 Jan 2018
*********************************************************/

  
    public static Map<String,String>  dynamicPostCalloutMapResponse(WKSFDC_DynamicCalloutWrapper dynamicObj)
    {
        try
        {
            String customMetadataName;
            Map<String,String> objectIdMap = new Map<String,String>();
            Map<String,String> existingValueMap = new Map<String,String>();
            Map<String,String> jsonMap = new Map<String,String>();
            Map<String,Map<String,String>> objectWSlabelFieldnameMapping = new Map<String,Map<String,String>>();
            
            
            if(dynamicObj.customMetadataName != null)
            {
                customMetadataName = dynamicObj.customMetadataName;
                //system.debug('customMetadataName'+customMetadataName);
            }
            if(dynamicObj.objectIdMap != null)
            {
                objectIdMap = dynamicObj.objectIdMap;
                //system.debug('objectIdMap'+objectIdMap);
            }
            if(dynamicObj.existingValueMap != null)
            {
                existingValueMap = dynamicObj.existingValueMap;
                //system.debug('existingValueMap'+existingValueMap);
            }
            
            WebService__mdt serviceDetails=WKSFDC_WebServiceLogin.getWebServiceDetails(customMetadataName);             
            
            if(serviceDetails.RequestType__c == 'POST') //for POST Requests
            {
                Set<String> tempFields=new Set<String>();
                tempFields.add('Body');
                String body = serviceDetails.JSONBody__c;
                
                 if(WKSFDC_Util.validateString(body)) {
                        jsonMap= procressPostRequestInputRequest(body,objectIdMap ,existingValueMap);
                 }
                
                
                return jsonMap;
            }
             
            return new Map<String,String>();
        }
        
        catch(Exception ex)
        {
            
           // WKSFDC_Logger.debug('Exception in WKSFDC_WebServiceLogin.dynamicCalloutMapResponse(): at Line No. ' + ex.getLineNumber() + ' and ERROR is: ' +ex);
            
            return new Map<String,String>();
        }
        
    }
  

/*****************************************************
Class Name    : createJSONMap
Author        : ANkush Dubey
Description   : Generate Json Map to convert request into Json
Created Date  : 10 Jan 2018
*********************************************************/
   
    
    public static Map<String,String> createJSONMap(Map<String,Map<String,String>> objectWSlabelFieldnameMapping , Map<String,String> jsonMap , Map<String,String> objectIdMap )
    {
        system.debug('ANKUSH->objectWSlabelFieldnameMapping'+objectIdMap);
        
        if(objectWSlabelFieldnameMapping.get(WKSFDC_Constants.CONTACT) != null)
        {
            Set<String> values = new Set<String>();
            Map<String,String> objectField = objectWSlabelFieldnameMapping.get(WKSFDC_Constants.CONTACT);
            for(String obf: objectField.keySet() )
            {
                values.add(objectField.get(obf));
            }
            String objId = objectIdMap.get(WKSFDC_Constants.CONTACT);
            Map<String, String> conditionsMap = new Map<String, String>();
             String operator ='';
             conditionsMap.put('Id',objId);
             operator = '=';
            List<SObject> temp = WKSFDC_DBUtil.getRecords(WKSFDC_Constants.CONTACT, values , conditionsMap, operator);
            
            if(temp != null && temp.size() > 0)
            {
                for(String obf: objectField.keySet() )
                {
                    List<String> mapValue=objectField.get(obf).split('\\.');
                    system.debug('mapValue-->'+mapValue);
                    if(mapValue.size()>1)
                    {
                        String objApi=mapValue[0];
                        String fApi=mapValue[1];
                        //system.debug(objApi+' &&&&&&&&& '+fApi);
                        //system.debug('Value from parent object '+temp.getSObject(objApi).get(fApi));
                        ////system.debug('myobject' +temp.getSObject(objApi).get(objectField.get(fApi)));
                        jsonMap.put(obf,String.valueof(temp[0].getSObject(objApi).get(fApi)));
                    }
                    else if(mapValue.size() == 1)
                    {
                        jsonMap.put(obf,String.valueof(temp[0].get(objectField.get(obf))));
                    }
                } 
            }           
        }
        if(objectWSlabelFieldnameMapping.get('Opportunity') != null)
        {
            Set<String> values = new Set<String>();
            Map<String,String> objectField = objectWSlabelFieldnameMapping.get('Opportunity');
            for(String obf: objectField.keySet() )
            {
                values.add(objectField.get(obf));
            }
            String objId = objectIdMap.get('Opportunity');
            
            Map<String, String> conditionsMap = new Map<String, String>();
            conditionsMap.put('Id',objId);
            
            List<SObject> temp = WKSFDC_DBUtil.getRecords('Opportunity', values , conditionsMap, '');
            if(temp != null && temp.size() > 0)
            {
                for(String obf: objectField.keySet() )
                {
                    List<String> mapValue=objectField.get(obf).split('\\.');
                    system.debug('mapValue-->'+mapValue);
                    if(mapValue.size()>1)
                    {
                        String objApi=mapValue[0];
                        String fApi=mapValue[1];
                        //system.debug(objApi+' &&&&&&&&& '+fApi);
                        //system.debug('Value from parent object '+temp.getSObject(objApi).get(fApi));
                        ////system.debug('myobject' +temp.getSObject(objApi).get(objectField.get(fApi)));
                        jsonMap.put(obf,String.valueof(temp[0].getSObject(objApi).get(fApi)));
                    }
                    else if(mapValue.size() == 1)
                    {
                        jsonMap.put(obf,String.valueof(temp[0].get(objectField.get(obf))));
                    }
                } 
            }           
        }
        return jsonMap;
        
    }
  
/*****************************************************
Class Name    : getWebServiceDetails
Author        : ANkush Dubey
Description   : Fetch Webservice Details
Created Date  : 10 Jan 2018
*********************************************************/

    
    public static WebService__mdt getWebServiceDetails(String serviceName){
        try
        {
            Set<String> tempFields=new Set<String>();
            tempFields.add('AuthorizationType__c');          
            tempFields.add('ClientId__c');
            tempFields.add('ClientPassword__c');
            tempFields.add('ClientSecretKey__c');
            tempFields.add('ClientUsername__c');
            tempFields.add('ContentType__c');
            tempFields.add('isLogEnabled__c'); 
            tempFields.add('JSONBody__c');
            tempFields.add('RequestType__c');
            tempFields.add('ServiceEndPoint__c');
            tempFields.add('TimeOutPeriod__c');
             tempFields.add('SFNameCredential__c');
            
         

            Map<String, String> condMap = new Map<String, String>();
            condMap.put('MasterLabel',serviceName);
            List<WebService__mdt> serviceDetails=(List<WebService__mdt>)WKSFDC_DBUtil.getRecords('WebService__mdt', tempFields, condMap,'');
           
            
            if(serviceDetails!=null && serviceDetails.size() > 0)
            {
                //system.debug('Service Details'+serviceDetails);
                return  serviceDetails[0]; 
            }
            
            return null;
        }
        
        catch(Exception ex)
        {
        
            System.debug('Error in Integration'+ex.getMessage());
            if(!Test.isRunningTest()){
          
            }
            return null;
        }
    }
   
}