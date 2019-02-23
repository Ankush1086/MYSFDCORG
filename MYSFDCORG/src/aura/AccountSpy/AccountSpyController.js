({
    
    	doInit : function(component,event,helper) {
           
          var AccountID ='0017F00001ZpQfM'; 
		  helper.getAccountTask(component,event,AccountID);
                       
                
            
	},
    
    
	handleMessage : function(component, event, helper) {
		const param = event.getParam('message');
        console.log('Param'+param);
		console.log('Task "${param.sobject.Name}" with Id ${param.sobject.Id} is ${param.event.type}');
		var AccountID ='0017F00001ZpQfM'; 
		  helper.getAccountTask(component,event,AccountID);
	},
    
    afterScriptsLoaded :function (component,event,helper) {
        
        
    }
})