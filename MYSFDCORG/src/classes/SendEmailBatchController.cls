/*****************************************************
Class Name    : SendEmailBatchController
Author        : ANkush Dubey
Description   : SendEmail Hepler Controller method
Created Date  : 2 Sept 2018
*********************************************************/

public with sharing class SendEmailBatchController{
	
    
    
/*****************************************************
Method Name    : getEmailTemplate
Author        : ANkush Dubey
Description   : Fetch Email Tepmate
Created Date  : 2 Sept 2018
*********************************************************/
    public static List<EmailTemplate> getEmailTemplate(){
        
        List<EmailTemplate> templateList = new List<EmailTemplate>(); 
        String emailTemplate =System.Label.BatchEmailTemplate;
        try{
            templateList = [Select Body,HTMLValue,Subject FROM EmailTemplate WHERE DeveloperName =:emailTemplate LIMIT 1];
            
        }
        catch(Exception e){
            
        }
        return templateList;
    }
    
    
/*****************************************************
Method Name    : sendStatusEmail
Author        : ANkush Dubey
Description   : Send Email to USer 
Created Date  : 2 Sept 2018
*********************************************************/
    public static void sendStatusEmail(String resultIds){
        Integer recCount= 0;
        try{
            List<EmailTemplate> emailTemplates = getEmailTemplate();
            // Email Stored in Customer Seeting EmailUser__c
            List<EmailUser__c> emailUserList = [select Email__c from EmailUser__c LIMIT 1];
            
            if(emailTemplates != null && emailTemplates.size() > 0 && emailUserList != null && emailUserList.size() > 0){
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                
                Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                String[] toAddresses = new list<string>();
                //toAddresses.add(userinfo.getuseremail()); 
                
                toAddresses.add(emailUserList[recCount].Email__c); 
                email.setSubject(emailTemplates[recCount].Subject);
                email.setToAddresses(toAddresses);
                DateTime currentDate = Date.Today();
                String todayDate = currentDate.format('dd/MM/yyyy') ;
                String emailStr = emailTemplates[recCount].Body;
                emailStr = emailStr.replace('[DATE]',todayDate);
				emailStr = emailStr.replace('{!accountList}',resultIds);
                //email.setHtmlBody(emailTemplates[recCount].HTMLValue);
                email.setPlainTextBody(emailStr);
                Messaging.SendEmailResult [] mailRes = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
            
            
        }catch(Exception e){
             system.debug('Message'+e.getMessage()+e.getLineNumber());
        }
        
    }
 /*****************************************************
Method Name    : parseDate
Author        : ANkush Dubey
Description   : Find out data between 24 hours to add date condition in Batch query location to fetch record notin Last batch 
Created Date  : 2 Sept 2018
*********************************************************/
    public static DateTime parseDate(String dte, Boolean isEnd){
    	System.debug('Date : '+dte);
        String finalDate;
        DateTime dTime;
        if(UtilController.validateString(dte)){
        	Date dt = date.valueOf(dte);
        	if(isEnd){
        		dTime=datetime.newInstance(dt.year(), dt.month(),dt.day());
        		dtime=dtime.addHours(23);
				dtime=dtime.addMinutes(59);
        	}
        	else{
        		dTime=datetime.newInstance(dt.year(), dt.month(),dt.day());
        	}
        	//finalDate=dtime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''); 
        }
        return dTime;
    }    
}