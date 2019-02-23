@istest
public class CustomerserviceTest{
    
 @testSetup  
  static void setupAccountSenarios2() {
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
      Account temp1 = new Account();
      temp1.Name='Sanam';
      temp1.CustomerID__c='9001';
      testAccts.add(temp1);
      Account temp2 = new Account();
      temp2.Name='Sanam';
      temp2.CustomerID__c='9001';
      testAccts.add(temp2);
      Account temp3 = new Account();
      temp3.Name='Samar';
      temp3.CustomerID__c='9002';
      testAccts.add(temp3);
      
      Account temp4 = new Account();
      temp4.Name='Samar';
      temp4.CustomerID__c='9002';
      testAccts.add(temp4);
      
      insert testAccts;
    }

 static testMethod void  createServiceTest(){

   String MockRequest ='{ "accounts":[{"Name":"Sunil","CustomerID":"8080"}, {"Name":"Ajay","CustomerID":"6767"}]}';
   

   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/AccountService';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type
    req.requestBody = Blob.valueOf(MockRequest);
    RestContext.request = req;
    RestContext.response= res;
     Test.startTest();
     CustomService_Cls.createAccount();
    System.debug('Responce Body'+res);
    Test.stopTest();
     System.assertNotEquals(null, res);

   }
    
   static testMethod void  createServiceSenarios2Test(){

       String MockRequest ='{"accounts":[{"Name":"","CustomerID":""},{"Name":"Sumit","CustomerID":"5656"}]}';
       
   Test.startTest();
   List<Account> testAccts = new List<Account>();
   Account temp = new Account();
   temp.Name='Sumit';
   temp.CustomerID__c='5656';
   testAccts.add(temp);
   insert testAccts;

   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/AccountService';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type
    req.requestBody = Blob.valueOf(MockRequest);
    RestContext.request = req;
    RestContext.response= res;
    
     CustomService_Cls.createAccount();
    System.debug('Responce Body'+res);
    Test.stopTest();
     System.assertNotEquals(null, res);

   }   
    
 static testMethod void  createServiceSenarios3Test(){

   String MockRequest ='{"accounts":[{"Name":"Sanam","CustomerID":"9001"}, {"Name":"Samar","CustomerID":"9002"} ]}';
   
   Test.startTest();
   setupAccountSenarios2();
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/AccountService';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type
    req.requestBody = Blob.valueOf(MockRequest);
    RestContext.request = req;
    RestContext.response= res;
    
     CustomService_Cls.createAccount();
    System.debug('Responce Body'+res);
    Test.stopTest();
     System.assertNotEquals(null, res);

   }   
   
    static testMethod void  createServiceSenarios4Test(){

   String MockRequest ='{"accounts":[{"Name":"Sanam","CustomerID":"9001"}, {"Name":"Sanam","CustomerID":"9001"},{"Name":"Sanam","CustomerID":"9001"}]}';
   
   Test.startTest();
    setupAccountSenarios2();
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/AccountService';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type
    req.requestBody = Blob.valueOf(MockRequest);
    RestContext.request = req;
    RestContext.response= res;
    
     CustomService_Cls.createAccount();
    System.debug('Responce Body'+res);
    Test.stopTest();
   System.assertNotEquals(null, res);
   }   
    
  static testMethod void  createServiceSenarios5Test(){

   String MockRequest ='{"accounts":[{"Name":"Sanam","CustomerID":"9001"}, {"Name":"Sanam","CustomerID":"9001"},{"Name":"Sanam","CustomerID":"9001"}]}';
   
   Test.startTest();
   
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/AccountService';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type
    req.requestBody = Blob.valueOf(MockRequest);
    RestContext.request = req;
    RestContext.response= res;
    
     CustomService_Cls.createAccount();
    System.debug('Responce Body'+res);
    Test.stopTest();
   System.assertNotEquals(null, res);
   }  
    
   static testMethod void  getServiceSenarios1Test(){
   Test.startTest();
    setupAccountSenarios2();
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/AccountService?customerId=9001';  //Request URL
    req.httpMethod = 'GET';//HTTP Request Type
    RestContext.request = req;
    RestContext.response= res;
    system.debug('req'+req);
    CustomService_Cls.searchCustomer();
    System.debug('Responce Body'+res);
    Test.stopTest();
    System.assertNotEquals(null, res);
   }   
    
    
   static testMethod void  getServiceSenarios2Test(){
   Test.startTest();
    setupAccountSenarios2();
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/AccountService?limit=100';  //Request URL
    req.httpMethod = 'GET';//HTTP Request Type
    RestContext.request = req;
    RestContext.response= res;
    
     CustomService_Cls.searchCustomer();
    System.debug('Responce Body'+res);
    Test.stopTest();
    System.assertNotEquals(null, res);
   }   

    static testMethod void  getServiceSenarios3Test(){
   Test.startTest();
    setupAccountSenarios2();
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/AccountService?limit=11000';  //Request URL
    req.httpMethod = 'GET';//HTTP Request Type
   
    RestContext.request = req;
    RestContext.response= res;
    
     CustomService_Cls.searchCustomer();
    System.debug('Responce Body'+res);
    Test.stopTest();
    System.assertNotEquals(null, res);

   }  
     static testMethod void  getServiceSenarios4Test(){
   Test.startTest();
    setupAccountSenarios2();
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/AccountService';  //Request URL
    req.httpMethod = 'GET';//HTTP Request Type
    RestContext.request = req;
    RestContext.response= res;
    
     CustomService_Cls.searchCustomer();
    System.debug('Responce Body'+res);
    Test.stopTest();
    System.assertNotEquals(null, res);
   }   

    
    
    
}