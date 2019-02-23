/*************************************
    /* Class Name: WKSFDC_DBUtil
    /* Author Name: Ankush Dubey
    /* Created Date: 10/12/2018
     * Related: Common to all Apex Classes
    /* Descrition: Generic Util Class 
*************************************/ 


public class WKSFDC_DBUtil implements WKSFDC_DataAccessEngine { 


    
    public  set<Id> upsertRecords(List<SObject> objectList)
    {
        List<SObject> recordInsertLst = new List<SObject>();
        List<SObject> recordUpdateLst = new List<SObject>();
        Set<Id> resultIdSet = new set<Id>();
        List<Database.SaveResult> insertResults=new List<Database.SaveResult>();
        
        if(objectList!= null )//&& WKSFDC_Util.isNotEmpty(objectList)
        {
            for(SObject s : objectList){
                if(s.get('Id') != null && WKSFDC_Util.validateString(String.valueOf(s.get('Id')))){
                    recordUpdateLst.add(s);
                }
                else{
                    recordInsertLst.add(s);
                }
            }
            if(!recordUpdateLst.IsEmpty()){
                insertResults.addAll(database.update(recordUpdateLst,true));
                
            }
            if(!recordInsertLst.IsEmpty()){
                insertResults.addAll(database.insert(recordInsertLst,true));
            }
        }
        
        
        if(!InsertResults.isEmpty() ){//&& WKSFDC_Util.isNotEmpty(InsertResults)
            for(Database.SaveResult ds : InsertResults){
                if(ds.isSuccess()){
                    resultIdSet.add(ds.getId());
                }
            }
        }
        return resultIdSet;
    }
    
    public set<Id> deleteRecords(List<SObject> objectList, Boolean allOrNone)
    {
        Set<Id> resultIdSet = new set<Id>();
        List<Database.DeleteResult> deleteResults=new List<Database.DeleteResult>();
        
        if(objectList!= null && objectList.size()>0){//&& WKSFDC_Util.isNotEmpty(objectList)
        
            deleteResults.addAll(database.delete(objectList,allOrNone));
        
            if(!deleteResults.isEmpty() ){//&& WKSFDC_Util.isNotEmpty(InsertResults)
                for(Database.DeleteResult dr : deleteResults){
                    if(dr.isSuccess()){
                        resultIdSet.add(dr.getId());
                    }
                }
            }
        }
        return resultIdSet;
    }
    
    public static List<SObject> getRecords(String objName,Set<String> fieldSet, Map<String, String> conditionsMap, String operator) {
        String fields = '';
        String query = '';
        String conditions = '';
        String limitValue = '';
        List<String> fieldTypes = new List<String>{'integer','double','boolean','currency','date'};
            
        try
        {
            for(String field : fieldSet) {
                fields += field + ' ,';
            }
            fields=fields.substring(0, fields.length()-1);
            
            if (conditionsMap != null && !conditionsMap.isEmpty()) {
                for (String cond : conditionsMap.keySet()) 
                {
                    //cond = cond.trim();
                    if(cond.toLowerCase().trim() == 'limit')
                    {
                        limitValue = conditionsMap.get(cond);
                        conditionsMap.remove('limit');
                        continue;
                    }
                    System.debug('conditionsMap-->'+conditionsMap.get(cond));
                    //if(cond.toLowerCase().trim() != 'limit' || cond.toLowerCase().trim() != 'order by')
                    //{
                        String condValue = conditionsMap.get(cond).replaceAll('\\{','').replaceAll('\\}','').replaceAll('\\(','').replaceAll('\\)','').replaceAll(' ','');
                        String fieldType = WKSFDC_Util.getFieldType(objName, cond.trim());
                        
                        if(fieldTypes.contains(fieldType.toLowerCase()) && condValue.contains(','))
                        {
                            conditions += cond + ' IN ( ' + condValue + ' ) ' + operator + ' ';   
                        }
                        else if(fieldTypes.contains(fieldType.toLowerCase()))
                        {
                            conditions += cond + ' = ' + condValue + ' ' + operator + ' ';   
                        }
                        else if(conditionsMap.get(cond).contains(','))
                        {
                            String newValue = condValue.replaceAll(',','\',\'').trim();
                            conditions += cond + ' IN ( \'' + newValue + '\' ) ' + operator + ' ';   
                        }
                        else
                        {
                            conditions += cond + ' = \'' + condValue + '\' ' + operator + ' ';   
                        }   
                    //}
                }
                conditions = conditions.removeEnd(operator+' ');
            }
            
            if (conditionsMap != null && !conditionsMap.isEmpty() && limitValue != '') 
            {
                query = 'SELECT '+ fields +' FROM '+objName+' WHERE ' + conditions + ' LIMIT ' + limitValue;
            }
            else if(conditionsMap != null && !conditionsMap.isEmpty())
            {
                query = 'SELECT '+ fields +' FROM '+objName+' WHERE ' + conditions;
            }
            else
            {
                query = 'SELECT '+ fields +' FROM '+objName + ' ' + limitValue;
            }
            
            System.debug('query-->'+query);
            
            if(query != null)
            {
                return Database.query(query);
            }
        }
        catch(Exception e){
            System.debug('exception -->'+e);
        } 
        return new List<SObject>(); 
    } 
    
    public static List<SObject> getFieldSetRecords(String objName, String fieldSetName, Map<String, String> conditionsMap, String operator) {
        String fields = '';
        String query = '';
        String conditions = '';
        List<String> fieldTypes = new List<String>{'integer','double','boolean','currency'};
            
        try
        {   
            for(Schema.FieldSetMember f : WKSFDC_Util.readFieldSet(fieldSetName,objName)) {
                if(f.getFieldPath() !=null){
                    fields += f.getFieldPath() + ',';
                } 
            }
            
            fields=fields.substring(0, fields.length()-1);
            
            if (conditionsMap != null && !conditionsMap.isEmpty()) {
                for (String cond : conditionsMap.keySet()) 
                {
                    String condValue = conditionsMap.get(cond).replaceAll('\\{','').replaceAll('\\}','').replaceAll('\\(','').replaceAll('\\)','').replaceAll(' ','');
                    String fieldType = WKSFDC_Util.getFieldType(objName, cond);
                    
                    if(fieldTypes.contains(fieldType.toLowerCase()) && condValue.contains(','))
                    {
                        conditions += cond + ' IN ( ' + condValue + ' ) ' + operator + ' ';   
                    }
                    else if(fieldTypes.contains(fieldType.toLowerCase()))
                    {
                        conditions += cond + ' = ' + condValue + ' ' + operator + ' ';   
                    }
                    else if(conditionsMap.get(cond).contains(','))
                    {
                        String newValue = condValue.replaceAll(',','\',\'').trim();
                        conditions += cond + ' IN ( \'' + newValue + '\' ) ' + operator + ' ';   
                    }
                    else
                    {
                        conditions += cond + ' = \'' + condValue + '\' ' + operator + ' ';   
                    }
                }
                conditions = conditions.removeEnd(operator+' ');
            }
            system.debug('sdgsdghsrhhdrhdh');
            if (conditionsMap != null && !conditionsMap.isEmpty()) {
                query = 'SELECT '+ fields +' FROM '+objName+' WHERE ' + conditions;
            }
            else
            {
                query = 'SELECT '+ fields +' FROM '+objName;
            }
            
            System.debug('query-->'+query);
            
            if(query != null)
            {
                return Database.query(query);
            }
        }
        catch(Exception e){
            System.debug('exception -->'+e);
        } 
        return new List<SObject>(); 
    }
    
    public static List<String> getPickListValues(String objectName, String fieldName) {
        List<String> values = new List<String>();
            List<String> types = new List<String>{objectName};
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                if (entry.isActive()) {values.add(entry.getValue());}
            }
        }
        return values;
    }
    public static Map<String,Id> getRecordTypeName(String objectName)
    {
        String objectAPIName = objectName;
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(objectAPIName).getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
        Map<String,Id> recordTypeNameToIdMap = new Map<String,Id>();
        for(Schema.RecordTypeInfo info : recordTypeInfo){
            recordTypeNameToIdMap.put(info.getName(),info.getRecordTypeId());
        }
        return recordTypeNameToIdMap;
    }
    
    
}