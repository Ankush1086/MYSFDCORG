({
	getAccountTask : function(component,event,AccountID){
        
  var action = component.get("c.getAccountTask");     
  action.setParams({ AccountID : AccountID });  
  action.setCallback(this, function(response) {
 
    var state = response.getState(); 
    if (state == 'SUCCESS') { 
     component.set("v.TaskList",response.getReturnValue()); 
     console.log('Test'+component.get("v.TaskList"));
        
        
         

    } 
    else {  
      console.log(state);
    }
  });
  $A.enqueueAction(action);
        
        
         }
  
		
})