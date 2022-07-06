/*=====================================================================
* (c) 2018 Appirio - A Wipro Company, Inc
* Name: AHFC_DatePickerUIController_Test.apex
* Description: Unit Test class for AHFC_Due_Date_Screen component to get data from server
* Created Date: 9th Nov 2018
* Created By: Karunakar Pulkam
*  ===================================================================== */
@isTest
public class AHFC_DatePickerUIController_Test {
    public static List<Finance_Account__c> faList;
    public static Integer daysToadd = Integer.valueOf(LABEL.AHFC_DaysToAdd);
    //test method for DatePickerUIController
    
    public static testmethod void testDatePicker(){
        Test.startTest();
        daysUnderDDC__c days = daysUnderDDC__c.getOrgDefaults();
        days.Days__c = LABEL.AHFC_DaysToAdd;
        AHFC_DatePickerUIController.getDDC();
        Test.stopTest();
    }
    
    public static testmethod void testDatePicker1(){
        daysUnderDDC__c ddc = new daysUnderDDC__c(Days__c=LABEL.AHFC_DaysToAdd);
        insert ddc;
        Test.startTest();
        String days = AHFC_DatePickerUIController.getDDC();
        Test.stopTest(); 
        System.assertEquals(ddc.Days__c, days);
    }
    
    public static testmethod void testDatePicker2(){
        Finance_Account__c fAccount  = new Finance_Account__c(name = '123456',Next_Due_Date__c = Date.today()+5,First_Due_Date__c = Date.today(),Finance_Account_Number__c ='123456');
        insert fAccount;
        List<Finance_Account__c> accList = [SELECT id from Finance_Account__c WHERE Finance_Account_Number__c =:fAccount.Finance_Account_Number__c LIMIT 1];
        System.assert(accList[0].Id != null);
        Test.startTest();
        AHFC_DatePickerUIController.wrapDateClass wrapObj = new AHFC_DatePickerUIController.wrapDateClass();
        wrapObj = AHFC_DatePickerUIController.getNext25Days(fAccount.Finance_Account_Number__c);
        Test.stopTest(); 
        System.assertEquals(fAccount.First_Due_Date__c.addDays(daysToadd+5).day(), wrapObj.eligibleDay);
        
        Finance_Account__c fAccount1  = new Finance_Account__c(name = '12345',Next_Due_Date__c = Date.today()+5,Finance_Account_Number__c ='12345');
        insert fAccount1;
        wrapObj = AHFC_DatePickerUIController.getNext25Days(fAccount1.Finance_Account_Number__c);
        //System.assertEquals(null, wrapObj.eligibleDay);
       
    }
    
}