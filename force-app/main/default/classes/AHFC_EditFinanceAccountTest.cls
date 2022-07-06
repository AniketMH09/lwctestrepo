/* Apex Class Name   :	AHFC_EditFinanceAccountTest
* Description        :  Test Class for AHFC_EditFinanceAccount
* Created By         :	Kanagaraj
* Created on         :  5/28/2021
* Modification Log 	 :	03-June-2021 by Aakash - Added closeCustomerFinanceAccountTest Method to cover closeCustomerFinanceAccount in AHFC_EditFinanceAccount class
* Modification Log 	 :	01-Sep-2021 by Prabu - Added updateMessageAckDateTest Method to cover updateMessageAckDate in AHFC_EditFinanceAccount class
*********************************************************************************/

@isTest
public class AHFC_EditFinanceAccountTest {    
    //Method to setup test data
    static Id custUserProfileId = [SELECT Id, Name FROM Profile Where Name =: AHFC_GlobalConstans.CUSTOMER_PROFILE].Id;
    static Id sysAdminProfile = [select ID, Name FROM Profile where Name =: AHFC_GlobalConstans.SYSTEM_ADMINISTRATOR].Id;    
     @testSetup
    public static void createTestData(){        
            List<Account> accList = new List<Account>();
            for(Integer i=0; i<2; i++){
                accList.add(AHFC_TestDataFactory.createPersonAccount());
            }
            if(!accList.isEmpty()){
                insert accList;
            }
           // Account personAcc = [Select PersonContactId From Account Where Id = :accList[0].Id];            
            //create common test AHFC_Service_Account__c.
            Finance_Account__c ahfcfinAccount = new Finance_Account__c();
            ahfcfinAccount.Name = 'ahfcService';
            ahfcfinAccount.Fl_OneTime_Payment_Eligible_Web__c = false;
            ahfcfinAccount.Fl_Payoff_Payment_Eligible_Web__c = false;
            ahfcfinAccount.Finance_Account_Number__c = '765677889';
            ahfcfinAccount.AHFC_Fl_Archived__c = 'Y';            
            insert ahfcfinAccount;            
            //Creation of Service account customer
          //  Customer_Finance_Account__c ahfcCustFinAcc = AHFC_TestDataFactory.createFinanceAccountCustomer(ahfcfinAccount.Id, personAcc.id);
            //insert ahfcCustFinAcc;            
            //Create a test Contact
            Contact con = new Contact();
            con.LastName = 'testuser';
            insert con;        
           AHFC_EditFinanceAccount.getFinanceAccountDetails(ahfcfinAccount.id);   
         //create Finance account for stop Managing finance account by Aakash
            Finance_Account__c ahfcfinAccountStop = new Finance_Account__c();
            ahfcfinAccountStop.Name = 'ahfcServiceForStop';
            ahfcfinAccountStop.Fl_OneTime_Payment_Eligible_Web__c = false;
            ahfcfinAccountStop.Fl_Payoff_Payment_Eligible_Web__c = false;
            ahfcfinAccountStop.Finance_Account_Number__c = '709090900';
            insert ahfcfinAccountStop;
        
         //Creation of Service account customer For stop managing finance account by Aakash
            Customer_Finance_Account__c ahfcCustFinAccStop = new Customer_Finance_Account__c();
        	//ahfcCustFinAccStop.Customer__c =personAcc.id;
        	ahfcCustFinAccStop.Finance_Account__c = ahfcfinAccountStop.Id;
        	ahfcCustFinAccStop.Is_Active__c = true;
        	insert ahfcCustFinAccStop;        
    } 
    
    //Method to test get finance Account functionality
    @isTest
    public static void getFinanceAccTest() {  
        String financeAccNumber = '765677889';
        Test.startTest();        
                Test.setMock(HttpCalloutMock.class, new AHFC_GetDemographicsIntegrationMock());
                AHFC_DemographicsIntegrationHandler.DemographicsWrapper demoIntHandler = new AHFC_DemographicsIntegrationHandler.DemographicsWrapper();
                demoIntHandler = AHFC_EditFinanceAccount.getFinannceAccountHandler(financeAccNumber);        
                System.assertNotEquals(financeAccNumber, null, 'Finance account should not be null');        
        Test.stopTest();        
    }
    
    //Method to test update finance Account contact information functionality
    @isTest
    public static void updateFinanceAccTest(){               
        String financeAccNumber = '765677889';
        Test.startTest();        
                Test.setMock(HttpCalloutMock.class, new AHFC_GetDemographicsIntegrationMock());
                String strBody = '{ "lookupID": '+financeAccNumber+','+
                    '"cellPhone": "3108888888",'+
                    '"cellPhone2": "",'+
                    '"homePhone": null,'+
                    '"placeOfEmployment": "THUNDERSTRUCK RESTORATIONS Test",'+
                    '"workPhone": "3104444444"'+
                    '}';
                 AHFC_EditFinanceAccount.updateFinannceAccountContactDetails(financeAccNumber, strBody);               
                System.assertNotEquals(financeAccNumber, null,'Finance account should not be null'); 
    }
    
    /* Method Name      :   updateMessageAckDateTest
* Description       :   This method will cover the updateMessageAckDate Method of the AHFC_EditFinanceAccount Class
* Developer Name	: 	Prabu Mohanasundaram
* Date				:	01-Sep-2021
* @params			:	finAcctId - will take finance account record Id	
*********************************************************************************/    
    @isTest
    public static void updateMessageAckDateTest(){
        Finance_Account__c finaccount = [Select Id from Finance_Account__c where Finance_Account_Number__c = '709090900'];
        AHFC_EditFinanceAccount.updateMessageAckDate(finaccount.Id);
        System.assertNotEquals(finaccount, null,'Finance account should not be null'); 

    }
    
/* Method Name      :   closeCustomerFinanceAccountTest
* Description       :   This method will cover the closeCustomerFinanceAccount Method of the AHFC_EditFinanceAccount Class
* Developer Name	: 	Akash Solanki
* Date				:	03-June-2021
* @params			:	finAcctId - will take finance account record Id	
*********************************************************************************/    
    @isTest
    public static void closeCustomerFinanceAccountTest(){
        Finance_Account__c finaccount = [Select Id from Finance_Account__c where Finance_Account_Number__c = '709090900'];
        AHFC_EditFinanceAccount.closeCustomerFinanceAccount(finaccount.Id);
        System.assertNotEquals(finaccount, null,'Finance account should not be null'); 
    }
}