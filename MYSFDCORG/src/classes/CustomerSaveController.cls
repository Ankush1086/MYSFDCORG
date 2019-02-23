public with sharing class CustomerSaveController {

   @auraEnabled
    public static String saveRecords(List<SObject> sObjList, String feature){
    
    Map<String,String> saveResult =new Map<String,String>();
    Database.SaveResult  sr = null;
    try {
    system.debug('sObjList-->'+sObjList);
    if(sObjList.size() > 0) {
         sr = Database.insert(sObjList[0], false);
       
        if(sr.isSuccess()){
          saveResult.put('Success','Inserted Successfully');
          saveResult.put('RecordID',sr.getId());
        } 
        else {
         saveResult.put('Error','Inserted Error');
        }
        
      
    }
    
    }catch (Exception e) {
            system.debug('Message'+e.getMessage()+e.getLineNumber());
        }
    
     return JSON.serialize(saveResult);
    }

 @auraEnabled  
 public static String saveRecordsAddress(List<SObject> sObjList, String feature){
    
    Map<String,String> saveResult =new Map<String,String>();
    Database.SaveResult  sr = null;
    try {
    system.debug('sObjListAddress'+sObjList);
    if(sObjList.size() > 0) {
         sr = Database.update(sObjList[0], false);
       
        if(sr.isSuccess()){
          saveResult.put('Success','Inserted Successfully');
        } 
        else {
         saveResult.put('Error','Inserted Error');
        }
        
      
    }
    
    }catch (Exception e) {
            system.debug('Message'+e.getMessage()+e.getLineNumber());
        }
    
     return JSON.serialize(saveResult);
    }




}