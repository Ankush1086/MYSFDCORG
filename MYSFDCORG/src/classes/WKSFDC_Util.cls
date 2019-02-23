/*************************************
    /* Class Name: WKSFDC_DBUtil
    /* Author Name: Ankush Dubey
    /* Created Date: 10/12/2018
     * Related: Common to all Apex Classes
    /* Descrition: Generic Util Class 
*************************************/ 
 
public with sharing class WKSFDC_Util {
    
    
   
   
   
/*****************************************************
Method Name    : validateString
Author        : ANkush Dubey
Description   : Generic Method to check valid String 
Created Date  : 10 Dec 2018
*********************************************************/ 
    
    public static Boolean validateString(String str){
        Boolean result;
        
        if(String.isNotEmpty(str) && str!=null && String.isNotBlank(str)){
            result=true;
        }
        else{
            result=false;
        }
        return result;
    } 
    
    
  /*****************************************************
Method Name    : getFieldType
Author        : ANkush Dubey
Description   : Fetch Field Set Type for specific Object
 
Created Date  : 10 Dec 2018
*********************************************************/ 

    public static String getFieldType(String objName, String fieldName)
    {
        Schema.DescribeFieldResult fr;
        try
        {
            Schema.SObjectType t = Schema.getGlobalDescribe().get(objName);
            
            Schema.DescribeSObjectResult res = t.getDescribe();
    
            fr = res.fields.getMap().get(fieldName).getDescribe();
     
        }
        catch(Exception e)
        {
       
        }
        return String.valueOf(fr.getType());
    }
    
    
/*****************************************************
Method Name    : getFieldType
Author        : ANkush Dubey
Description   : Show Data in Date Format 
 
Created Date  : 10 Dec 2018
*********************************************************/ 

    public static String changeDateFormat(DateTime d)
    {
        String formatedDate='';
        try
        {
            if(d != null)
            {
                formatedDate = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd-MMM-YYYY').toUpperCase();
                return formatedDate;
            }
        }
        catch(Exception ex)
        {
            //System.debug('exception in changeDateFormat-->'+ex);
        }
        return formatedDate;
    }
    
    /*****************************************************
Method Name    : getFieldType
Author        : ANkush Dubey
Description   : Show Data in Date Format 
 
Created Date  : 10 Dec 2018
*********************************************************/ 
    
    public static String yearCount(String month, String year){
        Map<String,Integer> monthMap = new Map<String,Integer>();
        monthMap.put('January',1);
        monthMap.put('February',2);
        monthMap.put('March',3);
        monthMap.put('April',4);
        monthMap.put('May',5);
        monthMap.put('June',6);
        monthMap.put('July',7);
        monthMap.put('August',8);
        monthMap.put('September',9);
        monthMap.put('October',10);
        monthMap.put('November',11);
        monthMap.put('December',12);
        try{
            if(WKSFDC_Util.validateString(month) && WKSFDC_Util.validateString(year))
            {
                DateTime dt = System.now();
                if(dt.year() >= Integer.valueOf(year))
                {
                    if(monthMap.containsKey(month) && dt.month() >= monthMap.get(month))   
                    {
                        return String.valueOf(dt.year() - Integer.valueOf(year));
                    }
                    else if(monthMap.containsKey(month) && dt.month() < monthMap.get(month))
                    {
                        return String.valueOf(dt.year() - Integer.valueOf(year)-1);    
                    }
                    return '0';
                }
            }
        }
        catch(Exception ex)
        {
            //System.debug('-->'+ex);
            System.debug('Exception in CAS_Logger.log(): at Line No. ' + ex.getLineNumber() + ' and ERROR is: ' +ex);
        }
        return '0';
    }
    
    public static String monthCount(String month, String year){        
        try{
            if(WKSFDC_Util.validateString(month) && WKSFDC_Util.validateString(year))
            {
                DateTime dt = System.now();
                if(dt.year() >= Integer.valueOf(year))
                {
                    if(dt.month() >= Integer.valueOf(month))   
                    {
                        Integer yr = (dt.year() - Integer.valueOf(year))*12;
                        return String.valueOf(yr + dt.month() - Integer.valueOf(month));
                    }
                    else if(dt.month() < Integer.valueOf(month))
                    {
                        Integer yr = (dt.year() - Integer.valueOf(year))*12;
                        Integer mon = dt.month() - Integer.valueOf(month);
                        return String.valueOf(yr - mon); 
                    }
                    else
                    {
                        return String.valueOf(dt.month() - Integer.valueOf(month));
                    }
                }
            }
        }
        catch(Exception ex)
        {
            //System.debug('-->'+ex);
        }
        return '0';
    }
    
  
/*****************************************************
Method Name    : getPickValues
Author        : ANkush Dubey
Description   : Fetch Picklist Value from Object form Lightning Componenent
 
Created Date  : 10 Dec 2018
*********************************************************/     

    public static Map<String,String> getPickValues
        (String object_name, String field_name, String first_val) {
        Map<String,String> options = new Map<String,String>();
        if (first_val != null && first_val != '') { 
            options.put(first_val,first_val); 
        }
        Map<String, Schema.SObjectType> schemaDescribe = Schema.getGlobalDescribe();
        Schema.DescribeFieldResult fieldResult = schemaDescribe.get(object_name).getDescribe().fields.getMap().get(field_name).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) 
        {
            options.put(f.getLabel(),f.getValue());
        }
        return options;
    }
    
    
/*****************************************************
Method Name    : isEmpty
Author        : ANkush Dubey
Description   : Check isEmplay for Object 
 
Created Date  : 10 Dec 2018
*********************************************************/       
    
   public static boolean isEmpty(Object obj){
        boolean returnValue = True;
        if(obj instanceOf String){
            String str = (String)obj;
            return (str == null || str.length()== 0 || str.trim().length()==0);
        }
        if(obj instanceOf Decimal){
            Decimal decimalVar = (Decimal)obj;
            return (decimalVar == null);
        }
        if(obj instanceOf Date){
            Date dateVar = (Date)obj;
            return (dateVar == null);
        }
        if(obj instanceOf DateTime){
            DateTime DateTimeVar = (DateTime)obj;
            return (DateTimeVar == null);
        }
        if(obj instanceOf List<Object>){
            List<Object> lst = (List<Object>) obj;
            return (lst == null || lst.isEmpty());
        }
        if(obj instanceOf Map<String,String>){
            Map<String,String> m = (Map<String,String>) obj;
            return (m == null || m.isEmpty());
        }
        if(obj instanceOf Pagereference){
            Pagereference pr = (Pagereference) obj;
            return (pr == null);
        }
    
        if(obj instanceOf sObject)
        {
            sObject sObj = (sObject) obj;
            return (sObj == null);
        }
        
        if(obj instanceOf sObject)
        {
            sObject sObj = (sObject) obj;
            return (sObj == null);
        }
        return returnValue;
    }
/**********************************************
* Author        : 
* Description   : Method to get profileName of logged in user
* Created Date  : 7th Dec 2018
**********************************************/
    public static String getProfileNameOfLoggedInUser(){
        try{
            return [SELECT Name FROM Profile WHERE Id=:userInfo.getProfileId() LIMIT 1][0].Name;
        }
        catch(Exception e){
            System.debug('exc '+e.getMessage());
            return null;
        }
        
    }
    
/**********************************************
* Author        : 
* Description   : Method to check Object Level Permission
* Created Date  : 7th Dec 2018
**********************************************/
    //Method to Check Object has Read Access
    public static boolean hasReadAccess(String objName){
        return Schema.getGlobalDescribe().get(objName).getDescribe().isAccessible();
    }
    
    //Method to Check Object has Create Access
    public static boolean hasCreateAccess(String objName){
        return Schema.getGlobalDescribe().get(objName).getDescribe().isCreateable();
    }
    
    //Method to Check Object has update Access
    public static boolean hasUpdateAccess(String objName){
        return Schema.getGlobalDescribe().get(objName).getDescribe().isUpdateable();
    }
   

  
    public static String getRoleAPI(String userId){
        return fetchUserAttribute(userId, 'RoleAPI');
    }
   
        
    /**********************************************
    * Author        : Ankush Dubey
    * Description   : Fetch UserData Common Detail 
    * Created Date  : 7th Dec 2018
    **********************************************/
    
    
    public static String fetchUserAttribute(String userId, String feature){
        String result;
        User usr;
        try{
            usr=fetchUserData(userId);
            result=feature.equals('ProfileName') ? usr.profile.Name : (feature.equals('RoleAPI') ? usr.UserRole.DeveloperName : (feature.equals('ManagerId') ? usr.ManagerId : result) ) ;
            
        }
        catch(Exception e){
            System.debug('exc '+e.getMessage());
        }
        return result;
    }
    
    
    
    public static User fetchUserData(String userId){
    
       return ((List<User>)WKSFDC_DBUtil.getRecords('User',new Set<String>{'Name','ManagerId','UserRole.DeveloperName','profile.Name'},new Map<String,String>{ 'Id' => userId}, null))[0];
    
    
    }
    
    
    
    
    
    
    
    public static Object fetchValue(SObject obj, String apiStr){
        List<String> apiList = apiStr.split('\\.');
        Object value;
        Integer cnt=0;
        //system.debug(con);
        if(apiList!=null && apiList.size()>0){
            system.debug(cnt+'     '+obj);
            for(String api: apiList){
                cnt++;
                if(cnt==apiList.size()){
                    value=obj.get(api);
                }
                else{
                    obj=obj.getSObject(api);
                }
            }
        }
        return value;
    }
    
    public static Boolean getSRResult(Database.SaveResult[] srList){
        Boolean result=true;
        for(Database.saveResult sr : srList){
            if(!sr.isSuccess()){
                result=false;
            }
        }
        return result;
    }
    
    
        
/*****************************************************
Method Name    : readFieldSet
Author        : ANkush Dubey
Description   : Fetch FeldSet Field for give Object
 
Created Date  : 10 Dec 2018
*********************************************************/  
    
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String objectName)
    {
        Schema.FieldSet fieldSetObj;
        try
        {
            if(WKSFDC_Util.validateString(fieldSetName) && WKSFDC_Util.validateString(objectName))
            { 
                Schema.SObjectType sObjectTypeObj = Schema.getGlobalDescribe().get(objectName);
                Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
                fieldSetObj = describeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
                       
            }
        }
        catch(Exception e)
        {
            
        }
        return fieldSetObj.getFields(); 
    }
    
    
}