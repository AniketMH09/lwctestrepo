/*
Author     :AMS Team
Description :This class purpose is to support the UserSecurityNotAuthorized.
              It will log an error in Error Log object every time a customer fails to login successfully.    
*/
public class UserSecurityNotAuthorizedController{
    
   public void createErrorLog(){
       ErrorLog__c errorLog = new ErrorLog__c();
       errorLog.ClassName__c = 'UserSecurityNotAuthorizedController';
       errorLog.ExceptionMsg__c = 'User Security Not Authorized';
       try{
             insert errorLog;
       }
       Catch(exception ex){}
    } 
    
}