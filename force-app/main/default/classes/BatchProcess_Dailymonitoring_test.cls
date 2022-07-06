@isTest
public class BatchProcess_Dailymonitoring_test {
  static testMethod void retryCallouttest(){
        list<ErrorLog__c> errorlst = new list<ErrorLog__c>();
      	list<Finance_Account__c> finaccList = new list<Finance_Account__c>();
      	Datetime yesterday = Datetime.now().addDays(-1);
        try{
            
           Batch_Size_Settings__c bs=new Batch_Size_Settings__c();
           bs.Name='BatchProcessDailymonitoring';
           bs.BatchSize__c=1;
           insert bs;

            Test.setCreatedDate(bs.Id, yesterday);
          
             Batch_Size_Settings__c testjoc = [SELECT Id,Name,CreatedDate  FROM Batch_Size_Settings__c WHERE Batch_Size_Settings__c.id = :bs.Id LIMIT 1];
            System.assertEquals(testjoc.CreatedDate, yesterday); 
                        Test.setCreatedDate(testjoc.Id, yesterday);

            update testjoc;
          Account a=new Account();
            a.Name='testaccount';
            insert a;
            
            Contact c=new Contact();
            c.LastName='test';
            c.AccountId=a.Id;
            c.Email='test@mail.com';
            insert c;
            
            Finance_Account__c finacc = new Finance_Account__c();
            finacc.Finance_Account_Number__c='2458';
            finacc.Next_Due_Date__c=System.Today()+2;
            finacc.Payment_Due_Date__c=System.Today()+1;
            finacc.Past_Amount_Due__c=2000;
            finacc.Payoff_Amount__c=1000;
            finacc.Total_Amount_Due__c=5000;
            finacc.Honda_Brand__c='HFS';
            //finacc.Customer__c=cfa.Id;
            finaccList.add(finacc);
            insert finaccList;
            
            Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
            cfa.Customer__c= a.Id;
            cfa.Finance_Account__c=finacc.Id;
            insert cfa;
            
            finacc.Customer__c=cfa.Id;
            update finacc;
            
            ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;   
            insert cbg;
            
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
            ch.Finance_Account_Number__c=finacc.Id;
            ch.Payment_Type__c = 'R';
            ch.Next_Withdrawal_Date__c=System.Today()+10;
            ch.ChargentOrders__Charge_Amount__c=5000;
            //RecordType rt = [select Id from RecordType where Name ='Recurring Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
            //ch.RecordTypeId=rt.Id;
            ch.ChargentOrders__Payment_Start_Date__c=System.Today();
            ch.Payment_Display_Status__c='Processing';
            //ch.Email_Account_Brand__c='HFS';
            //ch.ChargentOrders__Payment_Status__c='Recurring';
            //ch.ChargentOrders__Payment_Frequency__c='Once';
            //ch.Payment_Source_Nickname__c=payNickName;
            insert ch;
            
        	Test.setCreatedDate(ch.Id, yesterday);
            ChargentOrders__ChargentOrder__c testCc = [SELECT Id, Finance_Account_Number__c, CreatedDate FROM ChargentOrders__ChargentOrder__c WHERE Finance_Account_Number__c = :finacc.Id LIMIT 1];
            System.assertEquals(testCc.CreatedDate, yesterday); 
            Communication_Preferences__c cPref=new Communication_Preferences__c();
            cPref.Finance_Account_Number__c=finacc.Id;
            cPref.Payment_Confirmations_via_Email__c=true;
            cPref.Payment_Reminders_via_Text__c=true;
            cPref.Payment_Confirmations_via_Text__c=true;
            cPref.EasyPay_Communications_via_Text__c =true;
            cPref.Payment_Reminders_via_Email__c=true;
            cPref.Text_Number__c='(999) 999-9999' ;
            cPref.Days_Prior_Reminder__c ='1day';
            cPref.Unsubscribe_from_all__c=false;
            cPref.Customer__c=a.Id;
            cpref.Email_Address__c = 'testagent@gmail.com';
            insert cPref;
            String acc = cPref.Finance_Account_Number__c; 
        	List<MC_Notification__c> mnRecList = TestDataUtility.createMCNotification();
      		for(MC_Notification__c mc:mnRecList){
              mc.Email_Processed_Date__c = system.today();
              mc.Email_Processed__c = true;
              //mc.SMS_Processed__c = true;
              mc.Notification_Code__c = 'Remainder';
              }
        	insert mnRecList; 
            /*List<MC_Notification__c> mnRecList1 = TestDataUtility.createMCNotification();
      		for(MC_Notification__c mc:mnRecList1){
              //mc.Email_Processed_Date__c = system.today();
              mc.SMS_Processed_Date__c = system.today();
              mc.Email_Processed__c = true;
              mc.SMS_Processed__c = true;
              mc.Notification_Code__c = 'SMS Journey';
              }
        	insert mnRecList1; */
            
              
          
            
            ErrorLog__c errorLog = new ErrorLog__c();
            errorLog.ClassName__c = 'CASSCallOut';
            errorLog.ExceptionMsg__c = 'Exception';
            errorlst.add(errorLog);
            ErrorLog__c errorLog1 = new ErrorLog__c();
            errorLog1.ClassName__c = 'CASSCallOut';
            errorLog1.ExceptionMsg__c = 'Exception';
           	//errorlst.add(errorLog1);
            insert errorLog1;
            
            Test.setCreatedDate(errorLog1.Id, yesterday);  
            //Test.startTest(); 
            ErrorLog__c testerr = [SELECT Id, ClassName__c, CreatedDate FROM ErrorLog__c WHERE ClassName__c = 'CASSCallOut' LIMIT 1];
            System.assertEquals(testerr.CreatedDate, yesterday);  
            //Test.stopTest();  
        }catch(exception e){}
            Test.startTest();
            BatchProcess_Dailymonitoring batchretry = new BatchProcess_Dailymonitoring(); 
            database.executebatch(batchretry,1);
            batchretry.execute(null, finaccList);
            batchretry.finish(null);
         	Test.stopTest();
    }
}