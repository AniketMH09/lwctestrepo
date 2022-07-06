/********************************************************
Author      :  Praveen Shukla
Description :  Test class for UpdateMCContactEmail Trigger 
*********************************************************/
    @isTest(seeAllData=false)
    public class UpdateMCContactEmailTriggerHelper_Test {          
    //Positive test scenario
     static testMethod void TestPositiveCase()
        {   
            test.startTest();             
            List<Communication_Preferences__c> CommPrefList = TestDataUtility.createComPref();
            insert CommPrefList; 
            List<Id> finId=new List<Id>();
            finId.add((CommPrefList.get(0)).Finance_Account_Number__c);
            List<Contact> contactList= TestDataUtility.createContactRecs(finId);
            insert ContactList;
            (CommPrefList.get(0)).Email_Address__c='test@test.com';
            update CommPrefList;             
            Contact con=[Select Finance_Account__c,MobilePhone ,Email 
                         from Contact where Finance_Account__c=:(CommPrefList.get(0)).Finance_Account_Number__c];                         
            system.assertEquals(con.Email, CommPrefList.get(0).Email_Address__c);            
            test.stopTest();
        }
        
     //Negative test scenario   
    static testMethod void TestNegativeCase()
        {   
            test.startTest();  
            
            List<Communication_Preferences__c> CommPrefList2 = TestDataUtility.createComPref();
            insert CommPrefList2; 
            List<Id> finId=new List<Id>();
            finId.add((CommPrefList2.get(0)).Finance_Account_Number__c);
            List<Contact> ContactList2 = TestDataUtility.createContactRecs(finId);
            insert ContactList2;
            (ContactList2.get(0)).Email='abc123@test.com';           
            update ContactList2;            
            Communication_Preferences__c CommPrefRec1 = [Select Finance_Account_Number__c,Email_Address__c, 
                                                         Text_Number__c from Communication_Preferences__c
                                                         where Finance_Account_Number__c=:(ContactList2.get(0)).Finance_Account__c ]; 
            system.assertNotEquals(CommPrefRec1.Email_Address__c, ContactList2.get(0).Email);
            test.stopTest();
        }   
        
		static testMethod void TestBulkRecords()
        {   
            test.startTest();             
            List<Communication_Preferences__c> CommPrefList = TestDataUtility.createComPref();
            insert CommPrefList;
            List<Id> finId=new List<Id>();
                for(Communication_Preferences__c compRec:CommPrefList)
                {
                    finId.add(compRec.Finance_Account_Number__c);
                }
            List<Contact> contactList= TestDataUtility.createContactRecs(finId);
            insert ContactList;
            (CommPrefList.get(0)).Email_Address__c='test@test.com';
            (CommPrefList.get(1)).Email_Address__c='test@test.com';
            (CommPrefList.get(2)).Email_Address__c='test@test.com';
            update CommPrefList;             
            List<Contact> conList=[Select Finance_Account__c,MobilePhone ,Email 
                         from Contact where Finance_Account__c=:finId];   
            for(Integer i=0;i<conList.size();i++)
            {
                system.assertEquals((conList.get(i)).Email, (CommPrefList.get(i)).Email_Address__c);            
            }
            test.stopTest();
        }
                
    
    }