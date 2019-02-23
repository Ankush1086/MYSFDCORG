({
     constructValidationMap : function(component){
        var valMap={};
        valMap["contact.FirstName"]="Required,StrictlyText";
        valMap["contact.LastName"]="Required,StrictlyText";
        valMap["contact.MiddleName"]="StrictlyText";
        valMap["contact.Email"]="Email";     
        component.set("v.contactValidationMap",valMap);
    },
    
    
	handleValidate : function(component, fieldAuraId){
        debugger;
      	var cmp=component.find(fieldAuraId);
        var value=component.find(fieldAuraId).get("v.value");
        var mapName='v.'+(fieldAuraId.slice(0, fieldAuraId.indexOf('.')))+'ValidationMap';
        var valMap=component.get(mapName);
        var valList=(valMap[fieldAuraId]).split(',');
        var result=this.validate(component, valList, value, false, false,  fieldAuraId);
        console.log(result);
        
         if(!$A.util.isUndefinedOrNull(result) || !$A.util.isEmpty(result)){
             if(!$A.util.isUndefinedOrNull(cmp.get("v.type"))){
                 
                  if(cmp.get("v.type")=='text' || cmp.get("v.type")=='number' || cmp.get("v.type")=='tel'){
                        var errMsg= (result=='Required') ? (cmp.get("v.name")+' is mandatory') : 'Enter valid '+cmp.get("v.name");
                        cmp.setCustomValidity(errMsg);
                       
                        //}
                        //if(cmp.get("v.type")=='number'){
                        //	 var errMsg='Enter valid '+cmp.get("v.name");
                        //	 cmp.setCustomValidity(errMsg);
                    }
                    cmp.reportValidity();
                 
             }
             
         }
        
        
    },
    
    validate : function (component, valList, value, isDraft, isSave, fieldAuraId){
     
         var valResult=true;
         var valCondition;
        
         for(var i in valList){
             var tmpVal = value ;
                if(valList[i]=='Required'){
        			if(fieldAuraId === 'contact.FirstName' || fieldAuraId === 'contact.LastName'){
                    	tmpVal = (!$A.util.isUndefinedOrNull(tmpVal) && !$A.util.isEmpty(tmpVal)) ? tmpVal.trim() : tmpVal;
                    }
                    if($A.util.isUndefinedOrNull(tmpVal) || $A.util.isEmpty(tmpVal)){
                        valResult=false;
                    }
                }
             
             if(valList[i]=='StrictlyText'){
        			if(fieldAuraId === 'contact.FirstName' || fieldAuraId === 'contact.LastName'){
                    	tmpVal = (!$A.util.isUndefinedOrNull(tmpVal) && !$A.util.isEmpty(tmpVal)) ? tmpVal.trim() : tmpVal;
                        if(!util.validate(tmpVal,'StrictlyText')) {
                        	valResult=false;
                        }
                    
                    }
                    
                        
                    
                }
             
             if(!valResult){
                    valCondition=valList[i];
                    break;
                }
         }
      return valCondition; 
        
    },
    
     validateAll : function(component, isDraft){
       
        component.set("v.isDataValid",true);
        var contactValidationMap=component.get("v.contactValidationMap");
        this.checkValidity(component, isDraft, contactValidationMap);
        
    },
    
    checkValidity : function(component, isDraft, valMap){
       
        for(var fieldAuraId in valMap){
            //var fieldAuraId=valMap[key];
            var cmp=component.find(fieldAuraId);
            if(!$A.util.isUndefinedOrNull(cmp)){
                var value= cmp.get("v.value") ;
                
                //var value=obj[fieldAuraId];
                var valList;
                valList=(valMap[fieldAuraId]).split(',');
                
                
                
                var result=this.validate(component, valList, value, isDraft, true, fieldAuraId);
                if(!$A.util.isUndefinedOrNull(result) || !$A.util.isEmpty(result)){
                    var cmp=component.find(fieldAuraId);
                    //alert(fieldAuraId);
                    component.set("v.isDataValid",false);
                    //alert(fieldAuraId);
                    if(result!='CreditPolicies'){
                        if(fieldAuraId==='contact.Birthdate'){
                            cmp.set("v.errors", [{
                                message: "Invalid date format"
                            }]);
                        }
                        else if(!$A.util.isUndefinedOrNull(cmp.get("v.type"))){
                            //cmp.setCustomValidity(result);
                            if(cmp.get("v.type")=='text'  || cmp.get("v.type")=='number' || cmp.get("v.type")=='tel'){
                                var errMsg= (result=='Required') ? (cmp.get("v.name")+' is mandatory') : 'Enter valid '+cmp.get("v.name");
                                cmp.setCustomValidity(errMsg);
                            }
                            cmp.reportValidity();
                            
                        }
                            else{
                                
                                cmp.showHelpMessageIfInvalid();
                            }
                    }
                }
            }
        }
    },
    
     saveData : function(component, sObjList, saveOn){ 
         debugger;
        var sObjList=[];
        var contact = component.get("v.contact");
         if(!$A.util.isUndefinedOrNull(contact) || !$A.util.isEmpty(contact)) {
         sObjList.push(contact);
             
             this.saveToServer(component, this, sObjList, saveOn, function(result, helper){
              if(!$A.util.isUndefinedOrNull(result) && !$A.util.isUndefinedOrNull(JSON.parse(result))){
                var res = JSON.parse(result);
                var customerID = res['RecordID'];
              		alert('Insert Successfully');
                  
                  util.fireEvent(component, 'BroadcastCustomerID', {"ContactID":customerID}, 'Application');
              
              }
            });
         }
         
         
         
     },
    
    saveToServer : function (component, helper, sObjList, saveOn, hCallBack){
     var feature = 'customerdemographicdetails';
        if(!$A.util.isUndefinedOrNull(sObjList)) {
        
            util.getDataFromServer(component, null, {"sObjList":sObjList,"feature":feature}, "c.saveRecords", helper, function(result, helper) {
                if(!$A.util.isUndefinedOrNull(result)){
                	var res = JSON.parse(result);
                    if(res['Error'] === 'Inserted Error'){
                     alert('Insert Failed'); 
                      util.fireEvent(component, 'BroadcastCustomerID', {"ContactID":"ghgjhg"}, 'Application');
                    }
                    
                    else if (hCallBack){    
                    hCallBack(result, helper);
                }
                }
            }); 
            
        }  
     
        
    }
    
    
    
})