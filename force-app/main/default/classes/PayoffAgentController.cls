public with sharing class PayoffAgentController{
    public ChargentOrders__ChargentOrder__c c;
    public ChargentOrders__ChargentOrder__c cPrincipal;
    public ChargentOrders__ChargentOrder__c cinsertNew;
    public ChargentOrders__ChargentOrder__c cPayOff;
    public ChargentOrders__ChargentOrder__c cOrderRecord{get;set;}
    public list<ChargentOrders__ChargentOrder__c > cOrderListPF{get;set;}
    public list<ChargentOrders__ChargentOrder__c > cOrderListPFExist{get;set;}
    public ChargentOrders__ChargentOrder__c cOrderRecordID{get;set;}
    public Integer typecheck {get;set;}
    public Integer Initialtypecheck {get;set;}
    public Boolean setPopFlagPF {get;set;}
    public Boolean displaypopupdrawer{get;set;}
    public String finID ; 
    public String finIDVF{get;set;}
    public String chargentID;
    public String OTPid{get;set;}
    public String RPID{get;set;}
    public String RecurringID {get;set;}
    public String PayoffID {get;set;}
    public String PayoffAmount {get;set;}
    public Boolean editMode {get; private set;}
    public Boolean reviewMode {get;private set;}
    public Boolean successMode {get;private set;}
    public Boolean displayModeRP {get;set;}
    public Boolean editModePF {get; private set;}
    public Boolean reviewModePF {get;private set;}
    public Boolean successModePF {get;private set;}
    public Boolean eligibleFlag {get;set;}
    public Boolean eligibleFlagRP {get;set;}
    public Boolean eligibleFlagPF {get;set;}
    public Boolean eligibleFlagPFP {get;set;}
    public Boolean OTPFlag {get;set;}
    public Boolean existingPFFlag {get;set;}
    public Boolean displaypopupotp {get;set;}
    public String fname {get;set;}
    public String StandardAmount {get;set;}
    public String PrincipalAmount {get;set;}
    public String BankaccntNameotp {get;set;}
    public String ReviewBanknameOTP {get;set;}
    public String PaymentDate {get;set;}
    public DateTime today;
    public Integer flag = 0;   
    public String bankAccntName {get;set;}
    public String chargeDate {get;set;}
    public Boolean readOnly {get;set;}
    public Boolean suspendedStatus {get;set;}
    public Boolean PastDueStatus {get;set;}
    public Boolean displaypopupRP {get;set;}
    public Boolean displaypopupDelete{get;set;}
    public String confirmationRP {get;set;}
    public Boolean cancelReview {get;set;}
    //This boolean for rending the popup page in Our VF
    public boolean displaypopup{get;set;}
    public Boolean displaypopupdeletePF {get;set;}
    public Boolean readOnlyPF {get;set;}
    public String BankAccntNamePF {get;set;}
    public String bankAccntToken {get;set;}
    public String reviewBankNamePF {get;set;}
    public String paymentStartDate {get;set;}
    public Finance_Account__c finaccount{get;set;}
    public Map<Id,Payment_Source__c> bankAccountsMap ;
    public Map<String,RecordType>  orderRTMap ; 
    public Map<String,RecordType>  gatewayRTMap ;
    public Map<String,List<ChargentOrders__ChargentOrder__c>> orderMap;
    public String[] myDateOnly;
    public String[] strDate;
    public Integer myIntDate;
    public Integer myIntMonth;
    public Integer myIntYear;
    List<ChargentOrders__ChargentOrder__c> cOrderConcatenated;
    Decimal paymentAmountDueEligibility;
    public ChargentOrders__ChargentOrder__c cOrderRecordPF {get;set;}
    public Boolean recordTypeName {get;set;}
    public string pageDisplay;
    public ChargentOrders__ChargentOrder__c cOrder{get;set;}
    public ChargentOrders__ChargentOrder__c co{get;set;}
    public ChargentOrders__ChargentOrder__c  cOrderQuery; 
    public String RecordSelect{get;set;} 
    public list<Finance_Account__c> financeAccount;
    public List<ChargentOrders__ChargentOrder__c> cOrderIDRedirect{get;set;}    
    
    
    public List<SelectOption> BankAccs {get;set;} 
    public String SelBankAcc {get;set;} 
    Map<String,Payment_Source__c>  BankAccRecords ;
    Public String RecordMode = NULL ;
    Public String IsFromBank = '';   
   
    
    public PayoffAgentController(ApexPages.StandardController controller) {
        
        OTPFlag = false;
        readOnly = false;
        suspendedStatus = false;
        pastDueStatus = false;
        displaypopupRP = false;
        displaypopupDelete = false;
        displaypopup = false;
        displaypopupdeletePF = false;
        editModePF = true;
        reviewModePF = false;
        successModePF = false;
        //eligibleFlagPF = 'None';
        eligibleFlagPF = false;
        eligibleFlagPFP = false;
        readOnlyPF = true;
        BankAccntNamePF = '';
        existingPFFlag = false;
        cancelReview = false;
        pageDisplay='';
        eligibleFlag = false;
        displaypopupotp = false;
        paymentAmountDueEligibility =0;       
        
        
        // displaypopupdrawer = false;
        setPopFlagPF = false;
        cOrder=new ChargentOrders__ChargentOrder__c();
        cOrderIDRedirect = new List<ChargentOrders__ChargentOrder__c>();        
        cOrderRecordID = new ChargentOrders__ChargentOrder__c();
        this.c = (ChargentOrders__ChargentOrder__c)controller.getRecord();
        /*Changes proposed for Security Vulnerabilities against line 152,396,411 -- Gufran Date 4/20/2020*/ 
        finID = ApexPages.CurrentPage().getParameters().get('finnumber');
        system.debug('financeId='+finID);
        finID = ESAPI.encoder().SFDC_HTMLENCODE(finID);
        //finID = ApexPages.CurrentPage().getParameters().get('finnumber').escapeHtml4();
        
        //chargentId = ApexPages.CurrentPage().getParameters().get('Id').escapeHtml4();
        chargentId = ApexPages.CurrentPage().getParameters().get('Id');
        chargentId = ESAPI.encoder().SFDC_HTMLENCODE(chargentId);
        finAccount = new Finance_Account__c();
        cOrderListPF = new list<ChargentOrders__ChargentOrder__c>();
        cOrderListPFExist = new list<ChargentOrders__ChargentOrder__c>();
        c.ChargentOrders__Next_Transaction_Date__c = null;
        fetchDataPF();
        
        
        // ASSIGN BANK ACCOUNTS TO MAP FOR AUTO POPULATION ON CHANGE  
        
        BankAccs = New List<SelectOption> () ;
        
        if ( ApexPages.CurrentPage().getParameters().get('isfromBank') <> NULL  ) {
        
            isfromBank =ApexPages.CurrentPage().getParameters().get('isfromBank') ;
        }
        
        
        if ( ApexPages.CurrentPage().getParameters().get('finnumber') <> NULL ) {
            RecordMode = 'NEW' ;
            // LIST THE RELATED BANK ACCOUNTS IN DROP DOWN 
            BankAccRecords = New Map<String,Payment_Source__c> (PaymentsUtils.fetchBankAccs(finID)) ;
            if ( !BankAccRecords.isEmpty() ) {
                
                for ( String a : BankAccRecords.keySet() ) {
                    SelBankAcc = a ;
                    Break;
                }
                BankAccs  = PaymentsUtils.fetchBankAccSelecOptions(finID,'NEW',NULL); 
                AccountPopulated();
            } 
        } else if ( ApexPages.CurrentPage().getParameters().get('Id') <> NULL ) {
            RecordMode = 'EDIT' ;
            // LIST THE RELATED BANK ACCOUNTS IN DROP DOWN 
            
            ChargentOrders__ChargentOrder__c ChargentOrder = [SELECT Id, ChargentOrders__Charge_Amount__c, Payment_Source_Nickname__c, 
                                                              Finance_Account_Number__r.Finance_Account_Number__c 
                                                              FROM ChargentOrders__ChargentOrder__c 
                                                              WHERE ID  = : chargentID ];    
            
            SelBankAcc =  ChargentOrder.Payment_Source_Nickname__c ; 
            String FinNumber = ChargentOrder.Finance_Account_Number__r.Finance_Account_Number__c ;
            
            BankAccRecords = New Map<String,Payment_Source__c> (PaymentsUtils.fetchBankAccs(FinNumber)) ;
            BankAccs  = PaymentsUtils.fetchBankAccSelecOptions(FinNumber ,'EDIT',SelBankAcc); 
            AccountPopulated();
            
        } else {
            RecordMode = 'NULL' ;
        }
        
        
        
        
        /*       //DROP DOWN : FETCH BANK ACCOUNTS
BankAccs = new List<SelectOption>();
BankAccRecords =  New Map<String,Payment_Source__c> ([ SELECT Id, Name, Bank_Name__c, Last_4__c, ChargentOrders_Tokenization__c, Payment_Source_Nickname__c,
Preferred_Payment_Source__c  
FROM Payment_Source__c
WHERE Finance_Account_Number__r.Finance_Account_Number__c = : finID and Status__c=:'Active']);
// Assign Values to Drop Down
//BankAccs.add(new SelectOption('--None--','--None--'));
for ( Payment_Source__c a : BankAccRecords.Values() ) {
if(a.Payment_Source_Nickname__c!=null)
{
BankAccs.add(new SelectOption(a.Id,a.Payment_Source_Nickname__c));
}
if ( a.Preferred_Payment_Source__c && chargentID == null) {
SelBankAcc = a.Id;
AccountPopulated();
}
else if(chargentID!=null){
SelBankAcc = cOrderRecord.Payment_Source_Nickname__c;
AccountPopulated();
}
}   */
        
    }
    public void fetchDataPF()  {
        orderRTMap = RecordTypeUtility.getOrderRecordTypes();
        gatewayRTMap = RecordTypeUtility.getgatewayRecordTypes();
        typecheck = 1;
        
        
        if(chargentID!=null)
        {
            cOrderRecord= [select Finance_Account_Number__r.Finance_Account_Number__c,ChargentOrders__Charge_Amount__c,Payment_Source_Nickname__c,ChargentOrders__Payment_Start_Date__c,recordtype.developername from ChargentOrders__ChargentOrder__c where id = :chargentID];
            
            finID = cOrderRecord.Finance_Account_Number__r.Finance_Account_Number__c;
        }
        
        finAccount = [select id,Good_Through_Date__c,Finance_Account_Number__c,Due_On_Day__c,Fl_Charged_Off__c,Fl_Payoff_Payment_Eligible_Agent__c,Final_Due_Date__c,Account_Type__c,Regular_Monthly_Payment__c,Ownerid,Payoff_Amount__c,Fl_Refinanced__c,FI_Stop_Reinstate_Recurring_Payment__c,past_amount_due__c,next_due_date__c,name,Payment_Due_Date__c,Paid_to_Date__c from Finance_Account__c where Finance_Account_Number__c = :finID];
        
        orderMap = UtilityClass.getChargentOrders(finAccount.id);
        
        system.debug('##### inside schedule1');
        
        
        // Eligibilty Flag 
        // Defect:114012 : Check Payoff amount is negative ot not
        if(finaccount.Fl_Payoff_Payment_Eligible_Agent__c == true)
        {
            if(finaccount.Payoff_Amount__c > 0)
                eligibleFlagPF = true;
            else
                eligibleFlagPF = false;
         }
        else 
            eligibleFlagPF = false;
            
            
         // Changes added to the defect 114264 by Jayashree
          
          if(orderRTMap.containsKey('Payoff_Payment')){
            cOrderListPFExist = [select id,ChargentOrders__Charge_Amount__c,ChargentOrders__Charge_Date__c,ChargentOrders__Next_Transaction_Date__c,Payment_Source_Nickname__r.Payment_Source_Nickname__c 
            from ChargentOrders__ChargentOrder__c 
            where Finance_Account_Number__r.id = :finAccount.id and recordtypeid =:orderRTMap.get('Payoff_Payment').Id 
            and Payment_Display_Status__c in ('Pending','Processing')];
          }

          if(cOrderListPFExist.size() > 0 && RecordMode == 'NEW')
          {
            existingPFFlag = true;
            flag = 1;
          }   
          
          //End of defect 114264   
           
        // Populate Charge Amount 
        if(finaccount.Payoff_Amount__c!= null && finaccount.Payoff_Amount__c!= 0){
            this.c.ChargentOrders__Charge_Amount__c = finaccount.Payoff_Amount__c;
        }
        //populate Charge Date
        Date myDate1 = Date.today();
        PaymentDate = myDate1.format();
        paymentStartDate = String.valueOf(system.today());
        this.c.ChargentOrders__Payment_Start_Date__c=myDate1 ;
        
        //populate Date and Amount
        
        if(chargentID == null || chargentID == '') {
            if(finaccount.Payoff_Amount__c != NULL)
                
                PayoffAmount = String.valueof(finaccount.Payoff_Amount__c);
            Date myDate = Date.today();
            PaymentDate = myDate.format();
            paymentStartDate = String.valueOf(system.today());
            cOrder.ChargentOrders__Charge_Amount__c=finaccount.Payoff_Amount__c;
            cOrder.ChargentOrders__Payment_Start_Date__c=myDate ;
            //Defect ID:113127 Tiru:11-7-2015
            cOrder.ChargentOrders__Charge_Amount__c=finaccount.Payoff_Amount__c;       
            //System.debug('Record Type Utility Inside Fetch Data'+orderRTMap+gatewayRTMap);
        }else{
            cOrder.ChargentOrders__Payment_Start_Date__c=cOrderRecord.ChargentOrders__Payment_Start_Date__c;
            cOrder.ChargentOrders__Charge_Amount__c=  cOrderRecord.ChargentOrders__Charge_Amount__c;
        }
        
    }   
    public void checkDatevaluePF() {
        
        paymentDate =cOrder.ChargentOrders__Payment_Start_Date__c.format();
        Date paymentDateCheck ;
        if(paymentDate != null && paymentDate != ''){
            
            myDateOnly = PaymentDate.split(' ');
            strDate = myDateOnly[0].split(System.Label.System_CL0002); 
            paymentDateCheck = Date.newInstance(integer.valueOf(strDate[2]),integer.valueOf(strDate[0]),integer.valueOf(strDate[1]));
        }  
        
        Date today = Date.today();
        String dateString = today.format();
        String[] todayDate = dateString.split(System.Label.System_CL0002);
        Date todayPastCheck = Date.newInstance(integer.valueOf(todayDate[2]),integer.valueOf(todayDate[0]),integer.valueOf(todayDate[1]));
        
        // Date can't be a date in past -126
        if(paymentDateCheck < todayPastCheck && paymentDate !=null && paymentDate != '' ) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be a date in the past.'));            
            flag = 1;
            
        } 
        
    }    
    
    
    /* Method : On Selection of Bank Account Populate the Bank details */
    
    Public void AccountPopulated() {
        
        System.debug('*** AccountPopulated ==> ' + SelBankAcc );
        
        if ( SelBankAcc <> NULL ) {
            cOrder.Payment_Source_Nickname__r            = BankAccRecords.get(SelBankAcc);
            cOrder.ChargentOrders__Bank_Name__c          = BankAccRecords.get(SelBankAcc).Bank_Name__c ;
            cOrder.Payment_Source_Nickname__r.Last_4__c  = BankAccRecords.get(SelBankAcc).Last_4__c ;
            bankAccntToken = BankAccRecords.get(SelBankAcc).ChargentOrders_Tokenization__c;
        }
        
    } 
    
    /* Redirecting to detail page */
    public pageReference CancelPayoff(){
        
        
        
        if(chargentId == null || chargentId == '')   {        
            Pagereference p = new Pagereference(System.Label.System_CL0002+finAccount.Id);   
            return p;  
        }   
        else{    
            cOrderIDRedirect = [select Id from ChargentOrders__ChargentOrder__c where id=:chargentId];    
            Pagereference p = new Pagereference(System.Label.System_CL0002+cOrderIDRedirect[0].Id);    
            //Pagereference p = new Pagereference(+sUrlRewrite+'/a1Ug0000002Jfr8');     
            p.setredirect(true);    
            return p;    
        }    
        return null;  
    }
    public void ReviewDetailsOTP(){  
        // Bank Account can't be null
        BankAccntName = cOrder.Payment_Source_Nickname__r.Id; 
        if(BankAccntName == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter Bank Account Nick Name .'));
            flag = 1;   
        }
    }
    
    /* For inserting and Updating Records */ 
    public pageReference savePayOff(){
        //Jayashree added this for defect #92
        BankAccntName = cOrder.Payment_Source_Nickname__r.Id; 
        if(BankAccntName == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter Bank Account Nick Name .'));
            flag = 1;   
        }
        // Added : 114012
        if(finaccount.Payoff_Amount__c != null && finaccount.Payoff_Amount__c <= 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payoff Amount must be greater than $0.00.'));
            flag = 1;  
        }
        try{
          if(flag != 1) {
            editModePF = false;
            reviewModePF = false;
            successModePF = true;
            ReviewDetailsOTP();
            AccountPopulated();
            ChargentOrders__ChargentOrder__c cinsertNewPayOff = new ChargentOrders__ChargentOrder__c();
            if(chargentId == null || chargentId == '') {
                String[] myDateOnly = paymentStartDate.split(' ');
                String[] strDate = myDateOnly[0].split('-');
                Integer myIntDate = integer.valueOf(strDate[2]);
                Integer myIntMonth = integer.valueOf(strDate[1]);
                Integer myIntYear = integer.valueOf(strDate[0]);
                //Defect ID:113127 Tiru:11-7-2015
                cinsertNewPayOff.ChargentOrders__Charge_amount__c = Decimal.valueOf(PayoffAmount);        
                cinsertNewPayOff.ChargentOrders__Payment_Start_Date__c = Date.newInstance(myIntYear, myIntMonth, myIntDate);
                cinsertNewPayOff.Payment_Source_Nickname__c = cOrder.Payment_Source_Nickname__r.Id;
                cinsertNewPayOff.ChargentOrders__Bank_Name__c = cOrder.ChargentOrders__Bank_Name__c;
                cinsertNewPayOff.ChargentOrders__Manual_Charge__c = true;
                cinsertNewPayOff.ChargentOrders__Payment_Method__c = 'check';
                cinsertNewPayOff.ChargentOrders__Payment_Status__c = 'Recurring';
                cinsertNewPayOff.Payment_Display_Status__c = 'Pending';
                cinsertNewPayOff.ChargentOrders__Payment_Frequency__c = 'Once';
                cinsertNewPayOff.Payment_Type__c = 'P';
                cinsertNewPayOff.Payment_Channel__c = 'A';
                cinsertNewPayOff.Finance_Account_Number__c = finaccount.id;
                cinsertNewPayOff.ChargentOrders__Tokenization__c=bankAccntToken;
                if(orderRTMap.containsKey('Payoff_Payment'))
                {
                    cinsertNewPayOff.recordtypeid = orderRTMap.get('Payoff_Payment').Id;
                }
                //Changes added to the defect 114165 by Jayashree 
                cinsertNewPayOff.Duplicate_Key_Tracker__c = finID + 'Payoff_Payment' + 'ACTIVE';
                //End of defect 114165
                try
                {
                    insert cinsertNewPayOff;
                }Catch(DMLException e)
                {
                    return null;
                }
                
                
            }
            else
            {  
               
                cinsertNewPayOff.id = chargentId;
                cinsertNewPayOff.Payment_Source_Nickname__c = cOrder.Payment_Source_Nickname__r.Id;
                cinsertNewPayOff.ChargentOrders__Payment_Start_Date__c = cOrder.ChargentOrders__Payment_Start_Date__c;
                //cinsertNewPayOff.ChargentOrders__Charge_Amount__c =  Decimal.valueOf(PayoffAmount);
                
                cinsertNewPayOff.ChargentOrders__Bank_Name__c = cOrder.ChargentOrders__Bank_Name__c;
                cinsertNewPayOff.ChargentOrders__Tokenization__c=bankAccntToken;
                try
                {
                    update cinsertNewPayOff; 
                }
                Catch(DMLException e)
                {
                    return null;
                }
            }    
           // cOrderRecordID  = [select id, Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id=:cinsertNewPayOff.id];
            // Calling INT 31 web service to post the payment to CASS when created or modified by user
           // PendingPaymentCASSService.pendingPaymentCASSService(cOrderRecordID.Confirmation_Number__c);
            if(IsFromBank == 'true'){
               return new Pagereference(System.Label.System_CL0002+cOrder.Payment_Source_Nickname__r.Id);
            }
            else{
                return new PageReference(System.Label.System_CL0002+finAccount.Id);
            }
           }
           return null;  
        }
        catch(DMLException ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getdmlMessage(0));
            ApexPages.addMessage(myMsg );
            
            return null;
        }
    }      
}