/*=====================================================================
* (c) 2019 Appirio - A Wipro Company, Inc
* Name: AHFC_FLOW_Controller_Test.apex
* Description: Unit Test class for AHFC_CheckLoginUser_Controller Apex Controller 
* Created Date: 4th Feb 2019
* Created By: Akshat Gupta
*  ===================================================================== */

@isTest
public class AHFC_CheckLoginUser_Controller_Test {
    
    @isTest
    public static void checklogin() {
        test.startTest();
        final string ACURA_DOMAIN =  Label.AHFC_Port +Label.ACURA_DOMAIN;
        AHFC_CheckLoginUser_Controller.checkLoginUser();
        System.assertEquals(ACURA_DOMAIN, AHFC_CheckLoginUser_Controller.checkLoginUser());  
        AHFC_CheckLoginUser_Controller.currentRequestURL  = Label.HONDA_DOMAIN;
        AHFC_CheckLoginUser_Controller.checkLoginUser();
        AHFC_CheckLoginUser_Controller.currentRequestURL  = 'test';
        AHFC_CheckLoginUser_Controller.checkLoginUser();
        test.stopTest();
    } 

}