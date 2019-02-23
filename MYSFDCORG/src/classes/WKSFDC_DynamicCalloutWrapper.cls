public with sharing class WKSFDC_DynamicCalloutWrapper 
{
    public Map<String,String> objectIdMap{get;set;} 
    public Map<String,String> existingValueMap{get;set;}
    public String customMetadataName{get;set;}
    
    public WKSFDC_DynamicCalloutWrapper (Map<String,String> objectIdMap ,  Map<String,String> existingValueMap , String customMetadataName )
    {
        this.objectIdMap = objectIdMap;
        this.existingValueMap = existingValueMap;
        this.customMetadataName = customMetadataName;
    }
    public WKSFDC_DynamicCalloutWrapper()
    {
        
    }
}