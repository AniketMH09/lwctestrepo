@isTest
private class BatchUpdateNWDTest {
    
    static void test() {
               
        final DateTime LastRun = DateTime.Now().AddDays(-1);
        final Date LastExtDate = Date.Today().AddDays(-1);
        final Date LastNWD = Date.Today().AddDays(-1);
        final Date AF_Proc_Date;
        final Date NWDAdjMonday;
        final Date LastExtDateAdjMonday;
        final Integer stmtdays;
        Honda_Finance__c hondaCT = new Honda_Finance__c();
        hondaCT.No_of_Days__c = 21;
        hondaCT.CutOff_Time__c = DateTime.parse('1/18/2016 11:00 AM');
        insert hondaCT;
        BatchUpdateNWDParams__c params = new BatchUpdateNWDParams__c();
        params.LastNWD__c = LastNWD  ;
       // params.LastExtDate__c = LastExtDate;
        params.LastRun__c = LastRun;
        insert params;
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Contact con =new Contact();
        con.LastName='TestName';
        con.AccountId=a.Id;
        con.Email='test@123.com';
        insert con;
        
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Honda_Brand__c='AFS';
        //finacc.Customer__c=cfa.Id;
        finacc.IsUpdated__c=true;
        
        insert finacc;
        
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Payment_Confirmations_via_Text__c=true;
        cPref.EasyPay_Communications_via_Text__c =true;
        cPref.Text_Number__c='9992223334';
        cPref.Email_Address__c='test@123.com';
        cPref.Email_BounceBack_Count__c=5; 
        cPref.EmailBouncedDate__c=null;
        cPref.Customer__c=a.Id;
        insert cPref;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        ch.Payment_Display_Status__c='Pending';
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';  
        ch.ChargentOrders__Payment_Start_Date__c=System.today();
        ch.ChargentOrders__Payment_End_Date__c=System.today()+30;
        ch.ChargentOrders__Charge_Date__c='1';
        insert ch;
        
        
        List<Finance_Account__c> Finaccs = new List<Finance_Account__c>();
        
        for ( Integer i =0 ; i < 2; i++ ) {
            Finance_Account__c f = new Finance_Account__c();
            f.Finance_Account_Number__c= '123123123' + '-'+i;
            f.Honda_Brand__c='AFS';
            f.IsUpdated__c=true;
            f.Fl_Suppress_All_Notifications__c = true;
            f.FI_Stop_Reinstate_Recurring_Payment__c='S';
            
            
            //Test Case 1 EzPay on this account should get extended ext months(2) + 1 = 3
            if ( i == 0 ) {
                f.Account_Type__c = 'Retail' ;
                f.Fl_Defer_Recurring_Payment_Today__c = true;
                f.Payment_Due_Date__c = date.today().AddDays(20);
                f.FA_Next_Withdrawal_Date__c = date.today().AddDays(-1);
                f.Paid_to_Date__c = f.FA_Next_Withdrawal_Date__c.AddDays(22);
                f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
                f.Fl_Extend_Recurring_Payment_Today__c = true ;
                f.CASS_LST_EXT_DATE__c = Date.today().AddDays(-1);
                f.CASS_EXT_MNTHS__c = 2;
                f.Regular_Monthly_Payment__c=200;
                
            }
            //Test Case 2 EzPay on this account should get extended ext months(2)
            if ( i == 1 ) {
                f.Account_Type__c = 'Retail' ;
                f.Fl_Defer_Recurring_Payment_Today__c = true;
                f.Payment_Due_Date__c = date.today().AddDays(20);
                f.FA_Next_Withdrawal_Date__c = date.today().AddDays(2);
                f.Paid_to_Date__c = f.FA_Next_Withdrawal_Date__c.AddDays(22);
                f.CASS_LST_EXT_DATE__c = Date.today().AddDays(-1);
                f.CASS_EXT_MNTHS__c = 2;
                f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
                f.Fl_Extend_Recurring_Payment_Today__c = true ;
                f.Regular_Monthly_Payment__c=200;
                
            }
            
            
            Finaccs.add(f);
            
            
        }
        Insert Finaccs;
        
        List<ChargentOrders__ChargentOrder__c> Payments = new List<ChargentOrders__ChargentOrder__c>();
        
        for ( Integer i =0 ; i < 2; i++ ) {
            ChargentOrders__ChargentOrder__c c =new ChargentOrders__ChargentOrder__c ();
            c.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            c.ChargentOrders__Charge_Amount__c=5000;
            c.Payment_Type__c = 'O';
            c.ChargentOrders__Manual_Charge__c = true;
            c.Payment_Display_Status__c='Pending';
            c.ChargentOrders__Payment_Status__c='Recurring';
            c.ChargentOrders__Payment_Frequency__c='Once';  
            c.ChargentOrders__Payment_Start_Date__c=System.today();
            c.ChargentOrders__Payment_End_Date__c=System.today()+30;
            c.ChargentOrders__Charge_Date__c='1';
            c.Finance_Account_Number__c = Finaccs[i].Id;
            System.Debug(Finaccs);
            
            
            if (i == 0){
                c.Payment_Display_Status__c = 'Pending';
                c.Next_Withdrawal_Date__c = date.today().AddDays(-1);
                c.ChargentOrders__Charge_Date__c = '27';
                c.ChargentOrders__Charge_Amount__c = 200;
                c.ChargentOrders__Payment_Frequency__c='Monthly';  
            }
            if (i == 1){
                c.Payment_Display_Status__c = 'Pending';
                c.Next_Withdrawal_Date__c = date.today().AddDays(2);
                c.ChargentOrders__Charge_Date__c = '29';
                c.ChargentOrders__Charge_Amount__c = 200;
                c.ChargentOrders__Payment_Frequency__c='Monthly';  
            }
            
            
            Payments.add(c);
            
            
        }
        
        insert Payments ;
        System.Debug(Finaccs);
        
        
        
        
        
        
    }
    
    static TestMethod void Method1() { 
        
        
        String uniqueUserName = 'apexbatch@hondaprod.com.prod.pmtextdef';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='iConnect ETL'];
        User u = new User(Alias = 'apexb', Email='apexbatch@test.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName,
         id = System.Label.BatchApexUserId );
        System.runAs(u) {
        BatchUpdateNWDTest.test();
        Test.startTest();
        Database.executeBatch(new BatchUpdateNWD());
        Test.stopTest();
        List<ChargentOrders__ChargentOrder__c> payments 
                            =  [select id, Next_Withdrawal_Date__c, Finance_Account_Number__c
                 ,Finance_Account_Number__r.CASS_LST_EXT_DATE__c
                 ,Finance_Account_Number__r.CASS_EXT_MNTHS__c
                 ,Finance_Account_Number__r.finance_account_number__c               
                 from ChargentOrders__ChargentOrder__c
                 where createddate = today
                 and Payment_Display_Status__c = 'Pending' 
                 and recordtype.developername = 'Recurring_Payment'
                 and createdById = :System.Label.BatchApexUserId 
                 order by Finance_Account_Number__r.finance_account_number__c];
    }
    }
    
}