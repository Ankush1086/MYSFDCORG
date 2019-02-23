public interface WKSFDC_DataAccessEngine {
    set<Id> upsertRecords(List<SObject> objectList);
    List<String> getPickListValues(String objectName, String fieldName);
    List<SObject> getRecords(String objName,Set<String> fieldSet, Map<String, String> conditionsMap, String operator);
    List<SObject> getFieldSetRecords(String objName, String fieldSetName, Map<String, String> conditionsMap, String operator);
}