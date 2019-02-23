@istest
public class CreateAccountExtensionControllerTestCls {

     static testmethod void savetest() {        
        Test.startTest();
         Account temp1 = new Account();
         temp1.Name='Sanam';
         temp1.CustomerID__c='9001';
        insert temp1;
        ApexPages.StandardController sc = new ApexPages.StandardController(temp1);
        CreateAccountExtensionController createObj = new CreateAccountExtensionController(sc);
        createObj.save();
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(1, [select count() from account]);
    }

}