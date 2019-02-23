public class  AccountController_Cls {
    
     @AuraEnabled
     public static List<Task> getAccountTask(String AccountID) {
      List<String> TaskID = new List<String>();   
         List<Task> taskList =  [Select id,Subject,Status from Task where WhatID =:AccountID];
         for(Task rs:taskList) {
            TaskID.add(rs.id); 
             
         }
         
    return taskList;
    }
    
    public static List<Task> getAccountTaskBackup(String AccountID) {
      List<String> TaskID = new List<String>();   
         List<Task> taskList =  [Select id,Subject,Status from Task where WhatID =:AccountID];
         for(Task rs:taskList) {
            TaskID.add(rs.id); 
             
         }
         
    return taskList;
    }

}