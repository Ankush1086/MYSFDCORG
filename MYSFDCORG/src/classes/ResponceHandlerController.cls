/*****************************************************
Class Name    : ResponceHandlerController
Author        : ANkush Dubey
Description   : Wrapper class on Output  rquest  
Created Date  : 1 Sept 2018
*********************************************************/

global with sharing class ResponceHandlerController {

	public List<results> results;
 
 	global class results {
	public String Status {get; set;}
    public String Message {get;set;}
    public String ErrorCode {get; set;}
    public String CustomerID {get; set;}
	}

	
	public static ResponceHandlerController parse(String json) {
		return (ResponceHandlerController) System.JSON.deserialize(json, ResponceHandlerController.class);
	}
}