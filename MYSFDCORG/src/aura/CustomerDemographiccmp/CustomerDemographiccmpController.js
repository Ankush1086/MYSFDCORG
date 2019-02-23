({
    doInit: function(component, event, helper) {
       helper.constructValidationMap(component); 
        console.log(component.get("v.contactValidationMap"));
        
    },
    afterScriptsLoaded: function(component, event, helper) {
        
    },
    
    
	 handleBlur : function(component, event, helper){
         debugger;
        var fieldAuraId = event.getSource().getLocalId();
        
        if(!$A.util.isUndefinedOrNull(fieldAuraId) && !$A.util.isUndefinedOrNull(component.find(fieldAuraId))){
            
            helper.handleValidate(component, fieldAuraId);
            
        }  
     },

    validate :function(component, event, helper) {
        helper.validateAll(component, false);
        
     return component.get("v.isDataValid");    
    },
    
     save :function(component, event, helper) {
         debugger;
        helper.saveData(component, null, 'final'); 
     }
     
})