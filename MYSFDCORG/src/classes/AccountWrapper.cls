/*****************************************************
Class Name    : AccountWrapper
Author        : ANkush Dubey
Description   : Wrapper class on Input rquest  
Created Date  : 1 Sept 2018
*********************************************************/


global with sharing class AccountWrapper {

	public List<Accounts> accounts;
    public results results {get;set;} 
	global class Accounts {
    public String Name{get;set;}
	public String Phone{get;set;}
	public String CustomerID{get;set;}
	
	}
    
    global class results {
	public String Status {get; set;}
    public String Message {get;set;}
    public String ErrorCode {get; set;}
    public String CustomerID {get; set;}
	}

	
	public static AccountWrapper parse(String json) {
		return (AccountWrapper) System.JSON.deserialize(json, AccountWrapper.class);
	}
}