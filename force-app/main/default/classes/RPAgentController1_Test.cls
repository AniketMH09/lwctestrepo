/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for RPAgentController1
*****************************************************************************/

@isTest
public class RPAgentController1_Test{
    private static TestMethod void rpAgenttest1(){
        Honda_Finance__c hondaCT = new Honda_Finance__c();
        hondaCT.No_of_Days__c = 21;
        hondaCT.CutOff_Time__c = DateTime.parse('1/18/2016 02:00 PM');
        insert hondaCT;
        
      Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2541';
        finacc.Honda_Brand__c='HFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKC';
        finacc.Account_Type__c='Balloon';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        insert finacc;
    
        Account a=new Account();
        a.Name='Test';
        insert a;
    
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Customer__c=a.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Text_Number__c='9992223334';
        insert cPref;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
    
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';  
        ch.ChargentOrders__Payment_Start_Date__c =System.today();
        ch.Payment_Display_Status__c='Pending';
        ch.Deficiency_Account__c = true;
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        insert ch;
   
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        paysourcerecord.Bank_Name__c='TestCitiBank';
        paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=true;
        paysourcerecord.Bank_Account_Number__c='Test1234567';
        paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Status__c='Active';
        insert paysourcerecord; 
       
        PageReference pageRef = Page.Recurring_Payment_Agent;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('id', ch.Id);
        ApexPages.CurrentPage().getparameters().put('isfromBank', 'true');
    
        ApexPages.StandardController sc = new ApexPages.standardController(ch);
        RPAgentController1 rp=new RPAgentController1(sc);
        rp.fetchdataRP();
        //rp.checkDatevalue();
        rp.populateRecords();
        rp.editRP();
        rp.cancelRP();
        rp.validationCheck();
        //pageReference p=rp.saveRP();
        try{
        pageReference p=rp.saveRP();
        }catch(Exception e){}
        rp.checkDatevalue();
        //}
        //catch(Exception e){}
    } 
    private static TestMethod void rpAgenttest2(){
        
        Honda_Finance__c hondaCT = new Honda_Finance__c();
        hondaCT.No_of_Days__c = 21;
        hondaCT.CutOff_Time__c = DateTime.parse('1/18/2016 02:00 PM');
        insert hondaCT;
        
      Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2541';
        finacc.Honda_Brand__c='HFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKC';
        finacc.Due_On_Day__c = '24';
        finacc.Account_Type__c='Balloon';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        insert finacc;
    
        Account a=new Account();
        a.Name='Test';
        insert a;
    
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Customer__c=a.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Text_Number__c='9992223334';
        insert cPref;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
    
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Monthly';  
        ch.ChargentOrders__Charge_Date__c='18';
        ch.ChargentOrders__Payment_Start_Date__c =System.today();
        ch.ChargentOrders__Payment_End_Date__c =System.today()+12;
        ch.Payment_Display_Status__c='Pending';
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        insert ch;
   
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        paysourcerecord.Bank_Name__c='TestCitiBank';
        paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=true;
        paysourcerecord.Bank_Account_Number__c='Test1234567';
        paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Status__c='Active';
        insert paysourcerecord; 
        
        ch.Payment_Source_Nickname__c =paysourcerecord.Id;
        update ch;
       
        PageReference pageRef = Page.Recurring_Payment_Agent;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('finnumber', '1111');
        ApexPages.CurrentPage().getparameters().put('id', ch.Id);
        ApexPages.CurrentPage().getparameters().put('isfromBank', 'true');
    
        ApexPages.StandardController sc = new ApexPages.standardController(ch);
        //try{
        RPAgentController1 rp=new RPAgentController1(sc);
        //}catch(Exception e){}
        rp.fetchdataRP();
        rp.checkDatevalue();
        rp.populateRecords();
        rp.editRP();
        rp.validationCheck();
        //pageReference p=rp.saveRP();
        try{
        pageReference p=rp.saveRP();
            rp.cancelRP();
        }catch(Exception e){}
        
        //}
        //catch(Exception e){}
    } 
        private static TestMethod void rpAgenttest3(){
    
      Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2541';
        finacc.Honda_Brand__c='HFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKC';
        finacc.Account_Type__c='Balloon';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        finacc.Past_Amount_Due__c = 300;
        finacc.Due_On_Day__c = '24';
        finacc.Regular_Monthly_Payment__c = 100;
        finacc.account_type__c = 'Lease';
        insert finacc;
    
        Account a=new Account();
        a.Name='Test';
        insert a;
    
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Customer__c=a.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Text_Number__c='9992223334';
        insert cPref;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
    
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=200;
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';  
        ch.ChargentOrders__Charge_Date__c= '10';
        ch.ChargentOrders__Payment_Start_Date__c =System.today();
        ch.ChargentOrders__Payment_End_Date__c =System.today()+12;
        ch.Payment_Display_Status__c='Pending';
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        insert ch;
        
        ChargentOrders__ChargentOrder__c ch2 =new ChargentOrders__ChargentOrder__c();
        ch2.Finance_Account_Number__c=finacc.Id;
        ch2.Payment_Type__c = 'O';
        ch2.ChargentOrders__Charge_Amount__c=100;
        ch2.ChargentOrders__Payment_Status__c='Recurring';
        ch2.ChargentOrders__Payment_Frequency__c='Once';  
        ch2.ChargentOrders__Payment_Start_Date__c =System.today();
        ch2.ChargentOrders__Charge_Date__c='10';
        ch2.Payment_Display_Status__c='Suspended';
        ch2.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        insert ch2;
        
        
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        paysourcerecord.Bank_Name__c='TestCitiBank';
        paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=true;
        paysourcerecord.Bank_Account_Number__c='Test1234567';
        paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Status__c='Active';
        insert paysourcerecord; 
        
        ch.Payment_Source_Nickname__c =paysourcerecord.Id;
        update ch;
       
        PageReference pageRef = Page.Recurring_Payment_Agent;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('id', null);
        ApexPages.CurrentPage().getparameters().put('isfromBank', 'true');
    
        ApexPages.StandardController sc = new ApexPages.standardController(ch);
        //try{
        RPAgentController1 rp=new RPAgentController1(sc);
        //}catch(Exception e){}
        rp.fetchdataRP();
        //rp.checkDatevalue();
        rp.populateRecords();
        rp.editRP();
        rp.cancelRP();
        rp.validationCheck();
        //pageReference p=rp.saveRP();
        try{
        pageReference p=rp.saveRP();
        }
        catch(Exception e){}
        //rp.checkDatevalue();
        //}
        //catch(Exception e){}
    } 
    
    private static TestMethod void rpAgenttest4(){
    
      Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2541';
        finacc.Honda_Brand__c='HFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKC';
        finacc.Due_On_Day__c = '24';
        finacc.Account_Type__c='Balloon';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        finacc.Regular_Monthly_Payment__c = 5001;
        insert finacc;
    
        Account a=new Account();
        a.Name='Test';
        insert a;
    
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Customer__c=a.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Text_Number__c='9992223334';
        insert cPref;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
    
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';  
        ch.ChargentOrders__Charge_Date__c='5000';
        ch.ChargentOrders__Payment_Start_Date__c =System.today();
        ch.ChargentOrders__Payment_End_Date__c =System.today()+12;
        ch.Payment_Display_Status__c='Pending';
        ch.Skip_First__c=TRUE;
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        insert ch;
   
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        paysourcerecord.Bank_Name__c='TestCitiBank';
        paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=true;
        paysourcerecord.Bank_Account_Number__c='Test1234567';
        paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Status__c='Active';
        insert paysourcerecord; 
        
        ch.Payment_Source_Nickname__c =paysourcerecord.Id;
        update ch;
       
        PageReference pageRef = Page.Recurring_Payment_Agent;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('finnumber', '1111');
        ApexPages.CurrentPage().getparameters().put('id', ch.Id);
        ApexPages.CurrentPage().getparameters().put('isfromBank', 'true');
    
        ApexPages.StandardController sc = new ApexPages.standardController(ch);
        //try{
        RPAgentController1 rp=new RPAgentController1(sc);
        //}catch(Exception e){}
        rp.fetchdataRP();
        //rp.checkDatevalue();
        rp.populateRecords();
        rp.editRP();
        rp.cancelRP();
        rp.validationCheck();
        //pageReference p=rp.saveRP();
        try{
        pageReference p=rp.saveRP();
        }catch(Exception e){}
        //rp.checkDatevalue();
        //}
        //catch(Exception e){}
    } 
    private static TestMethod void rpAgenttest5(){
    
      Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2541';
        finacc.Honda_Brand__c='HFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKC';
        finacc.Due_On_Day__c = '24';
        finacc.Account_Type__c='Retail';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        finacc.Payoff_Amount__c = 100;
        insert finacc;
    
        Account a=new Account();
        a.Name='Test';
        insert a;
    
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Customer__c=a.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Text_Number__c='9992223334';
        insert cPref;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
    
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';  
        ch.ChargentOrders__Charge_Date__c='5000';
        ch.ChargentOrders__Payment_Start_Date__c =System.today();
        ch.ChargentOrders__Payment_End_Date__c =System.today()+12;
        ch.Payment_Display_Status__c='Pending';
        ch.Skip_First__c=TRUE;
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        insert ch;
   
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        paysourcerecord.Bank_Name__c='TestCitiBank';
        paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=true;
        paysourcerecord.Bank_Account_Number__c='Test1234567';
        paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Status__c='Active';
        insert paysourcerecord; 
        
        ch.Payment_Source_Nickname__c =paysourcerecord.Id;
        update ch;
       
        PageReference pageRef = Page.Recurring_Payment_Agent;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('finnumber', '1111');
        ApexPages.CurrentPage().getparameters().put('id', ch.Id);
        ApexPages.CurrentPage().getparameters().put('isfromBank', 'true');
    
        ApexPages.StandardController sc = new ApexPages.standardController(ch);
        //try{
        RPAgentController1 rp=new RPAgentController1(sc);
        //}catch(Exception e){}
        rp.fetchdataRP();
        //rp.checkDatevalue();
        rp.populateRecords();
        rp.editRP();
        rp.cancelRP();
        rp.validationCheck();
        //pageReference p=rp.saveRP();
        try{
        pageReference p=rp.saveRP();
        }catch(Exception e){}
       // rp.checkDatevalue();
        //}
        //catch(Exception e){}
    } 
}