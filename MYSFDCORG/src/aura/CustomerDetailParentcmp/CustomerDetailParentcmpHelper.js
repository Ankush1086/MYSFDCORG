({
	saveHelper: function(component){
         debugger; 
        var demographicCmp=component.find('demographic'); 
         var customeraddress=component.find('customeraddress'); 
        
		var result=this.performSpecifiedOperation(component,'validate');
		var valResult = false;
		if(result){
            
            alert('Validate Success');
            demographicCmp.save();
            customeraddress.save();
			//this.performSpecifiedOperation(component,'save');
            //alert(JSON.stringify(component.get("v.creditPolicyValueMap"))); 
			////console.log('creditPolicyValueMap : '+JSON.stringify(component.get("v.creditPolicyValueMap")));
			//alert('creditPolicyValueMap : '+JSON.stringify(component.get("v.creditPolicyValueMap")));
			
			valResult = true;
		}
		return valResult;
	},
    
    performSpecifiedOperation: function(component, opsType){
       var demographicCmp=component.find('demographic'); 
       var dResult=demographicCmp[opsType]();
        var customeraddress=component.find('customeraddress'); 
        var aResult=customeraddress[opsType]();
        
       console.log('dResult '+dResult);
       if(opsType=='validate'){
        var result=(dResult && aResult);
         if(!result){
			//util.showToast('Error!', 'error', 'Please check all error messages before proceeding');
         }
        return result;
       }
       
        
    }
})