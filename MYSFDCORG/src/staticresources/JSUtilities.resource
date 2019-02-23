/* Author : Ankush Dubey */

(function(w){
    "use strict"; //Optional because LC on LockerService active runs in strict mode

    var utilMethods = {
        "showToast":showToast,
        "createComponent":createComponent,
		"getDataFromServer":getDataFromServer,
		"openModal":openModal,
		"closeModal":closeModal,
		"fireEvent":fireEvent,
		"regExMatcher":regExMatcher,
		"validate":validate,
		"validateV1":validateV1,
		"generateRegEx":generateRegEx,
		"toggleCollapseHandler":toggleCollapseHandler,
		
    };
	
	function toggleCollapseHandler(component, divId, auraId) {
		debugger;
		var toggleDotsSrc= $A.util.isUndefinedOrNull(auraId) ? "toggleDots" : auraId;
        var toggleDots = component.find(toggleDotsSrc);
        var container = document.getElementById(divId);
        $A.util.toggleClass(container, 'slds-is-collapsed');
        if (toggleDots.get("v.iconName") == 'utility:jump_to_bottom')
            toggleDots.set("v.iconName", "utility:jump_to_top");
        else
            toggleDots.set("v.iconName", "utility:jump_to_bottom");
    }

    function showToast(title, type, message){
		debugger;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({

            "title": title,
            "type": type,
            "mode": "pester",
            "message": message,
            "duration": 100
        }); //type : success, error, warning.
        toastEvent.fire();
    } 

    function createComponent(component, cmpName, objAttribute, helper, callback){
		debugger;
        $A.createComponent(
            cmpName,
            objAttribute,
            function(newCmp) {
                if (!$A.util.isUndefinedOrNull(newCmp) && newCmp.isValid()) {
					if (callback) callback(newCmp,helper);
                }
            }
        );
        console.log("method2 called");
    }
	
	function getDataFromServer(component, event, fnAttr, fName, helper, callback){	    
        debugger;
        var action = component.get(fName);
        if(!$A.util.isUndefinedOrNull(fnAttr)){
            action.setParams(fnAttr);
        }
        action.setCallback(this, function(response) {
            
            if (response.getState() == "SUCCESS") {
                if (callback) callback(response.getReturnValue(),helper);
                
            } 
        });
        $A.enqueueAction(action);
        console.log("method2 called");
    }
	
	function openModal(component, target, backdrop){
		var result=false;	    
		if(!$A.util.isUndefinedOrNull(component) &&  !$A.util.isUndefinedOrNull(target) && !$A.util.isUndefinedOrNull(backdrop)){
			var cmpTarget = component.find(target);
			var cmpBack = component.find(backdrop);
			$A.util.addClass(cmpTarget, 'slds-fade-in-open');
			$A.util.addClass(cmpBack, 'slds-backdrop--open');
			result=true;
		}
		return result;
    }
	
	function closeModal(component, target, backdrop){	  
		var result=false;
		if(!$A.util.isUndefinedOrNull(component) &&  !$A.util.isUndefinedOrNull(target) && !$A.util.isUndefinedOrNull(backdrop)){
			var cmpTarget = component.find(target);
			var cmpBack = component.find(backdrop);
			$A.util.removeClass(cmpBack, 'slds-backdrop--open');
			$A.util.removeClass(cmpTarget, 'slds-fade-in-open');
			result=true;
		}
		return result;
	}
	
	function fireEvent(component, eventName, eventParameters, eventType){	
		debugger;
		var evt;
		var result=false;
		if(!$A.util.isUndefinedOrNull(eventType) && !$A.util.isUndefinedOrNull(component) 
			&& !$A.util.isUndefinedOrNull(eventName)){
			if(eventType=='Application'){
				evt = $A.get("e.c:"+eventName);
			}
			else if(eventType=='Component'){
				evt = component.getEvent(eventName);
			}
			
			if(!$A.util.isUndefinedOrNull(evt)){
				if(!$A.util.isUndefinedOrNull(eventParameters)){
					evt.setParams(eventParameters);
				}
				evt.fire();
				result = true;
			}
		}
		return result;
	}
	
	function validate(value, validationType){	
		debugger;
		var regExMap=generateRegEx();
		var regularExpression;
		if (validationType != null && !$A.util.isUndefinedOrNull(validationType) && !$A.util.isEmpty(validationType)) {
			regularExpression = regExMap[validationType];
			if (!$A.util.isUndefined(regularExpression)) {
				return regExMatcher(regularExpression, value, [validationType]);
			}
		}
	}
	
	function generateRegEx(){
		var regExMap={};
		regExMap["StrictlyText"]=/^[a-zA-Z ]*$/;
		regExMap["Email"]=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		regExMap["MobileNo"]=/^[789]\d{9}$/;
		regExMap["PinCode"]=/^[1-9][0-9]{6}$/;
		regExMap["PANNo"]=/^([a-zA-Z]){5}([0-9]){4}([a-zA-Z]){1}?$/;
		regExMap["AadharNo"]=/^([0-9]){12}?$/;
		regExMap["PassportNo"]=/^([a-zA-Z]){1}([0-9]){7}?$/;
		regExMap["MICR"]=/^([0-9]){9}?$/;
		regExMap["IFSC"]=/^([a-zA-Z]){4}([0-9]){7}?$/;
		regExMap["TANNo"]=/^([a-zA-Z]){4}([0-9]){5}([a-zA-Z]){1}?$/;
		regExMap["CINNo"]=/^([ulUL]){1}([0-9]){5}([a-zA-Z]){2}([0-9]){4}([a-zA-Z]){3}([0-9]){6}?$/;
		regExMap["DrivingLisenceNo"]=/^([a-zA-Z]){2}([0-9]){13}?$/;
		return regExMap;

	}
	
	function validateV1(value, validationType){	
		var validationTypes=[validationType];
		if (validationTypes != null && !$A.util.isUndefinedOrNull(validationTypes) && !$A.util.isEmpty(validationTypes)) {
			var regularExpression;
			var errorMessage;
			//For strictlyText
			if (validationTypes.includes('StrictlyText')) {
				regularExpression = new RegExp('^[a-zA-Z ]*$');
				//errorMessage = "Name can only contain letters of the alphabet";
			}

			//For Email
			if (validationTypes.includes('Email')) {
				regularExpression = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
				//errorMessage = "Invalid email format entered(Hint:abc@example.com)";
			}

			//For Mobile
			if (validationTypes.includes('MobileNo')) {
				regularExpression = /^[789]\d{9}$/;
				//errorMessage = "Please Enter Valid Mobile Number!!!";
			}
			//For Pin Code
			if (validationTypes.includes('PinCode')) {
				regularExpression = /^[1-9][0-9]{6}$/;
				//errorMessage = "Please Enter Valid Pin Code!!!";
			}

			//For PAN Card Validation
			if (validationTypes.includes('PANNo')) {
				regularExpression = /^([a-zA-Z]){5}([0-9]){4}([a-zA-Z]){1}?$/;
				//errorMessage = "Invalid PAN No(Hint:XXXXX1234X)";
			}

			//For AadharNo Validation
			if (validationTypes.includes('AadharNo')) {
				regularExpression = /^([0-9]){12}?$/;
				//errorMessage = "Invalid Aadhar No (Hint:Enter 12 Digit Aadhar No)";
			}

			//For Passport No Validation
			if (validationTypes.includes('PassportNo')) {
				regularExpression = /^([a-zA-Z]){1}([0-9]){7}?$/;
				//errorMessage = "Invalid Passport Number(Hint:Enter X1234567)";
			}

			//For MICR
			if (validationTypes.includes('MICR')) {
				regularExpression = /^([0-9]){9}?$/;
				//errorMessage = "Invalid MICR (Hint:Enter 123456789)";
			}

			//For IFSC
			if (validationTypes.includes('IFSC')) {
				regularExpression = /^([a-zA-Z]){4}([0-9]){7}?$/;
				//errorMessage = "Invalid IFSC (Hint:Enter XXXX1234567)";
			}

			//For TANNo
			if (validationTypes.includes('TAN_No')) {
				regularExpression = /^([a-zA-Z]){4}([0-9]){5}([a-zA-Z]){1}?$/;
				//errorMessage = "Invalid TAN (Hint:Enter XXXX12345X)";
			}
			
			//For CINNo
			if (validationTypes.includes('CINNo')) {
				regularExpression = /^([ulUL]){1}([0-9]){5}([a-zA-Z]){2}([0-9]){4}([a-zA-Z]){3}([0-9]){6}?$/;
				//errorMessage = "Invalid CIN (Hint:Starts with L/U12345XX1234XXX123456)";
			}
			
			//For DrivingLisenceNo
			if (validationTypes.includes('DrivingLisenceNo')) {
				regularExpression = /^([a-zA-Z]){2}([0-9]){13}?$/;
				//errorMessage = "Invalid License(Hint:Enter XX1234567890123)";
			}
			
			if (!$A.util.isUndefined(regularExpression)) {
				return regExMatcher(regularExpression, value, validationTypes);
			}
		}
	}
	
	function regExMatcher(regularExpression, value, validationTypes) {
		if (!regularExpression.test(value)) {
			/*if (validationTypes.includes("Required")) {
				if (!$A.util.isUndefined(value) && !$A.util.isEmpty(value)) {
					return false;
				}
			} else if (!$A.util.isUndefined(value) && !$A.util.isEmpty(value)) {
				return false;
			}*/
			return false;
		}
		return true;
	}
	
	
	

    w.util = utilMethods;

})(window);
