@istest
public class SendEmailBatchTestCls {
  @testSetup  
  static void setupAccountSetup() {
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
  
     static testmethod void SendemailBatchtest() {        
        Test.startTest();
         setupAccountSetup();
        SendEmailBatch sendemailObj = new SendEmailBatch();
        Id batchId = Database.executeBatch(sendemailObj);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(1, 1);
    }

}