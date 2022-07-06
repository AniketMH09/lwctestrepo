@isTest
Public class CASSCallOut_Test{
    Private static TestMethod void Method1(){
        
        // CREATE CUSTOM SETTING RECORD
         CASSCallOut__c cs = new CASSCallOut__c ();
            cs.Name            = 'CassCallOut' ;
            cs.SiteId__c       = 'Salesforce' ;
            cs.BusinessId__c   = 'Salesforce' ;
            cs.TimeOut__c      = 60000 ;
         insert cs;
         
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
        insert newAccount;
        
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1000001';
        finacc.Honda_Brand__c='AFS';
        insert finacc;
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Customer__c= newAccount.Id;
        cfa.Finance_Account__c=finacc.Id;
        insert cfa;
        
        finacc.Customer__c=cfa.Id;
        update finacc;
        
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Payment_Confirmations_via_Text__c=true;
        cPref.EasyPay_Communications_via_Text__c =true;
        cPref.Text_Number__c='(999) 999-9999';
        cPref.Customer__c=newAccount.Id;
        insert cPref;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
        
        
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        paysourcerecord.Bank_Name__c='TestCitiBank';
        paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=true;
        paysourcerecord.Bank_Account_Number__c='Test1234567';
        paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Status__c='Active';
        insert paysourcerecord; 
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        
        ch.ChargentOrders__Charge_Amount__c=5000;
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';  
        ch.ChargentOrders__Payment_Start_Date__c =System.today();
        ch.Next_Withdrawal_Date__c=System.Today()+1;
        ch.ChargentOrders__Payment_End_Date__c=System.Today()+30;
        ch.Payment_Display_Status__c = 'Pending';
        ch.Payment_Type__c = 'P';
        insert ch;
        /*ChargentOrders__ChargentOrder__c chh =[Select Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id =:ch.Id ];
       System.debug('@@@@@@@@@@@ '+ chh.Confirmation_Number__c);*/
        
        Case testCase = new Case();
        testCase.Finance_Account__c=finacc.Id;
        testCase.Type = 'Due Date Change';
        testCase.status='new';
        testCase.Origin='Email';
        testCase.Comm_Pref_Email__c='test@ahfc.com';
        testCase.Service_Request__c='<p><b>Date/Time Received:</b>1/12/2019 7:18 PM</p> \r\n <p><b>Case Origin:</b> Web</p> \r\n <p><b>Finance Account Number:</b> 915158702</p> \r\n <p><b>Current Due Date:</b> 30th of the month</p> \r\n <p><b>Requested Due Date:</b> 7th of the month</p>';

        insert testCase;
        
        Test.setMock(HttpCalloutMock.class, new CASSCallOut_Mock());
        CASSCallOut.MakeHttpCall(ch.Id,'insert');
        CASSCallOut.MakeHttpCallRealTime(ch.Id);   
        CASSCallOut.makeHttpCallforCaseNoteInt(testCase.Id);
        
       /* Case testCase1 = new Case();
        testCase1.Finance_Account__c=finacc.Id;
        testCase1.Type = 'Lease Extension';
        testCase1.status='new';
        testCase1.Origin='Email';
        testCase1.Comm_Pref_Email__c='test@ahfc.com';
        testCase1.Service_Request__c='<p><b>Date/Time Received:</b>1/12/2019 7:18 PM</p> \r\n <p><b>Case Origin:</b> Web</p> \r\n <p><b>Finance Account Number:</b> 915158702</p> \r\n <p><b>Current Due Date:</b> 30th of the month</p> \r\n <p><b>Requested Due Date:</b> 7th of the month</p>';

        insert testCase1;*/
        CASSCallOut.makeHttpCallforCaseNoteInt('');
    }
    
}