@isTest
public class AHFC_globalAlert_Test {

    @isTest
    static void globalalertTest(){
        
        Global_Alert__c gAlert = new Global_Alert__c();
        gAlert.Alert_Message__c='Test';
        gAlert.Valid_Upto__c= Date.newInstance(2022, 1, 30);
        gAlert.Name='Test Alert';
        gAlert.Is_Active__c=true;
        insert gAlert;
        
        Test.startTest();
        AHFC_globalAlert.globalAlertMessage();        
        Test.stopTest();
        
    }
    
}