@isTest
public class MPLPController_newTest {
    public static Map<String,RecordType>  RTMap = RecordTypeUtility.getOrderRecordTypes();  
    @testSetup static void dataformethods(){
        Test.startTest();
        list<Finance_Account__c> accs = new List<Finance_Account__c>();
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Past_Amount_Due__c=2000;
        finacc.Honda_Brand__c='AFS';
        //finacc.account_type__c='Retail';
        finacc.Fl_Charged_Off__c=true;
        finacc.Region_Code__c='100';
        finacc.account_type__c='Lease';
        finacc.Regular_Monthly_Payment__c = 2000;
        finacc.Fl_OneTime_Payment_Eligible_Web__c = true;
        finacc.Fl_Bankrupt__c = false;
      //  finacc.Remaining_Amount_Due__c =100;
        finacc.Payoff_Amount__c =10000;
        finacc.Maturity_Date__c = Date.valueof('2016-08-27');
        finacc.Paid_to_Date__c = Date.valueof('2015-12-27');
        finacc.Current_Amount_Due__c = 200;
        finacc.Total_Fees_Due__c = 200;
        finacc.Total_Amount_Due__c = 200;
        finacc.Scheduled_EasyPay_Amount__c = 100;
        finacc.Next_Due_Date__c = Date.valueof('2016-01-18');
        finacc.Payment_Due_Date__c = Date.valueof('2016-01-18');
        finacc.Principal_Balance_Amount__c = 150;
        finacc.Fl_Refinanced__c = false;
        finacc.Due_On_Day__c = '12';
        
        accs.add(finacc);
        
        Finance_Account__c finacc1 = new Finance_Account__c();
        finacc1.Finance_Account_Number__c='2222';
        finacc1.Past_Amount_Due__c=2000;
        finacc1.Honda_Brand__c='HFS';
        //finacc.account_type__c='Retail';
        finacc1.Fl_Charged_Off__c=true;
        finacc1.Region_Code__c='NRC';
        finacc1.account_type__c='Lease';
        finacc1.Regular_Monthly_Payment__c = 2000;
        finacc1.Fl_OneTime_Payment_Eligible_Web__c = true;
        finacc1.Fl_Bankrupt__c = false;
      //  finacc.Remaining_Amount_Due__c =100;
        finacc1.Payoff_Amount__c =10000;
        finacc1.Maturity_Date__c = Date.valueof('2016-08-27');
        finacc1.Paid_to_Date__c = Date.valueof('2015-12-27');
        finacc1.Current_Amount_Due__c = 200;
        finacc1.Total_Fees_Due__c = 200;
        finacc1.Total_Amount_Due__c = 200;
        finacc1.Scheduled_EasyPay_Amount__c = 100;
        finacc1.Next_Due_Date__c = Date.valueof('2016-01-18');
        finacc1.Payment_Due_Date__c = Date.valueof('2016-01-18');
        finacc1.Principal_Balance_Amount__c = 150;
        finacc1.Fl_Refinanced__c = false;
        finacc1.Due_On_Day__c = '27';
        accs.add(finacc1);
        insert accs;
        
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe',Personemail='testhnda@testorg.com', Customer_Number__c='1234', RecordTypeId = recordType.id);
        insert newAccount;
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Customer__c= newAccount.Id;
        cfa.Finance_Account__c=finacc.Id;
        insert cfa;
        
        Communication_Preferences__c cPref1 = new Communication_Preferences__c();
        cPref1.Finance_Account_Number__c=finacc.id;
        cPref1.Customer__c=newAccount.Id;
        cPref1.Payment_Confirmations_via_Email__c=true;
        cPref1.Payment_Reminders_via_Text__c=true;
        cPref1.Email_Address__c= 'testhnda@testorg.com';
        cPref1.EasyPay_Communications_via_Email__c= true;
        cPref1.Text_Number__c = '(999) 999-9999' ;
        cpref1.Payment_Reminders_via_Email__c = true;
        cpref1.Days_Prior_Reminder__c = '5';
        cpref1.Paperless_Statements_Letters__c = true;
        cPref1.Payment_Confirmations_via_Text__c = true; 
        cPref1.EasyPay_Communications_via_Text__c = true;
        cPref1.Payment_Profile_Updates_via_Email__c= true;
        cPref1.Statements_Letters__c = 'eDelivery';
        insert cPref1;
        
        Payment_Source__c psor1 = new Payment_Source__c();
        psor1.Finance_Account_Number__c = finacc.id; 
        psor1.Bank_Name__c = 'CITIBank';
        psor1.Payment_Source_Nickname__c ='alpha' ;
        psor1.Bank_Account_Number__c = '1230000004560001';
        psor1.Bank_Account_Type__c = 's';
        psor1.Bank_Routing_Number__c = '021000089';
        psor1.Status__c = 'Active';

        insert psor1;

        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg;

        list<ChargentOrders__ChargentOrder__c> orders = new list<ChargentOrders__ChargentOrder__c>();
        
        ChargentOrders__ChargentOrder__c recurringpay = new ChargentOrders__ChargentOrder__c();
        recurringpay.Finance_Account_Number__c = finacc.id;
        recurringpay.Payment_Source_Nickname__c = psor1.id;
        recurringpay.Payment_Display_Status__c = 'Pending';
        recurringpay.ChargentOrders__Payment_Start_Date__c = system.today();
        recurringpay.ChargentOrders__Charge_Amount__c = 200.00;
        recurringpay.Payment_Channel__c = 'R';
        recurringpay.ChargentOrders__Payment_Method__c = 'Check';
        recurringpay.ChargentOrders__Payment_Frequency__c = 'Monthly';
        recurringpay.ChargentOrders__Payment_Status__c = 'Recurring';
        recurringpay.ChargentOrders__Payment_End_Date__c = system.today().addDays(20);
        recurringpay.ChargentOrders__Payment_Stop__c = 'Date' ;
        recurringpay.Payment_Type__c = 'H';
        recurringpay.Next_Withdrawal_Date__c = Date.valueof('2016-02-01');
        recurringpay.ChargentOrders__Next_Transaction_Date__c = Date.valueof('2016-02-01');
        recurringpay.recordtypeid =RTMap.get('Recurring_Payment').Id;
    
        orders.add(recurringpay);

        ChargentOrders__ChargentOrder__c otppay = new ChargentOrders__ChargentOrder__c();
        otppay.Finance_Account_Number__c = finacc.id;
        otppay.Payment_Source_Nickname__c = psor1.id;
        otppay.Payment_Display_Status__c = 'Pending';
        otppay.ChargentOrders__Payment_Start_Date__c = system.today();
        otppay.ChargentOrders__Charge_Amount__c = 200.00;
        otppay.Payment_Channel__c = 'A';
        otppay.ChargentOrders__Payment_Method__c = 'Check';
        otppay.ChargentOrders__Payment_Frequency__c = 'Once';
        otppay.ChargentOrders__Payment_Status__c = 'Recurring';
        otppay.ChargentOrders__Payment_End_Date__c = system.today().addDays(2);
        otppay.ChargentOrders__Payment_Stop__c = 'Date' ;
        otppay.Payment_Type__c = 'R';
        otppay.recordtypeid =RTMap.get('One_Time_Payment').Id;
        orders.add(otppay); 
        
        ChargentOrders__ChargentOrder__c principalotppay = new ChargentOrders__ChargentOrder__c();
        principalotppay.Finance_Account_Number__c = finacc.id;
        principalotppay.Payment_Source_Nickname__c = psor1.id;
        principalotppay.Payment_Display_Status__c = 'Pending';
        principalotppay.ChargentOrders__Payment_Start_Date__c = system.today();
        principalotppay.ChargentOrders__Charge_Amount__c = 200.00;
        principalotppay.Payment_Channel__c = 'A';
        principalotppay.ChargentOrders__Payment_Method__c = 'Check';
        principalotppay.ChargentOrders__Payment_Frequency__c = 'Once';
        principalotppay.ChargentOrders__Payment_Status__c = 'Recurring';
        principalotppay.ChargentOrders__Payment_End_Date__c = system.today().addDays(2);
        principalotppay.ChargentOrders__Payment_Stop__c = 'Date' ;
        principalotppay.Payment_Type__c = 'R';
        principalotppay.recordtypeid =RTMap.get('Principal_One_Time_Payment').Id;
    
        orders.add(principalotppay); 
    
        ChargentOrders__ChargentOrder__c payoffpay = new ChargentOrders__ChargentOrder__c();
        payoffpay.Finance_Account_Number__c = finacc.id;
        payoffpay.Payment_Source_Nickname__c = psor1.id;
        payoffpay.Payment_Display_Status__c = 'Pending';
        payoffpay.ChargentOrders__Payment_Start_Date__c = system.today();
        payoffpay.ChargentOrders__Charge_Amount__c = 200.00;
        payoffpay.Payment_Channel__c = 'W';
        payoffpay.ChargentOrders__Payment_Method__c = 'Check';
        payoffpay.ChargentOrders__Payment_Frequency__c = 'Once';
        payoffpay.ChargentOrders__Payment_Status__c = 'Recurring';
        payoffpay.ChargentOrders__Payment_End_Date__c = system.today().addDays(2);
        payoffpay.ChargentOrders__Payment_Stop__c = 'Date' ;
        payoffpay.Payment_Type__c = 'P';
        payoffpay.recordtypeid =RTMap.get('Payoff_Payment').Id;
        payoffpay.Next_Withdrawal_Date__c = system.today();
        payoffpay.ChargentOrders__Next_Transaction_Date__c = system.today();    
        
        orders.add(payoffpay); 
        insert orders;

        Honda_Finance__c hondaCT =new Honda_Finance__c();
        hondaCT.CutOff_Time__c=System.Today();
        insert hondaCT;
        Test.stopTest();
    }
    
    
    
    private static TestMethod void newOTP(){
           Payment_Source__c bank = [select id,Payment_Source_Nickname__c from Payment_Source__c where Payment_Source_Nickname__c = 'alpha'];
           PageReference pageRef = Page.MakeAPaymentLandingPage;
           Test.setCurrentPage(pageRef);
        
           ApexPages.CurrentPage().getparameters().put('finnumber', '1111');
           ApexPages.CurrentPage().getparameters().put('type','3');
           ApexPages.CurrentPage().getparameters().put('isReadOnly', 'false');
           ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
           ApexPages.StandardController sc = new ApexPages.standardController(ch);
           MPLPController mplp=new MPLPController(sc);
           mplp.onLoadMethod();   
            List<SelectOption> ls = mplp.getbankValuesOTP();         
           mplp.StandardAmount = '12';
            mplp.isPrincipalEdited = 'true';
            mplp.principalAmount = '10';
            //mplp.PaymentDate = String.valueof(system.today());
            mplp.checkDatevalueOTP();
            mplp.checkStdAmtOTP();
            mplp.checkPrincipalOTP();
            mplp.BankaccntNameotp = bank.id;
            Pagereference pr = mplp.reviewDetailsOTP();
            Pagereference pr1 = mplp.editOTP();
            pr = mplp.reviewDetailsOTP();
            Pagereference pr2 = mplp.submitOTP();
            

            mplp.StandardAmount = 'dsf';
            mplp.isPrincipalEdited = 'true';
            mplp.principalAmount = 'sdf';
            mplp.checkDatevalueOTP();
            mplp.checkStdAmtOTP();
            mplp.checkPrincipalOTP();
            
            pr = mplp.reviewDetailsOTP();
            mplp.StandardAmount = '';
            mplp.isPrincipalEdited = 'true';
            mplp.principalAmount = '';
            mplp.checkDatevalueOTP();
            mplp.checkStdAmtOTP();
            mplp.checkPrincipalOTP();
            pr = mplp.reviewDetailsOTP();
            mplp.isPrincipalEdited = 'false';
            mplp.StandardAmount = '0.5';
            pr = mplp.reviewDetailsOTP();
            
            mplp.StandardAmount = '0.5';
            mplp.isPrincipalEdited = 'true';
            mplp.principalAmount = '0.5';
            pr = mplp.reviewDetailsOTP();
        
            mplp.BankaccntNameotp = 'Add New';
            pr = mplp.reviewDetailsOTP();
        
            mplp.PaymentDate = '';
            pr = mplp.reviewDetailsOTP();
        
            // calling other vf methods
            Pagereference cdn = mplp.checkDataNew();
            Pagereference closebkpop = mplp.closeBankPopupNew();
            mplp.displaypopupRP();
            mplp.hidepopupRP();
            mplp.popupdeleteRP();
            mplp.hidedeleteRP();
            mplp.displaypopupOverview();
            mplp.hidepopupOverview();
            mplp.displaypopup();
            mplp.hidepopup();
            mplp.popupdeletePF();
            mplp.hidedeletePF();
            mplp.editPayOff();
            mplp.showdrawerPF();
            mplp.hidepopupdrawPF1();
            mplp.hidepopupdrawPF2();
            mplp.cancelReviewPayOff();
            mplp.displaypopupOTP();
            mplp.hidepopupOTP();
            Pagereference prs = mplp.checkPayment();
            Pagereference prs1 = mplp.redirectToHFS();
            ApexPages.currentPage().getHeaders().put('User-Agent','testing');
            mplp.checkDevice();
            ApexPages.currentPage().getHeaders().put('User-Agent','Android');
            mplp.checkDevice();
            ApexPages.currentPage().getHeaders().put('User-Agent','BlackBerry');
            mplp.checkDevice();
            ApexPages.currentPage().getHeaders().put('User-Agent','IEMobile');
            mplp.checkDevice();
            ApexPages.currentPage().getHeaders().put('User-Agent','iPad');
            mplp.checkDevice();
            ApexPages.currentPage().getHeaders().put('User-Agent','iPhone');
            mplp.checkDevice();
            ApexPages.currentPage().getHeaders().put('User-Agent','iPod');
            mplp.checkDevice();
            mplp.doNothingMethod();
        
            /*ChargentOrders__ChargentOrder__c chnrc=new ChargentOrders__ChargentOrder__c ();
           ApexPages.StandardController scnrc = new ApexPages.standardController(chnrc);
           MPLPController mplpnrc=new MPLPController(scnrc);
            ApexPages.CurrentPage().getparameters().put('finnumber', '2222');
           ApexPages.CurrentPage().getparameters().put('type','3');
           ApexPages.CurrentPage().getparameters().put('isReadOnly', 'false');
           mplpnrc.onLoadMethod();   
            mplpnrc.BankaccntNameotp = bank.id;
            List<SelectOption> lsnrc = mplp.getbankValuesOTP();
            mplpnrc.StandardAmount = 'dsf';
            mplpnrc.isPrincipalEdited = 'true';
            mplpnrc.principalAmount = 'sdf';
            mplpnrc.checkDatevalueOTP();
            mplpnrc.checkStdAmtOTP();
            mplp.checkPrincipalOTP();
            Pagereference erpf = mplp.ReviewDetailsOTP();
            mplp.BankaccntNameotp ='Add New';
            erpf = mplp.ReviewDetailsOTP();
            mplp.PaymentDate ='';
            erpf = mplp.ReviewDetailsOTP();
            mplp.BankaccntNameotp ='Select One';
            erpf = mplp.ReviewDetailsOTP();
            mplpnrc.StandardAmount = '';
            mplpnrc.isPrincipalEdited = 'true';
            mplpnrc.principalAmount = '';
            mplpnrc.checkDatevalueOTP();
            mplpnrc.checkStdAmtOTP();
            mplpnrc.checkPrincipalOTP();
            Pagereference prnrc = mplpnrc.reviewDetailsOTP();
           
            mplpnrc.StandardAmount = '12';
            mplpnrc.isPrincipalEdited = 'true';
            mplpnrc.principalAmount = '10';
            mplpnrc.checkDatevalueOTP();
            mplpnrc.checkStdAmtOTP();
            mplpnrc.checkPrincipalOTP();
            
            prnrc = mplpnrc.reviewDetailsOTP();
            Pagereference prnrc1 = mplpnrc.editOTP();
            prnrc = mplpnrc.reviewDetailsOTP();
            Pagereference prnrc2 = mplpnrc.submitOTP();*/
        
            
    }
    
    private static TestMethod void newRP(){
           Payment_Source__c bank = [select id,Payment_Source_Nickname__c from Payment_Source__c where Payment_Source_Nickname__c = 'alpha'];
           PageReference pageRef = Page.MakeAPaymentLandingPage;
           Test.setCurrentPage(pageRef);
        
           ApexPages.CurrentPage().getparameters().put('finnumber', '1111');
           ApexPages.CurrentPage().getparameters().put('type','2');
           ApexPages.CurrentPage().getparameters().put('isReadOnly', 'false');
           ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
           ApexPages.StandardController sc = new ApexPages.standardController(ch);
           MPLPController mplp=new MPLPController(sc);
           mplp.onLoadMethod();   
           mplp.BankaccntName = bank.id;
           List<SelectOption> ls = mplp.getbankValuesRP();
           List<SelectOption> cd = mplp.getChargeDateList();
           mplp.RPAmount = '';
           mplp.chargeDate = 'None';
           mplp.checkDatevalue();
           ApexPages.CurrentPage().getparameters().put('myParam', '7');
           mplp.checkDatevalue();
           ApexPages.CurrentPage().getparameters().put('myParam', '14');
           mplp.checkDatevalue();
           ApexPages.CurrentPage().getparameters().put('myParam', '24');
           mplp.checkDatevalue();
           ApexPages.CurrentPage().getparameters().put('myParam', '30');
           mplp.checkDatevalue();
           mplp.chargeDate = '29';
           mplp.checkDatevalue();
          
           Pagereference chkdata = mplp.checkDataRP();
           ApexPages.CurrentPage().getparameters().put('paymentValue', '');
           mplp.checkPaymentRP();
           ApexPages.CurrentPage().getparameters().put('paymentValue', '12');
           mplp.checkPaymentRP();
           mplp.RPAmount = '12';
           Pagereference pr = mplp.reviewDetailsRP();
           Pagereference pr2 = mplp.submitRP();
        
        
           // For NRC
           
           ApexPages.CurrentPage().getparameters().put('finnumber', '2222');
           ApexPages.CurrentPage().getparameters().put('type','2');
           ApexPages.CurrentPage().getparameters().put('isReadOnly', 'false');
           ChargentOrders__ChargentOrder__c chnrc =new ChargentOrders__ChargentOrder__c ();
           ApexPages.StandardController scnrc = new ApexPages.standardController(chnrc);
           MPLPController mplpnrc=new MPLPController(scnrc);
           mplpnrc.onLoadMethod();   
           mplpnrc.BankaccntName = bank.id;
           List<SelectOption> lsnrc = mplpnrc.getbankValuesRP();
           List<SelectOption> cdnrc = mplpnrc.getChargeDateList();
           mplpnrc.RPAmount = '';
           mplpnrc.chargeDate = 'None';
           mplpnrc.checkDatevalue();
           mplpnrc.chargeDate = '29';
           mplpnrc.checkDatevalue();
          
           Pagereference chkdatanrc = mplpnrc.checkDataRP();
           ApexPages.CurrentPage().getparameters().put('paymentValue', '');
           mplpnrc.checkPaymentRP();
           ApexPages.CurrentPage().getparameters().put('paymentValue', '12');
           mplpnrc.checkPaymentRP();
           mplpnrc.RPAmount = '12';
           Pagereference prnrc = mplpnrc.reviewDetailsRP();
           Pagereference prnrc2 = mplpnrc.submitRP();
    }
    
    private static TestMethod void newPF(){
           Payment_Source__c bank = [select id,Payment_Source_Nickname__c from Payment_Source__c where Payment_Source_Nickname__c = 'alpha'];
           PageReference pageRef = Page.MakeAPaymentLandingPage;
           Test.setCurrentPage(pageRef);
        
           ApexPages.CurrentPage().getparameters().put('finnumber', '1111');
           ApexPages.CurrentPage().getparameters().put('type','1');
           ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
           ApexPages.StandardController sc = new ApexPages.standardController(ch);
           MPLPController mplp=new MPLPController(sc);
           mplp.onLoadMethod();   
           mplp.BankAccntNamePF = bank.id;
           Pagereference pr = mplp.reviewDetails();
           List<SelectOption> ls = mplp.getbankValues();
           mplp.BankAccntNamePF ='None';
           pr = mplp.reviewDetails();
           mplp.BankAccntNamePF = 'Select One';
           pr = mplp.reviewDetails();
           
           Pagereference pr2 = mplp.submitPayOff();
        
           PageReference pageRefnrc = Page.MakeAPaymentLandingPage;
           Test.setCurrentPage(pageRefnrc);
       
    }
    
    private static TestMethod void editstdOTP(){
           ChargentOrders__ChargentOrder__c order = [select id from  ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Finance_Account_Number__c='1111' and recordtypeid = :RTMap.get('One_Time_Payment').Id];
           PageReference pageRef = Page.MakeAPaymentLandingPage;
           Test.setCurrentPage(pageRef);
           Payment_Source__c bank = [select id,Payment_Source_Nickname__c from Payment_Source__c where Payment_Source_Nickname__c = 'alpha'];
          // ApexPages.CurrentPage().getparameters().put('finnumber', '2222');
           ApexPages.CurrentPage().getparameters().put('Id', order.id);
           ApexPages.CurrentPage().getparameters().put('type','3');
           ApexPages.CurrentPage().getparameters().put('isReadOnly', 'false');
           ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
           ApexPages.StandardController sc = new ApexPages.standardController(ch);
           MPLPController mplp=new MPLPController(sc);
           mplp.onLoadMethod();   
            List<SelectOption> ls = mplp.getbankValuesOTP();           
            mplp.StandardAmount = '14';
            mplp.checkDatevalueOTP();
            mplp.checkStdAmtOTP();
            mplp.BankaccntNameotp = bank.id;
            Pagereference pr = mplp.reviewDetailsOTP();
            Pagereference pr1 = mplp.editOTP();
            Pagereference pr2 = mplp.submitOTP();
    }
    
    private static TestMethod void editPrincipalOTP(){
           ChargentOrders__ChargentOrder__c order = [select id from  ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Finance_Account_Number__c='1111' and recordtypeid = :RTMap.get('Principal_One_Time_Payment').Id];
           PageReference pageRef = Page.MakeAPaymentLandingPage;
           Test.setCurrentPage(pageRef);
           Payment_Source__c bank = [select id,Payment_Source_Nickname__c from Payment_Source__c where Payment_Source_Nickname__c = 'alpha'];
          // ApexPages.CurrentPage().getparameters().put('finnumber', '2222');
           ApexPages.CurrentPage().getparameters().put('Id', order.id);
           ApexPages.CurrentPage().getparameters().put('type','3');
           ApexPages.CurrentPage().getparameters().put('isReadOnly', 'false');
           ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
           ApexPages.StandardController sc = new ApexPages.standardController(ch);
           MPLPController mplp=new MPLPController(sc);
           mplp.onLoadMethod();   
           
            List<SelectOption> ls = mplp.getbankValuesOTP();
            mplp.BankaccntNameotp = bank.id;
            mplp.isPrincipalEdited = 'true';
            mplp.principalAmount = '13';
            mplp.checkDatevalueOTP();
            mplp.checkPrincipalOTP();
            
            Pagereference pr = mplp.reviewDetailsOTP();
            Pagereference pr1 = mplp.editOTP();
            Pagereference pr2 = mplp.submitOTP();
    }
    
    private static TestMethod void editcancelRP(){
           ChargentOrders__ChargentOrder__c order = [select id from  ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Finance_Account_Number__c='1111' and recordtypeid = :RTMap.get('Recurring_Payment').Id];
          PageReference pageRef = Page.MakeAPaymentLandingPage;
           Test.setCurrentPage(pageRef);
           ApexPages.CurrentPage().getparameters().put('finnumber', '2222');
           ApexPages.CurrentPage().getparameters().put('Id', order.id);
           ApexPages.CurrentPage().getparameters().put('type','2');
           ApexPages.CurrentPage().getparameters().put('isReadOnly', 'false');
           ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
           ApexPages.StandardController sc = new ApexPages.standardController(ch);
           MPLPController mplp=new MPLPController(sc);
           mplp.onLoadMethod();   
           List<SelectOption> ls = mplp.getbankValuesRP();
           List<SelectOption> cd = mplp.getChargeDateList();
           mplp.RPAmount = '';
           mplp.chargeDate = 'None';
           mplp.checkDatevalue();
           mplp.chargeDate = '30';
           mplp.checkDatevalue();
          
           Pagereference chkdata = mplp.checkDataRP();
           ApexPages.CurrentPage().getparameters().put('paymentValue', '');
           mplp.checkPaymentRP();
           ApexPages.CurrentPage().getparameters().put('paymentValue', '12');
           mplp.checkPaymentRP();
           mplp.RPAmount = '10';
           Pagereference pr = mplp.reviewDetailsRP();
           mplp.editexistRP();
           mplp.editRP();
           Pagereference pr2 = mplp.submitRP();
           mplp.deleteRP();
    }
    
    private static TestMethod void editcancelPF(){
         //  Payment_Source__c bank = [select id,Payment_Source_Nickname__c from Payment_Source__c where Payment_Source_Nickname__c = 'alpha'];
           ChargentOrders__ChargentOrder__c order = [select id from  ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Finance_Account_Number__c='1111' and recordtypeid = :RTMap.get('Payoff_Payment').Id];
           PageReference pageRef = Page.MakeAPaymentLandingPage;
           Test.setCurrentPage(pageRef);
           ApexPages.CurrentPage().getparameters().put('finnumber', '2222');        
           ApexPages.CurrentPage().getparameters().put('Id', order.id);
           ApexPages.CurrentPage().getparameters().put('isReadOnly', 'false');
           ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
           ApexPages.StandardController sc = new ApexPages.standardController(order);
           MPLPController mplp=new MPLPController(sc);
           mplp.onLoadMethod();   
           List<SelectOption> ls = mplp.getbankValues();
           mplp.editexistPF();
           Pagereference pr = mplp.reviewDetails();
           Pagereference pr2 = mplp.submitPayOff();
           Pagereference pr3 = mplp.deletePF();
    }
}