public with sharing class StdOTPController{
    public ChargentOrders__ChargentOrder__c c;
    public ChargentOrders__ChargentOrder__c cStandard;
    public ChargentOrders__ChargentOrder__c cinsertNew;  
    public ChargentOrders__ChargentOrder__c cOrderRecord{get;set;}
    public List<ChargentOrders__ChargentOrder__c> COrderRP{get;set;}
    public List<ChargentOrders__ChargentOrder__c> cOrderIDRedirect{get;set;} 
    public List<ChargentOrders__ChargentOrder__c> ChargeOrderList{get;set;}     //added as part of Rss 44813 November 2018 Release
    
    public String finID ; 
    public String finIDVF{get;set;}
    public String chargentID;
    public String OTPid{get;set;}        
    
    public Boolean editModeOTP {get; private set;}
    public Boolean reviewModeOTP {get;private set;}
    public Boolean successModeOTP {get;private set;}
   
    
    public Boolean editMode {get; private set;} 
    public Boolean eligibleFlag {get;set;} 
    public Boolean RecurringFlag {get;set;}
    public Boolean ExistingOTPFlag {get;set;}      // Added on AUG 2018 as part of RSS 44813 
    
    public Boolean displaypopupotp {get;set;}
    public String fname {get;set;}
    public String StandardAmount {get;set;}
    
    public String BankaccntNameotp {get;set;}
    public String ReviewBanknameOTP {get;set;}
    public String PaymentDate {get;set;}
    public DateTime today;
    public Integer flag = 0;    
    
    public String bankAccntName {get;set;}
    public String reviewBankName  {get;set;}
    public String bankAccntToken {get;set;}
    public String chargeDate {get;set;}
    public String reviewDate {get;set;}
    public Boolean readOnly {get;set;}
    public Date NextTransactionDate {get;set;}
    public Boolean suspendedStatus {get;set;}
    public Boolean PastDueStatus {get;set;}   
    public Boolean displaypopupDelete{get;set;}
    
    //This boolean for rending the popup page in Our VF
    public boolean displaypopup{get;set;}
    
    public String paymentStartDate {get;set;}
    
    public Finance_Account__c finaccountOTP{get;set;}
    public Finance_Account__c finaccount{get;set;}
    public Finance_Account__c finaccountPF{get;set;}
    
    public Map<Id,Payment_Source__c> bankAccountsMap ;
    public Map<String,RecordType>  orderRTMap ; 
    public Map<String,RecordType>  gatewayRTMap ;
    public Map<String,List<ChargentOrders__ChargentOrder__c>> orderMap;
    
    public String[] myDateOnly;
    public String[] strDate;
    public Integer myIntDate;
    public Integer myIntMonth;
    public Integer myIntYear;
    Public String RecordMode = NULL ;
    public List<ChargentOrders__ChargentOrder__c> cOrdersOTP;
    List<ChargentOrders__ChargentOrder__c> cOrdersStandard;
    List<ChargentOrders__ChargentOrder__c> cOrderConcatenated;
    Decimal paymentAmountDueEligibility;
    public Boolean recordTypeName {get;set;}
    public String confirmationStd {get;set;}
    public String confirmationStandard{get;set;}
    public string pageDisplay; 
    public ChargentOrders__ChargentOrder__c cOrder{get;set;}
    public ChargentOrders__ChargentOrder__c co{get;set;}            
    
    public String RecordSelect{get;set;} 
    public list<Finance_Account__c> financeAccount;
    
    public List<SelectOption> BankAccs {get;set;} 
    public String SelBankAcc {get;set;} 
    Map<String,Payment_Source__c>  BankAccRecords ;
    
    //Fix for cancel button
    Public String FinSFDCId {get;set;}
   
    Public String IsFromBank = '';
    
    public StdOTPController(ApexPages.StandardController controller) {
        
        
        editMode = true;   
        readOnly = false;       
        pastDueStatus = false;  
        displaypopupDelete = false;      
        RecurringFlag =false;
        ExistingOTPFlag =false;                //Added on AUG 2018 as part of RSS 44813 
        displaypopup = false;   
        pageDisplay='';
        editModeOTP = true;
        reviewModeOTP = false;
        successModeOTP = false;
        pastDueStatus = false;
       
        eligibleFlag = false;
        displaypopupotp = false;
        paymentAmountDueEligibility =0;
        
        this.c = (ChargentOrders__ChargentOrder__c)controller.getRecord();
        finID = ApexPages.CurrentPage().getParameters().get('finnumber');
       
        chargentID= ApexPages.CurrentPage().getParameters().get('Id');
        finAccount = new Finance_Account__c();
        
        c.ChargentOrders__Next_Transaction_Date__c = null;
        
        

        cOrder=new ChargentOrders__ChargentOrder__c();  
        cOrderIDRedirect = new List<ChargentOrders__ChargentOrder__c>();            
        orderRTMap = RecordTypeUtility.getOrderRecordTypes();
        this.co = (ChargentOrders__ChargentOrder__c)controller.getRecord();  
         fetchDataOTP();
        
       // ASSIGN BANK ACCOUNTS TO MAP FOR AUTO POPULATION ON CHANGE  
       
        BankAccs = New List<SelectOption> () ;
         
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
        
        
        if ( ApexPages.CurrentPage().getParameters().get('isfromBank') <> NULL  ) {
        
            isfromBank =ApexPages.CurrentPage().getParameters().get('isfromBank') ;
        }
        
        System.Debug(' finID ==> ' + finID );
              
    }
    
    Public Decimal PendingDueAmount = 0;
    
    public void fetchDataOTP()  {
        
        orderRTMap = RecordTypeUtility.getOrderRecordTypes();
        gatewayRTMap = RecordTypeUtility.getgatewayRecordTypes();
        
        
        if(chargentID!=null)
        {
            cOrderRecord= [select Finance_Account_Number__r.Finance_Account_Number__c,Payment_Source_Nickname__c,ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c,recordtype.developername from ChargentOrders__ChargentOrder__c where id = :chargentID];
            
            finID = cOrderRecord.Finance_Account_Number__r.Finance_Account_Number__c;
        }
        
        finaccountOTP = [SELECT id,Owner.Name,Fl_OneTime_Payment_Eligible_Agent__c,name,Regular_Monthly_Payment__c ,Good_Through_Date__c ,Finance_Account_Number__c,
                                Fl_Charged_Off__c,Fl_Bankrupt__c,Remaining_Amount_Due__c,Payoff_Amount__c,Account_Type__c,ownerid,Maturity_Date__c,
                                Fl_Cancel_One_Time_Payments__c,Current_Amount_Due__c,Past_Amount_Due__c,Total_Fees_Due__c,Total_Amount_Due__c,
                                Scheduled_EasyPay_Amount__c,Next_Due_Date__c,Payment_Due_Date__c,Principal_Balance_Amount__c,Fl_Future_OneTime_Payment_Eligible_Agent__c,
                                Fl_Refinanced__c,Region_Code__c,Paid_to_Date__c
                            FROM Finance_Account__c 
                            WHERE Finance_Account_Number__c = :finID ];
        
        FinSFDCId = finaccountOTP.Id;
        
                
        // Eligbility Check Flag 
        //Added this query and code for defect 112805
        System.debug(finId);
        ChargeOrderList = new List<ChargentOrders__ChargentOrder__c>();
        ChargeOrderList = [select id, ChargentOrders__Charge_Amount__c, PaymentAuthorizedOn__c, Next_Withdrawal_Date__c from ChargentOrders__ChargentOrder__c where recordtype.developername = 'One_Time_Payment' and Payment_Display_Status__c = 'Pending' and Finance_Account_Number__c =: finaccountOTP.id];
         //  Added as part of RSS 44813, also added one more field in the ChargeOrderList query.
        if (!ChargeOrderList.isEmpty()){
        ExistingOTPFlag =true; 
        }
        // End of code related RSS 44813                                                        
        if(finaccountOTP.Fl_OneTime_Payment_Eligible_Agent__c == true && ChargeOrderList.size() < 6)        
        {
            eligibleFlag = true;        
        }        
        else
        {
            eligibleFlag = false;
        }
        
        orderMap = UtilityClass.getChargentOrders(finaccountOTP.id);
        System.debug('Utility Class list of orders'+orderMap);
        
        //Check Existing RP Record
        COrderRP = new List<ChargentOrders__ChargentOrder__c>();
        if(orderRTMap.containsKey('Recurring_Payment')){
            COrderRP = [select id, ChargentOrders__Charge_Amount__c, ChargentOrders__Charge_Date__c, Next_Withdrawal_Date__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__c = :finaccountOTP.id and recordtypeid =:orderRTMap.get('Recurring_Payment').Id and Payment_Display_Status__c in('Pending')  ];
        }
        
        if(COrderRP.size() > 0)
        {
            RecurringFlag = true;         
        }
        
        
        cOrdersStandard = new List<ChargentOrders__ChargentOrder__c>();
        if(orderMap.containsKey('One_Time_Payment')){
            
            
            cOrdersStandard = orderMap.get('One_Time_Payment');
            System.debug('Standard Order List'+cOrdersStandard);
        }    
        
        if(chargentID == null || chargentID == '') {
            if(finaccountOTP.Remaining_Amount_Due__c != NULL)
                StandardAmount = String.valueof(finaccountOTP.Remaining_Amount_Due__c);
            Date myDate = Date.today();
            PaymentDate = myDate.format();        
            cOrder.ChargentOrders__Payment_Start_Date__c=myDate ;
            //cOrder.ChargentOrders__Charge_Amount__c = UtilityClass.getRemainingAmountDue(finID);
            cOrder.ChargentOrders__Charge_Amount__c=finaccountOTP.Remaining_Amount_Due__c;            
            System.debug('Record Type Utility Inside Fetch Data'+orderRTMap+gatewayRTMap);
        } 
        else {
            StandardAmount = String.valueof(cOrderRecord.ChargentOrders__Charge_Amount__c);
            PaymentDate = cOrderRecord.ChargentOrders__Payment_Start_Date__c.format(); 
            cOrder.ChargentOrders__Charge_Amount__c=  cOrderRecord.ChargentOrders__Charge_Amount__c;
            cOrder.ChargentOrders__Payment_Start_Date__c=cOrderRecord.ChargentOrders__Payment_Start_Date__c;
        }
        
        List<ChargentOrders__ChargentOrder__c> cOrdersOtpList = new List<ChargentOrders__ChargentOrder__c>();
        
        
        
        if(orderRTMap.containsKey('Recurring_Payment')){
            cOrdersOtpList = [ SELECT id,ChargentOrders__Charge_Amount__c, ChargentOrders__Payment_Start_Date__c,Next_Withdrawal_Date__c,recordtype.developername
                                FROM ChargentOrders__ChargentOrder__c 
                                WHERE Finance_Account_Number__r.id = :finaccountOTP.id 
                                    AND recordtypeid != :orderRTMap.get('Recurring_Payment').Id 
                                    AND Payment_Display_Status__c in('Pending')  ];    
            
            for ( ChargentOrders__ChargentOrder__c a : cOrdersOtpList ) { System.Debug(' a ==> ' + a );
                if(a.recordtype.developername == 'Recurring_Payment')
                {
                    if ( a.ChargentOrders__Charge_Amount__c <> null && a.Next_Withdrawal_Date__c <= finaccountOTP.Payment_Due_Date__c ) { 
                        PendingDueAmount += a.ChargentOrders__Charge_Amount__c ;
                    }
                    
                }
                else{
                    if ( a.ChargentOrders__Charge_Amount__c <> null && a.ChargentOrders__Payment_Start_Date__c <= finaccountOTP.Payment_Due_Date__c ) { 
                        PendingDueAmount += a.ChargentOrders__Charge_Amount__c ;
                    }
                }
            }
            
            System.Debug(' PendingDueAmount  ==> ' + PendingDueAmount ); 
        }
        
        for(ChargentOrders__ChargentOrder__c orderIteration : cOrdersOtpList ){
            paymentAmountDueEligibility += orderIteration.ChargentOrders__Charge_Amount__c;
        }
        
        
        //Finance Account past due status
         if(finaccountOTP.past_amount_due__c > 0) {
            List<ChargentOrders__ChargentOrder__c> cOrdersList = new List<ChargentOrders__ChargentOrder__c>();
            if(orderRTMap.containsKey('One_Time_Payment')){
                cOrdersList = [select id,ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.id = :finaccountOTP.id and recordtypeid = :orderRTMap.get('One_Time_Payment').Id and Payment_Display_Status__c in('Pending')];    
            }
            Decimal sumOfPayments = 0.0;
            if(cOrdersList.size() > 0) {
                for(ChargentOrders__ChargentOrder__c c : cOrdersList ) {
                    if(c.ChargentOrders__Charge_Amount__c != null && c.ChargentOrders__Payment_Start_Date__c < finAccount.Payment_Due_Date__c )
                        sumOfPayments += c.ChargentOrders__Charge_Amount__c ;
                    
                }
                if(sumOfPayments < finAccount.Past_Amount_Due__c  ) {
                    pastDueStatus = true; 
                }
                
            }
        } 
        
        //
        
        if(finaccountOTP.Past_Amount_Due__c>0)
        {
           pastDueStatus = true; 
        }
        
        
    }
    
    
    
    // OTP Functionalities 
    
    Public void FromValidationRules() {
    
        // RULE 01 : CHECK NULL
        if( cOrder.ChargentOrders__Payment_Start_Date__c == NULL ) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date should be Entered'));
            flag = 1;   
        } 
        
        
        
        // RULE 02: 
        
         // Payment Date should not be left blank for making a payment 
        
    }
    
    
    public void checkDatevalueOTP() {
                    
            
            Boolean errorFlag=false;
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
            flag = 0;
              
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
            flag = 1; 
        } else if(cOrder.ChargentOrders__Payment_Start_Date__c < Date.today()) {// Date can't be a date in past -126
        
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment Date cannot be in the past.'));            
            flag = 1;            
        }  
        else if (finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Agent__c) { // ALLOW ONLY FUTURE ONE TIME 
             // MESSAGE CODE A23 213 ROW
            if (!finaccountOTP.Fl_Charged_Off__c && finaccountOTP.Region_Code__c != 'NRC' && !pastStatus && PaymentSelectedDate > finaccountOTP.payment_due_date__c.addDays(45) && Date.today() < finaccountOTP.Maturity_Date__c && finaccountOTP.Remaining_Amount_Due__c > paymentAmt) {
            
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment Date cannot be beyond ' +finaccountOTP.payment_due_date__c.addDays(45).format()+'.')); 
                flag = 1;            
            }else  if (!finaccountOTP.Fl_Charged_Off__c && finaccountOTP.Region_Code__c != 'NRC' && pastStatus && (Date.today() < finaccountOTP.Maturity_Date__c) && noDaysPaidToDate <= 10 && PaymentSelectedDate > finaccountOTP.Paid_to_Date__c.addDays(45) && finaccountOTP.Remaining_Amount_Due__c > paymentAmt) { // MESSAGE CODE A39, 214, 215, 216, 217 row  
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment Date cannot be beyond ' +finaccountOTP.Paid_to_Date__c.addDays(45).format()+'.')); 
                flag = 1; 
            }else  if (!finaccountOTP.Fl_Charged_Off__c && finaccountOTP.Region_Code__c != 'NRC' && pastStatus && (Date.today() < finaccountOTP.Maturity_Date__c) && noDaysPaidToDate > 10 && noDaysPaidToDate <= 44 && PaymentSelectedDate > finaccountOTP.Paid_to_Date__c.addDays(45)) { // MESSAGE CODE A39, 214, 215, 216, 217 row  
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment Date cannot be beyond ' +finaccountOTP.Paid_to_Date__c.addDays(45).format()+'.')); 
                flag = 1; 
            } else if (finaccountOTP.Region_Code__c == 'NRC' && !finaccountOTP.Fl_Charged_Off__c && !pastStatus && PaymentSelectedDate > finaccountOTP.payment_due_date__c.addDays(45)) { // MESSAGE CODE A23 223 row 
            
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment Date cannot be beyond ' +finaccountOTP.payment_due_date__c.addDays(45).format()+'.')); 
                flag = 1; 
            }
            else if (finaccountOTP.Region_Code__c == 'NRC' && !finaccountOTP.Fl_Charged_Off__c && pastStatus == true && noDaysPaidToDate <= 45 && PaymentSelectedDate > finaccountOTP.Paid_to_Date__c.addDays(45)) { //224 row A39 message code 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment Date cannot be beyond ' +finaccountOTP.Paid_to_Date__c.addDays(45).format()+'.')); 
                flag = 1; 
            }else if (finaccountOTP.Fl_Charged_Off__c == true && finaccountOTP.Region_Code__c == 'NRC' && paymentSelectedDate > date.today().addDays(45)) { // 228, 229, 230 A24 code 
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment Date cannot be beyond ' +date.today().addDays(45).format()+'.')); 
                flag = 1; 
            }else if (finaccountOTP.Region_Code__c != 'NRC' && !finaccountOTP.Fl_Charged_Off__c && !pastStatus && Date.today() < finaccountOTP.Maturity_Date__c && (paymentSelectedDate > System.today().addmonths(6)) && finaccountOTP.Remaining_Amount_Due__c <= paymentAmt ) { // 231 A42 code 
               
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment Date cannot be beyond '+date.today().addDays(182).format()+'.')); 
                flag = 1;

            }else if (finaccountOTP.Region_Code__c != 'NRC' && !finaccountOTP.Fl_Charged_Off__c && pastStatus && noDaysPaidToDate <= 10 && Date.today() < finaccountOTP.Maturity_Date__c && (paymentSelectedDate > System.today().addmonths(6)) && finaccountOTP.Remaining_Amount_Due__c <= paymentAmt) {// 232 A42 code 
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment Date cannot be beyond '+date.today().addDays(182).format()+'.')); 
                flag = 1;
            }else if (finaccountOTP.Fl_Charged_Off__c && paymentSelectedDate > Date.today().addDays(45)) { // 234 row 
            
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment Date cannot be beyond ' +date.today().addDays(45).format()+'.')); 
                flag = 1; 
            }else if (finaccountOTP.Region_Code__c != 'NRC' && !finaccountOTP.Fl_Charged_Off__c && (Date.today() > finaccountOTP.Maturity_Date__c && noDaysMaturiyDate <= 44) && PaymentSelectedDate > finaccountOTP.Maturity_Date__c.addDays(45)) {
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment Date cannot be beyond the 45 days from the Maturity Date of '+ finaccountOTP.Maturity_Date__c.addDays(45).format()+'.'));
                flag = 1;
            }
        }else {
            
            if(paymentDateCheck > todayPastCheck) {
                
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Scheduled Payment date cannot be beyond '+System.now().date().format()+'.'));
                    flag = 1; 
            }
            else if (noDaysPaidToDate >44 && noDaysPaidToDate <= 119 && PaymentSelectedDate != Date.today() && PaymentSelectedDate > Date.today()) { // A38 MESSAGE CODE  218, row
        
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment date cannot be a future date.'));
                flag = 1;            
            }else if (finaccountOTP.Fl_Bankrupt__c == true && PaymentSelectedDate  != Date.today() && PaymentSelectedDate > Date.today()) { // A38 MESSAGE CODE 219, 220, 221 ROW 
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment date cannot be a future date.'));
                flag = 1; 
            }else if (finaccountOTP.Region_Code__c == 'NRC' && noDaysPaidToDate > 45 && PaymentSelectedDate != Date.today() && PaymentSelectedDate > Date.today()) { // 225 row A38 message code
             
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment date cannot be a future date.'));
                flag = 1; 
            }else if (finaccountOTP.Region_Code__c != 'NRC' && noDaysMaturiyDate > 44 && PaymentSelectedDate != Date.today() && PaymentSelectedDate > Date.today()){ // A38 MEESAGE CODE 
                
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment date cannot be a future date.'));
                 flag = 1; 
            }
            
            
        }
                                          
        
    }  
    public pageReference cancelPayment(){
        Pagereference p = new Pagereference(System.Label.System_CL0002+finaccountOTP.Id);
        return p;
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
    
    public void ReviewDetailsOTP(){    
        flag = 0;
        Boolean errorMsgPrincipal = false;
        Decimal principalAmountBalance = 0;
        Date paymentDateCheck ;
        if(cOrder.ChargentOrders__Payment_Start_Date__c!=null)
        {
            paymentDate =cOrder.ChargentOrders__Payment_Start_Date__c.format();
        }
        else
        {       
           paymentDate =null;
        }
        
        StandardAmount = String.valueof(cOrder.ChargentOrders__Charge_Amount__c);
        
        if(paymentDate != null && paymentDate != ''){
            String[] myDateOnly = PaymentDate.split(' ');
            String[] strDate = myDateOnly[0].split(System.Label.System_CL0002);
            paymentDateCheck = Date.newInstance(integer.valueOf(strDate[2]),integer.valueOf(strDate[0]),integer.valueOf(strDate[1]));
        }
        
        
        Date today = Date.today();
        String dateString = today.format();
        String[] todayDate = dateString.split(System.Label.System_CL0002);
        Date todayPastCheck = Date.newInstance(integer.valueOf(todayDate[2]),integer.valueOf(todayDate[0]),integer.valueOf(todayDate[1]));
       /* 
        // Date can't be a date in past -126
        if(paymentDateCheck < todayPastCheck && paymentDate !=null && paymentDate != '' ) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Date cannot be in the past.'));            
            flag = 1;  
        } 
        */
         // Payment Date should not be left blank for making a payment 
        if(paymentDate == null || paymentDate == '') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select a payment date'));
            flag = 1;   
        } 
       
        /*
        if(finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Agent__c == false && paymentDateCheck > Date.today()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be a Future Date.'));
            flag = 1; 
        }
        */
        if(paymentDateCheck != null){
            for(ChargentOrders__ChargentOrder__c pdate : cOrdersStandard ){
                if((pdate.ChargentOrders__Charge_Amount__c != null && pdate.ChargentOrders__Payment_Start_Date__c != null && pdate.ChargentOrders__Payment_Start_Date__c ==  paymentDateCheck && StandardAmount != null && StandardAmount != '') ){
                    principalAmountBalance += pdate.ChargentOrders__Charge_Amount__c;    
                }  
                
            }
            
        }
        
        /* End of payment date check */
        
        //system.debug('Standard amount is ' + StandardAmount);
        // Standard Amount should not be greater than Payoff Amount in Finance Account - 132
        if(StandardAmount != null && StandardAmount !='' && Decimal.valueOf(StandardAmount) > finaccountOTP.Payoff_Amount__c)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Amount cannot be greater than payoff amount'));
            flag = 1;  
        }
        
        // Standard Amount  can't be less than 1 -136
        if((StandardAmount != null && StandardAmount != '' && Decimal.valueOf(StandardAmount) < Decimal.valueOf(1) ))  {
            //system.debug('Aravind: Going to add amount ');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Amount cannot be less than $1.00'));
            flag = 1;    
        } 
        
        
        if((StandardAmount == null || StandardAmount == '')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter a Payment Amount.'));
            flag = 1;   
        }
        
        
        
        // Bank Account can't be null
        BankAccntName = cOrder.Payment_Source_Nickname__r.Id;
        if(BankAccntName == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must select a Bank Account to continue.'));
            flag = 1;   
        }
        
    }
    
    
    public pageReference saveOTP(){
          
        editModeOTP = false;
        reviewModeOTP = false;
        successModeOTP = true;
        Pagereference p;
       
        //String[] myDateOnly = PaymentDate.split(' ');
        //String[] strDate = myDateOnly[0].split('/');
        //Integer myIntDate = integer.valueOf(strDate[1]);
        //Integer myIntMonth = integer.valueOf(strDate[0]);
        //Integer myIntYear = integer.valueOf(strDate[2]);
        
         ReviewDetailsOTP(); 
        
        
        // Defect ID: 112767 & 112766
        // same flag variable is used in both review details OTP and check details OTP. TODO: Methods needs to be revisited.
        if(flag == 1){
            return null;
        } 
        
        AccountPopulated();
        checkDatevalueOTP(); // Added this method to validate the date before saving.
        //Added this condition to check whether have any issues before saving the record. Fix for Defect 112776 & 112778
        system.debug('Flag is ' + flag);
        
        
        if(flag != 1){
            if(chargentId == null || chargentId == '') {                
                cStandard = new ChargentOrders__ChargentOrder__c();  
                
                cStandard.recordtypeid = orderRTMap.get('One_Time_Payment').Id;
                cStandard.ChargentOrders__Charge_Amount__c = Decimal.valueOf(StandardAmount);
                cStandard.ChargentOrders__Payment_Start_Date__c= Date.newInstance(myIntYear, myIntMonth, myIntDate);
                cStandard.Payment_Source_Nickname__c = cOrder.Payment_Source_Nickname__r.Id;
                cStandard.ChargentOrders__Bank_Name__c = cOrder.ChargentOrders__Bank_Name__c;
                cStandard.ChargentOrders__Manual_Charge__c = true;
                cStandard.ChargentOrders__Payment_Method__c = 'check';
                cStandard.ChargentOrders__Payment_Status__c = 'Recurring';
                cStandard.Payment_Display_Status__c = 'Pending';
                cStandard.ChargentOrders__Payment_Frequency__c = 'Once';
                cStandard.Payment_Type__c = 'R';
                cStandard.Payment_Channel__c = 'A';
                cStandard.Finance_Account_Number__c = finaccountOTP.id;
                cStandard.ChargentOrders__Tokenization__c=bankAccntToken;
                try
                {
                    insert cStandard; 
                    // Sending the payment information to CASS Service only when the necessary information is updated
                   // ChargentOrders__ChargentOrder__c orderConfirm = [Select id,Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id =: cStandard.id Limit 1 ];
                   // PendingPaymentCASSService.pendingPaymentCASSService(orderConfirm.Confirmation_Number__c);
                }Catch(DMLException e)
                {
                return null;
                }
                
            }
            else 
            {
                ChargentOrders__ChargentOrder__c cOrderUpdate = new ChargentOrders__ChargentOrder__c();
                //system.debug('Chargent ID : '+ chargentId);
                
                cOrderUpdate.id = chargentId;
                cOrderUpdate.ChargentOrders__Charge_Amount__c =  Decimal.valueOf(StandardAmount) ;
                cOrderUpdate.ChargentOrders__Payment_Start_Date__c = Date.newInstance(myIntYear, myIntMonth, myIntDate);
                cOrderUpdate.Payment_Source_Nickname__c = cOrder.Payment_Source_Nickname__r.Id;
                cOrderUpdate.ChargentOrders__Bank_Name__c = cOrder.ChargentOrders__Bank_Name__c;
                cOrderUpdate.ChargentOrders__Tokenization__c=bankAccntToken;
                try
                {
                update cOrderUpdate;
               // ChargentOrders__ChargentOrder__c orderConfirm = [Select id,Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id =: cOrderUpdate.id Limit 1 ];
              //  PendingPaymentCASSService.pendingPaymentCASSService(orderConfirm.Confirmation_Number__c);
                }

                Catch(DMLException e)
                {
                return null;
                }
                
                
            }            
           
            if(IsFromBank == 'true'){
                p = new Pagereference(System.Label.System_CL0002+cOrder.Payment_Source_Nickname__r.Id);
            }
            else{
                p = new Pagereference(System.Label.System_CL0002+finaccountOTP.ID);
            }
            p.setredirect(true);
            return p;
        }else
            return null;
        
    }
    
    
    public pageReference saveandnewOTP(){
        
        editModeOTP = false;
        reviewModeOTP = false;
        successModeOTP = true;
        Pagereference p;
        
        String[] myDateOnly = PaymentDate.split(' ');
        String[] strDate = myDateOnly[0].split('/');
        Integer myIntDate = integer.valueOf(strDate[1]);
        Integer myIntMonth = integer.valueOf(strDate[0]);
        Integer myIntYear = integer.valueOf(strDate[2]);
        
        
        ReviewDetailsOTP();
        
        // Defect ID: 112767 & 112766
        // same flag variable is used in both review details OTP and check details OTP. TODO: Methods needs to be revisited.
        if(flag == 1){
            return null;
        }  
        AccountPopulated();
        checkDatevalueOTP();   
        // Added this method to validate the date before saving.
        //Added this condition to check whether have any issues before saving the record. Fix for Defect 112776 & 112778
        if(flag != 1){
            if(chargentId == null || chargentId == '') {                
                cStandard = new ChargentOrders__ChargentOrder__c();  
                //system.debug(orderRTMap.get('One_Time_Payment').Id);
                //system.debug(orderRTMap);
                
                cStandard.recordtypeid = orderRTMap.get('One_Time_Payment').Id;
                cStandard.ChargentOrders__Charge_Amount__c = Decimal.valueOf(StandardAmount);
                cStandard.ChargentOrders__Payment_Start_Date__c= Date.newInstance(myIntYear, myIntMonth, myIntDate);
                cStandard.Payment_Source_Nickname__c = BankaccntName;
                cStandard.ChargentOrders__Bank_Name__c = cOrder.ChargentOrders__Bank_Name__c;
                cStandard.ChargentOrders__Manual_Charge__c = true;
                cStandard.ChargentOrders__Payment_Method__c = 'check';
                cStandard.ChargentOrders__Payment_Status__c = 'Recurring';
                cStandard.Payment_Display_Status__c = 'Pending';
                cStandard.ChargentOrders__Payment_Frequency__c = 'Once';
                cStandard.Payment_Type__c = 'R';
                cStandard.Payment_Channel__c = 'A';
                cStandard.Finance_Account_Number__c = finaccountOTP.id;
                cStandard.ChargentOrders__Tokenization__c=bankAccntToken;
                //cStandard.Chargent_Queues__MerchantReferenceCode__c=finaccountOTP.Finance_Account_Number__c + cStandard.Payment_Type__c + cStandard.ChargentOrders__Payment_Start_Date__c + cStandard.Payment_Channel__c;
                //system.debug('***************'+finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Agent__c);
                
                try
                {
                insert cStandard; 
                }Catch(DMLException e)
                {
                return null;
                }
                
                
            }
            else 
            {
                ChargentOrders__ChargentOrder__c cOrderUpdate = new ChargentOrders__ChargentOrder__c();
                //system.debug('Chargent ID : '+ chargentId);
                
                cOrderUpdate.id = chargentId;
                cOrderUpdate.ChargentOrders__Charge_Amount__c =  Decimal.valueOf(StandardAmount) ;
                cOrderUpdate.ChargentOrders__Payment_Start_Date__c = Date.newInstance(myIntYear, myIntMonth, myIntDate);
                cOrderUpdate.Payment_Source_Nickname__c = BankaccntName;
                cOrderUpdate.ChargentOrders__Bank_Name__c = cOrder.ChargentOrders__Bank_Name__c;
                cOrderUpdate.ChargentOrders__Tokenization__c=bankAccntToken;
                
                
                try
                {
                update cOrderUpdate;
                }
                Catch(DMLException e)
                {
                return null;
                }
                
            }           
            
            if(IsFromBank == 'true'){
                p = new Pagereference(System.Label.System_CL0009+finaccountOTP.Finance_Account_Number__c+'&isfromBank=True');
            }
            else{            
                p = new Pagereference(System.Label.System_CL0009+finaccountOTP.Finance_Account_Number__c);
            }    
            //Pagereference p = new Pagereference(+sUrlRewrite+'/'+finaccountOTP.ID);
            p.setredirect(true);
            return p;
        }else
            return null;
        
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
  
    
    public pageReference CancelOTP(){
    
         if(chargentId == null || chargentId == '')
         {        
           Pagereference p = new Pagereference(System.Label.System_CL0002+finAccount.Id);   
           return p;  
         }   
         else
         {    
             cOrderIDRedirect = [select Id from ChargentOrders__ChargentOrder__c where id=:chargentId];    
             Pagereference p = new Pagereference(System.Label.System_CL0002+cOrderIDRedirect[0].Id); 
             p.setredirect(true);    
             return p;    
         }    
         return null;  
        
    }
    
    //End of OTP 
    
}