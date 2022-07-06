/*
Author     :AMS Team
Description :This class purpose is to test the UserSecurityNotAuthorizedController class.             
*/
@isTest

public class UserSecurityNotAuthorizedController_Test{
  private static testmethod void UserSecurityNotAuthorizedCheck(){
   
     Test.startTest();
    UserSecurityNotAuthorizedController us= new UserSecurityNotAuthorizedController();
    us.createErrorLog();
    Test.stopTest();
    }
  
    
}