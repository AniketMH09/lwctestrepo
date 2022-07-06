/*****************************************************
Author : Sajila Kadayaprath
Description : Test class for batchChargentPaymentUpdate Batch class
*****************************************************/

@isTest
private class batchChargentPaymentUpdate_Test{
     @testsetup static void test() {
       
       /*RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
       Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
       insert newAccount;*/
       Honda_Finance__c hondaCT = new Honda_Finance__c();
       hondaCT.No_of_Days__c = 21;
       hondaCT.CutOff_Time__c = DateTime.parse('1/18/2016 11:00 AM');
       insert hondaCT;
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
       finacc.FI_Stop_Reinstate_Recurring_Payment__c='R';
       finacc.Fl_Cancel_One_Time_Payments__c = true;
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
        //RecordType rt = [select Id from RecordType where Name ='Standard One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        ch.Payment_Display_Status__c='Pending';
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';  
        ch.ChargentOrders__Payment_Start_Date__c=System.today();
        ch.ChargentOrders__Payment_End_Date__c=System.today()+30;
        ch.ChargentOrders__Charge_Date__c='1';
        insert ch;
        
        
        List<Finance_Account__c> Finaccs = new List<Finance_Account__c>();
        
        for ( Integer i =0 ; i < 13; i++ ) {
            Finance_Account__c f = new Finance_Account__c();
             f.Finance_Account_Number__c= '123123123' + '-'+i;
             f.Honda_Brand__c='AFS';
             f.IsUpdated__c=true;
             f.Fl_Suppress_All_Notifications__c = true;
             f.FI_Stop_Reinstate_Recurring_Payment__c='S';
            
            if ( i == 2 ) {
                f.FI_Stop_Reinstate_Recurring_Payment__c='R';
            } 
            if ( i == 3 ) {
                f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
                f.Fl_Extend_Recurring_Payment_Today__c = true ;
                //f.Account_Type__c = 'Lease' ;
                 f.Account_Type__c = 'Balloon' ;
                 f.Regular_Monthly_Payment__c=200;
            } 
            if ( i == 4 ) {
                f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
                f.Fl_Extend_Recurring_Payment_Today__c = false ;
                f.Fl_Defer_Recurring_Payment_Today__c= true ;
                f.Account_Type__c = 'Retail';
                f.Fl_Defer_Recurring_Payment_Today__c =true;
                f.Payment_Due_Date__c= System.Today();
                f.Total_Amount_Due__c= 100;
                f.Payoff_Amount__c = 100; 
            }
            if ( i == 5 ) {
                f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
                f.Fl_Extend_Recurring_Payment_Today__c = false ;
                f.Fl_Defer_Recurring_Payment_Today__c= false ;
                f.Old_Regular_Monthly_Payment__c = 100 ;
                f.Regular_Monthly_Payment__c = 200 ;
                f.Account_Type__c = 'Lease' ;
                f.Region_Code__c = 'LMC';
            }
            if ( i == 6 ) {
                //system.debug('FA #6 starting');
                f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
                f.Fl_Extend_Recurring_Payment_Today__c = false ;
                f.Fl_Defer_Recurring_Payment_Today__c= false ;
                f.Account_Type__c = 'Retail' ;
                f.Total_Amount_Due__c = 100;
                //system.debug('total amount is '+ f.Total_Amount_Due__c);
                f.Payoff_Amount__c = 100;
                f.Payment_Due_Date__c = System.Today();
                //f.Payment_Due_Date__c = Date.Today().addDays(1); 
            }
            if ( i == 7 ) {
                f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
                f.Fl_Extend_Recurring_Payment_Today__c = false ;
                f.Fl_Defer_Recurring_Payment_Today__c= false ;
                f.Account_Type__c = 'Balloon' ;
                f.Total_Amount_Due__c = 100;
                f.Payoff_Amount__c = 100;
                f.Payment_Due_Date__c = System.Today();
                f.Fl_Refinanced__c = true ;
                 
            }
            
            if ( i == 8 ) {
                f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
                f.Fl_Extend_Recurring_Payment_Today__c = false ;
                f.Fl_Defer_Recurring_Payment_Today__c= false ;
                f.Account_Type__c = 'Retail' ;
                f.Total_Amount_Due__c = 100;
                f.Payoff_Amount__c = 100;
                f.Payment_Due_Date__c = System.Today();
                f.Scheduled_EasyPay_Amount__c =  2;
                 
            }
            
            if ( i == 9 ) {
                f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
                f.Fl_Extend_Recurring_Payment_Today__c = false ;
                f.Fl_Defer_Recurring_Payment_Today__c= false ;
                f.Account_Type__c = 'Balloon' ;
                f.Total_Amount_Due__c = 100;
                f.Payoff_Amount__c = 100;
                f.Payment_Due_Date__c = System.Today();
                f.Scheduled_EasyPay_Amount__c =  2;
                f.Fl_Refinanced__c = true ;
      
            }
            if ( i == 10 ) {
                f.Account_Type__c = 'Retail' ;
                f.Fl_Defer_Recurring_Payment_Today__c = true;
                f.Payment_Due_Date__c = date.valueof('2017-03-15');
                f.FA_Next_Withdrawal_Date__c = date.valueof('2016-11-07');
                
                f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
                f.Fl_Extend_Recurring_Payment_Today__c = true ;
                f.Regular_Monthly_Payment__c=200;
				                 
            }
            if ( i == 11 ) {
                f.Account_Type__c = 'Retail' ;
                f.Fl_Defer_Recurring_Payment_Today__c = true;
                f.Payment_Due_Date__c = date.valueof('2017-04-15');
                f.FA_Next_Withdrawal_Date__c = date.valueof('2016-11-27');
                
                f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
                f.Fl_Extend_Recurring_Payment_Today__c = true ;
                f.Regular_Monthly_Payment__c=200;
				                 
            }
            if ( i == 12 ) {
                f.Account_Type__c = 'Retail' ;
                f.Fl_Defer_Recurring_Payment_Today__c = true;
                f.Payment_Due_Date__c = date.valueof('2017-02-20');
                f.FA_Next_Withdrawal_Date__c = date.valueof('2016-11-29');
                
                f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
                f.Fl_Extend_Recurring_Payment_Today__c = true ;
                f.Regular_Monthly_Payment__c=200;
				                 
            }
            
           
            Finaccs.add(f);
            
            
        }
        Insert Finaccs;
         
        List<ChargentOrders__ChargentOrder__c> Payments = new List<ChargentOrders__ChargentOrder__c>();
        
        for ( Integer i =0 ; i < 13; i++ ) {
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
            
            if ( i == 2 ) {
                c.Payment_Display_Status__c = 'Stopped' ;
            } 
            if ( i == 3 ) {
                c.Payment_Display_Status__c = 'Pending' ;
                 
            }
            
            if( i==4 ){
                c.ChargentOrders__Charge_Amount__c =200;
                c.Payment_Display_Status__c = 'Pending';
                c.Charge_Amount_Date__c=Datetime.now();
                c.Next_Withdrawal_Date__c=System.Today();
            }
            
            if( i==5 ){
                c.ChargentOrders__Charge_Amount__c =200;
                c.Charge_Amount_Date__c=Datetime.now();
            }
            
            if ( i == 6 || i == 7 ) {
                //system.debug('payment #6 starting');
                c.Payment_Display_Status__c = 'Pending' ;
                c.ChargentOrders__Charge_Amount__c = 200 ;
                c.Next_Withdrawal_Date__c = System.Today();
                //system.debug('charge amount is '+ c.ChargentOrders__Charge_Amount__c);
                
            }
            if ( i == 8 || i ==9 ) {
                c.Payment_Display_Status__c = 'Pending' ;
                c.ChargentOrders__Charge_Amount__c = 200 ;
                c.Next_Withdrawal_Date__c = System.Today();
                c.ChargentOrders__Payment_End_Date__c =  System.Today();
            }
            if (i == 10){
                c.Payment_Display_Status__c = 'Pending';
                c.Next_Withdrawal_Date__c = date.valueOf('2016-11-30');
                c.ChargentOrders__Charge_Date__c = '31';
                c.ChargentOrders__Charge_Amount__c = 200;
                c.ChargentOrders__Payment_Frequency__c='Monthly';  
            }
            if (i == 11){
                c.Payment_Display_Status__c = 'Pending';
                c.Next_Withdrawal_Date__c = date.valueOf('2016-11-27');
                c.ChargentOrders__Charge_Date__c = '27';
                c.ChargentOrders__Charge_Amount__c = 200;
                c.ChargentOrders__Payment_Frequency__c='Monthly';  
            }
            if (i == 12){
                c.Payment_Display_Status__c = 'Pending';
                c.Next_Withdrawal_Date__c = date.valueOf('2016-11-29');
                c.ChargentOrders__Charge_Date__c = '29';
                c.ChargentOrders__Charge_Amount__c = 200;
                c.ChargentOrders__Payment_Frequency__c='Monthly';  
            }
            
           
            Payments.add(c);
            
            
        }
        
        insert Payments ;
     
        
        
        
       
       
    }
    
    static TestMethod void Method1() { 
       
         Test.startTest();
            Database.executeBatch(new batchChargentPaymentUpdate() );
        Test.stopTest();
    }
    
}