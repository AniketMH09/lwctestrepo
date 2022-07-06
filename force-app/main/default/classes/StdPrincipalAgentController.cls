public with sharing class StdPrincipalAgentController{
    public ChargentOrders__ChargentOrder__c c;
    public ChargentOrders__ChargentOrder__c cPrincipal;
    public ChargentOrders__ChargentOrder__c cinsertNew;  
    public ChargentOrders__ChargentOrder__c cOrderRecord{get;set;}
    public String finID ;     
    public String chargentID;   
    public Boolean populatePrincipal{get;set;}
    public Boolean populatePrincipalPastDue{get;set;} // added by Supriya
    public Boolean eligibleFlag {get;set;} 
    public String PrincipalAmount {get;set;} 
    
    public List<SelectOption> BankAccs {get;set;} 
    public String SelBankAcc {get;set;} 
    
    public String PaymentDate {get;set;}
    public DateTime today;     
    public String bankAccntName {get;set;} 
    public String bankAccntToken {get;set;} 
    public Boolean readOnlyPF{get;set;} 
    public Boolean PastDueStatus {get;set;} 
    
    public Finance_Account__c finaccountOTP{get;set;}
    public Finance_Account__c finaccount{get;set;}
    public Map<String,RecordType>  orderRTMap ; 
    public Map<String,RecordType>  gatewayRTMap ;
    public Map<String,List<ChargentOrders__ChargentOrder__c>> orderMap;
    
    public String[] myDateOnly;
    public String[] strDate;
    public Integer myIntDate;
    public Integer myIntMonth;
    public Integer myIntYear;
    
    public List<ChargentOrders__ChargentOrder__c> cOrdersOTP;
    List<ChargentOrders__ChargentOrder__c> cOrdersPrincipal;
    List<ChargentOrders__ChargentOrder__c> cOrderConcatenated;
    Decimal paymentAmountDueEligibility;
    public Boolean recordTypeName {get;set;}  
    
    public ChargentOrders__ChargentOrder__c cOrder{get;set;}
    
    Public String RecordMode = NULL ;
    Public String FinSFDCId {get;set;}
    
    Public Map<String,Payment_Source__c> BankAccRecords ; 
    Public String IsFromBank = '';
    Public Boolean isValidRule;

    public StdPrincipalAgentController(ApexPages.StandardController controller) {
        
        populatePrincipalPastDue = true;
        populatePrincipal= true;
        eligibleFlag = false; 
        pastDueStatus = false;  
        
        
        
        paymentAmountDueEligibility =0;
        cOrder=new ChargentOrders__ChargentOrder__c();            
        orderRTMap = RecordTypeUtility.getOrderRecordTypes();
        
        this.c = (ChargentOrders__ChargentOrder__c)controller.getRecord();
        /*Changes propsed for Security Vulnerabilities against line 86 -- Gufran Date 4/20/2020*/
        if(ApexPages.CurrentPage().getParameters().get('finnumber')!=NULL){
            finID = ApexPages.CurrentPage().getParameters().get('finnumber');
            finID = ESAPI.encoder().SFDC_HTMLENCODE(finID);

        }
        chargentID= ApexPages.CurrentPage().getParameters().get('Id');
        fetchDataOTP();
        
        //ASSIGN BANK ACCOUNTS TO MAP FOR AUTO POPULATION ON CHANGE  
       
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
        
        
        
        
         
        
    }
    
    
    Public Boolean FormValidationRules(){
        
        Boolean isValid = True;
        
        //Removed Rule 01 as part of 113816 by Jayashree
                
        //RULE 02: Payment Amount NULL & RULE 01 PAYMENT AMOUNT Cannot be Greater than PRINCIPAL Amount
        if( cOrder.ChargentOrders__Charge_Amount__c == NULL ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter a Payment Amount.'));
            isValid = False;
        } 
        //Defect#114161 - Modified the error message as part of the regression test 
        else if ( cOrder.ChargentOrders__Charge_Amount__c < 1 ) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Amount cannot be less than $1.'));
            isValid = False;
        } else if ( cOrder.ChargentOrders__Charge_Amount__c > finaccountOTP.Principal_Balance_Amount__c ) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Amount cannot be greater than the Principal Balance.'));
            isValid = False;
        } 
        
        //RULE 03: BANK Account NULL
        BankAccntName = cOrder.Payment_Source_Nickname__r.Id;
        if(BankAccntName == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter Bank Account Nick Name'));
            isValid = False;   
        }
        
        return isValid;
    }
    
    // FIND THE DIFFERENCE DAYS BETWEEN TWO DATES 
    public Integer findDaysBetweenDate(Date startDate, Date endDate) {
    
        Integer numberDaysDue = startDate != null && endDate != null ? startDate.daysBetween(endDate) : 0; 
        Decimal numberDaysDuee = numberDaysDue != null ? Decimal.valueof(numberDaysDue).abs() : 0;
        return Integer.valueof(numberDaysDuee);         
    }  

    // QUERY PAYMENT RECORDS 
    public Decimal queryPaymentRecord() {
        
        system.debug ('::finaccountOTP.Id ::' +finaccountOTP.Id );
        Decimal totalAmount = 0;
        
        if (finaccountOTP.Id != NULL) {
            
            //QUERY ALL THE PAYMENTS UNDER FINANCE ACCOUNT 
            for (ChargentOrders__ChargentOrder__c ch : [SELECT ChargentOrders__Charge_Amount__c, Finance_Account_Number__c 
                                                        FROM ChargentOrders__ChargentOrder__c 
                                                        WHERE Finance_Account_Number__c = :finaccountOTP.Id AND RecordType.DeveloperName = 'One_Time_Payment' AND (Payment_Display_Status__c='Pending' OR Payment_Display_Status__c='Processing')
                                                       ]) {
                if (ch.ChargentOrders__Charge_Amount__c == NULL) ch.ChargentOrders__Charge_Amount__c = 0;
                totalAmount += ch.ChargentOrders__Charge_Amount__c; 
            }
            system.debug ('::totalAmount::' +totalAmount );
        }
        return totalAmount;   
    }
    //  113816 end 
    
    Public void PaymentRules(){
        
        isValidRule = True;
        
        if(cOrder.ChargentOrders__Payment_Start_Date__c!=null){
               paymentDate =cOrder.ChargentOrders__Payment_Start_Date__c.format();
            } else
            {
               paymentDate =null;
            }      
            
            Date paymentDateCheck ;
            if(paymentDate != null && paymentDate != ''){
                
                myDateOnly = PaymentDate.split(' ');
                strDate = myDateOnly[0].split(System.Label.System_CL0002); 
                paymentDateCheck = Date.newInstance(integer.valueOf(strDate[2]),integer.valueOf(strDate[0]),integer.valueOf(strDate[1]));
                
              
            myIntDate = integer.valueOf(strDate[1]);
            myIntMonth = integer.valueOf(strDate[0]);
            myIntYear = integer.valueOf(strDate[2]); 
            }
            Date today = Date.today();
            String dateString = today.format();
            String[] todayDate = dateString.split(System.Label.System_CL0002);
            Date todayPastCheck = Date.newInstance(integer.valueOf(todayDate[2]),integer.valueOf(todayDate[0]),integer.valueOf(todayDate[1]));
              
             system.debug(paymentDate);
                   
             
            String profName = [select id, name from profile where Id =:UserInfo.getProfileId()][0].name;       
            system.debug(profName);
             
            SYSTEM.DEBUG ('::PP');
        // TO CALCULATE DAYS BETWEEN DATES 
        Integer noDaysPaidToDate = findDaysBetweenDate(finaccountOTP.Paid_to_Date__c, Date.today());
        SYSTEM.DEBUG ('::noDaysPaidToDate::' +noDaysPaidToDate);
        Integer noDaysMaturiyDate = findDaysBetweenDate(finaccountOTP.Maturity_Date__c, Date.today());
        Decimal paymentAmt =  queryPaymentRecord();
        Boolean pastStatus = false;
        Date PaymentSelectedDate = Date.newInstance(myIntYear, myIntMonth, myIntDate) ;
        
        if(finAccountOTP.Past_Amount_Due__c == null || finAccountOTP.Past_Amount_Due__c == 0 || paymentAmt  >= finAccountOTP.Remaining_Amount_Due__c){
             pastStatus = false;
        }else{
             pastStatus = true;
        }
        
        
        
        system.debug ('::paymentAmt::' +paymentAmt);
        if(cOrder.ChargentOrders__Payment_Start_Date__c == NULL) {
        
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select a Payment Date'));
            isValidRule = False; 
        } else if(cOrder.ChargentOrders__Payment_Start_Date__c < Date.today()) {// Date can't be a date in past -126
        
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment Date cannot be in the past.'));            
            isValidRule = False;           
        }  
        else if (finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Agent__c) { // ALLOW ONLY FUTURE ONE TIME 
             // MESSAGE CODE A23 213 ROW
            if (!finaccountOTP.Fl_Charged_Off__c && finaccountOTP.Region_Code__c != 'NRC' && !pastStatus && PaymentSelectedDate > finaccountOTP.payment_due_date__c.addDays(45) && Date.today() < finaccountOTP.Maturity_Date__c && finaccountOTP.Remaining_Amount_Due__c > paymentAmt) {
            
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond ' +finaccountOTP.payment_due_date__c.addDays(45).format()+'.')); 
                isValidRule = False;           
            }else if (finaccountOTP.Region_Code__c == 'NRC' && !finaccountOTP.Fl_Charged_Off__c && !pastStatus && PaymentSelectedDate > finaccountOTP.payment_due_date__c.addDays(45)) { // MESSAGE CODE A23 223 row 
            
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond ' +finaccountOTP.payment_due_date__c.addDays(45).format()+'.')); 
                isValidRule = False;
            }else if (finaccountOTP.Fl_Charged_Off__c == true && finaccountOTP.Region_Code__c == 'NRC' && paymentSelectedDate > date.today().addDays(45)) { // 228, 229, 230 A24 code 
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond ' +date.today().addDays(45).format()+'.')); 
                isValidRule = False; 
            }else if (finaccountOTP.Region_Code__c != 'NRC' && !finaccountOTP.Fl_Charged_Off__c && !pastStatus && Date.today() < finaccountOTP.Maturity_Date__c && (paymentSelectedDate > System.today().addmonths(6)) && finaccountOTP.Remaining_Amount_Due__c <= paymentAmt ) { // 231 A42 code 
               
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' Payments cannot be scheduled for more than 6 months from today')); 
                isValidRule = False;

            }else if (finaccountOTP.Fl_Charged_Off__c && paymentSelectedDate > Date.today().addDays(45)) { // 234 row 
            
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond ' +date.today().addDays(45).format()+'.')); 
                isValidRule = False; 
            }else if (finaccountOTP.Region_Code__c != 'NRC' && !finaccountOTP.Fl_Charged_Off__c && (Date.today() > finaccountOTP.Maturity_Date__c && noDaysMaturiyDate <= 44) && PaymentSelectedDate > finaccountOTP.Maturity_Date__c.addDays(45)) {
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond 45 days from Maturity Date'));
                isValidRule = False;
            }
        }else {
            
            if(paymentDateCheck > todayPastCheck) {
                
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment date cannot be a future date.'));
                    isValidRule = False; 
            }
            else if (noDaysPaidToDate >44 && noDaysPaidToDate <= 119 && PaymentSelectedDate != Date.today() && PaymentSelectedDate > Date.today()) { // A38 MESSAGE CODE  218, row
        
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment date cannot be a future date.'));
                isValidRule = False;          
            }else if (finaccountOTP.Fl_Bankrupt__c == true && PaymentSelectedDate != Date.today() && PaymentSelectedDate > Date.today()) { // A38 MESSAGE CODE 219, 220, 221 ROW 
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment date cannot be a future date.'));
                isValidRule = False;
            }else if (finaccountOTP.Region_Code__c == 'NRC' && noDaysPaidToDate > 45 && PaymentSelectedDate != Date.today() && PaymentSelectedDate > Date.today()) { // 225 row A38 message code
             
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment date cannot be a future date.'));
                isValidRule = False; 
            }else if (finaccountOTP.Region_Code__c != 'NRC' && noDaysMaturiyDate > 44 && PaymentSelectedDate != Date.today() && PaymentSelectedDate > Date.today()){ // A38 MEESAGE CODE 
                
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment date cannot be a future date.'));
                 isValidRule = False; 
            }
            
            
        }
    }
    
    public pageReference cancelPayment(){
        Pagereference p = new Pagereference(System.Label.System_CL0002+finaccountOTP.Id);
        return p;
    }
      
   public void fetchDataOTP()  {
        
        orderRTMap = RecordTypeUtility.getOrderRecordTypes();
        gatewayRTMap = RecordTypeUtility.getgatewayRecordTypes();
      
        if(chargentID!=null)
        {
        cOrderRecord= [select Finance_Account_Number__r.Finance_Account_Number__c,ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c,recordtype.developername from ChargentOrders__ChargentOrder__c where id = :chargentID];
       
        finID = cOrderRecord.Finance_Account_Number__r.Finance_Account_Number__c;
        }
 
        finaccountOTP = [select id,Fl_OneTime_Payment_Eligible_Agent__c,name,Finance_Account_Number__c,Fl_Charged_Off__c,Fl_Bankrupt__c, Region_Code__c,
                                    Remaining_Amount_Due__c,Payoff_Amount__c,Account_Type__c,ownerid,Maturity_Date__c,Fl_Cancel_One_Time_Payments__c,Current_Amount_Due__c,Past_Amount_Due__c,Total_Fees_Due__c,Total_Amount_Due__c,Scheduled_EasyPay_Amount__c,Next_Due_Date__c,Payment_Due_Date__c,Principal_Balance_Amount__c,Fl_Future_OneTime_Payment_Eligible_Agent__c,Fl_Refinanced__c,Paid_to_Date__c from Finance_Account__c where Finance_Account_Number__c = :finID ];
        
        FinSFDCId =   finaccountOTP.Id;    
        // Eligbility Check Flag 
        if(finaccountOTP.Fl_OneTime_Payment_Eligible_Agent__c == true)        
        {
            eligibleFlag = true;        
        }        
        else
        {
            eligibleFlag = false;
        }
        orderMap = UtilityClass.getChargentOrders(finaccountOTP.id);
        System.debug('Utility Class list of orders'+orderMap);
        
        //Check pending payments
        List<ChargentOrders__ChargentOrder__c> cOrdersOtp = new List<ChargentOrders__ChargentOrder__c>();
        if(orderRTMap.containsKey('Principal_One_Time_Payment')){
        cOrdersOtp = [select id,ChargentOrders__Charge_Amount__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__c = :finaccountOTP.id  and recordtypeid = :orderRTMap.get('Principal_One_Time_Payment').Id and Payment_Display_Status__c='Pending'];    
        }
        if(cOrdersOtp.size()>=6)
        {
            eligibleFlag = false;
        }
        
        if(finaccountOTP.Fl_OneTime_Payment_Eligible_Agent__c == true){
        
            if(finaccountOTP.Fl_Charged_Off__c== true)
            {
                populatePrincipal=false;
            }else if( (finaccountOTP.account_type__c == 'Retail' || (finaccountOTP.account_type__c == 'Balloon' &&  finaccountOTP.Fl_Refinanced__c == true)) && finaccountOTP.Past_Amount_Due__c>0 )
            {
               //populatePrincipal=false;
               populatePrincipalPastDue = false; // Modified by Supriya
            }else if((finaccountOTP.account_type__c == 'Lease'|| (finaccountOTP.account_type__c == 'Balloon' &&  finaccountOTP.Fl_Refinanced__c == false)))
            {
              populatePrincipal=false;
            }
        }
        
       //Principal Payment List for the finance account - principal payment created with same date with another principal payment warning message
        
        cOrdersPrincipal = new List<ChargentOrders__ChargentOrder__c>();
        if(orderMap.containsKey('Principal_One_Time_Payment')){
        cOrdersPrincipal = orderMap.get('Principal_One_Time_Payment');
        System.debug('Principal Order List'+cOrdersPrincipal);
        }   
        
       if(chargentID == null || chargentID == '') {
        if(finaccountOTP.Payoff_Amount__c != NULL)
        PrincipalAmount = String.valueof(finaccountOTP.Payoff_Amount__c);
        Date myDate = Date.today();
        PaymentDate = myDate.format();        
        cOrder.ChargentOrders__Payment_Start_Date__c=myDate ;
        if(populatePrincipal==true)
        {
           // cOrder.ChargentOrders__Charge_Amount__c=finaccountOTP.Payoff_Amount__c;
        }
        System.debug('Record Type Utility Inside Fetch Data'+orderRTMap+gatewayRTMap);
        } 
        else {
         PrincipalAmount = String.valueof(cOrderRecord.ChargentOrders__Charge_Amount__c);
         PaymentDate = cOrderRecord.ChargentOrders__Payment_Start_Date__c.format(); 
         cOrder.ChargentOrders__Charge_Amount__c=  cOrderRecord.ChargentOrders__Charge_Amount__c;
         cOrder.ChargentOrders__Payment_Start_Date__c=cOrderRecord.ChargentOrders__Payment_Start_Date__c;
        }
      
        List<ChargentOrders__ChargentOrder__c> cOrdersOtpList = new List<ChargentOrders__ChargentOrder__c>();
        if(orderRTMap.containsKey('One_Time_Payment')){
        cOrdersOtpList = [select id,ChargentOrders__Charge_Amount__c,recordtype.developername from ChargentOrders__ChargentOrder__c where Finance_Account_Number__c = :finaccountOTP.id  and recordtype.developername='One_Time_Payment' and Payment_Display_Status__c='Pending'];    
        }
      
       for(ChargentOrders__ChargentOrder__c orderIteration : cOrdersOtpList ){
            paymentAmountDueEligibility += orderIteration.ChargentOrders__Charge_Amount__c;
        }        
       
        if(finaccountOTP.Past_Amount_Due__c>0)
        {
           pastDueStatus = true; 
        }  
 
       cOrder.Finance_Account_Number__c = finaccountOTP.id;
    }
 
    
    Public Boolean isSaveandNew = False;
    
    Public pageReference SaveAndNewRecord(){
        
        isSaveandNew = True; 
        
        
        return SaveRecord () ;     
    }
     
    Public Pagereference SaveRecord () {
        
       if (  FormValidationRules() ) {
          
           PaymentRules();
           if(isValidRule)
          {
               
               AccountPopulated();
               
               System.debug(' RecordMode  ==> ' + RecordMode );
               
               if ( RecordMode == 'NEW' ) {
            
                    SaveNew();                   
                    
                    Pagereference p = new Pagereference(System.Label.System_CL0002+finaccountOTP.ID);
                    
                    if(IsFromBank == 'true'){
                        p = new Pagereference(System.Label.System_CL0002+cOrder.Payment_Source_Nickname__r.Id);
                    }
                    if ( isSaveandNew ) {
                        p = new Pagereference('/apex/RecordTypeSelectionPage?finnumber='+finaccountOTP.Finance_Account_Number__c);
                    } 
                    p.setredirect(true);
                    return p;
                
                } else if ( RecordMode == 'EDIT' ) {
                    
                    SaveEdit();                    
                    Pagereference p = null;
                    if ( isSaveandNew ) {
                        p = new Pagereference('/apex/RecordTypeSelectionPage?finnumber='+finaccountOTP.Finance_Account_Number__c);
                    } else {
                        p = new Pagereference(System.Label.System_CL0002+finaccountOTP.ID);
                        if(IsFromBank == 'true'){
                            p = new Pagereference(System.Label.System_CL0002+cOrder.Payment_Source_Nickname__r.Id);
                        }
                    }
                    System.debug(' p ==> ' + p);
                    p.setredirect(true);
                    return p;
                
                }
         }       
          
       } 
        return Null;
    }
    
    
  
    
    Public void SaveNew(){
    
        cPrincipal = new ChargentOrders__ChargentOrder__c();  
        cPrincipal.recordtypeid = orderRTMap.get('Principal_One_Time_Payment').Id;
        cPrincipal.ChargentOrders__Charge_Amount__c = cOrder.ChargentOrders__Charge_Amount__c ;
        cPrincipal.ChargentOrders__Payment_Start_Date__c = cOrder.ChargentOrders__Payment_Start_Date__c ;
        cPrincipal.Payment_Source_Nickname__c = SelBankAcc;
        cPrincipal.ChargentOrders__Bank_Name__c = cOrder.ChargentOrders__Bank_Name__c;
        cPrincipal.ChargentOrders__Manual_Charge__c = true;
        cPrincipal.ChargentOrders__Payment_Method__c = 'check';
        cPrincipal.ChargentOrders__Payment_Status__c = 'Recurring';
        cPrincipal.Payment_Display_Status__c = 'Pending';
        cPrincipal.ChargentOrders__Payment_Frequency__c = 'Once';
        cPrincipal.Payment_Type__c = 'O';
        cPrincipal.Payment_Channel__c = 'A';
        cPrincipal.Finance_Account_Number__c = finaccountOTP.id;
        cPrincipal.ChargentOrders__Tokenization__c=bankAccntToken;
        insert cPrincipal;
        
        // Calling INT 31 web service to post the payment to CASS when created or modified by user
        //ChargentOrders__ChargentOrder__c cOrderRecordID  = [select id, Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id=:cPrincipal.id];
       // PendingPaymentCASSService.pendingPaymentCASSService(cOrderRecordID.Confirmation_Number__c);
        System.debug('------outside SaveNew------');
    }
    
    Public void SaveEdit(){
    System.debug('------inside SaveEdit------');
        ChargentOrders__ChargentOrder__c cOrderUpdate = new ChargentOrders__ChargentOrder__c();
        cOrderUpdate.id = chargentId;
        System.debug('ID======>'+chargentId);
        cOrderUpdate.Finance_Account_Number__c = finaccountOTP.id;
        cOrderUpdate.ChargentOrders__Charge_Amount__c =  cOrder.ChargentOrders__Charge_Amount__c ;
        cOrderUpdate.ChargentOrders__Payment_Start_Date__c = cOrder.ChargentOrders__Payment_Start_Date__c ;
        cOrderUpdate.Payment_Source_Nickname__c = SelBankAcc;
        cOrderUpdate.ChargentOrders__Bank_Name__c = cOrder.ChargentOrders__Bank_Name__c;
        cOrderUpdate.ChargentOrders__Tokenization__c=bankAccntToken;
        system.debug(bankAccntToken);
        update cOrderUpdate;
        
        // Calling INT 31 web service to post the payment to CASS when created or modified by user
       // ChargentOrders__ChargentOrder__c cOrderRecordID  = [select id, Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id=:cOrderUpdate.id];
      //  PendingPaymentCASSService.pendingPaymentCASSService(cOrderRecordID.Confirmation_Number__c);
        System.debug('------outside SaveEdit-----');
    }   
    
  
      
  /* Method : On Selection of Bank Account Populate the Bank details */
        
       Public void AccountPopulated() {
           
            
           
           System.debug('*** AccountPopulated ==> ' + SelBankAcc + BankAccRecords );
            
           if ( SelBankAcc <> NULL ) {
               cOrder.Payment_Source_Nickname__r            = BankAccRecords.get(SelBankAcc);
               cOrder.ChargentOrders__Bank_Name__c          = BankAccRecords.get(SelBankAcc).Bank_Name__c ;
               cOrder.Payment_Source_Nickname__r.Last_4__c  = BankAccRecords.get(SelBankAcc).Last_4__c ;
               bankAccntToken = BankAccRecords.get(SelBankAcc).ChargentOrders_Tokenization__c;
           }
           
        }        
   

 
    
}