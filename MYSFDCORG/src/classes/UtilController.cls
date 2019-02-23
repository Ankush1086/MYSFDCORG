/*****************************************************
Class Name    : UtilController
Author        : ANkush Dubey
Description   : Global util method like valid string, record access check  
Created Date  : 1 Sept 2018
*********************************************************/
public with sharing class UtilController {
    
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
	
	public static Boolean validateNumber(String str){
        Boolean result;
        
        if(String.isNotEmpty(str) && str!=null && String.isNotBlank(str) && str.isNumeric()){
            result=true;
        }
        else{
            result=false;
        }
        return result;
    } 
	
	public static Boolean validateAlphanumeric(String str){
        Boolean result;
        
        if(String.isNotEmpty(str) && str!=null && String.isNotBlank(str) && str.isAlphanumeric()){
            result=true;
        }
        else{
            result=false;
        }
        return result;
    } 
    
    public static boolean validatePhone(String Phone)  
    {
        boolean result =false;
        if (Phone != null)  
        {  
            String phoneNumber = Phone ;  
            Pattern phonePattern = Pattern.compile('\\D*?(\\d\\D*?){10}');  
            Pattern numericPattern = Pattern.compile('[0-9]{10}');  
            Matcher phoneMatcher = phonePattern.matcher(phoneNumber);  
            
            if(phoneNumber.length() == 10)  
            {  
                Matcher numericMatcher = numericPattern.matcher(phoneNumber);  
                if(numericMatcher.matches())  
                {  
                    result =true;
                      
                }  
                else  
                {   
                    result =false;
                }  
            }  
            else  
            {  
                result =false; 
            }  
        }  
        
       return result;
    }

}