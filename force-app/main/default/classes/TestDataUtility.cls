/***************************************************************************************************
    Apex Class Name    : TestDataUtility 
    Version            : 1.0 
    Created Date       : 26 APRIL 2018
    Function           : This is a helper class for UpdateMCContactEmail trigger
                              and updates the changed email id and Text number details in MC Contact
                              as per changes done in communication preferences.
    Modification Log   :
    -----------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ----------------------------------------------------------------------------                 
    * Priya Gupta              04/26/2018              Original Version
    ***************************************************************************************************/

//Utility class to create Test Data 

@isTest(seeAllData = false)
    public class TestDataUtility {
    //Method to create Finance Account records        
        public static List<Finance_Account__c> createFinAccount()
        {
            Finance_Account__c finAccRec1 = new Finance_Account__c(name='0123456',Finance_Account_Number__c='0123456');
            Finance_Account__c finAccRec2 = new Finance_Account__c(name='6543210',Finance_Account_Number__c='6543210');
            Finance_Account__c finAccRec3 = new Finance_Account__c(name='9876543',Finance_Account_Number__c='9876543');// finance account for which we wont be creating MC notification object.
            List<Finance_Account__c> finAccList = new List<Finance_Account__c>();
            finAccList.add(finAccRec1);
            finAccList.add(finAccRec2);
            finAccList.add(finAccRec3);
            return finAccList;
        }
    
        //Method to create Communication Preference records        
         public static List<Communication_Preferences__c> createComPref()
        {
            List<Finance_Account__c> finAList2 = createFinAccount();
            List <Communication_Preferences__c> comprf = new List<Communication_Preferences__c>();
            insert(finAList2);
            for(Finance_Account__c finAcc:finAList2)
            {
             Communication_Preferences__c comPRec1 = new Communication_Preferences__c(Finance_Account_Number__c=finAcc.Id); //Com pref for record without staging object.
             comprf.add(comPRec1);
             }
           /* Communication_Preferences__c comPRec2 = new Communication_Preferences__c(Finance_Account_Number__c=(finAList2.get(2)).Id); //Com pref for record without staging object.
            comprf.add(comPRec2);
            Communication_Preferences__c comPRec3 = new Communication_Preferences__c(Finance_Account_Number__c=(finAList2.get(2)).Id); //Com pref for record without staging object.
            comprf.add(comPRec3); */           
            return comprf;
        }
        
        //Method to create MC Notification records        
         public static List<MC_Notification__c> createMCNotification()
        {
            List<Finance_Account__c> finAList = createFinAccount();
            insert(finAList);
            Communication_Preferences__c comPRec1 = new Communication_Preferences__c(Finance_Account_Number__c=(finAList.get(0)).Id);
            insert comPRec1;
            MC_Notification__c mcRec1 = new MC_Notification__c(Finance_Account__c=(finAList.get(0)).Id,Last_Name__c='testMCRec');
            MC_Notification__c mcRec2 = new MC_Notification__c(Finance_Account__c=(finAList.get(0)).Id,Last_Name__c='testMCRec1');
            MC_Notification__c mcRec3 = new MC_Notification__c(Finance_Account__c=(finAList.get(1)).Id);
            List<MC_Notification__c> mcRecList = new List<MC_Notification__c>();
            mcRecList.add(mcRec1);                                               
            mcRecList.add(mcRec2);
            mcRecList.add(mcRec3);
            return(mcRecList);
        }
        
        //Create Contact Records
        public static List<Contact> createContactRecs(List<Id> finAList){
            List<Contact> contRec = new List<Contact>();
            for(Integer i=0;i<finAList.size();i++)
            {
                Contact contactRec1=new Contact(Finance_Account__c = finAList.get(i), LastName='Testing Account'+i,MobilePhone='9632516527',
                Email='abc123@test.com');
                contRec.add(contactRec1);
            }
            return contRec;            
        }
        
    }