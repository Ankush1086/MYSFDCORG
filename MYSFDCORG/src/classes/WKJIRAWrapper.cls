//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//
// The supplied json has fields with names that are not valid in apex
// and so can only be parsed with explicitly generated code, this option
// was auto selected for you.

public class WKJIRAWrapper {


  public class UUIDMetadataRequest {
    
        public String UUID {get;set;} 
        public String TargetSystemName {get;set;} 
        public String CallingSystemName {get;set;} 
        public String UniqueCallingUserId {get;set;} 
        public String IPAddressOfConsumer {get;set;} 
        public String RequestDateTime {get;set;} 
        public String ServiceVersion {get;set;} 
        public String TransactionMonitoringFlag {get;set;} 
        public String LoggingFlag {get;set;} 
        public String SVCusername {get;set;} 
        public String SVCpassword {get;set;} 
        public String ServiceName {get;set;} 
        public String OperationName {get;set;} 
        public String ObjectName {get;set;} 
        public String SourceCountry {get;set;} 
        public String SourceOrganisation {get;set;} 
        public String CallingSystemBatchId {get;set;} 
        public Map<String,String> OperationalInfo {get;set;} 

    
    }
  
    
   
   public WKJIRAWrapper()
    {
        this.UUIDMetadataRequest = new UUIDMetadataRequest();
        this.JObjects =new List<JObjects>();
       
    }  
    
   public UUIDMetadataRequest UUIDMetadataRequest {get;set;} 
    public List<JObjects> JObjects {get;set;} 
    
    
    public class JObjects {
        public String id {get;set;} 
        public String type_Z {get;set;} // in json: type
        public String operation {get;set;} 
        public Body  Body {get;set;} 
        
        
        public JObjects(){
            this.id = id;
            this.type_Z = type_Z;
            this.operation =operation;
            this.Body = new Body();
        }

       
    } 
    
    public class Body {
        public String SalesforceId {get;set;} 
        public String Summary {get;set;} 
        public String Description {get;set;} 
        public Map<String,String> Assignee {get;set;} 
        public Map<String,String> Browser {get;set;} 
        public Map<String,String> CMS {get;set;} 
        public String ExternalCaseCreationDate {get;set;} 
        public String BusinessImpactDescription {get;set;} 
        public String SLATimestamp {get;set;} 
        public String FTPLocation {get;set;} 
        public String StepsToReproduce {get;set;} 
        public String SLATerms {get;set;} 
        public String DurationOfProblem {get;set;} 
        public String ExternalCaseNumber {get;set;} 
        public String StartTimeOfProblem {get;set;} 
        public Map<String,String> Intermittent {get;set;} 
        
        public String ExternalQueueContactPhone {get;set;} 
        public Map<String,String> ScopeOfUsersImpacted {get;set;}  
        public String ExternalQueueContactEmail {get;set;} 
        public Map<String,String> DataIntegrityConcernIdentified {get;set;}   
        public Map<String,String> SecurityConcernIdentified  {get;set;}   
        public String Customer {get;set;} 
        public String EngagementReason {get;set;} 
        public String ExternalCaseAssignedTo {get;set;} 
        public String ExternalCasePriority {get;set;} 
        public String ExternalCaseSeverity {get;set;} 
        public String ExternalCaseStatus {get;set;} 
        public String ExternalContactName {get;set;} 
        public Map<String,String> ExternalQueueContactLocation  {get;set;}  
        public Map<String,String> ExternalQueueContactShift {get;set;}    
        public String ExternalQueueName {get;set;} 
        public String Module {get;set;} 
        public Map<String,String> Product {get;set;}
        public String ReportedEnvironment {get;set;} 
        public String ReproductionEnvironment {get;set;} 

       
    }
    
    
    
    /*
    public static WKJIRAWrapper parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new WKJIRAWrapper(parser);
    }*/
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    







  



}