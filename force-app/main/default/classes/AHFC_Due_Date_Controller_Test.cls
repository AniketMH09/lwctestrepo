/*=====================================================================
* (c) 2018 Appirio - A Wipro Company, Inc
* Name: AHFC_Due_Date_Controller_Test.apex
* Description: Unit Test class for AHFC_Due_Date_Controller component to get data from server
* Created Date: 12th Nov 2018
* Created By: Karunakar Pulkam
*  ===================================================================== */
@isTest
public class AHFC_Due_Date_Controller_Test {
    public static List<Finance_Account__c> faList;
   
    //test method for DatePickerUIController
    
    public static testmethod void testDueDate(){
        Test.startTest();
        //daysUnderDDC__c days = daysUnderDDC__c.getOrgDefaults();
        daysUnderDDC__c days = new daysUnderDDC__c();
        days.Days__c = '25';
        insert days;
       // System.assertEquals(days.Days__c, '25');
        //Create Finance Account Records
        faList = TestDataUtility.createFinAccount();
        faList[0].Next_Due_Date__c=Date.today()+5;
        falist[0].First_Due_Date__c=Date.today();
        faList[1].Next_Due_Date__c=Date.today()+5;
        falist[1].First_Due_Date__c=Date.today();
        faList[2].Next_Due_Date__c=Date.today()+5;
        falist[2].First_Due_Date__c=Date.today();
        insert faList;
        System.assert(faList.size()>0);
        //Calling Controller method
        AHFC_Due_Date_Controller.wrapDateClass wrapC = new AHFC_Due_Date_Controller.wrapDateClass();
        wrapC = AHFC_Due_Date_Controller.getDDC();
        Test.stopTest();
        System.assertEquals(days.Days__c,wrapC.ddcDays);
        System.assertEquals(faList[0].Next_Due_Date__c,wrapC.nextDueDate);
        System.assertEquals( falist[0].First_Due_Date__c,wrapC.firstDueDate);
        
        
    }
}