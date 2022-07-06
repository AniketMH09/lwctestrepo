/*
Author      :  Naveen Pilla
Description :  Test class for AHFC_CaseTrigger,AHFC_CaseTriggerHelper,AHFC_CaseTriggerHandler
*/

@isTest
public class AHFC_CaseTrigger_Test {
    
    @isTest 
   public static void caseEmailTest() {
        
        System.debug('@@@@@');
       createTestData();
       Test.setMock(HttpCalloutMock.class, new CASSCallOut_Mock());
             
    }
    
    
    // public static Map<Id, Case> testCaseRecMap = new Map<Id, Case>();
     static void createTestData() {
         
         
        Profile pff =[SELECT p.Name,p.Id from Profile p where p.Name='System Administrator' limit 1];
        
    	User u = new User();
    	u.Username='ashok.raparthi@gmail.com';	
    	u.Email='ashok.raparthi@gmail.com';
    	u.LastName='test';
    	u.TimeZoneSidKey='America/New_York';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='ISO-8859-1';
        u.ProfileId=pff.Id;
        u.LanguageLocaleKey='en_US';
        u.Alias='testt1';  
        u.FirstName='Test234';
    	 insert u; 	   
         ID UserId=u.Id;
       
       TriggerRules__c test_TriggerRules = new TriggerRules__c (
          Name='test',
          CaseTrigger__c = True
       );
       insert test_TriggerRules;
        
        // Create common Finance accounts
       
        ID FARecTypeId = Schema.SObjectType.Finance_Account__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        
        List<Finance_Account__c> testFinanceAccts = new List<Finance_Account__c>();
        for(Integer i=0;i<10;i++) {
            if(i<5){
                testFinanceAccts.add(new Finance_Account__c(Name ='100000'+i ,
                                                            Customer_Name__c='TestFA'+i,
                                                     RecordTypeId=FARecTypeId,
                                                     Finance_Account_Number__c='100000'+i,
                                                     Honda_Brand__c= 'HFS',
                                                     AHFC_Last_Active_User__c=UserId
                                                    ));
            }
            else
            {
               testFinanceAccts.add(new Finance_Account__c(Name ='100000'+i ,
                                                            Customer_Name__c='TestFA'+i,
                                                     RecordTypeId=FARecTypeId,
                                                     Finance_Account_Number__c='100000'+i,
                                                     Honda_Brand__c= 'AFS',
                                                     AHFC_Last_Active_User__c=UserId
                                                    )); 
            }
        }
        insert testFinanceAccts; 
        
         // Create Communication Preference
        List<Communication_Preferences__c> testComPrefRec = new List<Communication_Preferences__c>();
        
        for(Integer i=0; i<testFinanceAccts.size(); i++)
        {
        testComPrefRec.add(new Communication_Preferences__c(Finance_Account_Number__c=testFinanceAccts[i].id,
                                 Account_Status_Updates_via_Email__c=true,
                                 Email_Address__c='test@ahfc.com'
                       ));
        }
        insert testComPrefRec;
        System.debug('@@ '+ testComPrefRec);
        
        Id SelfServiceCaseRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Self Service').getRecordTypeId();
        
       List<Case> testCaseRec = new List<Case>();
        
        for(Integer i=0; i<testFinanceAccts.size(); i++)
        {
        Case caseRec= new Case();
            if(i<5){ 
                     caseRec.Finance_Account__c=testFinanceAccts[i].id;
                                caseRec.RecordTypeId=SelfServiceCaseRTId;
                				 caseRec.Type = 'Due Date Change';
                                 caseRec.status='new';
                                 caseRec.Origin='Email';
                					caseRec.Comm_Pref_Email__c='test@ahfc.com';
                      				caseRec.Service_Request__c='<p><b>Date/Time Received:</b>1/12/2019 7:18 PM</p> \r\n <p><b>Case Origin:</b> Web</p> \r\n <p><b>Finance Account Number:</b> 915158702</p> \r\n <p><b>Current Due Date:</b> 30th of the month</p> \r\n <p><b>Requested Due Date:</b> 7th of the month</p>';
                           testCaseRec.add(caseRec);
          
                }
            else
            {
				caseRec.Finance_Account__c=testFinanceAccts[i].id;
                                caseRec.RecordTypeId=SelfServiceCaseRTId;
                				 caseRec.Type = 'Lease Extension';
                                 caseRec.status='new';
                                 caseRec.Origin='Email';
                					caseRec.Service_Request__c='<p><b>Date/Time Received:</b> 1/12/2019 7:18 PM</p> \r\n <p><b>Case Origin:</b> Web</p> \r\n <p><b>Finance Account Number:</b> 915158702</p> \r\n <p><b>Current Due Date:</b> 30th of the month</p> \r\n <p><b>Requested Due Date:</b> 7th of the month</p>';
                					caseRec.Comm_Pref_Email__c='test1@ahfc.com';
                      
                           testCaseRec.add(caseRec);                
            }
        }
        CASSCallOut__c cas = new CASSCallOut__c();
        cas.BusinessId__c = 'Salesforce';
        cas.Name='Demo';
        cas.SiteId__c='xyz';
        cas.TimeOut__c = 25;
        insert cas;
        insert testCaseRec;
        
       
  }
  
   
 
}