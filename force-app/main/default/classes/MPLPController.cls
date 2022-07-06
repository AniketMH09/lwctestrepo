/********************** @Update History **********************
@25th May 2016 - Defect 114149 by Omkar - Removed the line on all Submit methods ie.. ( cinsertNew.ChargentOrders__Bank_Name__c = bankAccountsMap.get(BankaccntName).Bank_Name__c; )
@21st Feb 2017 - Defect 114355, 114372 by AMS Team - changes made to line number and 1427 to implement business rules 1430.01 and 1430.02 correctly for Non-NRc Accounts
@2nd March 2017 - Defect 114464 by AMS Team - changed the logic for startdate and enddate 
@3nd March 2017 - Defect 114491 by AMS Team - Changes made to change the error message.

@14 April 2017- Defect RSS41358 by AMS team
@17 April 2017- Defect RSS41359 by AMS team
@17 october 2017- Defect RSS42603 by AMS team.
@30 April 2018- Defect  RSS42897 by PWC Team
@8 October 2018 -Defect RSS-41334 by PWC Team

/********************** @Update History **********************/

public class MPLPController{

    /*
    Removed With sharing to implement custom security
    */
    public ChargentOrders__ChargentOrder__c c;
    public ChargentOrders__ChargentOrder__c cPrincipal;
    public ChargentOrders__ChargentOrder__c cinsertNew;
    public ChargentOrders__ChargentOrder__c cPayOff;
    public ChargentOrders__ChargentOrder__c cOrderRecord{get;set;}
    public list<ChargentOrders__ChargentOrder__c > cOrderListPF{get;set;}
    public list<ChargentOrders__ChargentOrder__c > cOrderListPFExist{get;set;}
    public List<Communication_Preferences__c> CommPref{get;set;}
    public boolean displaypopup_banknew{get;set;}
    
    public Integer typecheck {get;set;}
    public Integer Initialtypecheck {get;set;}
    public Boolean setPopFlagPF {get;set;}
    
    // received from query parameter for CSAT user
    public Boolean isReadonlyFlag {get;set;}
    
    public Boolean mobile {get;set;}
    
    public Boolean displaypopupdrawer{get;set;}
    
    public String finID ; 
    public String finIDVF{get;set;}
    public String chargentID;
    public String OTPid{get;set;}
    
    public String RPID{get;set;}
    public String RecurringID {get;set;}
    
    public String PayoffID {get;set;}
    public Decimal PayoffAmount {get;set;}
    
    public Boolean displayOverview{get;set;}
    
    public Boolean editModeOTP {get; private set;}
    public Boolean reviewModeOTP {get;private set;}
    public Boolean successModeOTP {get;private set;}
    public Boolean displayModeOTP {get;set;}
    
    public Boolean editMode {get; private set;}
    public Boolean reviewMode {get;private set;}
    public Boolean successMode {get;private set;}
    public Boolean displayModeRP {get;set;}
    
    public Boolean editModePF {get; private set;}
    public Boolean reviewModePF {get;private set;}
    public Boolean successModePF {get;private set;}
    
    
    //public Boolean displayMode {get;set;}
    public Boolean eligibleFlag {get;set;}
    public Boolean eligibleFlagRP {get;set;}
    public String eligibleFlagPF {get;set;}
    public Boolean OTPFlag {get;set;}
    public Boolean existingPFFlag {get;set;}
    
    public Boolean displaypopupotp {get;set;}
    public String fname {get;set;}
    public String StandardAmount {get;set;}
    public String PrincipalAmount {get;set;}
    public Decimal TotalPaymentAmount{get;set;}
    public Decimal onloadPrincipalAmt {get;set;}
    public String BankaccntNameotp {get;set;}
    public String ReviewBanknameOTP {get;set;}
    public String last4Num {get;set;}
    public String PaymentDate {get;set;}
    public String PaymentAuthorizedOn {get;set;}            // Added as part of July 2018 Release RSS 41776
    public DateTime today;
    public Integer flag = 0;
    
    public String RPAmount {get;set;}
    public String bankAccntName {get;set;}
    public String reviewBankName  {get;set;}
    public String chargeDate {get;set;}
    public String reviewDate {get;set;}
    public Boolean readOnly {get;set;}
    public Date NextTransactionDate {get;set;}
    public Boolean suspendedStatus {get;set;}
    public Boolean PastDueStatus {get;set;}
    public Boolean isPastdueEE {get;set;}
    public Boolean displaypopupRP {get;set;}
    public Boolean displaypopupDelete{get;set;}
    public String confirmationRP {get;set;}
    public Date NextWithdrawDate;
    
    public Boolean cancelReview {get;set;}
    //This boolean for rending the popup page in Our VF
    public boolean displaypopup{get;set;}
    public Boolean displaypopupdeletePF {get;set;}
    public Boolean readOnlyPF {get;set;}
    public String BankAccntNamePF {get;set;}
    public String reviewBankNamePF {get;set;}
    public String paymentStartDate {get;set;}
    public String paymentAuthDate {get;set;}                  // Added as part of July 2018 Release RSS 43709
    
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
    
    public List<ChargentOrders__ChargentOrder__c> cOrdersOTP;
    List<ChargentOrders__ChargentOrder__c> cOrdersPrincipal;
    List<ChargentOrders__ChargentOrder__c> cOrderConcatenated;
    Decimal paymentAmountDueEligibility;
    public ChargentOrders__ChargentOrder__c cOrderRecordPF {get;set;}
    public Boolean recordTypeName {get;set;}
    public String confirmationstd {get;set;}
    public String confirmationPrincipal{get;set;}
    public string pageDisplay;
    public String DateErrorMessage{get;set;}
    
    //PF
    
    public String ConfirmationPF{get;set;}
    public string pageDisplayPopup;
    
    //RP
    public ChargentOrders__ChargentOrder__c cOrderRecordRP{get;set;}
    public list<ChargentOrders__ChargentOrder__c > cOrderListRP{get;set;}
    public List<ChargentOrders__ChargentOrder__c> cOrders {get;set;}
    public string pageDislayEasypay;
    
    public boolean Honda{get;set;}
    public String errorColor {get;set;}
    public String errorColorPD {get;set;}
    /*changes include for defect # 112553*/
    public String errorColorWD {get;set;}
    public String errorstdColorPD {get;set;}
    public String errorColorPrincipalPD {get;set;}
    public String errorColorBA {get;set;}
    public String errorcolorTC {get;set;}
    public String token ;

    // to check if the principal click is edited or not
    public String isPrincipalEdited{get;set;}

    // set for storing all payment start date
    public set<Date> otpPaymentDates = new set<Date>();

    public decimal RemainingAmtDue {get;set;}

    // Scheduled EasyPay
    public decimal scheduledEasypayAmt {get;set;}
    public Datetime scheduledNextWithdrawalDate {get;set;}

    // Flags for continuously displaying OTP warning messages
    public boolean notclickedContinueOTP {get;set;}
    public boolean haswarningStdAmtmsg {get;set;}
    public boolean haswarningPrnAmtmsg {get;set;}
    public boolean haswarningPaydatemsg {get;set;}

    public String stdwarnmsg{get;set;}
    public String prnwarnmsg{get;set;}
    public String paydatewarnmsg{get;set;}
    
    public String isReadOnlyParam{get;set;}
    public String userfedID{get;set;}
    
    public String cutOffTime{get;set;}
    
    // Browser Detection
    public String browserInfo{get;set;}
    public String deviceInfo{get;set;}
    
    public String disableRPbtn {get;set;}
    public String disableOTPbtn {get;set;}
    public String disablePFbtn {get;set;}
    // Start : Time out roll back functionality was added By Omkar for Defect - 114048     
    public Long StarttimeOfMethodrp;
    public Long EndtimeOfMethodrp;     
    public Long ActualRedirectTime;
    //End
    
    //Below variable declared by Jayashree for 114188
    public Boolean displayConfirmationOTP {get;set;}
    public Boolean displayContinuePopup {get;set;}
    //End of 114188
    public MPLPController(ApexPages.StandardController controller) { 
        system.debug('In constructor');  
              
        //Honda = true;
        pageDislayEasypay='';
        editMode = true;
        reviewMode = false;
        successMode = false;
        displayModeRP = true;
        eligibleFlagRP = true;
        OTPFlag = false;
        readOnly = false;
        suspendedStatus = false;
        pastDueStatus = false;
        displaypopupRP = false;
        displaypopupDelete = false;
        displayOverview = false;
        
        pageDisplayPopup='';
        displaypopup = false;
        displaypopupdeletePF = false;
        editModePF = true;
        reviewModePF = false;
        successModePF = false;
        eligibleFlagPF = 'None';
        readOnlyPF = false;
        BankAccntNamePF = '';
        existingPFFlag = false;
        cancelReview = false;
        
        pageDisplay='';
        editModeOTP = true;
        
        reviewModeOTP = false;
        successModeOTP = false;
        displayModeOTP = true;
        eligibleFlag = false;
        displaypopupotp = false;
        paymentAmountDueEligibility =0;

        isPrincipalEdited = 'false';
        
        displaypopupdrawer = false;
        setPopFlagPF = false;
        
        errorColor = 'None';
        errorColorPD = 'None';
        /*changes include for defect # 112553*/
        errorColorWD = 'None';
        errorstdColorPD = 'None';
        errorColorPrincipalPD = 'None';
        errorColorBA = 'None';
        errorcolorTC = 'None';
        token = '';

        notclickedContinueOTP = true;
        haswarningStdAmtmsg = false;
        haswarningPrnAmtmsg = false;
        haswarningPaydatemsg = false;

        isPastdueEE = false;
        
        disableRPbtn = 'false'; 
        disableOTPbtn = 'false';
        disablePFbtn = 'false';
        
        //Below Initialization added by Jayashree for 114188
        displayConfirmationOTP = false;
        displayContinuePopup = false;
        //End of 114188
        
        Honda_Finance__c hondaCT = Honda_Finance__c.getOrgDefaults();
        cutOffTime = hondaCT.CutOff_Time__c.format('h:mm a') ;
        
        /*Fields added as part of changes for defect#114464; as these fields are referenced in NWDManager class */
        if (!Test.isRunningTest()) {controller.addFields(new List<String>{'ChargentOrders__Payment_Stop__c','ChargentOrders__Payment_End_Date__c','Extracted_Payment_Count__c','ChargentOrders__Payment_Count__c'});}
        
        this.c = (ChargentOrders__ChargentOrder__c)controller.getRecord();
        
        system.debug('Controller constructor ' + this.c);
        // For IE9 Changes Made for Security Vulnerability RSS 49578
        Apexpages.currentPage().getHeaders().put('p3p', 'CP="HONDA"');
        finID = ApexPages.CurrentPage().getParameters().get('finnumber');
        finID  = ESAPI.encoder().SFDC_HTMLENCODE(finID);
        //finID = ApexPages.CurrentPage().getParameters().get('finnumber').escapeHtml4();
        //finID = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('finnumber'));
        system.debug('In constructor, FIn num is ' + finID);
        
        finIDVF = ApexPages.CurrentPage().getParameters().get('finnumber');
        finIDVF  = ESAPI.encoder().SFDC_HTMLENCODE(finIDVF);
        //finIDVF = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('finnumber'));
         if(ApexPages.CurrentPage().getParameters().get('Id')!=NULL){
            chargentId = ApexPages.CurrentPage().getParameters().get('Id');
            chargentId  = ESAPI.encoder().SFDC_HTMLENCODE(chargentId);

        }
        
        
        //chargentId= String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('Id'));
        isReadOnlyParam = ApexPages.CurrentPage().getParameters().get('isReadOnly');
        if (String.isBlank(isReadOnlyParam)) {
            isReadOnlyParam = 'false';
        }
        
        finAccount = new Finance_Account__c();
        cOrderListPF = new list<ChargentOrders__ChargentOrder__c>();
        cOrderListPFExist = new list<ChargentOrders__ChargentOrder__c>();
        commpref = new List<Communication_Preferences__c>();

        // Getting federation id for survey popup
        String userid = userinfo.getUserId();
        User userdetails = [SELECT FederationIdentifier FROM User WHERE Id = :userid limit 1];
        userfedID = userdetails.FederationIdentifier;
        ApexPages.currentPage().setCookies(new Cookie[]{new Cookie('webID',userfedID,null,-1,true)});
        //  c.Next_Withdrawal_Date__c = null;

        // as chargent id is made null in each fetch method      
        fetchDataOTP();
        if(ApexPages.CurrentPage().getParameters().get('Id') != null){
            chargentId = ApexPages.CurrentPage().getParameters().get('Id');
           chargentId  = ESAPI.encoder().SFDC_HTMLENCODE(chargentId);
            //chargentId= String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('Id'));
        }
        
        fetchDataRP(); 
        
        if(ApexPages.CurrentPage().getParameters().get('Id') != null){
            chargentId = ApexPages.CurrentPage().getParameters().get('Id');
           chargentId  = ESAPI.encoder().SFDC_HTMLENCODE(chargentId);
            //chargentId= String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('Id'));
            //to clear fin id set up by fetchdatarp method
           // finID = null;
       }

       fetchData();                

       if(ApexPages.CurrentPage().getParameters().get('Id') != NULL){
        chargentId = ApexPages.CurrentPage().getParameters().get('Id');
        chargentId  = ESAPI.encoder().SFDC_HTMLENCODE(chargentId);
        //chargentId= String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('Id'));
       } 
       
       typecheck = 0;

       if(ApexPages.CurrentPage().getParameters().get('Id') == NULL){
        chargentId = null;
       }    
       system.debug('Chargent id is ' + chargentId);
       
       // Detect user browser info
       browserInfo = ApexPages.currentPage().getHeaders().get('User-Agent');
       system.debug('Sankalan - userAgent - ' + browserInfo);
       //Start : Time out roll back functionality was added by Omkar - 114048      
       ActualRedirectTime = Long.valueOf(System.Label.TimeInterval);
       //End
   }

   public PageReference onLoadMethod() {

    system.debug('In onLoadMethod');

        /*
            Rajesh changed the function signature from void to PageReference to force redirect if security check fails
        
            */
        // if (UtilityClass.CheckSecurity(finID)==false)
        if ( Apexpages.currentPage().getParameters().get('finnumber') != NULL ) {
            if ( !UserSecurity.ValidateFinNumber(Apexpages.currentPage().getParameters().get('finnumber').escapeHtml4()) ) {

                pagereference p = new pagereference('/apex/UserSecurityNotAuthorized');
                p.setRedirect(true);
                return p;
            }
            } else if (Apexpages.currentPage().getParameters().get('id') != NULL) {

                 
                if (!UserSecurity.ValidateChargentId(ApexPages.currentPage().getParameters().get('id').escapeHtml4())) {

                    pagereference p = new pagereference('/apex/UserSecurityNotAuthorized');
                    p.setRedirect(true);
                    return p;
                }
            } 

            try{    

                system.debug('Type Check after on load method' + typecheck);

                String FinanceId;
                
                if(finID != null) {
                    
                       // 114252 Prakash Start 
                    List<Finance_Account__c> finAccList = new List<Finance_Account__c>();
                    //Added Fl_Paid_Ahead__c for 114282
                    finAccList = [SELECT id,Fl_OneTime_Payment_Eligible_Web__c,name,Finance_Account_Number__c,Fl_Bankrupt__c,Remaining_Amount_Due__c,Payoff_Amount__c,Account_Type__c,ownerid,Maturity_Date__c,Paid_to_Date__c,Fl_Cancel_One_Time_Payments__c,Current_Amount_Due__c,Past_Amount_Due__c,Total_Fees_Due__c,Total_Amount_Due__c,Scheduled_EasyPay_Amount__c,Next_Due_Date__c,Payment_Due_Date__c,Principal_Balance_Amount__c,Fl_Future_OneTime_Payment_Eligible_Web__c,Fl_Refinanced__c,Region_Code__c,Fl_Paid_Ahead__c
                                  FROM Finance_Account__c 
                                  WHERE Finance_Account_Number__c = :FinId LIMIT 1];
                        
                     
                    finaccountOTP = finAccList != NULL && !finAccList.isempty() ? finAccList[0] : NULL;
                     // 114252 Prakash End 
                }
 
               
                
                if(chargentId != null) {
                    cOrderRecord = [select Finance_Account_Number__r.Finance_Account_Number__c,ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c,recordtype.developername from ChargentOrders__ChargentOrder__c where id = :chargentID];

                    FinanceId = cOrderRecord.Finance_Account_Number__r.Finance_Account_Number__c;
                    list<Finance_Account__c> financelist =[select id,Honda_Brand__c from Finance_Account__c where Finance_Account_Number__c=:FinanceId];

                    if(financelist.size()>0){
                        if(financelist[0].Honda_Brand__c == 'AFS'){
                            Honda = false;
                        }
                        else{
                            Honda = true;
                        }               
                    }


                    if(cOrderRecord.recordtype.developername == 'One_Time_Payment' || cOrderRecord.recordtype.developername == 'Principal_One_Time_Payment'){
                        typecheck = 1;  
                 //   fetchDataOTP();
             }
             if(cOrderRecord.recordtype.developername == 'Recurring_Payment'){
                typecheck = 2;
                 //   fetchdataRP();
             }
             if(cOrderRecord.recordtype.developername == 'Payoff_Payment'){
                typecheck = 3;  
                 //   fetchData();
             }

         } 

         if(finID != null){
            list<Finance_Account__c> financelist =[select id,Honda_Brand__c from Finance_Account__c where Finance_Account_Number__c=:finId];
            if(financelist.size()>0){
                if(financelist[0].Honda_Brand__c == 'AFS'){
                    Honda = false;
                }
                else{
                    Honda = true;
                }
            }

            if(ApexPages.CurrentPage().getParameters().get('type')!= null) {
                if(ApexPages.CurrentPage().getParameters().get('type') == '1'){
                     //   fetchDataOTP(); 
                        typecheck = 3;  // Changed Value from 1 to 3 as per B2C portal Requirement
                    }
                    if(ApexPages.CurrentPage().getParameters().get('type') == '2'){
                     //   fetchdataRP();
                     typecheck = 2;
                 }
                 if(ApexPages.CurrentPage().getParameters().get('type') == '3'){
                     //   fetchData();
                        typecheck = 1;  // Changed Value from 3 to 1 as per B2C portal Requirement
                    }
                }
            }
            

            
            system.debug('Type Check after on load method' + typecheck);

            } Catch ( Exception e ){
                logException.Debug('Page','MakeAPaymentLandingPage',e);
                UtilityClass.logError('MPLPController', e.getmessage(), finID , 'Browser - '+ browserInfo);
                return null;
            }
            return null;
        }  



        public void fetchDataOTP(){

            try{    

                system.debug('In fetchDataOTP ' + finID + 'Chargentid is ' + chargentid);
                principalAmount ='';
                orderRTMap = RecordTypeUtility.getOrderRecordTypes();
                gatewayRTMap = RecordTypeUtility.getgatewayRecordTypes();
                //system.debug(finId);
                notclickedContinueOTP = true;

                errorColorBA = 'None';
                
                // clearing other methods error flags

                if(finid == null) { 
                    //system.debug('Finid equals null');
                    ////RSS 43713 -- Added Next_Withdrawal_Date__c & Payment_Display_Status__c to query 
                    //// Added CreatedDate, ID to the query as part of RSS 41776
                    cOrderRecord = [select Finance_Account_Number__r.Finance_Account_Number__c,Next_Withdrawal_Date__c,Payment_Display_Status__c,ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c,recordtype.developername, ID, CreatedDate,PaymentAuthorizedOn__c from ChargentOrders__ChargentOrder__c where id = :chargentID];
                      // Aravind commented it  
                      //  finID = cOrderRecord.Finance_Account_Number__r.Finance_Account_Number__c;
                      if(cOrderRecord != null && (cOrderRecord.recordtype.developername == 'One_Time_Payment' || cOrderRecord.recordtype.developername == 'Principal_One_Time_Payment')){
                        recordTypeName = cOrderRecord.recordtype.developername == 'One_Time_Payment' ? true : false ;
                    //    finID = cOrderRecord.Finance_Account_Number__r.Finance_Account_Number__c;
                    finIDVF = cOrderRecord.Finance_Account_Number__r.Finance_Account_Number__c;
                    OTPid = chargentId ;
                    }else{
                        chargentId = null;
                    }
                   //RSS 43713 Starts: Incorrect EZP message when edit OTP : fix added on 19/07/2018
                   if(cOrderRecord != null && cOrderRecord.Payment_Display_Status__c=='Pending' 
                       && (cOrderRecord.recordtype.developername == 'One_Time_Payment' || cOrderRecord.recordtype.developername == 'Principal_One_Time_Payment' )&& cOrderRecord.ChargentOrders__Charge_Amount__c!=null)
                    {
                        List<ChargentOrders__ChargentOrder__c> existingRecPayment=[select Next_Withdrawal_Date__c,Payment_Display_Status__c,ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c,recordtype.developername from ChargentOrders__ChargentOrder__c 
                                                                   where Finance_Account_Number__c=:cOrderRecord.Finance_Account_Number__c AND recordtype.developername='Recurring_Payment' AND Payment_Display_Status__c='Pending'];
                        if(existingRecPayment.size()>0)
                        { 
                            scheduledEasypayAmt = cOrderRecord.ChargentOrders__Charge_Amount__c;
                            scheduledNextWithdrawalDate = cOrderRecord.Next_Withdrawal_Date__c;
                        }
                        
                    }                          
                    //RSS 43713 Ends
                   
                   
                    
                }
                
                
                if(chargentID == RPID || chargentID == payoffID)
                chargentId = null;

                //system.debug(chargentId);
                if(finid != null){
                    //Added Fl_Paid_Ahead__c for 114282
                    finaccountOTP = [select id,Fl_OneTime_Payment_Eligible_Web__c,name,Finance_Account_Number__c,Fl_Bankrupt__c,Remaining_Amount_Due__c,Payoff_Amount__c,Account_Type__c,ownerid,Maturity_Date__c,Paid_to_Date__c,Fl_Cancel_One_Time_Payments__c,Current_Amount_Due__c,Past_Amount_Due__c,Total_Fees_Due__c,Total_Amount_Due__c,Scheduled_EasyPay_Amount__c,Next_Due_Date__c,Payment_Due_Date__c,Principal_Balance_Amount__c,Fl_Future_OneTime_Payment_Eligible_Web__c,Fl_Refinanced__c,Region_Code__c,Fl_Paid_Ahead__c from Finance_Account__c where Finance_Account_Number__c = :FinId];

                    
                     // Defect: 114173- Veera Start
                    if(finaccountOTP != null){
                    List<ChargentOrders__ChargentOrder__c> pendingOTPOrders = [Select id from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.id = :finaccountOTP.Id and (Payment_Display_Status__c='Pending' or Payment_Display_Status__c='Processing')];
                    if(pendingOTPOrders != NULL && pendingOTPOrders.size() > 0){
          // Changed the error message for the defect: 114173 -- Veera
                    paydatewarnmsg = 'You already have one or more payment(s) scheduled for this account. You may review your scheduled payment(s) on the Pending Payments page.';
                    errorColorPD = 'None';
                    haswarningPaydatemsg = true;
                    //Below Initialization declared by Jayashree for 114188
                    displayContinuePopup = true;                    
                    }
                // Defect: 114173- Veera End        
                        
                        // Eligbility Check Flag 
                        if(finaccountOTP.Fl_OneTime_Payment_Eligible_Web__c == true)
                        eligibleFlag = true;
                        else
                        eligibleFlag = false;

                        // Pre-Populating principal payment amount
                        if(finaccountOTP.Principal_Balance_Amount__c != null)
                        onloadPrincipalAmt = finaccountOTP.Principal_Balance_Amount__c;
                        
                        // More than 6 One Time Payment flag 
                        orderMap = UtilityClass.getChargentOrders(finaccountOTP.id);
                        //System.debug('Utilit Class list of orders'+orderMap);
                        
                        cOrdersOTP = new List<ChargentOrders__ChargentOrder__c>();
                        if(orderMap.containsKey('One_Time_Payment')){
                            cOrdersOTP = orderMap.get('One_Time_Payment');
                            //System.debug('OTP order List'+cOrdersOTP);
                        }

                        List<ChargentOrders__ChargentOrder__c> paymentRP = [select id,ChargentOrders__Charge_Amount__c,ChargentOrders__Charge_Date__c,Next_Withdrawal_Date__c,Payment_Source_Nickname__r.Payment_Source_Nickname__c,Payment_Display_Status__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.id = :finaccountOTP.id and recordtypeid =:orderRTMap.get('Recurring_Payment').Id and Payment_Display_Status__c = 'Pending'];

                        if(paymentRP.size() > 0){
                            for(ChargentOrders__ChargentOrder__c RPPayment: paymentRP){
                                if(RPPayment.Payment_Display_Status__c=='Pending'){
                                    scheduledEasypayAmt = RPPayment.ChargentOrders__Charge_Amount__c;
                                    scheduledNextWithdrawalDate = RPPayment.Next_Withdrawal_Date__c;
                                }
                            }
                        } 

                        List<ChargentOrders__ChargentOrder__c> cstdPrnOrder = new List<ChargentOrders__ChargentOrder__c>();
                        if(orderMap.containsKey('One_Time_Payment')){
                            cstdPrnOrder.addall(orderMap.get('One_Time_Payment'));
                        }
                        if(orderMap.containsKey('Principal_One_Time_Payment')){
                            cstdPrnOrder.addall(orderMap.get('Principal_One_Time_Payment'));
                        }

                        if(cstdPrnOrder.size() >= 6){
                            displayModeOTP = false;
                            flag = 1;
                        }

                        for(ChargentOrders__ChargentOrder__c corder: cOrdersOTP){
                            otpPaymentDates.add(cOrder.ChargentOrders__Payment_Start_Date__c);
                        }



                        //system.debug(displayModeOTP);
                        //Principal Payment List for the finance account - principal payment created with same date with another principal payment warning message

                        cOrdersPrincipal = new List<ChargentOrders__ChargentOrder__c>();
                        if(orderMap.containsKey('Principal_One_Time_Payment')){
                            cOrdersPrincipal = orderMap.get('Principal_One_Time_Payment');
                            //System.debug('Principal Order List'+cOrdersPrincipal);
                        }


                        // More than 6 months Eligibility Calculation
                        for(ChargentOrders__ChargentOrder__c orderIteration : cOrdersOTP){
                            paymentAmountDueEligibility += orderIteration.ChargentOrders__Charge_Amount__c;
                        }
                        

                        // Setting past due status, will be used in showing Principal payment
                        if(finAccountOTP.Past_Amount_Due__c == null || finAccountOTP.Past_Amount_Due__c == 0 || paymentAmountDueEligibility >= finAccountOTP.Past_Amount_Due__c){
                            pastDueStatus = false;
                            }else{
                                pastDueStatus = true;
                            }
                            system.debug(' Days between  ' + finAccountOTP.Paid_to_Date__c.daysBetween(system.today()));
                            if(pastDueStatus && finAccountOTP.Paid_to_Date__c.daysBetween(system.today()) < 11){
                                isPastdueEE  = true;
                            }


                            System.debug('paymentAmountDueEligibility'+paymentAmountDueEligibility + ' isPastdueEE ' + isPastdueEE + ' pastDueStatus ' + pastDueStatus);

                        // Prepopulation for finance account number in URL - One Time Payment record creation
                        if(chargentID == null || chargentID == '') {

                            Date myDate = System.today();
                            PaymentDate = myDate.format();
                            PaymentAuthorizedOn = myDate.format();                     // Added as part of July 2018 Release RSS 41776
                            System.debug('This is the payment Authorized Date we are getting....'+ PaymentAuthorizedOn);

                            if(flag != 1) {
                                if(finaccountOTP.Fl_Bankrupt__c == false)
                                standardAmount = String.valueof(finaccountOTP.Remaining_Amount_Due__c);

                            }
                        }  
                    } 
                    // Business rule 768.01 
                    if(finaccountOTP.Fl_Bankrupt__c)
                    standardAmount ='';
                }    
                // Prepopulation for Editing One Time / Principal payment
                else {
                    cOrdersOTP = new List<ChargentOrders__ChargentOrder__c>();
                    cOrdersPrincipal = new List<ChargentOrders__ChargentOrder__c>();
                    system.debug('In edit mode ' + cOrdersOTP);

                    if(cOrderRecord.recordtype.developername == 'One_Time_Payment'){
                        standardAmount = String.valueof(cOrderRecord.ChargentOrders__Charge_Amount__c);
                        cOrdersOTP.add(cOrderRecord);
                    }
                    else{
                        PrincipalAmount = String.valueof(cOrderRecord.ChargentOrders__Charge_Amount__c);
                        cOrdersPrincipal.add(cOrderRecord);
                    }
                    PaymentDate = Date.valueOf(cOrderRecord.ChargentOrders__Payment_Start_Date__c).format(); 
                    PaymentAuthorizedOn = Date.valueOf(cOrderRecord.PaymentAuthorizedOn__c).format();//Date.valueOf(cOrderRecord.CreatedDate).format();  // Added as part of July 2018 Release RSS 41776 
                    system.debug('Principal Amount to be populated ' + PrincipalAmount);
                    system.debug('PaymentAuthorizedOn is...'+PaymentAuthorizedOn+'from Payment Id '+cOrderRecord.ID);
                }    
                System.debug('PrincipalAmount in fetchdataotp '+principalAmount);
                system.debug('End of fetchDataOTP ' + finId + 'Chargentid is ' + chargentid);
                } Catch ( Exception e ){
                    logException.Debug('Page','MakeAPaymentLandingPage',e);
                }
            }



            public void fetchdataRP(){
                try{    

                    system.debug('In fetchDataRP ' + finid + 'Chargentid is ' + chargentid);

                    orderRTMap = RecordTypeUtility.getOrderRecordTypes();
                    gatewayRTMap = RecordTypeUtility.getgatewayRecordTypes();

                // Clearing other methods flags
                system.debug('In fetchdata RP, Fin numm' + finID);
                //typecheck = 2;
                //Initialtypecheck = typecheck;
                errorColorBA = 'None';


                if(finID == null) {
                    cOrderRecordRP = [select recordtype.developername,Finance_Account_Number__r.Finance_Account_Number__c,ChargentOrders__Payment_Status__c from ChargentOrders__ChargentOrder__c where id = :ApexPages.CurrentPage().getParameters().get('Id') and Payment_Display_Status__c != 'Cancelled' and Payment_Display_Status__c != 'Complete'];
                    if(cOrderRecordRP != null){
                        finID = cOrderRecordRP.Finance_Account_Number__r.Finance_Account_Number__c;
                        finIDVF = cOrderRecordRP.Finance_Account_Number__r.Finance_Account_Number__c;
                        if(cOrderRecordRP.recordtype.developername == 'Recurring_Payment'){
                            RPID = chargentId ;
                            RecurringID = chargentId;
                            system.debug('RPID ' + RPID);
                            system.debug('RecurringID ' + RecurringID);
                            displayModeRP = true;
                            }else {
                                chargentId = null;
                                RecurringID = null;
                            }
                        }
                    }

                    if(finID != null){                
                        //New Field "First_Due_Date__c" is added to query as part of RSS-42897 on 30/April/2018
                        finAccount = [select id,Due_On_Day__c,Fl_Charged_Off__c,Fl_Recurring_Payment_Eligible_Web__c,Final_Due_Date__c,Account_Type__c,Regular_Monthly_Payment__c,Ownerid,Region_Code__c,Payoff_Amount__c,Fl_Refinanced__c,FI_Stop_Reinstate_Recurring_Payment__c,past_amount_due__c,next_due_date__c,name,Payment_Due_Date__c,Paid_to_Date__c,Total_Amount_Due__c, First_Due_Date__c from Finance_Account__c where Finance_Account_Number__c = :finID];
                        fName = finAccount.name;
                        orderMap = UtilityClass.getChargentOrders(finAccount.id);

                        if(chargentId == payoffID) 
                        chargentId = null; 

                    //Check Suspended Status
                    cOrderListRP = [select ChargentOrders__Payment_Status__c,Payment_Display_Status__c,ChargentOrders__Charge_Amount__c,Payment_Source_Nickname__r.Payment_Source_Nickname__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Finance_Account_Number__c =:finID and recordtypeid =:orderRTMap.get('Recurring_Payment').Id and Payment_Display_Status__c != 'Stopped' and Payment_Display_Status__c != 'Complete' and Payment_Display_Status__c != 'Cancelled'];
                    if(cOrderListRP.size() > 0) {
                        if(cOrderListRP[0].Payment_Display_Status__c == 'Suspended') {
                            suspendedStatus = true;
                        }
                    } 


                    //Check Existing RP Record
                    if(RPID == null) {
                        if(orderRTMap.containsKey('Recurring_Payment')){
                        // Defect:114271 -- Adding last4 Digits of Bank Account Number
                            cOrders = [select id,ChargentOrders__Charge_Amount__c,ChargentOrders__Charge_Date__c,Next_Withdrawal_Date__c,Payment_Source_Nickname__r.Payment_Source_Nickname__c,Payment_Source_Nickname__r.last_4__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.id = :finAccount.id and recordtypeid =:orderRTMap.get('Recurring_Payment').Id and Payment_Display_Status__c != 'Cancelled' and Payment_Display_Status__c != 'Stopped' and Payment_Display_Status__c != 'Complete'];
                        }

                        if(cOrders.size() > 0)
                        {
                            displayModeRP = false;
                            flag = 1;
                        }

                    }

                    if(orderMap.containsKey('Recurring_Payment')){
                        cOrderListRP = orderMap.get('Recurring_Payment');
                        RPID = cOrderListRP[0].Id;
                        //system.debug(cOrderListRP);
                        system.debug(' RPID in Recurring payment '+RPID);
                        chargentID = RPID;
                    }
                    
                    else {
                        chargentId = null;
                    }

                    // }   

                        // Aravind found the below code is breaking the existing payoff edit function. moreover. #31 and 32 in the UAT feedback sheet is related to Agentconsole
                        // Defect 31 and 32 
                        /*    List<ChargentOrders__ChargentOrder__c> completeListPFExist = new List<ChargentOrders__ChargentOrder__c>();
                       completeListPFExist = [select id,Confirmation_Number__c,ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c,Payment_Source_Nickname__r.Payment_Source_Nickname__c,Payment_Display_Status__c,Payment_Type__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Finance_Account_Number__c=:finID and recordtypeid =:orderRTMap.get('Payoff_Payment').Id]; 
                       if(completeListPFExist.size() > 0)
                       payoffId = completeListPFExist[0].id;
                       
                       List<ChargentOrders__ChargentOrder__c> completePFList = new List<ChargentOrders__ChargentOrder__c>();
                        if(payoffID != null) {
                        completePFList = [select Payment_Display_Status__c from ChargentOrders__ChargentOrder__c where id = :payOffID and ChargentOrders__Payment_Status__c = 'Complete'];
                        
                        if(completePFList.size() > 0)
                        finaccount.Fl_Recurring_Payment_Eligible_Web__c= false;
                        } */

                    //Eligibility Checks    
                    if(finaccount.Fl_Recurring_Payment_Eligible_Web__c == true)
                    eligibleFlagRP = true;
                    else 
                    eligibleFlagRP = false;


                    /*  if(finAccount.Payment_Due_Date__c != null) { 
                        if(finAccount.Payment_Due_Date__c > finaccount.Next_Due_Date__c && finaccount.Paid_to_Date__c <= finaccount.Next_Due_Date__c)
                        {
                        pastDueStatus = true; 
                        
                        }
                        } */

                        if(finaccount.past_amount_due__c > 0) {
                            system.debug('Past Due account ');
                            List<ChargentOrders__ChargentOrder__c> cOrdersLis = new List<ChargentOrders__ChargentOrder__c>();
                            if(orderRTMap.containsKey('One_Time_Payment')){
                                cOrdersLis = [select id,ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.id = :finAccount.id and recordtypeid = :orderRTMap.get('One_Time_Payment').Id and Payment_Display_Status__c in('Pending','Processing')];    
                            }
                            system.debug('OTPs are ' + cOrdersLis);
                            Decimal sumOfPayments = 0.0;
                            if(cOrdersLis.size() > 0) {
                                for(ChargentOrders__ChargentOrder__c c : cOrdersLis ) {
                                    if(c.ChargentOrders__Charge_Amount__c != null /*&& c.ChargentOrders__Payment_Start_Date__c < finAccount.Payment_Due_Date__c */ ){
                                        sumOfPayments += (c.ChargentOrders__Charge_Amount__c);
                                    }
                                }
                            }    
                            system.debug('Sum of payments ' + sumOfPayments + ' Past Due ' + finAccount.Past_Amount_Due__c );

                            if(sumOfPayments >= finAccount.Past_Amount_Due__c  ) {
                                pastDueStatus = false; 
                                }else{
                                    pastDueStatus = true;
                                }
                            } 

                            system.debug('Past due status is ' + pastDueStatus);

                    //  if(finaccount.past_amount_due__c > 0)
                    //  pastDueStatus = true;
                    //End of Eligibility Checks  

                    //system.debug(chargentID);

                    if(chargentID == null || chargentID == '') {

                        if(finAccount.Account_Type__c == 'Retail Consumer Lease' /* && finAccount.Ownerid != 'NRC'*/)
                        readOnly = true;


                        if((finAccount.account_type__c == 'Lease' || finAccount.account_type__c == 'Baloon') && finAccount.Fl_Refinanced__c == false )
                        readOnly = true;

                        //system.debug(readOnly);
                        
                        this.c.Monthly_Payment_Amount__c = finAccount.Regular_Monthly_Payment__c;
                        RPAmount = String.valueOf(finAccount.Regular_Monthly_Payment__c); //Needs review
                        
                        if(orderRTMap.containsKey('One_Time_Payment')){
                        List<ChargentOrders__ChargentOrder__c> cOrdersOtp = new List<ChargentOrders__ChargentOrder__c>();
                            cOrdersOtp = [select id,ChargentOrders__Charge_Amount__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.id = :finAccount.id and recordtypeid = :orderRTMap.get('One_Time_Payment').Id and Payment_Display_Status__c in('Pending','Processing')];    
                        }
                        Decimal sumOfPayments = 0.0;
                        if(cOrdersOtp.size() > 0) {
                            for(ChargentOrders__ChargentOrder__c c : cOrdersOtp) {
                                if(c.ChargentOrders__Charge_Amount__c != null)
                                sumOfPayments += c.ChargentOrders__Charge_Amount__c ;

                            }

                            if(sumOfPayments < finAccount.Past_Amount_Due__c && flag != 1 ) {
                                pastDueStatus = true ;
                                flag = 1;
                            }

                        }
                        chargedate = 'None';
                        }else {
                            //system.debug('Inside else part');
                            cinsertNew = [select ChargentOrders__Charge_Amount__c,ChargentOrders__Charge_Date__c,ChargentOrders__Next_Transaction_Date__c,Next_Withdrawal_Date__c from ChargentOrders__ChargentOrder__c where id =:RPID limit 1];
                            RPAmount = String.valueOf(cinsertNew.ChargentOrders__Charge_Amount__c);
                            chargeDate = cinsertNew.ChargentOrders__Charge_Date__c;
                            NextTransactionDate = cinsertNew.Next_Withdrawal_Date__c; 
                            //system.debug(RPID);
                        }
                    }    
                    system.debug('Charge date is ' + chargeDate);
                    system.debug('End of fetchDataRP ' + finid + 'Chargentid is ' + chargentid);
                    } Catch ( Exception e ){
                        logException.Debug('Page','MakeAPaymentLandingPage',e);
                    }   
                }

                public void fetchData()  {
                    try{

                        system.debug('In fetchData ' + finid + 'Chargentid is ' + chargentid);

                        orderRTMap = RecordTypeUtility.getOrderRecordTypes();
                        gatewayRTMap = RecordTypeUtility.getgatewayRecordTypes();
                //typecheck = 1;

                errorColorBA = 'None';

                system.debug('In Fetch data, Fin id ' + finid + ' Chargent ID is ' + chargentId);

                if(finID == null) {
                    cOrderRecordPF = [select recordtype.developername,Finance_Account_Number__r.Finance_Account_Number__c,Payment_Display_Status__c from ChargentOrders__ChargentOrder__c where id = :chargentID and Payment_Display_Status__c != 'Cancelled'];
                    if(cOrderRecordPF != null){
                        finID = cOrderRecordPF.Finance_Account_Number__r.Finance_Account_Number__c;
                        finIDVF = cOrderRecordPF.Finance_Account_Number__r.Finance_Account_Number__c;
                        system.debug('in Fetch data, When Fin ID is null, record type is  ' + cOrderRecordPF.recordtype.developername + ' Chargent id is ' + chargentId);
                        if(cOrderRecordPF.recordtype.developername == 'Payoff_Payment'){
                            payoffID = chargentId ;
                            editModePF = true;
                            system.debug('Aravind editmodepf is set as true ' + editModePF);
                            }else{
                                chargentId = null;
                            }    
                        }    
                    }

                    system.debug('In Fetch data after fin id null check, payoff id ' + payoffid);
                    if(finId != null){
                        finaccountPF = [select id,name,Fl_Recurring_Payment_Eligible_Web__c,Payoff_Amount__c,Fl_Payoff_Payment_Eligible_Web__c,account_type__c from Finance_Account__c where Finance_Account_Number__c = :FinId];
                        fName = finaccountPF.name;

                    // Removed the utility class as it doesnt not include processing status
                    //    orderMap = UtilityClass.getChargentOrders(finaccountPF.id);
                    orderMap = new Map<String,List<ChargentOrders__ChargentOrder__c>>();
                    List<ChargentOrders__ChargentOrder__c> chargentOrderList = [Select id,ChargentOrders__Payment_Start_Date__c,ChargentOrders__Charge_Amount__c,RecordType.DeveloperName  from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.id = :finaccountPF.id and RecordType.DeveloperName='Payoff_Payment' and (Payment_Display_Status__c='Pending' or Payment_Display_Status__c='Processing' or Payment_Display_Status__c='Researching')];
                    if(chargentOrderList.size() > 0 ){
                        system.debug('After fetching orderMap ' + chargentOrderList.size());
                        orderMap.put(chargentOrderList[0].RecordType.DeveloperName,chargentOrderList);
                    }
                      /*  for(ChargentOrders__ChargentOrder__c order : orderMap) {
                        // TODO: recheck the below logic
                            if(orderMap.containsKey(order.RecordType.DeveloperName)){
                                List<ChargentOrders__ChargentOrder__c> orderList = orderMap.get(order.RecordType.DeveloperName);
                                orderList.add(order);
                            } 
                            else{
                                List<ChargentOrders__ChargentOrder__c> orderTmpList = new List<ChargentOrders__ChargentOrder__c>();
                                orderTmpList.add(order);
                                orderMap.put(order.RecordType.DeveloperName,orderTmpList);
                            }
                            } */

                            if(chargentId == RPID) 
                            chargentId = null; 

                            if(finaccountPF.Fl_Payoff_Payment_Eligible_Web__c == false)
                            eligibleFlagPF = 'No';
                            else 
                            eligibleFlagPF = 'Yes';
                            
                            //Changes added to defect 114012 by Jayashree
                            
                            if(finaccountPF.Payoff_Amount__c == NULL || finaccountPF.Payoff_Amount__c <= 0){
                            finaccountPF.Fl_Payoff_Payment_Eligible_Web__c = false;
                            }
                            //End of Defect 114012


                            
                            system.debug('Payoff id is ' + payoffID);
                    //Check Existing Payoff Record
                    if(payoffID == null) {
                        if(orderMap.containsKey('Payoff_Payment')){
                        // Defect:114271 -- Adding last4 Digits of Bank Account Number
                            cOrderListPFExist = [select Confirmation_Number__c,ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c,Payment_Source_Nickname__r.Payment_Source_Nickname__c,Payment_Source_Nickname__r.last_4__c,Payment_Display_Status__c,Payment_Type__c,CreatedDate,PaymentAuthorizedOn__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Finance_Account_Number__c=:finID and recordtypeid =:orderRTMap.get('Payoff_Payment').Id and Payment_Display_Status__c != 'Cancelled' and Payment_Display_Status__c != 'Reversed'];
                            system.debug('Pay off payments -----> ' + cOrderListPFExist );
                            existingPFFlag = true;
                            editmodepf= false;
                        }
                    }
                    system.debug('Order map in payoff section ' + orderMap);
                    
                    if(orderMap.containsKey('Payoff_Payment')){
                        cOrderListPF = orderMap.get('Payoff_Payment');
                        payoffID = cOrderListPF[0].Id;
                        chargentID = payoffID ;
                        }else{
                            chargentId = null;
                        }

                        system.debug('Order map in payoff section ' + payoffid); 


                    // Defect 31 amd 32 
                    List<ChargentOrders__ChargentOrder__c> completeListPFExist = new List<ChargentOrders__ChargentOrder__c>();
                    completeListPFExist = [select id,Confirmation_Number__c,ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c,Payment_Source_Nickname__r.Payment_Source_Nickname__c,Payment_Display_Status__c,Payment_Type__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Finance_Account_Number__c=:finID and recordtypeid =:orderRTMap.get('Payoff_Payment').Id and Payment_Display_Status__c = 'Complete']; 
                    if(completeListPFExist.size() > 0)
                    payoffId = completeListPFExist[0].id;

                    List<ChargentOrders__ChargentOrder__c> completePFList = new List<ChargentOrders__ChargentOrder__c>();
                    if(payoffID != null) {
                        completePFList = [select Payment_Display_Status__c from ChargentOrders__ChargentOrder__c where id = :payOffID and ChargentOrders__Payment_Status__c = 'Complete'];
                        if(completePFList.size() > 0)
                        finaccountPF.Fl_Payoff_Payment_Eligible_Web__c = false;
                    }


                    system.debug('Chargent id before null check ' + chargentID );
                    if(chargentID == null || chargentID == '') {
                        if(finaccountPF.Payoff_Amount__c != NULL)
                        PayoffAmount = finaccountPF.Payoff_Amount__c;

                        paymentStartDate = String.valueOf(System.today().format());
                        paymentAuthDate  = String.valueOf(System.today().format());              // Added as part of July 2018 Release RSS 43709

                        //System.debug('Record Type Utility Inside Fetch Data'+orderRTMap+gatewayRTMap);
                        }else {
                            if(orderRTMap.containsKey('Payoff_Payment')){
                                //added field createddate as part of RSS 43709
                                cOrderListPF = [select ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c,Payment_Source_Nickname__r.Payment_Source_Nickname__c,Payment_Display_Status__c,Payment_Type__c,Confirmation_Number__c,CreatedDate,PaymentAuthorizedOn__c from ChargentOrders__ChargentOrder__c where Id=:payoffID and recordtypeid =:orderRTMap.get('Payoff_Payment').Id and Payment_Display_Status__c != 'Cancelled'];
                                PayoffAmount = cOrderListPF[0].ChargentOrders__Charge_Amount__c;
                                paymentStartDate = String.valueOf((cOrderListPF[0].ChargentOrders__Payment_Start_Date__c).format());
                               paymentAuthDate= String.valueOf(Date.valueOf(cOrderListPF[0].PaymentAuthorizedOn__c).format());
                                                                                                  // Added as part of July 2018 Release RSS 43709
                                                                                              
                                today = System.today();
                                system.debug('Order PF list ' + cOrderListPF);
                                Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();
                                if(cOrderListPF[0].Payment_Display_Status__c == 'Pending'){
                                    if(cOrderListPF[0].ChargentOrders__Payment_Start_Date__c.isSameDay(System.today())){
                                        if(System.now().time() > hfc.CutOff_Time__c.time()){
                                            readOnlyPF = true;
                                            system.debug('Crossed CutOff_Time__c');
                                            }else{
                                                readOnlyPF = false;
                                            }
                                            }else if(System.today().daysBetween(cOrderListPF[0].ChargentOrders__Payment_Start_Date__c) < 0){
                                                system.debug('Comes in else part - pay start '+ PaymentStartDate +' < date today' + string.valueof(System.today().format()));
                                                readOnlyPF = true;
                                            }    
                                            }else if(cOrderListPF[0].Payment_Display_Status__c.equalsignorecase('Processing')){
                                                readOnlyPF = true;     
                                                system.debug('Is processing' + cOrderListPF[0].Payment_Display_Status__c);
                                                }else if(cOrderListPF[0].Payment_Display_Status__c.equalsignorecase('Researching')){
                                                    readOnlyPF = true;     
                                                } 
                                            }
                                        }   
                                    }    
                                    system.debug('End of fetchData ' + finid + 'Chargentid is ' + chargentid);
                                    } Catch ( Exception e ){
                                        logException.Debug('Page','MakeAPaymentLandingPage',e);
                                    }    
                                }   


                                public pagereference checkDataNew(){
                                    displaypopup_banknew = true;

                                    return null;
                                }


                                public Pagereference closeBankPopupNew(){
                                    displaypopup_banknew = false;

                                    return null;
                                }

        //RP Functionalities 

        public pageReference checkDataRP(){
            //system.debug('checkdata');
            String recID = ApexPages.CurrentPage().getParameters().get('recID');
            Pagereference p;
            if(recID == 'Add New' || BankAccntName == 'Add New') {
                p = new Pagereference(System.Label.System_CL0019+fName);
                p.setredirect(true);
            }
            return p;
        }

        public void checkDatevalue(){
            try{

            // clearing previous colour
            errorColorWD = 'None';
            system.debug('parameter value is ' + Apexpages.currentPage().getParameters().get('myParam'));
            chargeDate = Apexpages.currentPage().getParameters().get('myParam');
            chargeDate  = ESAPI.encoder().SFDC_HTMLENCODE(chargeDate);
            system.debug('Inside checkDatevalue, coming with the selected value of  ' + chargeDate );
            // Removed "Refinanced" flag as part of defect 114355 by AMS team
            if((finaccount.account_type__c == 'Lease' || finaccount.account_type__c == 'Retail' || finaccount.Account_Type__c == 'Balloon') && ChargeDate != 'None' && finaccount.Region_Code__c != 'NRC')
            {
                //system.debug('Day ' + System.today().toStartOfMonth().adddays(Integer.valueOf(finaccount.Due_On_Day__c)+10));
               // if(Integer.valueOf(ChargeDate) > Integer.valueOf(finaccount.Due_On_Day__c) && Integer.valueof(ChargeDate) < ((Integer.valueOf(finaccount.Due_On_Day__c) + 10 > 31) ?((Integer.valueOf(finaccount.Due_On_Day__c) + 10)-30) :Integer.valueOf(finaccount.Due_On_Day__c) + 10 )){ 
                // due -26: chargedate - 4;  4-11-15 > 26-11-15 && 4-11-15 < 7-12-15 - Invalid case
                // due - 5: chargedate -16;  16-11-15 > 5-11-15 && 16-11-15 < 15-11-15 - Valid case
                Integer startday=(Integer.valueof(finaccount.Due_On_Day__c))+1;
                startday=(startday > 31? startday - 31 : startday);
                Integer endday = (Integer.valueof(finaccount.Due_On_Day__c)) + 11;
                endday = (endday> 31? endday- 31 : endday);
                if(Integer.valueof(chargeDate) >= startday && startday > EndDay){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                    flag = 1;
                    errorColorWD = 'Red';
                }
                else if (Integer.valueof(chargeDate) >= startday && Integer.valueof(chargeDate) < EndDay){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                    flag = 1;
                    errorColorWD = 'Red';
                } 
                else if (Integer.valueof(chargeDate) < EndDay && startday > EndDay){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                    flag = 1;
                    errorColorWD = 'Red';
                }   
              /*  if(Integer.valueof(chargeDate) > startday){

                    if(Integer.valueof(chargeDate) <=endday){
                        // Defect 114491 fixes by AMS team: Changes the error message
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                        flag = 1;
                        /*changes include for defect # 112553*/
                        //errorColorWD = 'Red';
                    //    finaccount.Due_On_Day__c = chargeDate;
               // }
               // } 
                /*else{
                        // 4-12-15 < 7-12-15
                        if(Integer.valueof(ChargeDate) <= endday){
                            // Defect 114491 fixes by AMS team: Changes the error message
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                            flag = 1;
                            /*changes include for defect # 112553*/
                           // errorColorWD = 'Red';
                    //    finaccount.Due_On_Day__c = chargeDate;
              //  }

            //  }    
            }
            // As Per Kamesh, checked Region code as NRC.
            //  if(finaccount.Fl_Charged_Off__c == true /* &&  finaccount.ownerid != 'label.nrc'*/){
                if(finaccount.Region_Code__c == 'NRC'){
                    Integer startday=(Integer.valueof(finaccount.Due_On_Day__c))+1;
                    startday=(startday > 31? startday - 31 : startday);
                    Integer endday = (Integer.valueof(finaccount.Due_On_Day__c)) + 8;
                    endday = (endday> 31? endday- 31 : endday);
                    if(Integer.valueof(chargeDate) >= startday && startday > EndDay){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                        flag = 1;
                        errorColorWD = 'Red';
                    }
                    else if (Integer.valueof(chargeDate) >= startday && Integer.valueof(chargeDate) < EndDay){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                        flag = 1;
                        errorColorWD = 'Red';
                    } 
                    else if (Integer.valueof(chargeDate) < EndDay && startday > EndDay){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                        flag = 1;
                        errorColorWD = 'Red';
                    }    
                   /* if(Integer.valueof(chargeDate) > startday){

                        if(Integer.valueof(ChargeDate) <= endday){
                            // Defect 114491 fixes by AMS team: Changes the error message
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                            flag = 1;
                            /*changes include for defect # 112553*/
                            //errorColorWD = 'Red';
                        //finaccount.Due_On_Day__c = chargeDate;
                    //}
                    //}else{
                        // 4-12-15 < 7-12-15
                      /*  if(Integer.valueof(ChargeDate) <= endday){
                            // Defect 114491 fixes by AMS team: Changes the error message
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                            flag = 1;
                            /*changes include for defect # 112553*/
                           // errorColorWD = 'Red';
                        //finaccount.Due_On_Day__c = chargeDate;
                    //}

                //}   
            }
            
            
            if(flag != 1) {
                system.debug('No errors in checkdatevalue, choose value from dropdown is ' + ChargeDate);
                today = System.today();
                //Integer WithdrawPaymentOn;
                Date WithdrawPaymentDate;
                if(ChargeDate != 'None') {
                    //WithdrawPaymentOn = Integer.valueOf(ChargeDate);
                    c.ChargentOrders__Charge_Date__c = ChargeDate;
                    //WithdrawPaymentDate = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                }
                
                //Defect#114464 - use NWDManager method calculateNWD(ChargentOrders__ChargentOrder__c easypay, Date newStartDate, Boolean skipFirstMonth) 
                //Logic to calculate Next Withdrawal Date is updated as per RSS-42897 on 30/April/2018
                //c.Next_Withdrawal_Date__c= NWDManager.calculateNWD(c, Date.today(), false);
                If (finaccount.first_due_date__c != null)
                {
                    If (finaccount.first_due_date__c.addDays(-21) > Date.Today())
                    {
                        c.Next_Withdrawal_Date__c = NWDManager.calculateNWD(c,finaccount.first_due_date__c.addDays(-21), false);
                    }
                    else
                    {
                        c.Next_Withdrawal_Date__c = NWDManager.calculateNWD(c, Date.today(), false);
                    }
                }
                else
                {
                    c.Next_Withdrawal_Date__c = NWDManager.calculateNWD(c, Date.today(), false);
                }

                NextTransactionDate = c.Next_Withdrawal_Date__c;

                // Defect: 113923 by Veera 06 APR 2016  STARTS --  NWD of each Month
                // commented as part of Defect#114464 changes to use NWDManager for NWD calculation.
                /*if(WithdrawPaymentOn >= System.today().day()){
                        if( WithdrawPaymentOn >= date.daysInMonth(System.today().year(), System.today().month())){
                            c.Next_Withdrawal_Date__c = Date.newInstance(System.today().year(), System.today().month(),date.daysInMonth(System.today().year(), System.today().month()));
                            NextTransactionDate = Date.newInstance(System.today().year(), System.today().month(),date.daysInMonth(System.today().year(), System.today().month()));
                           }else{
                            c.Next_Withdrawal_Date__c = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                            NextTransactionDate = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                            }
                 }else{
                        c.Next_Withdrawal_Date__c = WithdrawPaymentDate.addmonths(1);
                        NextTransactionDate = WithdrawPaymentDate.addmonths(1);
                      }
                            
                            //cut-off time Implementation
                
                Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();
                // Logic Added for getting the payment with in cut off Time.
                if(WithdrawPaymentOn == System.today().day() && (System.now().time() < hfc.CutOff_Time__c.time())){
                        c.Next_Withdrawal_Date__c = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                        NextTransactionDate = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                }
                // Logic Added for submitting the payment for next month
                if(WithdrawPaymentOn == System.today().day() && (System.now().time() > hfc.CutOff_Time__c.time())){
                        c.Next_Withdrawal_Date__c = WithdrawPaymentDate.addmonths(1);
                        NextTransactionDate = WithdrawPaymentDate.addmonths(1);
                }   */ 
                //End of Defect#114464     
                
                //Defect: 113923 by Veera 06 APR 2016  ENDS  -- NWD of each Month
  
                if(ChargeDate == '29' || ChargeDate == '30' || ChargeDate == '31'){
                 // Changes added to the defect 114086 by Jayashree
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<b>In months without '+ChargeDate+' days, your payment will be processed on the last day of the month.</b>'));  
                 //End of defect 114086
                    errorColorWD = 'Green';
                }


                if(NextTransactionDate > finaccount.next_due_date__c && finaccount.Paid_to_Date__c <= finaccount.next_due_date__c){
                // Changes added to the defect 114086 by Jayashree
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'<b>Your first EasyPay payment will withdraw on ' + NextTransactionDate.format() +', which falls after your Next Payment Due Date of '+ finaccount.next_due_date__c.format() +'. To keep your account current, please be sure to pay $' + finaccount.Total_Amount_Due__c + ' by '+ finaccount.next_due_date__c.format() +'.</b>'));  
                    //End of defect 114086
                    errorColorWD = 'Green';  
                   
                }
                system.debug('Next transaction date ' + NextTransactionDate + ' Next_Withdrawal_Date__c ' + c.Next_Withdrawal_Date__c );
            }
            
            
            } Catch ( Exception e ){
                logException.Debug('Page','MakeAPaymentLandingPage',e);
            }    
        }


        public List<selectOption> getChargeDateList() {
            try{ 
                            
                Schema.DescribeFieldResult fieldResult = ChargentOrders__ChargentOrder__c.ChargentOrders__Charge_Date__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    //system.debug(ple);


                    // remove next 10 days value
                    Integer startday =0; 
                    Integer endday = 0; 
                    boolean isNrc = false;

                    system.debug('Fin Account in get ChargeDateList is ' + finaccount);
                    // Commented as part of defect 114355 by AMS team: Removed the "Refinanced" flag to correctly implement rule 1430.01   
                    /*if(((finaccount.account_type__c == 'Lease' || finaccount.account_type__c == 'Retail') || (finaccount.Account_Type__c == 'Balloon' && finaccount.Fl_Refinanced__c == true)) && finaccount.Region_Code__c != 'NRC') */
                    if ((finaccount.account_type__c == 'Lease' || finaccount.account_type__c == 'Retail' || finaccount.Account_Type__c == 'Balloon') && finaccount.Region_Code__c != 'NRC') 
                    {
                        system.debug('in chargelist...NonNRC');
                        // commented as part of defect 114464 by AMS team: To make sure start date and end date are calculates correctly.
                        /*startday = (System.today().toStartOfMonth().adddays(Integer.valueOf(finaccount.Due_On_Day__c))).day(); 
                        endday = (System.today().toStartOfMonth().adddays(Integer.valueOf(finaccount.Due_On_Day__c)).adddays(10)).day(); */
                        startday=(Integer.valueof(finaccount.Due_On_Day__c))+1;
                        startday=(Startday > 31? Startday - 31 : startday);
                        endday = (Integer.valueof(finaccount.Due_On_Day__c)) + 11;
                        endday = (endday> 31? endday- 31 : endday);
                        system.debug('start date in non NRC is...'+startday);
                        system.debug('end day in non NRC is...'+endday);
                        system.debug('Account_Type__c for given account is....'+finaccount.Account_Type__c);
                        system.debug('Fl_Refinanced__c flag for this acount is.....'+finaccount.Fl_Refinanced__c);

                    }
                    // As Per Kamesh, checked Region code as NRC.
                    if(finaccount.Region_Code__c == 'NRC'){
                        system.debug('in chargelist...NRC');
                        isNrc = true;
                        // commented as part of defect 114464 by AMS team: To make sure start date and end date are calculates correctly.
                        /*startday = (System.today().toStartOfMonth().adddays(Integer.valueOf(finaccount.Due_On_Day__c))).day(); 
                        endday = (System.today().toStartOfMonth().adddays(Integer.valueOf(finaccount.Due_On_Day__c)).adddays(7)).day();*/
                        startday=(Integer.valueof(finaccount.Due_On_Day__c))+1;
                        startday=(Startday > 31? Startday - 31 : startday);
                        endday = (Integer.valueof(finaccount.Due_On_Day__c)) + 8;
                        endday = (endday> 31? endday- 31 : endday);
                        system.debug('start date in NRC is...'+startday);
                        system.debug('end day in NRC is...'+endday);
                    }
                    
                    List<selectOption> cdOptions = new List<selectOption>();
                    cdOptions.add(new SelectOption('Select One','Select One'));        //updated as part of RSS 44870
                    
                    for( Schema.PicklistEntry f : ple)
                    {                         
                       if(startday > 21 && !isNrc){
                            // 30< 28 && 30>8
                            // 27 >28 && 27<8
                            if((Integer.valueOf(f.getValue()) < startday) && (Integer.valueOf(f.getValue()) >= endday)){
                                cdOptions.add(new SelectOption(f.getValue(), Integer.valueOf(f.getValue())+getDayOfMonthSuffix(Integer.valueOf(f.getValue())) + ' ' +'of the month' ));
                            }

                            }else if(startday > 25 && isNrc){
                                if((Integer.valueOf(f.getValue()) < startday) && (Integer.valueOf(f.getValue()) >= endday)){
                                    cdOptions.add(new SelectOption(f.getValue(), Integer.valueOf(f.getValue())+getDayOfMonthSuffix(Integer.valueOf(f.getValue())) + ' ' +'of the month' ));
                                }    
                                }else if(!(Integer.valueOf(f.getValue()) >= startday && Integer.valueOf(f.getValue()) < endday)){
                                    cdOptions.add(new SelectOption(f.getValue(), Integer.valueOf(f.getValue())+getDayOfMonthSuffix(Integer.valueOf(f.getValue())) + ' ' +'of the month' ));
                                }  
                                
                            }
                            
                                for (SelectOption SO : cdOptions)
                                 {
                                 system.debug('Picklist value - ' + SO.getValue());
                                  }                             
                            
                            return cdOptions;
                            
                            } Catch ( Exception e ){
                                logException.Debug('Page','MakeAPaymentLandingPage',e);
                                return  null;
                            }   

                        } 


                        public static String getDayOfMonthSuffix(Integer n) {
                            try{
                                if (n == null) {
                                    return '';
                                }

                                if (n >= 11 && n <= 13) {
                                    return 'th';
                                }

                                Integer modResult = Math.mod(n, 10);        
                                if (modResult == 1) { 
                                    return 'st'; 
                                    } else if (modResult == 2) { 
                                        return 'nd'; 
                                        } else if (modResult == 3) { 
                                            return 'rd'; 
                                            } else { 
                                                return 'th';
                                            }
                                            } Catch ( Exception e ){
                                                logException.Debug('Page','MakeAPaymentLandingPage',e);
                                                return null;
                                            }
                                        }

        public List<selectOption> getbankValuesRP() {
            try {
                
                
                List<selectOption> options = new List<selectOption>();
                if (finAccount != NULL ) {  //// 114252 Prakash added          
                    system.debug('In getbankValuesRP');
                    pageDislayEasypay=apexpages.currentpage().getparameters().get('category');
                    flag = 0;
                    
                    if(String.IsNotBlank(finAccount.id)){
                    
                        bankAccountsMap = new Map<Id, Payment_Source__c> ([Select Payment_Source_Nickname__c, Last_4__c, ChargentOrders_Tokenization__c,id,Preferred_Payment_Source__c,Bank_Name__c from Payment_Source__c where Finance_Account_Number__r.id = :finAccount.id and status__c = 'Active' ]);
                        //Fetched Last_4__c field in Query - Defect: 114271 - Veera
                    }
                    
                    //system.debug(chargentID);
                    if(RPID == null) {
                        system.debug ('::pp::');
                        options = UtilityClass.getBankAccounts(bankAccountsMap);
                    }
                    else if(pageDislayEasypay=='popup'){
                        options = UtilityClass.getBankAccountNames(finAccount.id,pageDislayEasypay);
                    }
                    else {
                        system.debug('Inside else');
                        options = UtilityClass.getBankAccounts(bankAccountsMap,RPID);
                    }
                    system.debug(bankAccountsMap);
                    system.debug(RPID);
                    system.debug(options);
                   
                }
                 return options;
                
                
            } Catch ( Exception ex ){
                logException.Debug('Page','MakeAPaymentLandingPage',ex);
                UtilityClass.logError('MPLPController', ex.getmessage(), finAccount.id , 'Browser - '+ browserInfo); 
                return null;
            }

        }

        public pageReference checkPaymentRP(){
            try{

            // clearing previous colour
            errorcolor = 'None';

            RPAmount = Apexpages.currentPage().getParameters().get('paymentValue');
            RPAmount = ESAPI.encoder().SFDC_HTMLENCODE(RPAmount);
            if((RPAmount != null && RPAmount != '') && !Pattern.matches('[0-9]+(\\.[0-9][0-9]?)?',RPAmount)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Automatic Payment Amount should be numeric'));
                flag = 1;
                errorcolor = 'Red';
                }else{
                    if((Decimal.valueOf(RPAmount) > finAccount.Payoff_Amount__c) && (finAccount.account_type__c == 'Retail' || (finAccount.account_type__c == 'Balloon' && finAccount.Fl_Refinanced__c == true))){

                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Amount cannot be greater than payoff amount.'));  
                        errorcolor = 'Red';
                        flag = 1;
                    }

                    if((Decimal.valueOf(RPAmount) < finAccount.Regular_Monthly_Payment__c) && (finAccount.account_type__c == 'Retail' || (finAccount.account_type__c == 'Balloon' && finAccount.Fl_Refinanced__c == true))){
                   // Commented For changes in errror message as per Defect ID: 112719; Beware -  The error msg is wrong in the test script
                   //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Amount cannot be less than Regular monthly payment amount.'));  
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Amount must be equal to $'+ finAccount.Regular_Monthly_Payment__c + ' .'));  
                   errorcolor = 'Red';
                   flag = 1;
               }
           }

           if((Decimal.valueOf(RPAmount) > finAccount.Regular_Monthly_Payment__c)/* && (finAccount.account_type__c == 'Retail' || finAccount.account_type__c == 'Baloon Refinance') && finAccount.Fl_Refinanced__c == true */) {
            Decimal balance = Decimal.valueOf(RPAmount) - finAccount.Regular_monthly_payment__c;
            errorcolor = 'Green';
            //Below format Change added to the defect 114086 by Jayashree
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'<b>The amount you entered exceeds your Regular Monthly Payment by $'+balance+'. A total of $'+ RPAmount+' will be withdrawn from your bank account every month.</b>')); 
            flag = 1;
           } 

           else{
            ApexPages.getMessages().clear();
           }

           return null;

           } Catch ( Exception e ){
            logException.Debug('Page','MakeAPaymentLandingPage',e);
            return null;
           }
       } 

       public Pagereference reviewDetailsRP(){
        try {
        // Clearing existing colour
        errorColorWD = 'None';
        errorcolorTC = 'None';
        errorcolor = 'None';
        
         //Jayashree Added this as per the discussion with sankalan
            if(this.c.Next_Withdrawal_Date__c == null || NextTransactionDate == null) {
                if(ChargeDate != null) {
                    today = System.today();
                    //Integer WithdrawPaymentOn;
                    Date WithdrawPaymentDate;
                    if(ChargeDate != 'None') {
                        //WithdrawPaymentOn = Integer.valueOf(ChargeDate);
                        c.ChargentOrders__Charge_Date__c = ChargeDate;
                        //WithdrawPaymentDate = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                    }
                    
                    //Defect#114464 - use NWDManager method calculateNWD(ChargentOrders__ChargentOrder__c easypay, Date newStartDate, Boolean skipFirstMonth) 
                    //Logic to calculate Next Withdrawal Date is updated as per RSS-42897 on 30/April/2018
                   //c.Next_Withdrawal_Date__c= NWDManager.calculateNWD(c, Date.today(), false);
                   
                    If (finaccount.first_due_date__c != null)
                    {
                    If (finaccount.first_due_date__c.addDays(-21) > Date.Today())
                    {
                        c.Next_Withdrawal_Date__c = NWDManager.calculateNWD(c,finaccount.first_due_date__c.addDays(-21), false);
                    }
                    else
                    {
                        c.Next_Withdrawal_Date__c = NWDManager.calculateNWD(c, Date.today(), false);
                    }
                }
                else
                {
                    c.Next_Withdrawal_Date__c = NWDManager.calculateNWD(c, Date.today(), false);
                }               
                  NextTransactionDate = c.Next_Withdrawal_Date__c;

                    /* // commented as part of Defect#114464 changes to use NWDManager for NWD calculation.
                    if(WithdrawPaymentDate < System.today()){
                        c.Next_Withdrawal_Date__c = Date.newInstance(System.today().year(), System.today().month()+1,WithdrawPaymentOn);
                        NextTransactionDate = Date.newInstance(System.today().year(), System.today().month()+1,WithdrawPaymentOn);
                    }
                    if(WithdrawPaymentDate >= System.today()){
                        c.Next_Withdrawal_Date__c  = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                        NextTransactionDate = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                    }
                    //system.debug('InCheckdatevalue');
                    //cut-off time 
                    
                    Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();

                    if(NextTransactionDate == System.today() && (System.now().time() < hfc.CutOff_Time__c.time())){
                        NextTransactionDate = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                        c.Next_Withdrawal_Date__c = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                    }
                    
                    if(NextTransactionDate == System.today() && (System.now().time() > hfc.CutOff_Time__c.time())){
                        NextTransactionDate = Date.newInstance(System.today().year(), System.today().addMonths(1).month(),WithdrawPaymentOn);
                        c.Next_Withdrawal_Date__c = Date.newInstance(System.today().year(), System.today().addMonths(1).month(),WithdrawPaymentOn);
                    }
                    */// End of defect#114464
                } 
             } 
                
                //End of NWD

        if(String.isBlank(RPAmount)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter the Payment Amount'));
            flag = 1;
            errorcolor = 'Red';
            }else if((RPAmount != null && RPAmount != '') && !Pattern.matches('[0-9]+(\\.[0-9][0-9]?)?',RPAmount)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Automatic Payment Amount should be numeric'));
                flag = 1;
                errorcolor ='Red';
            }
        
         /*Adding as a part of RSS41359 fix */
        if(NextTransactionDate > finAccount.Final_Due_Date__c){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Next Withdrawal Date cannot be beyond final Payment Due Date of ' + finAccount.Final_Due_Date__c.format()));
        flag = 1;
            errorcolor = 'Red';
            }

            if(flag != 1) {

                if(chargeDate == 'None') {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'*Required fields'));
                    flag = 1;  
                    errorColorWD = 'Red';
                }
                // Added this null check for defect # 114026
                if(BankAccntName == 'None' || String.isBlank(BankAccntName)) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Create Bank Account to proceed further.'));
                    flag = 1;  
                    errorColorBA = 'Red';
                }

                if(BankAccntName == 'Select One' || BankAccntName == 'Add New') {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select Bank Account to proceed further.'));
                    flag = 1;
                    errorColorBA = 'Red';
                }



                if((Decimal.valueOf(RPAmount) > finAccount.Payoff_Amount__c) /*&& (finAccount.account_type__c == 'Retail' || finAccount.account_type__c == 'Baloon Refinance') && finAccount.Fl_Refinanced__c == true*/){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Amount cannot be greater than payoff amount.'));  
                    flag = 1;
                    errorColor ='Red';
                }


                if((Decimal.valueOf(RPAmount) < finAccount.Regular_Monthly_Payment__c) && (finAccount.account_type__c == 'Retail' || (finAccount.account_type__c == 'Balloon' && finAccount.Fl_Refinanced__c == true ))){
              //  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Amount cannot be less than Regular monthly payment amount.'));  
              //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Amount must be equal to Regular Monthly Payment'));  
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Amount must be equal to $'+ finAccount.Regular_Monthly_Payment__c + ' .'));  
              flag = 1;
              errorColor ='Red';
          }
            
        //changes include for defect # 113919 by Jayashree
              if((finAccount.account_type__c == 'Lease' || (finAccount.account_type__c == 'Balloon' && finAccount.Fl_Refinanced__c == false)) && finAccount.Regular_Monthly_Payment__c <= 0){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'EasyPay amount cannot be equal to $0.00.'));  
              flag = 1;
              errorColor ='Red';
              }
              
            // The below message comes from checkPayementRP method as it is an info
            // if((Decimal.valueOf(RPAmount) > finAccount.Regular_Monthly_Payment__c)/* && (finAccount.account_type__c == 'Retail' || finAccount.account_type__c == 'Baloon Refinance') && finAccount.Fl_Refinanced__c == true */) {
            /*    Decimal balance = Decimal.valueOf(RPAmount) - finAccount.Regular_monthly_payment__c;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'The amount you entered exceeds your Regular Monthly Payment by '+balance+' A total of '+finAccount.Regular_Monthly_Payment__c+' will be withdrawn from your bank account every month.')); 
               
                } */
                // Commented as part of defect 114372 : changed the parenthesis to implement rule 1430.02 correctly only for Non-NRC accounts.
                //if(((finaccount.account_type__c == 'Lease' || finaccount.account_type__c == 'Retail')/* && finaccount.ownerid != 'label.nrc'*/) || (finaccount.Account_Type__c == 'Balloon' && finaccount.Fl_Refinanced__c == true) && ChargeDate != 'None' && finaccount.Region_Code__c != 'NRC')
                if ((finaccount.account_type__c == 'Lease' || finaccount.account_type__c == 'Retail' || finaccount.Account_Type__c == 'Balloon') && ChargeDate != 'None' && finaccount.Region_Code__c != 'NRC')  
                {
                    Integer startday=(Integer.valueof(finaccount.Due_On_Day__c))+1;
                    startday=(startday > 31? startday - 31 : startday);
                    Integer endday = (Integer.valueof(finaccount.Due_On_Day__c)) + 11;
                    endday = (endday> 31? endday- 31 : endday);
                   
               // if(Integer.valueOf(ChargeDate) > Integer.valueOf(finaccount.Due_On_Day__c) && Integer.valueof(ChargeDate) < ((Integer.valueOf(finaccount.Due_On_Day__c) + 10 > 31) ?((Integer.valueOf(finaccount.Due_On_Day__c) + 10)-30) :Integer.valueOf(finaccount.Due_On_Day__c) + 10 )){ 
                /*if((Integer.valueof(ChargeDate) > startday) &&(Integer.valueof(ChargeDate) < endday)){
                    // Defect 114491 fixes by AMS team: Changes the error message
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                    flag = 1;
                    /*changes include for defect # 112553*/
                   // errorColorWD = 'Red';
                    /* commented to address changes for defect#114464 */
                    //finaccount.Due_On_Day__c = chargeDate;
               // }
                   if(Integer.valueof(chargeDate) >= startday && startday > EndDay){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                        flag = 1;
                        errorColorWD = 'Red';
                    }
                    else if (Integer.valueof(chargeDate) >= startday && Integer.valueof(chargeDate) < EndDay){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                        flag = 1;
                        errorColorWD = 'Red';
                    } 
                    else if (Integer.valueof(chargeDate) < EndDay && startday > EndDay){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                        flag = 1;
                        errorColorWD = 'Red';
                    }    
               }
            // As per Kamesh removing Charged off flag check
            //if(finaccount.Fl_Charged_Off__c == true /* &&  finaccount.ownerid != 'label.nrc'*/){
                system.debug('Fin acc NRC' + finaccount.Region_Code__c);    
                if(finaccount.Region_Code__c == 'NRC'){
                    Integer startday=(Integer.valueof(finaccount.Due_On_Day__c))+1;
                    startday=(startday > 31? startday - 31 : startday);
                    Integer endday = (Integer.valueof(finaccount.Due_On_Day__c)) + 8;
                    endday = (endday> 31? endday- 31 : endday);

                    /*if((Integer.valueof(ChargeDate) > startday) &&(Integer.valueof(ChargeDate) < endday)){ 
                        // Defect 114491 fixes by AMS team: Changes the error message
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday +'.'));
                        flag = 1;
                        /*changes include for defect # 112553*/
                       // errorColorWD = 'Red';
                        /* commented to address changes for defect#114464 */
                        //finaccount.Due_On_Day__c = chargeDate;
                    //}
                    if(Integer.valueof(chargeDate) >= startday && startday > EndDay){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                        flag = 1;
                        errorColorWD = 'Red';
                    }
                    else if (Integer.valueof(chargeDate) >= startday && Integer.valueof(chargeDate) < EndDay){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                        flag = 1;
                        errorColorWD = 'Red';
                    } 
                    else if (Integer.valueof(chargeDate) < EndDay && startday > EndDay){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date selected cannot be between '+startday+' and '+ endday+'.'));
                        flag = 1;
                        errorColorWD = 'Red';
                    }   
                }

                if((chargentid == null || chargentid == '') && RPID == null) {  
                    if(c.Terms_Condtions_Accepted__c == false ){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'To continue, read the following, scroll to the bottom and agree to the Terms & Conditions.')); 
                        errorcolorTC = 'Red';
                        flag = 1;
                    }

                }    

            }

            if(flag != 1) {    

                editMode = false;
                reviewMode = true;

                if(bankAccntName != 'None') {
                    reviewBankName  = bankAccountsMap.get(bankAccntName).Payment_Source_Nickname__c;
                    last4Num = bankAccountsMap.get(bankAccntName).last_4__c;
                    // Defect:114271 -- Adding last4 Digits of Bank Account Number
                    
                    
                }
            }  
            if(chargeDate != 'None') 
            reviewDate = Integer.valueOf(chargeDate)+getDayOfMonthSuffix(Integer.valueOf(chargeDate)) + ' ' +'of the month' ;
            return null;    

            } Catch ( Exception e ){
                logException.Debug('Page','MakeAPaymentLandingPage',e);
                return null;
            }    
        }


        public void displaypopupRP() {
            displaypopupRP = true;
        }

        public void hidepopupRP() {
            displaypopupRP = false;
        }

        public void popupdeleteRP(){
            displaypopupDelete = true;
        }

        public void hidedeleteRP() {
            displaypopupDelete = false;
        }

        public void displaypopupOverview() {
            displayOverview = true;
        }

        public void hidepopupOverview() {
            displayOverview = false;
        }


        public void deleteRP() {

            try { 
                cinsertNew = new ChargentOrders__ChargentOrder__c();
                cinsertNew.ChargentOrders__Payment_Status__c = 'Complete';
                cinsertNew.Payment_Display_Status__c = 'Cancelled';
                //Below line change added to the defect 114165 by Jayashree
                cinsertNew.Duplicate_Key_Tracker__c =  finID + 'Recurring_Payment' + 'INACTIVE' + dateTime.now();
                cinsertNew.id = corders[0].id;
                update cinsertNew;
                cOrderListRP = [select ChargentOrders__Payment_Status__c,Payment_Display_Status__c,ChargentOrders__Charge_Amount__c,Payment_Source_Nickname__r.Payment_Source_Nickname__c from ChargentOrders__ChargentOrder__c where id =:corders[0].id and recordtypeid =:orderRTMap.get('Recurring_Payment').Id];
                displaypopupDelete = false;
                displaymodeRP = true;
                suspendedStatus = false;
                scheduledEasypayAmt = 0;
                scheduledNextWithdrawalDate =null;
                RPID = null;
                fetchdatarp();
            } Catch ( Exception e ){
                logException.Debug('Page','MakeAPaymentLandingPage',e);
            }
        }

        public pageReference editexistRP(){
            system.debug(' editexistRP ==> ');
            editMode = true;
            reviewMode = false;
            displaymodeRP = true;
            return null;
        }

        public pageReference editRP(){
            editMode = true;
            reviewMode = false;
            return null;
        }

        
        public pageReference submitRP(){
                
                    
            StarttimeOfMethodrp = system.currentTimeMillis(); //DEFECT 114048 BY OMKAR 
            Savepoint sp = Database.setSavepoint(); //DEFECT 114048 BY OMKAR 
            
            // For Defect 114026        
            editMode = false;       
            reviewMode = false;     
            successMode = False;
            
            try {
                
                if(chargentID == OTPID || chargentID == payoffID){
                    chargentId = null;
                } 

                commpref = [select EasyPay_Communications_via_Email__c,Payment_Confirmations_via_Email__c,EasyPay_Communications_via_Text__c,Email_Address__c,Text_Number__c from Communication_Preferences__c where Finance_Account_Number__r.id =:finAccount.id];
                        
                //Jayashree Added this as per the discussion with sankalan
                if(this.c.Next_Withdrawal_Date__c == null || NextTransactionDate == null) {
                    if(ChargeDate != null) {
                        today = System.today();
                        Integer WithdrawPaymentOn;
                        Date WithdrawPaymentDate;
                        if(ChargeDate != 'None') {
                            //WithdrawPaymentOn = Integer.valueOf(ChargeDate);
                            c.ChargentOrders__Charge_Date__c = ChargeDate;
                            //WithdrawPaymentDate = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                        }
                        
                        
                 //Defect#114464 - use NWDManager method calculateNWD(ChargentOrders__ChargentOrder__c easypay, Date newStartDate, Boolean skipFirstMonth) 
                 //Logic to calculate Next Withdrawal Date is updated as per RSS-42897 on 30/April/2018
                 // c.Next_Withdrawal_Date__c= NWDManager.calculateNWD(c, Date.today(), false);
                  
                    If (finaccount.first_due_date__c != null)
                    {
                    If (finaccount.first_due_date__c.addDays(-21) > Date.Today())
                    {
                        c.Next_Withdrawal_Date__c = NWDManager.calculateNWD(c,finaccount.first_due_date__c.addDays(-21), false);
                    }
                    else
                    {
                        c.Next_Withdrawal_Date__c = NWDManager.calculateNWD(c, Date.today(), false);
                    }
                }
                else
                {
                    c.Next_Withdrawal_Date__c = NWDManager.calculateNWD(c, Date.today(), false);
                }
                       
                        NextTransactionDate = c.Next_Withdrawal_Date__c;
                    
                        /* // commented as part of Defect#114464 changes to use NWDManager for NWD calculation.
                        if(WithdrawPaymentDate < System.today()){
                            c.Next_Withdrawal_Date__c = Date.newInstance(System.today().year(), System.today().month()+1,WithdrawPaymentOn);
                            NextTransactionDate = Date.newInstance(System.today().year(), System.today().month()+1,WithdrawPaymentOn);
                        }
                        if(WithdrawPaymentDate >= System.today()){
                            c.Next_Withdrawal_Date__c  = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                            NextTransactionDate = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                        }
                        //system.debug('InCheckdatevalue');
                        //cut-off time 
                        
                        Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();

                        if(NextTransactionDate == System.today() && (System.now().time() < hfc.CutOff_Time__c.time())){
                            NextTransactionDate = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                            c.Next_Withdrawal_Date__c = Date.newInstance(System.today().year(), System.today().month(),WithdrawPaymentOn);
                        }
                        
                        if(NextTransactionDate == System.today() && (System.now().time() > hfc.CutOff_Time__c.time())){
                            NextTransactionDate = Date.newInstance(System.today().year(), System.today().addMonths(1).month(),WithdrawPaymentOn);
                            c.Next_Withdrawal_Date__c = Date.newInstance(System.today().year(), System.today().addMonths(1).month(),WithdrawPaymentOn);
                        }
                        */ //End of change for Defect#114464
                    } 
                }  
                    //End of NWD

                /*String[] myDateOnly = chargeDate.split(' ');
                String[] strDate = myDateOnly[0].split('/');
                Integer myIntDate = integer.valueOf(strDate[1]);
                Integer myIntMonth = integer.valueOf(strDate[0]);
                Integer myIntYear = integer.valueOf(strDate[2]);*/
                
                system.debug('In Submit RP ' + chargentId);
                                
                if(chargentId == null || chargentId == '') {
                    cinsertNew = new ChargentOrders__ChargentOrder__c();
                    cinsertNew.Payment_Source_Nickname__c = BankaccntName;
                    cinsertNew.ChargentOrders__Charge_Amount__c = Decimal.valueOf(RPAmount);
                    cinsertNew.ChargentOrders__Charge_Date__c = chargeDate;
                    system.debug('In SubmitRP, Charge date ' + chargeDate);
                    cinsertNew.Next_Withdrawal_Date__c = this.c.Next_Withdrawal_Date__c;
                    //cinsertNew.Next_Withdrawal_Date__c = NextWithdrawDate;                    
                    cinsertNew.ChargentOrders__Manual_Charge__c = true;
                    cinsertNew.ChargentOrders__Payment_Method__c = 'check';
                    cinsertNew.ChargentOrders__Payment_Status__c = 'Recurring';
                    cinsertNew.Payment_Display_Status__c = 'Pending';
                    cinsertNew.ChargentOrders__Payment_Stop__c = 'Date';
                    cinsertNew.ChargentOrders__Payment_Frequency__c ='Monthly';
                     if ( PaymentsUtils.isBeforeCutOffTime() ) {
                        cinsertNew.ChargentOrders__Payment_Start_Date__c = system.today();
                    } else {
                        cinsertNew.ChargentOrders__Payment_Start_Date__c = system.today().AddDays(1);
                    } 
                    cinsertNew.ChargentOrders__Payment_End_Date__c = finAccount.Final_Due_Date__c;
                    cinsertNew.Payment_Type__c = 'R';
                    cinsertNew.Payment_Channel__c = 'R';
                    cinsertNew.ChargentOrders__Gateway__c = System.Label.GatewayId;
                    cinsertNew.ChargentOrders__Tokenization__c = bankAccountsMap.get(BankaccntName).ChargentOrders_Tokenization__c;
                    cinsertNew.Finance_Account_Number__c = finAccount.ID;
                    if(orderRTMap.containsKey('Recurring_Payment')){
                        cinsertNew.recordtypeid = orderRTMap.get('Recurring_Payment').Id;
                    }
                    //Changes added to the defect 114165 by Jayashree
                    cinsertNew.Duplicate_Key_Tracker__c =  finID + 'Recurring_Payment' + 'ACTIVE';
                    //End of defect 114165 
                    insert cinsertNew;
                    cinsertNew = [select Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id=:cinsertNew.id];
                    confirmationRP = cinsertNew.Confirmation_Number__c;
                    disableRPbtn = 'true'; 
                    
                } else { 

                    cinsertNew.id = chargentId;
                    cinsertNew.ChargentOrders__Charge_Amount__c = Decimal.valueOf(RPAmount);
                    cinsertNew.ChargentOrders__Charge_Date__c = chargeDate;
                    cinsertNew.Payment_Source_Nickname__c = BankaccntName;                   
                    cinsertNew.Next_Withdrawal_Date__c = NextTransactionDate;
                    //cinsertNew.Next_Withdrawal_Date__c = NextWithdrawDate;
                    update cinsertNew; 
                    cinsertNew = [select Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id=:cinsertNew.id];
                    confirmationRP = cinsertNew.Confirmation_Number__c;
                }
                    
                // DEFECT 114048 BY OMKAR - ROLLBACK FUNCTION              
                EndtimeOfMethodrp = system.currentTimeMillis();
                if((EndtimeOfMethodrp - StarttimeOfMethodrp) > ActualRedirectTime) {
                    //Roll back
                    Database.rollback(sp);
                    //Redirect to error page
                    PageReference errorPage = new PageReference('/apex/PGCommunityErrorPage?isHonda='+Honda);
                    errorPage.setRedirect(true);
                    return errorPage;
                } 
                    successMode = True;
                    return null;
                
            } Catch (Exception e){
                             
                system.debug(' 4026 log ==> '+ e);          
                String Stacktrace  = e.getStackTraceString();           
                Integer Linenumber  = e.getLineNumber(); 
                String errorPageUrl = '';           
                UtilityClass.logError('Class : MakeAPaymentLandingPage - Method : submitRP - Line : '+ String.valueOf(Linenumber),Stacktrace,finID,e.getMessage());
                //Changes added to the defect 114165 by Jayashree
                if(e.getMessage().contains('Duplicate_Key_Tracker__c')){
                errorPageUrl = '/apex/MultipleRecurringPaymentErrorPage';
                }else {
                errorPageUrl = '/apex/PGCommunityErrorPage?isHonda='+ Honda;
                }
                //End of defect 114165
                PageReference errorPage = new PageReference(errorPageUrl);
                errorPage.setRedirect(true);
                return errorPage;
            }    
        } 


    // End of RP Functionalities 
    
    
    
    //PF Functionalities 
    
    public List<selectOption> getbankValues() {
        try {
            system.debug('In getBankValues');
            pageDisplayPopup=apexpages.currentpage().getparameters().get('category');
            List<selectOption> options = new List<selectOption>();
            bankAccountsMap = new Map<Id, Payment_Source__c> ([Select Payment_Source_Nickname__c,ChargentOrders_Tokenization__c,id,
                        Preferred_Payment_Source__c,Bank_Name__c,Last_4__c
                         from Payment_Source__c where Finance_Account_Number__r.id = :finaccountPF.id and status__c = 'Active']);
            // Fetched Last_4__c field in Query - Defect: 114271 - Veera
            if(payoffID == null) {
                options = UtilityClass.getBankAccounts(bankAccountsMap);
            }
            else if(pageDisplayPopup=='popup'){
                options = UtilityClass.getBankAccountNames(finaccountPF.id,pageDisplayPopup);
            }
            else {
                options = UtilityClass.getBankAccounts(bankAccountsMap,payoffID);
            }
            return options;
            } Catch ( Exception e ){
                logException.Debug('Page','MakeAPaymentLandingPage',e);
                return null;
            }
        }



        public void displaypopup() {
            displaypopup = true;
        }

        public void hidepopup(){
            displaypopup = false;
        }

        public void popupdeletePF(){
            displaypopupdeletePF = true;
        }

        public void hidedeletePF() {
            displaypopupdeletePF = false;
        }


        public PageReference deletePF() {
            try{
                ChargentOrders__ChargentOrder__c cinsertNewPayOff = new ChargentOrders__ChargentOrder__c();
                cinsertNewPayOff.ChargentOrders__Payment_Status__c = 'Stopped';
                cinsertNewPayOff.Payment_Display_Status__c = 'Cancelled';
                //Below line Change added to the defect 114165 by Jayashree
                cinsertNewPayOff.Duplicate_Key_Tracker__c = finID + 'Payoff_Payment' + 'INACTIVE' + dateTime.now();
                cinsertNewPayOff.id = cOrderListPFExist[0].id;
                update cinsertNewPayOff;
                displaypopupdeletePF = false;
                PageReference p;
                p = new Pagereference(System.Label.System_CL0020+finID+System.Label.System_CL0024);
                p.setredirect(true);
                return p;
                } Catch ( Exception e ){
                    logException.Debug('Page','MakeAPaymentLandingPage',e);
                    return null;
                }     

            }

            public Pagereference reviewDetails(){
                try{
         //   typecheck = 3;  // Changed Value from 1 to 3 as per B2C portal Requirement
         // Added this null check for defect # 114026
         if(BankAccntNamePF == 'None' || String.isBlank(BankAccntNamePF)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Create Bank Account to proceed further.'));
            flag = 1;  
            errorColorBA = 'Red';
         }

         if(BankAccntNamePF == 'Select One' || BankAccntNamePF == 'Add New') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Bank Account to proceed further.'));
            flag = 1;
            errorColorBA = 'Red';
         }
         
         //Changes added to the Defect 114012 by Jayashree
         Finance_Account__c finaccountPFNegativeRev = new Finance_Account__c();
         finaccountPFNegativeRev = [select id,name,Fl_Recurring_Payment_Eligible_Web__c,Payoff_Amount__c,Fl_Payoff_Payment_Eligible_Web__c,account_type__c from Finance_Account__c where Finance_Account_Number__c = :FinId];
         payoffAmount = finaccountPFNegativeRev.Payoff_Amount__c;
         if(finaccountPFNegativeRev.Payoff_Amount__c == NULL || finaccountPFNegativeRev.Payoff_Amount__c <= 0){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payoff Amount must be greater than $0.00.'));
         flag = 1;
         
         }
         //End of Defect #114012
 
         
         System.Debug(' reviewBankNamePF  ==> '+ reviewBankNamePF );


         if(flag != 1) {
            editModePF = false;
            reviewModePF = true;
                //System.debug('Inside ReviewDetails Method'+bankAccountsMap);
                
                if(BankAccntNamePF != 'None') {
                    if(bankAccountsMap.containsKey(BankAccntNamePF)){
                        reviewBankNamePF = bankAccountsMap.get(BankAccntNamePF).Payment_Source_Nickname__c+'(XXXX-'+bankAccountsMap.get(BankAccntNamePF).last_4__c+')';
                        // Defect:114271 -- Adding last4 Digits of Bank Account Number
                    }  
                }
                System.Debug(' reviewBankNamePF  ==> '+ bankAccountsMap.get(BankAccntNamePF).Payment_Source_Nickname__c );

            }  
            
            return null;    
            } Catch ( Exception e ){
                logException.Debug('Page','MakeAPaymentLandingPage',e);
                return null;
            }

        }

        
        public pageReference editPayOff(){
            editModePF = true;
            reviewModePF = false;
            system.debug('editModePF '+ editModePF + ' reviewModePF  ' + reviewModePF);
            return null;
        }

        
        public pageReference editexistPF(){

            editModePF = true;
            reviewModePF = false;
            existingPFFlag = false;
            //Reg failed for 141093
            List<ChargentOrders__ChargentOrder__c> pendingPayoff = [Select id from ChargentOrders__ChargentOrder__c 
                                                                        where Finance_Account_Number__r.id = :finaccountOTP.Id 
                                                                            and (Payment_Display_Status__c='Pending' or Payment_Display_Status__c='Processing') 
                                                                            and (RecordType.DeveloperName = 'Payoff_Payment') limit 1];
        
            if ( pendingPayoff!=null && !pendingPayoff.isEmpty() ) {
                  chargentId = pendingPayoff[0].Id;
            } else {
                chargentId = null;
            }
            return null;
        }
        

        public pageReference showdrawerPF() {
            displaypopupdrawer = true;
        //system.debug(displaypopupdrawer);
        return null;
        }
    
        public pageReference hidepopupdrawPF1() {
            displaypopupdrawer = false;
            //   if(ApexPages.CurrentPage().getParameters().get('type') == null)
            //   typecheck = Initialtypecheck;
            return null;
        }

 
    public pageReference hidepopupdrawPF2() {
        displaypopupdrawer = false;
        //if(ApexPages.CurrentPage().getParameters().get('typecheck') == null)
        //typecheck = Initialtypecheck;
        fetchdata();
        return null;
    }
    
    
    public pageReference cancelReviewPayOff(){
        cancelReview = true;
        return null;
    }
    
    public pageReference submitPayOff(){
        StarttimeOfMethodrp = system.currentTimeMillis(); //DEFECT 114048 BY OMKAR 
        Savepoint sp = Database.setSavepoint(); //DEFECT 114048 BY OMKAR 
        
        /*List<ChargentOrders__ChargentOrder__c> pendingPayoff = [Select id from ChargentOrders__ChargentOrder__c 
                                                                        where Finance_Account_Number__r.id = :finaccountOTP.Id 
                                                                            and (Payment_Display_Status__c='Pending' or Payment_Display_Status__c='Processing') 
                                                                            and (RecordType.DeveloperName = 'Payoff_Payment') limit 1];
        
        if ( pendingPayoff!=null && !pendingPayoff.isEmpty() ) {
            chargentId = pendingPayoff[0].Id;
        } else {
            chargentId = null;
        } */
        
        // For Defect 114026
        editModePF = false;
        reviewModePF = false;
        successModePF = false; 
        try {
               
                if(chargentID == RPID || chargentID == OTPID){
                    chargentId = null;
                }
            commpref = [select EasyPay_Communications_via_Email__c,EasyPay_Communications_via_Text__c,Email_Address__c,Text_Number__c,Payment_Confirmations_via_Email__c,Payment_Confirmations_via_Text__c from Communication_Preferences__c where Finance_Account_Number__r.id =:finAccountPF.id];

            system.debug('in submit payoff ' + bankAccountsMap);

            if(chargentId == null || chargentId == '') {
                String[] myDateOnly = paymentStartDate.split(' ');
                String[] strDate = myDateOnly[0].split('/');
                Integer myIntDate = integer.valueOf(strDate[2]);
                Integer myIntMonth = integer.valueOf(strDate[1]);
                Integer myIntYear = integer.valueOf(strDate[0]);
                ChargentOrders__ChargentOrder__c cinsertNewPayOff = new ChargentOrders__ChargentOrder__c();
                cinsertNewPayOff.ChargentOrders__Charge_amount__c = PayoffAmount;
                //The following code generates Today's date in a complicated fashion.  IF Chargent ID = null, means new payoff - for which date can be today.
                //cinsertNewPayOff.ChargentOrders__Payment_Start_Date__c = Date.newInstance(myIntMonth, myIntDate, myIntYear);
                cinsertNewPayOff.ChargentOrders__Payment_Start_Date__c = System.today();
                //Till here
                cinsertNewPayOff.Payment_Source_Nickname__c = BankAccntNamePF;               
                cinsertNewPayOff.ChargentOrders__Manual_Charge__c = true;
                cinsertNewPayOff.ChargentOrders__Payment_Method__c = 'check';
                cinsertNewPayOff.ChargentOrders__Payment_Status__c = 'Recurring';
                cinsertNewPayOff.Payment_Display_Status__c = 'Pending';
                cinsertNewPayOff.ChargentOrders__Payment_Frequency__c = 'Once';
                cinsertNewPayOff.Payment_Type__c = 'P';
                cinsertNewPayOff.Payment_Channel__c = 'W';
                cinsertNewPayOff.Finance_Account_Number__c = finaccountPF.id;
                cinsertNewPayOff.ChargentOrders__Gateway__c = System.Label.GatewayId;
                cinsertNewPayOff.ChargentOrders__Tokenization__c = bankAccountsMap.get(BankAccntNamePF).ChargentOrders_Tokenization__c;
                //System.debug('Record Type Utility'+orderRTMap+gatewayRTMap);
                if(orderRTMap.containsKey('Payoff_Payment')){
                    cinsertNewPayOff.recordtypeid = orderRTMap.get('Payoff_Payment').Id;
                }
                //Changes added to the defect 114165 by Jayashree 
                cinsertNewPayOff.Duplicate_Key_Tracker__c = finID + 'Payoff_Payment' + 'ACTIVE';
                //End of defect 114165
                insert cinsertNewPayOff;
                cinsertNewPayOff = [select Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id=:cinsertNewPayOff.id];
                ConfirmationPF = cinsertNewPayOff.Confirmation_Number__c;
                disablePFbtn = 'true'; 
                                               
            } else {
                ChargentOrders__ChargentOrder__c cUpdate = new ChargentOrders__ChargentOrder__c();
                cUpdate.id = chargentId;
                cUpdate.Payment_Source_Nickname__c = BankAccntNamePF;                
                //Changes added to defect 114031 by Jayashree
                cUpdate.ChargentOrders__Tokenization__c = bankAccountsMap.get(BankAccntNamePF).ChargentOrders_Tokenization__c;
                update cUpdate; 
                cUpdate = [select Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id=:cUpdate.id];
                ConfirmationPF = cUpdate.Confirmation_Number__c;
            } 
            
            // DEFECT 114048 BY OMKAR - ROLLBACK FUNCTION
 
            EndtimeOfMethodrp = system.currentTimeMillis();
            if((EndtimeOfMethodrp - StarttimeOfMethodrp) > ActualRedirectTime) {
                //Roll back
                Database.rollback(sp);
                //Redirect to error page
                PageReference errorPage = new PageReference('/apex/PGCommunityErrorPage?isHonda='+Honda);
                errorPage.setRedirect(true);
                return errorPage;
            }
            successModePF = true;           
            return null;
                            
            } Catch ( Exception e ){
                 
                system.debug(' 4026 log ==> '+ e);      
                String Stacktrace  = e.getStackTraceString();           
                Integer Linenumber  = e.getLineNumber();  
                String errorPageUrl = '';          
                UtilityClass.logError('Class : MakeAPaymentLandingPage - Method : submitPF - Line : '+ String.valueOf(Linenumber),Stacktrace,finID,e.getMessage());
                if(e.getMessage().contains('Duplicate_Key_Tracker__c')){
                errorPageUrl = '/apex/MultiplePayoffPaymentErrorPage';
                }else {
                errorPageUrl = '/apex/PGCommunityErrorPage?isHonda='+ Honda;
                }
                PageReference errorPage = new PageReference(errorPageUrl);
                errorPage.setRedirect(true);
                return errorPage;
                
            }
        } 


    //End of PF  
    
    
    // OTP Functionalities 
    
    public List<selectOption> getbankValuesOTP() {
        try{
            pageDisplay=apexpages.currentpage().getparameters().get('category');
            system.debug('Inside getbankValuesOTP, finid is ' + finid + ' Chargent id is '+chargentID );

            if(finID == null) {
                cOrderRecord = [select Finance_Account_Number__r.Finance_Account_Number__c,ChargentOrders__Charge_Amount__c,recordtype.developername from ChargentOrders__ChargentOrder__c where id = :chargentID];
                finID = cOrderRecord.Finance_Account_Number__r.Finance_Account_Number__c;
            }
            //Added Fl_Paid_Ahead__c for 114282
            finaccountOTP = [select id,Fl_OneTime_Payment_Eligible_Web__c,name,Finance_Account_Number__c,Fl_Bankrupt__c,Remaining_Amount_Due__c,Payoff_Amount__c,Account_Type__c,ownerid,Maturity_Date__c,Fl_Cancel_One_Time_Payments__c,Current_Amount_Due__c,Past_Amount_Due__c,Paid_to_Date__c,Total_Fees_Due__c,Total_Amount_Due__c,Scheduled_EasyPay_Amount__c,Next_Due_Date__c,Payment_Due_Date__c,Principal_Balance_Amount__c,Fl_Future_OneTime_Payment_Eligible_Web__c,Fl_Refinanced__c,Region_Code__c,Fl_Paid_Ahead__c from Finance_Account__c where Finance_Account_Number__c = :FinId];

            List<selectOption> options = new List<selectOption>();
            bankAccountsMap = new Map<Id, Payment_Source__c> ([Select Payment_Source_Nickname__c,Last_4__c,id,ChargentOrders_Tokenization__c,Preferred_Payment_Source__c,Bank_Name__c from Payment_Source__c where Finance_Account_Number__r.id = :finAccountOTP.id and status__c = 'Active']);
            //Fetched Last_4__c field in Query - Defect: 114271 - Veera
            system.debug('Chargent id is '+chargentID + 'OTPid is ' + OTPid);
            if(OTPid == null || OTPid== '') {
                flag = 0;
                options = UtilityClass.getBankAccounts(bankAccountsMap);
                //System.debug('Inside if without chargentID'+options);
            }
            else if(pageDisplay=='popup'){
                options = UtilityClass.getBankAccountNames(finAccountOTP.id,pageDisplay);
            }
            else {
                flag = 0; 
                options = UtilityClass.getBankAccounts(bankAccountsMap,OTPid);
                //System.debug('Inside if with chargentID'+options);
            }
            
            system.debug('End of bank values: Chargent id is '+chargentID + 'OTPid is ' + OTPid);
            return options;
            } Catch ( Exception e ){
                logException.Debug('Page','MakeAPaymentLandingPage',e);
                return null;
            }
        }    






        public void checkStdAmtOTP() {
            system.debug('calling checkStdAmtOTP');
            //Changes added to the defect 114085 by Jayashree
            haswarningStdAmtmsg = false;
            //End of defect 114085
            myDateOnly = PaymentDate.split(' ');
            strDate = myDateOnly[0].split('/'); 
            myIntDate = integer.valueOf(strDate[1]);
            myIntMonth = integer.valueOf(strDate[0]);
            myIntYear = integer.valueOf(strDate[2]);
            Decimal standartAmountBalance = 0.0;
            Boolean errorMsgOTP =false;
            Date paymentDateCheck;
            errorstdColorPD = 'None';

        //standardAmount = Apexpages.currentPage().getParameters().get('stdAmt');

        paymentDateCheck = Date.newInstance(myIntYear,myIntMonth,myIntDate);
        system.debug('Order size ' + cOrdersOTP.size());
        for(ChargentOrders__ChargentOrder__c pdate : cOrdersOTP){
            if((pdate.ChargentOrders__Charge_Amount__c != null && pdate.ChargentOrders__Payment_Start_Date__c != null && pdate.ChargentOrders__Payment_Start_Date__c ==  paymentDateCheck && standardAmount != null && standardAmount !='' ) && (OTPid == null || (OTPid != null && OTPid != pdate.id))){
                standartAmountBalance += pdate.ChargentOrders__Charge_Amount__c;
                errorMsgOTP = true;
            }
        }

        if(standardAmount == null || standardAmount == '') {
         //   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter the Standard Payment Amount'));
         //   flag = 1;
         //   errorstdColorPD = 'Red';
         }else{

            if((standardAmount != null && standardAmount != '') && !Pattern.matches('[0-9]+(\\.[0-9][0-9]?)?',standardAmount)){
           /* moved to reviewdetails otp     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Standard Payment Amount should be numeric'));
                flag = 1;
                errorstdColorPD = 'Red'; */
                }else{
                    standardAmount = String.valueOf(Decimal.valueOf(standardAmount).setScale(2));
                // Business rule 762.01 - Moved to Review details otp
             /*   if(Decimal.valueOf(standardAmount) > finAccountOTP.Payoff_Amount__c){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Amount cannot be greater than payoff amount.'));
                   // flag = 1;
                    errorstdColorPD = 'Red';
                    }else{ */
                    //Changes for 114282 - Starts
                    // Warning message when Standard Amount less than Remaining Amount Due
                    if(standardAmount != null && standardAmount !='' && Decimal.valueOf(standardAmount) < finaccountOTP.Remaining_Amount_Due__c  && !finaccountOTP.Fl_Paid_Ahead__c) {
                        Decimal balance = finaccountOTP.Remaining_Amount_Due__c - Decimal.valueOf(standardAmount);
                       // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'The Standard Payment Amount you entered is $'+balance+' less than your Remaining Amount Due. You must pay the remaining balance before '+finaccountOTP.payment_due_date__c.month() +'/' +finaccountOTP.payment_due_date__c.day()+'/'+finaccountOTP.payment_due_date__c.year()+' to avoid any fees.'));
                        //flag = 1;
                        stdwarnmsg = 'The Standard Payment Amount you entered is $'+balance+' less than your Remaining Amount Due.';
                        //Display additional error for current  accounts.
                        if(finAccountOTP.Past_Amount_Due__c == null || finAccountOTP.Past_Amount_Due__c == 0 || paymentAmountDueEligibility >= finAccountOTP.Remaining_Amount_Due__c){
                        stdwarnmsg += ' You must pay the remaining balance before '+finaccountOTP.payment_due_date__c.month() +'/' +finaccountOTP.payment_due_date__c.day()+'/'+finaccountOTP.payment_due_date__c.year()+' to avoid any fees.';
                        }
                        //Changes for 114282 - Ends
                        errorstdColorPD = 'Green';
                        haswarningStdAmtmsg = true;
                    }
                    
                    // Warning message when Standard Amount greater than Remaining Amount Due
                    if(standardAmount != null && standardAmount !='' && Decimal.valueOf(standardAmount) > finaccountOTP.Remaining_Amount_Due__c ) {
                        Decimal balance = Decimal.valueOf(standardAmount) - finaccountOTP.Remaining_Amount_Due__c;
                       // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'The Standard Payment Amount you entered exceeds the amount due. The additional $'+balance+' will be applied to your finance account.'));
                       //Changes made to the defect 114086 by Jayashree
                       stdwarnmsg = 'The Standard Payment Amount entered exceeds the amount due.'; // Changed the message for the Defect: 114173 -- Veera
                       //End of defect 114086
                        //flag = 1;
                        errorstdColorPD = 'Green';
                        haswarningStdAmtmsg = true;
                    }
               // }
           }    
       }
   }

   public void checkPrincipalOTP() {
    system.debug('Calling checkPrincipalOTP');
    //Changes added to the defect 114085 by Jayashree
    haswarningPrnAmtmsg = false;
    //End of Defect 114085
    myDateOnly = PaymentDate.split(' ');
    strDate = myDateOnly[0].split('/'); 
    myIntDate = integer.valueOf(strDate[1]);
    myIntMonth = integer.valueOf(strDate[0]);
    myIntYear = integer.valueOf(strDate[2]);
    Decimal standartAmountBalance = 0.0;
    Boolean errorMsgOTP =false;
    Date paymentDateCheck;

    paymentDateCheck = Date.newInstance(myIntYear,myIntMonth,myIntDate);

    system.debug('PrincipalAmount in check principal is ' + PrincipalAmount);

    Decimal principalAmountBalance = 0;
    Boolean errorMsgPrincipal = false;

    if(isPrincipalEdited == 'true'){
        errorColorPrincipalPD = 'Clicked';
        }else{
            errorColorPrincipalPD = 'None';
        }    

        for(ChargentOrders__ChargentOrder__c pdate : cOrdersPrincipal ){
            if((pdate.ChargentOrders__Charge_Amount__c != null && pdate.ChargentOrders__Payment_Start_Date__c != null && pdate.ChargentOrders__Payment_Start_Date__c ==  paymentDateCheck && PrincipalAmount != null && PrincipalAmount != '') && (OTPid == null || (OTPid != null && OTPid != pdate.id))){
                principalAmountBalance += pdate.ChargentOrders__Charge_Amount__c;
                errorMsgPrincipal = true;
            }
        }

        if(PrincipalAmount != null && PrincipalAmount != '' && !Pattern.matches('[0-9]+(\\.[0-9][0-9]?)?',PrincipalAmount)){
             /* moved to reviewdetailsOTP   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Principal Payment Amount should be numeric'));
                flag = 1;
                errorColorPrincipalPD='Red'; */
                }else{
                    if(PrincipalAmount != null && PrincipalAmount != '')
                    PrincipalAmount = String.valueOf(Decimal.valueOf(PrincipalAmount).setScale(2));
            // Error message for edit scenario from pending payments
            //Commented below warning message as a part of 114086 by Jayashree
           /* if(PrincipalAmount != null && PrincipalAmount != '' && (Decimal.valueOf(PrincipalAmount) > 0.0)){
                system.debug('Principal payment is ' + Decimal.valueOf(PrincipalAmount) + ' and ' + (Decimal.valueOf(PrincipalAmount) > 0.0) );
               // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'The $'+ PrincipalAmount +' Principal Payment Amount will only be applied to your principal balance. This is in addition to your standard monthly payment.'));
                //flag = 1;
                prnwarnmsg = 'The $'+ PrincipalAmount +' Principal Payment Amount will only be applied to your principal balance. This is in addition to your standard monthly payment.';
                errorColorPrincipalPD = 'Green';
                haswarningPrnAmtmsg = true;
            } */
            //End of defect 114086
            system.debug('In check principal, fin acc balance is ' + finaccountOTP.Principal_Balance_Amount__c + 'OTPid is '+ OTPid);

            // Informational message for Principal One Time Payment scheduled in the same date 
            //Commented redundant message as a part of 114086 by Jayashree
           /* if(errorMsgPrincipal == true ) {
               // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You already have a Principal Payment of $'+principalAmountBalance+' scheduled for '+Paymentdate+'. You may edit your scheduled payment on the Pending Payments page.'));
                //flag = 1;
                prnwarnmsg = 'You already have a Principal Payment of $'+principalAmountBalance+' scheduled for '+Paymentdate+'. You may edit your scheduled payment on the Pending Payments page.';
                errorColorPrincipalPD = 'Green';
                haswarningPrnAmtmsg = true;
            } */
            // End of defect 114086
        }
    }

    public void checkDatevalueOTP() {
        try{

            system.debug('Calling checkDatevalueOTP');
            
            //Changes added to the defect 114085 by Jayashree
            haswarningPaydatemsg = false;
            //End of defect 114085

            if(isPrincipalEdited == 'true'){
                errorColorPrincipalPD = 'Clicked';
                }else{
                    errorColorPrincipalPD = 'None';
                }


                if(PaymentDate ==null || PaymentDate==''){
             //   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select a payment date.'));
             //   flag = 1;
             //   errorColorPD='Red';
             }else{

               // paymentDate = Apexpages.currentPage().getParameters().get('stdDate');
               if(!Pattern.matches('(0?[1-9]|1[0-2])/(0?[1-9]|[12][0-9]|3[01])/((19|20)[0-9][0-9])', PaymentDate)){
                /* moved to reviewdetailsOTP    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment date should be in MM/DD/YYYY format'));
                    flag = 1;
                    errorColorPD='Red'; */
                    }else{
                        myDateOnly = PaymentDate.split(' ');
                        strDate = myDateOnly[0].split('/'); 
                        myIntDate = integer.valueOf(strDate[1]);
                        myIntMonth = integer.valueOf(strDate[0]);
                        myIntYear = integer.valueOf(strDate[2]);
                        Decimal standartAmountBalance = 0;
                        Decimal principalAmountBalance = 0;
                        Boolean errorMsgOTP = false;
                        Boolean errorMsgPrincipal = false;
                        Boolean errorFlag = false;
                        Date paymentDateCheck;

                        Date today = System.today();
                        String dateString = today.format();
                        String[] todayDate = dateString.split(System.Label.System_CL0002);
                        Date todayPastCheck = Date.newInstance(integer.valueOf(todayDate[2]),integer.valueOf(todayDate[0]),integer.valueOf(todayDate[1]));


                        errorColorPD = 'None';

                        String DueDate = '';
                        if ( finaccountOTP.payment_due_date__c <> NULL ){
                            DueDate  = finaccountOTP.payment_due_date__c.month()+'/'+finaccountOTP.payment_due_date__c.day()+'/'+finaccountOTP.payment_due_date__c.year() ;
                        }

                        paymentDateCheck = Date.newInstance(myIntYear,myIntMonth,myIntDate);

                        dateErrormessage = String.valueof(Date.newInstance(myIntYear, myIntMonth, myIntDate)) + ' > ' + String.valueof(finaccountOTP.Payment_Due_Date__c);
                        
                        // Changes added to the defect 114086 by Jayashree
                List<ChargentOrders__ChargentOrder__c> OTPOrders = new List<ChargentOrders__ChargentOrder__c>();
                OTPOrders = [Select id,ChargentOrders__Payment_Start_Date__c,ChargentOrders__Charge_Amount__c,RecordType.DeveloperName from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.id = :finaccountOTP.Id and (Payment_Display_Status__c='Pending' or Payment_Display_Status__c='Processing') and (RecordType.DeveloperName = 'One_Time_Payment' or RecordType.DeveloperName = 'Principal_One_Time_Payment')];
              
                
                        for(ChargentOrders__ChargentOrder__c pdate : OTPOrders){
                            if((pdate.ChargentOrders__Charge_Amount__c != null && pdate.ChargentOrders__Payment_Start_Date__c != null && pdate.ChargentOrders__Payment_Start_Date__c ==  paymentDateCheck && standardAmount != null && standardAmount !='' ) && (OTPid == null || (OTPid != null && OTPid != pdate.id))){
                                standartAmountBalance += pdate.ChargentOrders__Charge_Amount__c;
                                errorMsgOTP = true;
                            }
                        }

                        for(ChargentOrders__ChargentOrder__c pdate : OTPOrders){
                            if((pdate.ChargentOrders__Charge_Amount__c != null && pdate.ChargentOrders__Payment_Start_Date__c != null && pdate.ChargentOrders__Payment_Start_Date__c ==  paymentDateCheck && PrincipalAmount != null && PrincipalAmount != '') && (OTPid == null || (OTPid != null && OTPid != pdate.id))){
                                principalAmountBalance += pdate.ChargentOrders__Charge_Amount__c;
                                errorMsgPrincipal = true;
                            }
                        }
                        
                         //End Of defect 114086 

                    // Date can't be a date in past
                /* Moved to review details otp    if(paymentDate !=null && paymentDate != '' && paymentDateCheck < todayPastCheck) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be a date in the past.'));            
                        errorColorPD = 'Red';
                        errorFlag = true;
                    } 

                    else if(finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c == false && (Date.newInstance(myIntYear, myIntMonth, myIntDate)) > finaccountOTP.Payment_Due_Date__c  && !(Date.newInstance(myIntYear, myIntMonth, myIntDate).isSameday(Date.today()))/*&& finaccount.Region_Code__c != 'NRC'*/ /*){
                        system.debug('web Eligibility is false' + Date.newInstance(myIntYear, myIntMonth, myIntDate) + ' > ' + finaccountOTP.Payment_Due_Date__c);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+finaccountOTP.payment_due_date__c.format()+' . '));
                        errorFlag = true;
                        errorColorPD = 'Red';
                        } */


                    // Date beyond 6 months with valid error message
                    /*Change on defect# 112628 & 113703 - for restricting future payments beyond 10 days*/        
                  /*  else if(finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c == true && (((Date.newInstance(myIntYear, myIntMonth, myIntDate)) > finaccountOTP.Payment_Due_Date__c.addDays(10)) && ((Date.newInstance(myIntYear, myIntMonth, myIntDate)) > system.today().addmonths(6))) && finaccount.Region_Code__c != 'NRC' && !isPastdueEE){
                        system.debug('Future one time is true, Date greater than 6 months  - RemainingAmtDue ' + RemainingAmtDue + ' paymentAmountDueEligibility ' + paymentAmountDueEligibility + ' isPastdueEE ' +isPastdueEE);
                        if((RemainingAmtDue > paymentAmountDueEligibility)){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+(finaccountOTP.payment_due_date__c.addDays(10)).format()+' .'));
                            errorFlag = true;
                            errorColorPD = 'Red';
                        }else{
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+(system.today().addmonths(6)).format()+' .'));
                            errorFlag = true;
                            errorColorPD = 'Red';   
                        }
                        } */
                    // Date within 6 months error scenario
                    /*Change on defect# 112628 and added changes (else if for past due EE) for 113703 */
                  //  else 
                  if(finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c == true && (((Date.newInstance(myIntYear, myIntMonth, myIntDate)) > finaccountOTP.Payment_Due_Date__c.addDays(10)) && ((Date.newInstance(myIntYear, myIntMonth, myIntDate)) <= system.today().addmonths(6))) && finaccount.Region_Code__c != 'NRC' && !isPastdueEE){
                    system.debug('Future one time is true, Date within 6 months  - RemainingAmtDue ' + RemainingAmtDue + ' paymentAmountDueEligibility ' + paymentAmountDueEligibility + ' isPastdueEE ' +isPastdueEE);
                    if((finaccountOTP.Remaining_Amount_Due__c > paymentAmountDueEligibility)){
                        /*    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond  '+finaccountOTP.payment_due_date__c.addDays(10).format()+' .'));
                            errorColorPD = 'Red';
                            errorFlag = true; */
                            }else{
                          //  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You are scheduling a payment beyond your Payment Due Date of '+finaccountOTP.payment_due_date__c.month() +'/' +finaccountOTP.payment_due_date__c.day()+'/'+finaccountOTP.payment_due_date__c.year()+'. Please be aware that you may incur additional fees and/ or interest during this period.'));
                            //    errorFlag = true;
                            paydatewarnmsg ='You are scheduling a payment beyond your Payment Due Date of '+finaccountOTP.payment_due_date__c.month() +'/' +finaccountOTP.payment_due_date__c.day()+'/'+finaccountOTP.payment_due_date__c.year()+'. Please be aware that you may incur additional fees and/ or interest during this period.';
                            errorColorPD = 'Green';
                            haswarningPaydatemsg = true;
                        }    
                    }
                    system.debug('Is past due ee ' + isPastdueEE + ' and owner is ' + finaccount.Region_Code__c);
                    // Error message for pastdue EE account
                    /* if(isPastdueEE && finaccount.Region_Code__c != 'NRC'){
                        if(finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c == true && (Date.newInstance(myIntYear, myIntMonth, myIntDate) > finaccountOTP.Payment_Due_Date__c) && ((Date.newInstance(myIntYear, myIntMonth, myIntDate) > finaccountOTP.Payment_Due_Date__c.addDays(10)) && finaccount.Region_Code__c != 'NRC')){
                            system.debug('Future one time is true, PastDueEE  - RemainingAmtDue ' + RemainingAmtDue + ' paymentAmountDueEligibility ' + paymentAmountDueEligibility + ' isPastdueEE ' +isPastdueEE);
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+(finaccountOTP.payment_due_date__c.addDays(10)).format()+' .'));
                            errorFlag = true;
                            errorColorPD = 'Red';
                        }
                        }   */


                    // NRC Accounts
                    /*
                     if(finaccount.Region_Code__c == 'NRC' && finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c == true && pastDueStatus && finAccountOTP.payment_due_date__c.daysBetween(finAccountOTP.Paid_to_Date__c) > 11 ){
                        system.debug('NRC account and future web is true, payment date is greater than 10 days and pastDueStatus ' + pastDueStatus);
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+finaccountOTP.payment_due_date__c.format()+' . '));
                                errorFlag = true;
                                errorColorPD = 'Red';
                     
                     }
                     else if(finaccount.Region_Code__c == 'NRC' && finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c == true && pastDueStatus && finAccountOTP.payment_due_date__c.daysBetween(finAccountOTP.Paid_to_Date__c) <= 10){
                        system.debug('NRC account and future web is true, paymentdate is less than 10 days and pastDueStatus ' + pastDueStatus);
                         if(((Date.newInstance(myIntYear, myIntMonth, myIntDate) > finaccountOTP.Payment_Due_Date__c.addDays(10)))){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+(finaccountOTP.payment_due_date__c.addDays(10)).format()+' .'));
                                    errorFlag = true;
                                    errorColorPD = 'Red';
                         }
                         
                     
                         } */
                         
                    // For less than 10 days, show warning message
                    if(finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c == true && (Date.newInstance(myIntYear, myIntMonth, myIntDate) > finaccountOTP.Payment_Due_Date__c) && ((Date.newInstance(myIntYear, myIntMonth, myIntDate) < finaccountOTP.Payment_Due_Date__c.addDays(11)) && finaccount.Region_Code__c != 'NRC' && !isPastdueEE)){
                       // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You are scheduling a payment beyond your Payment Due Date of '+ finaccountOTP.payment_due_date__c.month() +'/' +finaccountOTP.payment_due_date__c.day()+'/'+finaccountOTP.payment_due_date__c.year()+'. Please be aware that you may incur additional fees and/or interest during this period.'));
                       paydatewarnmsg = 'You are scheduling a payment beyond your Payment Due Date of '+ finaccountOTP.payment_due_date__c.month() +'/' +finaccountOTP.payment_due_date__c.day()+'/'+finaccountOTP.payment_due_date__c.year()+'. Please be aware that you may incur additional fees and/or interest during this period.'; 
                       errorColorPD = 'Green';
                       flag = 1;
                       haswarningPaydatemsg = true;
                   }

                    // Payment Date can't be beyond maturity date - Added logic as per 113583
                    /*   if(paymentDateCheck > finaccountOTP.Maturity_Date__c) {
                        system.debug('Account type is ' +finaccount.Account_Type__c + ' finaccount.Fl_Refinanced__c ' + finaccount.Fl_Refinanced__c +' finaccount.Region_Code__c ' + finaccount.Region_Code__c + 'date check ' + paymentDateCheck.isSameDay(System.today()));
                        if((finaccount.Account_Type__c == 'Retail' || (finaccount.Account_Type__c == 'Balloon' && finaccount.Fl_Refinanced__c == true)) && !paymentDateCheck.isSameDay(System.today()) && finaccount.Region_Code__c != 'NRC'){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond Maturity Date.'));
                            errorColorPD = 'Red';
                            errorFlag = true;
                        }
                        } */

                    // Informational message when customer tries to submit One Time Payment scheduled beyond payment due date
                   /* if(finaccount.payment_due_date__c != null && (RemainingAmtDue == null || RemainingAmtDue == 0)){
                        if(finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c == true && paymentDateCheck > finaccountOTP.payment_due_date__c && errorFlag == false && finaccount.Region_Code__c != 'NRC')
                        system.debug('Future one time is true date > payment_due_date__c - RemainingAmtDue ' + RemainingAmtDue + ' paymentAmountDueEligibility ' + paymentAmountDueEligibility + ' isPastdueEE ' +isPastdueEE);
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You are scheduling a payment beyond your Payment Due Date of '+ finaccountOTP.payment_due_date__c.month() +'/' +finaccountOTP.payment_due_date__c.day()+'/'+finaccountOTP.payment_due_date__c.year()+'. Please be aware that you may incur additional fees and/or interest during this period.'));
                            flag = 1;
                            errorColorPD = 'Green';
                        }   
                        } */


                    // Information Messages
                    // Informational message for standard One Time Payment Scheduled in the same date
                    
                     
                     //Changes made to the defect 114086 by Jayashree -- 
                     
                    if((errorMsgOTP || errorMsgPrincipal)  && !errorFlag) {
                    // Changed the error message for the defect: 114173 -- Veera
                    paydatewarnmsg = 'You already have one or more payment(s) scheduled for this account. You may review your scheduled payment(s) on the Pending Payments page.';
                    errorColorPD = 'Green';
                    haswarningPaydatemsg = true;
                        }

                    // Informational message for Principal One Time Payment scheduled in the same date 
                    //Commented as a part of 114086 by Jayashree
                   /* if(errorMsgPrincipal == true && errorFlag == false) {
                        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You already have a Principal Payment of $'+principalAmountBalance+' scheduled for '+Paymentdate+'. You may edit your scheduled payment on the Pending Payments page.'));
                        //flag = 1;
                        paydatewarnmsg ='You already have a Principal Payment of $'+principalAmountBalance+' scheduled for '+Paymentdate+'. You may edit your scheduled payment on the Pending Payments page.';
                        errorColorPD = 'Green';
                        haswarningPaydatemsg = true;
                    } */
                    //End of defect 114086
                }    
            }
            } Catch ( Exception e ){
                logException.Debug('Page','MakeAPaymentLandingPage',e);
            }
        }    

        public Pagereference ReviewDetailsOTP(){
            try{ 
                system.debug('ChargentID is ' + chargentId);
                if(chargentID == RPID || chargentID == payoffID){
                    chargentId = null;
                    system.debug('Cleared Chargentid ' + chargentID);
                }
                Boolean errorFlag = false;
                Boolean errorMsgOTP = false;
                Decimal standartAmountBalance = 0;
                Boolean errorMsgPrincipal = false;
                Decimal principalAmountBalance = 0;
                Date paymentDateCheck ;
                errorColorPD = 'None';
                Boolean pastAccStatus = false;
                //Below Initialization added to the defect 114051 
                paymentAmountDueEligibility = 0;
                //End of 114051
                
                if(isPrincipalEdited=='true'){
                    errorColorPrincipalPD ='clicked';
                }            

                notclickedContinueOTP = false;
                haswarningStdAmtmsg = false;
                haswarningPrnAmtmsg = false;
                haswarningPaydatemsg = false;
                
                // Changes added to the defect 114051 by Jayashree
                cOrdersOTP = new List<ChargentOrders__ChargentOrder__c>();
                
                cOrdersOTP = [Select id,ChargentOrders__Payment_Start_Date__c,ChargentOrders__Charge_Amount__c,RecordType.DeveloperName from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.id = :finaccountOTP.Id and (Payment_Display_Status__c='Pending' or Payment_Display_Status__c='Processing') and RecordType.DeveloperName = 'One_Time_Payment'];
                if(!cOrdersOTP.isEmpty()) {
                for(ChargentOrders__ChargentOrder__c orderIteration : cOrdersOTP){
                            paymentAmountDueEligibility += orderIteration.ChargentOrders__Charge_Amount__c;
                }   
                
                }
                
                //End Of defect 114051 
                
                if(finAccountOTP.Past_Amount_Due__c == null || finAccountOTP.Past_Amount_Due__c == 0 || paymentAmountDueEligibility >= finAccountOTP.Remaining_Amount_Due__c){
                            pastAccStatus = false;
                 }else{
                            pastAccStatus = true;
                 }      

                system.debug('Std amount ' + standardAmount + ' Principal amount is ' + principalAmount + ' Is Princial edited ' + isPrincipalEdited);
                if(BankaccntNameOTP == 'Add New') {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select Bank Account to proceed further.'));
                    flag = 1;
                    errorColorBA = 'Red';
                }

                if(standardAmount !='' && standardAmount !=null && !Pattern.matches('[0-9]+(\\.[0-9][0-9]?)?',standardAmount)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Standard Payment Amount should be numeric'));
                    flag = 1;
                    errorstdColorPD = 'Red';
                }

                if(PrincipalAmount != null && PrincipalAmount != '' && !Pattern.matches('[0-9]+(\\.[0-9][0-9]?)?',PrincipalAmount)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Principal Payment Amount should be numeric'));
                    flag = 1;
                    errorColorPrincipalPD='Red';
                }

                if(PaymentDate ==null || PaymentDate==''){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select a payment date.'));
                    flag = 1;
                    errorColorPD='Red';
                    }else if(!Pattern.matches('(0?[1-9]|1[0-2])/(0?[1-9]|[12][0-9]|3[01])/((19|20)[0-9][0-9])', PaymentDate)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment date should be in MM/DD/YYYY format'));
                        flag = 1;
                        errorColorPD='Red';
                    }


                    if(flag != 1) {

                        if(paymentDate != null && paymentDate != ''){
                            String[] myDateOnly = PaymentDate.split(' ');
                            String[] strDate = myDateOnly[0].split(System.Label.System_CL0002);
                            paymentDateCheck = Date.newInstance(integer.valueOf(strDate[2]),integer.valueOf(strDate[0]),integer.valueOf(strDate[1]));
                        }


                        Date today = System.today();
                        String dateString = today.format();
                        String[] todayDate = dateString.split(System.Label.System_CL0002);
                        Date todayPastCheck = Date.newInstance(integer.valueOf(todayDate[2]),integer.valueOf(todayDate[0]),integer.valueOf(todayDate[1]));

                /*Defect 114107 added by Jayashree */
                Integer noDaysPaidToDate = findDaysBetweenDate(finaccountOTP.Paid_to_Date__c, Date.today()); 
                if(paymentDateCheck != null){

                    for(ChargentOrders__ChargentOrder__c pdate : cOrdersOTP){
                        if((pdate.ChargentOrders__Charge_Amount__c != null && pdate.ChargentOrders__Payment_Start_Date__c != null && pdate.ChargentOrders__Payment_Start_Date__c ==  paymentDateCheck && standardAmount != null && standardAmount !='' ) && (OTPid == null || (OTPid != null && OTPid != pdate.id))){
                            standartAmountBalance += pdate.ChargentOrders__Charge_Amount__c;
                            errorMsgOTP = true;
                        }
                    }

                    for(ChargentOrders__ChargentOrder__c pdate : cOrdersPrincipal ){
                        if((pdate.ChargentOrders__Charge_Amount__c != null && pdate.ChargentOrders__Payment_Start_Date__c != null && pdate.ChargentOrders__Payment_Start_Date__c ==  paymentDateCheck && PrincipalAmount != null && PrincipalAmount != '') && (OTPid == null || (OTPid != null && OTPid != pdate.id))){
                            principalAmountBalance += pdate.ChargentOrders__Charge_Amount__c;
                            errorMsgPrincipal = true;
                        }
                    }


                    // Date can't be a date in past
                    if(paymentDateCheck < todayPastCheck && !String.isBlank(PaymentDate) ) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be a date in the past.'));            
                        flag = 1;
                        errorColorPD = 'Red';
                        errorFlag = true;
                      }else{
                      
                         if(finaccountOTP.Region_Code__c != 'NRC' && paymentDateCheck > finaccountOTP.Maturity_Date__c && !finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c && paymentDateCheck > System.today() && paymentDateCheck != System.today()){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+System.today().format()+'.'));
                                flag = 1;
                                errorColorPD = 'Red';
                                errorFlag = true;
                          } 
                         
                          else if (finaccountOTP.Region_Code__c != 'NRC' && !pastAccStatus && paymentDateCheck > finaccountOTP.payment_due_date__c.addDays(10) && Date.today() < finaccountOTP.Maturity_Date__c && finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c && finaccountOTP.Remaining_Amount_Due__c > paymentAmountDueEligibility) {
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+(finaccountOTP.payment_due_date__c.addDays(10)).format()+'.'));
                                    errorFlag = true;
                                    errorColorPD = 'Red';
                                    flag = 1;
                          }  
                          
                           else if (finaccountOTP.Region_Code__c != 'NRC' && pastAccStatus && Date.today() < finaccountOTP.Maturity_Date__c && (finaccountOTP.Paid_to_Date__c < System.today() && noDaysPaidToDate <= 10) && paymentDateCheck > finaccountOTP.Paid_to_Date__c.addDays(10) && finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c  && finaccountOTP.Remaining_Amount_Due__c > paymentAmountDueEligibility) { 
                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond  '+finaccountOTP.Paid_to_Date__c.addDays(10).format()+'.'));
                                   flag = 1;
                                  errorColorPD = 'Red';
                                  errorFlag = true;
                           }
                           
                           else if (pastAccStatus && (finaccountOTP.Paid_to_Date__c < System.today() && noDaysPaidToDate >= 11 && noDaysPaidToDate <= 59) && paymentDateCheck != System.today() && paymentDateCheck > System.today()) {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+System.today().format()+'.'));
                                flag = 1;
                                errorColorPD = 'Red';
                                errorFlag = true;
                           }
                           
                           else if(finaccountOTP.Fl_Bankrupt__c && !finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c && paymentDateCheck > System.today() && paymentDateCheck != System.today()){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+System.today().format()+'.'));
                                flag = 1;
                                errorColorPD = 'Red';
                                errorFlag = true;
                            } 
                            
                            else if(!finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c && paymentDateCheck > System.today() && paymentDateCheck != System.today()){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+System.today().format()+'.'));
                                flag = 1;
                                errorColorPD = 'Red';
                                errorFlag = true;
                            } 
                            
                            else if (finaccountOTP.Region_Code__c == 'NRC' && !pastAccStatus && PaymentDateCheck > finaccountOTP.payment_due_date__c.addDays(10)){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+(finaccountOTP.payment_due_date__c.addDays(10)).format()+'.'));
                                errorFlag = true;
                                errorColorPD = 'Red';
                                flag = 1;
                            }  
                            
                            else if (finaccountOTP.Region_Code__c == 'NRC' && pastAccStatus && (finaccountOTP.Paid_to_Date__c < System.today() && noDaysPaidToDate <= 10) && paymentDateCheck > finaccountOTP.Paid_to_Date__c.addDays(10)){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond  '+finaccountOTP.Paid_to_Date__c.adddays(10).format()+'.'));
                                errorFlag = true;
                                errorColorPD = 'Red';
                                flag = 1;
                            }  
                            
                            else if(finaccountOTP.Region_Code__c == 'NRC' && (finaccountOTP.Paid_to_Date__c < System.today() && noDaysPaidToDate > 10) && paymentDateCheck > System.today() && paymentDateCheck != System.today() && !finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+System.today().format()+'.'));
                                flag = 1;
                                errorColorPD = 'Red';
                                errorFlag = true;
                            } 
                            
                            
                          
                            else if (finaccountOTP.Region_Code__c != 'NRC' && System.today() < finaccountOTP.Maturity_Date__c && paymentDateCheck > finaccountOTP.Maturity_Date__c ) {
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond Maturity Date.'));
                                 flag = 1;
                                 errorColorPD = 'Red';
                                 errorFlag = true;
                            }
                                                     
                            else if (finaccountOTP.Region_Code__c != 'NRC' && !pastAccStatus && Date.today() < finaccountOTP.Maturity_Date__c && finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c && (paymentDateCheck > System.today().addDays(182)) && finaccountOTP.Remaining_Amount_Due__c <= paymentAmountDueEligibility) {
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+(System.today().addDays(182)).format()+'.'));
                                    errorFlag = true;
                                    errorColorPD = 'Red';
                                    flag = 1;
                          }  
                          
                           else if (finaccountOTP.Region_Code__c != 'NRC' && pastAccStatus && Date.today() < finaccountOTP.Maturity_Date__c && (finaccountOTP.Paid_to_Date__c < System.today() && noDaysPaidToDate <= 10) && finaccountOTP.Fl_Future_OneTime_Payment_Eligible_Web__c && (paymentDateCheck > System.today().addDays(182)) && finaccountOTP.Remaining_Amount_Due__c <= paymentAmountDueEligibility) { 
                                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment Date cannot be beyond '+(System.today().addDays(182)).format()+'.'));
                                   errorFlag = true;
                                   errorColorPD = 'Red';
                                   flag = 1;
                           }
                          
                       
                         }     
                     }
                     /* End of payment date check 114107 */


                // PrincipalAmount should not be greater than Principal Balance Amount in Finance Account

                // New scenario
                if((PrincipalAmount ==null || PrincipalAmount =='') && finaccountOTP.Principal_Balance_Amount__c!= null && onloadPrincipalAmt != null && finaccountOTP.Principal_Balance_Amount__c > onloadPrincipalAmt)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Amount cannot be greater than principal balance of $'+onloadPrincipalAmt+' .'));
                    flag = 1;
                    errorFlag = true;
                }

                // edit scenario
                if(PrincipalAmount!= null && PrincipalAmount!='' && onloadPrincipalAmt != null && Decimal.valueOf(PrincipalAmount) > onloadPrincipalAmt)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Amount cannot be greater than principal balance of $'+onloadPrincipalAmt+' .'));
                    flag = 1;
                    errorFlag = true;
                }
                
                
                
                // Standard Amount should not be greater than payoff amount
                if(standardAmount != null && standardAmount !='' && Decimal.valueOf(standardAmount) > finaccountOTP.Payoff_Amount__c) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Amount cannot be greater than payoff Amount'));
                    flag = 1;
                    errorFlag = true;
                }
                
                
                // Standard Amount and Principal amount both can't be less than 1
                if(standardAmount != null && standardAmount != '' && (Decimal.valueOf(standardAmount) < Decimal.valueOf(1))) {
                    if((PrincipalAmount != null && PrincipalAmount != '' && Decimal.valueOf(PrincipalAmount) < Decimal.valueOf(1) && isPrincipalEdited == 'true')){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Amount cannot be less than $1'));
                        flag = 1;
                        errorFlag = true;
                        errorstdColorPD ='Red';
                        errorColorPrincipalPD = 'Red';
                        }else if(PrincipalAmount != null && PrincipalAmount != '' && Decimal.valueOf(PrincipalAmount) < Decimal.valueOf(1) && isPrincipalEdited != 'true'){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Amount cannot be less than $1'));
                            flag = 1;
                            errorFlag = true;
                            errorstdColorPD ='Red';
                        }
                    }

                    // Modified the condition to check if principal amount is equal to zero for defect # 114161- (Decimal.valueOf(principalAmount) >= 0)
                    if((standardAmount != null && standardAmount != '' && (Decimal.valueOf(standardAmount) > 0) &&(Decimal.valueOf(standardAmount) < Decimal.valueOf(1))) || (principalAmount != null && principalAmount != '' && (Decimal.valueOf(principalAmount) >= 0) &&(Decimal.valueOf(principalAmount) < Decimal.valueOf(1))))  {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Amount cannot be less than $1 '));
                        flag = 1;
                        errorFlag = true;
                        if(Decimal.valueOf(standardAmount) < Decimal.valueOf(1))
                        errorstdColorPD ='Red';
                        else
                        errorColorPrincipalPD = 'Red';    
                    }   
                    
                    //Added this code as a part of RS41358 Defect fixes
                    if((standardAmount != null && standardAmount != '' && (Decimal.valueOf(standardAmount) == Decimal.valueOf(0))) && (principalAmount == null || principalAmount == '' ))  {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Amount cannot be less than $1'));
                        flag = 1;
                        errorFlag = true;
                        if(Decimal.valueOf(standardAmount) < Decimal.valueOf(1))
                        errorstdColorPD ='Red';
                        else
                        errorColorPrincipalPD = 'Red';    
                    }                       
                 
                // Standard Amount can't be null when the remaining amount due is greater than 0 on create scenario
                if(OTPid == null){
                    if((standardAmount == null || standardAmount == '') && (principalAmount == null || principalAmount =='') /* && finaccountOTP.Remaining_Amount_Due__c > 0 */) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter a Standard or a Principal Payment Amount'));
                        flag = 1;
                        errorFlag = true; 
                        errorstdColorPD ='Red';
                    }
                }
                
                // Only occurs on edit scenario for One time payments and principal amount payment
                if(OTPid != null){
                    if((standardAmount == null || standardAmount == '') && cOrderRecord.recordtype.developername == 'One_Time_Payment' ){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter a Standard Payment Amount'));
                        flag = 1;
                        errorFlag = true;
                        errorstdColorPD ='Red';
                    }
                    if((PrincipalAmount == null || PrincipalAmount == '')&& cOrderRecord.recordtype.developername == 'Principal_One_Time_Payment'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter a Principal Payment Amount'));
                        flag = 1;
                        errorFlag = true;
                        errorColorPrincipalPD = 'Red';
                    }
                }
                
                
                // Bank Account can't be null
                 // Added this null check for defect # 114026
                if(BankAccntNameOTP == 'None' || String.isBlank(BankAccntNameOTP)) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Create Bank Account to proceed further.'));
                    flag = 1;  
                    errorFlag = true;
                }
                
                if(BankAccntNameOTP == 'Select One') {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Bank Account to proceed further.'));
                    flag = 1;
                    errorFlag = true;
                }
                
                String DueDate = '';
                if ( finaccountOTP.payment_due_date__c <> NULL ){
                    DueDate  = finaccountOTP.payment_due_date__c.month()+'/'+finaccountOTP.payment_due_date__c.day()+'/'+finaccountOTP.payment_due_date__c.year() ;
                }
            }
            system.debug(flag);
            if(flag != 1) {
            //Below Changes to the defect 114188 by Jayashree
                if(displayContinuePopup == true) {
                    displayConfirmationOTP = true;
                    return null;
                }
            //End of defect 114188
                editModeOTP = false;
                reviewModeOTP = true;

                if(BankaccntNameOTP != 'None') {
                    if(bankAccountsMap.containsKey(BankaccntNameOTP)){
                        ReviewBanknameOTP = bankAccountsMap.get(BankaccntNameOTP).Payment_Source_Nickname__c;
                        last4Num = bankAccountsMap.get(BankaccntNameOTP).last_4__c;
                        // Defect:114271 -- Adding last4 Digits of Bank Account Number
                    }  
                }
                standardAmount = String.valueOf(Decimal.valueOf(standardAmount).setScale(2));
                if(!String.isBlank(PrincipalAmount))
                PrincipalAmount = String.valueOf(Decimal.valueOf(PrincipalAmount).setScale(2));
            } 
            
            return null;    
            } Catch ( Exception e ){
                logException.Debug('Page','MakeAPaymentLandingPage',e);
                return null;
            }   
        }
        
        // FIND THE DIFFERENCE DAYS BETWEEN TWO DATES added to defect 114107 by Jayashree
    public Integer findDaysBetweenDate(Date startDate, Date endDate) {
    
        Integer numberDaysDue = startDate != null && endDate != null ? startDate.daysBetween(endDate) : 0; 
        Decimal numberDaysDuee = numberDaysDue != null ? Decimal.valueof(numberDaysDue).abs() : 0;
        return Integer.valueof(numberDaysDuee);         
    }  
    
    //End of defect 114107
    
        public void displaypopupOTP() {
            displaypopupotp = true;
        }

        public void hidepopupOTP() {
            displaypopupotp = false;
        } 
        
        //Below Changes added to the defect 114188 by Jayashree
        public pageReference reviewdetailsOTPNavigation() {
            try {
                    displayConfirmationOTP = false;
                    editModeOTP = false;
                    reviewModeOTP = true;

                if(BankaccntNameOTP != 'None') {
                    if(bankAccountsMap.containsKey(BankaccntNameOTP)){
                        ReviewBanknameOTP = bankAccountsMap.get(BankaccntNameOTP).Payment_Source_Nickname__c;
                        last4Num = bankAccountsMap.get(BankaccntNameOTP).last_4__c;
                        // Defect:114271 -- Adding last4 Digits of Bank Account Number
                    }  
                }
                standardAmount = String.valueOf(Decimal.valueOf(standardAmount).setScale(2));
                if(!String.isBlank(PrincipalAmount))
                PrincipalAmount = String.valueOf(Decimal.valueOf(PrincipalAmount).setScale(2));
            
            
            return null;    
            } Catch ( Exception e ){
                logException.Debug('Page','MakeAPaymentLandingPage',e);
                return null;
            }   
            
        }
        
        public void hideConfirmationOTP() {
            displayConfirmationOTP = false;
        } 
        //End of defect 114188

        public pageReference editOTP(){
            editModeOTP = true;            
            reviewModeOTP = false;
            return null;
        }

        public pageReference submitOTP(){
            
            StarttimeOfMethodrp = system.currentTimeMillis(); //DEFECT 114048 BY OMKAR 
            Savepoint sp = Database.setSavepoint(); //DEFECT 114048 BY OMKAR 
                
            // For Defect 114026
            editModeOTP = false;
            reviewModeOTP = false;
            successModeOTP = false;     
            try{

                system.debug('ChargentID is ' + chargentId);
                if(chargentID == RPID || chargentID == payoffID){
                    chargentId = null;
                    system.debug('Cleared Chargentid ' + chargentID);
                }
                system.debug('In Submit OTP : ' + StandardAmount + ' P: ' + principalAmount  );
                commpref = [select EasyPay_Communications_via_Email__c,EasyPay_Communications_via_Text__c,Email_Address__c,Text_Number__c,Payment_Confirmations_via_Email__c,Payment_Confirmations_via_Text__c from Communication_Preferences__c where Finance_Account_Number__r.id =:finAccountotp.id];

                if((standardAmount != '' && StandardAmount != null && Decimal.valueOf(standardAmount) > Decimal.valueOf(0)) && (PrincipalAmount != '' && PrincipalAmount != null && Decimal.valueOf(PrincipalAmount) > Decimal.valueOf(0) && isPrincipalEdited =='true')){
                    totalPaymentAmount = Decimal.valueOf(StandardAmount) + Decimal.valueOf(PrincipalAmount);
                    }else if(standardAmount != '' && StandardAmount != null && Decimal.valueOf(standardAmount) > Decimal.valueOf(0)){
                        totalPaymentAmount = Decimal.valueOf(StandardAmount);
                        }else if(PrincipalAmount != '' && PrincipalAmount != null && Decimal.valueOf(PrincipalAmount) > Decimal.valueOf(0) && isPrincipalEdited =='true'){
                            totalPaymentAmount = Decimal.valueOf(PrincipalAmount);
                        }

                        String[] myDateOnly = PaymentDate.split(' ');
                        String[] strDate = myDateOnly[0].split('/');
                        Integer myIntDate = integer.valueOf(strDate[1]);
                        Integer myIntMonth = integer.valueOf(strDate[0]);
                        Integer myIntYear = integer.valueOf(strDate[2]);
                        if(chargentId == null || chargentId == '') {

                        
                            ChargentOrders__ChargentOrder__c cinsertNewOTP = new ChargentOrders__ChargentOrder__c();

                            if(orderRTMap.containsKey('One_Time_Payment')){
                                cinsertNewOTP.recordtypeid = orderRTMap.get('One_Time_Payment').Id;
                            }
                            //Changes for RSS-41333 Starts
                            List< ChargentOrders__ChargentOrder__c> paymentList=new List<ChargentOrders__ChargentOrder__c>();
                            //changes for RSS-41333 Ends
                            if(standardAmount != '' && standardAmount!= null && Decimal.valueOf(standardAmount) > Decimal.valueOf(0)) {
                                cinsertNewOTP.ChargentOrders__Charge_Amount__c = Decimal.valueOf(StandardAmount);
                                cinsertNewOTP.ChargentOrders__Payment_Start_Date__c= Date.newInstance(myIntYear, myIntMonth, myIntDate);
                                cinsertNewOTP.Payment_Source_Nickname__c = BankaccntNameotp;                                     
                                cinsertNewOTP.ChargentOrders__Manual_Charge__c = true;                                
                                cinsertNewOTP.ChargentOrders__Payment_Method__c = 'check';
                                cinsertNewOTP.ChargentOrders__Payment_Status__c = 'Recurring';
                                cinsertNewOTP.Payment_Display_Status__c = 'Pending';
                                cinsertNewOTP.ChargentOrders__Payment_Frequency__c = 'Once';
                                cinsertNewOTP.Payment_Type__c = 'R';
                                cinsertNewOTP.Payment_Channel__c = 'W';
                                cinsertNewOTP.Finance_Account_Number__c = finaccountOTP.id;
                                cinsertNewOTP.ChargentOrders__Gateway__c = System.Label.GatewayId;
                                cinsertNewOTP.ChargentOrders__Tokenization__c = bankAccountsMap.get(BankaccntNameotp).ChargentOrders_Tokenization__c;
                                //Changes for RSS-41334 Starts
                                paymentList .add(cinsertNewOTP);
                               /*insert cinsertNewOTP;                               
                               cinsertNewOTP = [select Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id=:cinsertNewOTP.id];
                               confirmationstd = cinsertNewOTP.Confirmation_Number__c;*/
                               //Changes for RSS-41334 Ends                                
                            }

                            if((principalAmount != '' && principalAmount!= null) && Decimal.valueOf(principalAmount) > Decimal.valueOf(0) && isPrincipalEdited=='true') {
                                TaskHelper.setTriggerAsNotExecuted();
                        // For edit or new principal the variable is different.
                       // decimal tempPrincipal = 0.00;

                        /*if((PrincipalAmount == null || PrincipalAmount =='') && (onloadPrincipalAmt != null && finaccountOTP.Principal_Balance_Amount__c <= onloadPrincipalAmt)){
                            tempPrincipal = finaccountOTP.Principal_Balance_Amount__c;
                        }else{
                            tempPrincipal = Decimal.valueOf(PrincipalAmount);
                            }*/

                            cPrincipal = new ChargentOrders__ChargentOrder__c();
                            if(orderRTMap.containsKey('Principal_One_Time_Payment')){
                                cPrincipal.recordtypeid = orderRTMap.get('Principal_One_Time_Payment').Id;
                                cPrincipal.ChargentOrders__Charge_Amount__c = Decimal.valueof(PrincipalAmount);
                                cPrincipal.ChargentOrders__Payment_Start_Date__c= Date.newInstance(myIntYear, myIntMonth, myIntDate);
                                cPrincipal.Payment_Source_Nickname__c = BankaccntNameotp;                                
                                cPrincipal.ChargentOrders__Manual_Charge__c = true;
                                cPrincipal.ChargentOrders__Payment_Method__c = 'check';
                                cPrincipal.ChargentOrders__Payment_Status__c = 'Recurring';
                                cPrincipal.Payment_Display_Status__c = 'Pending';
                                cPrincipal.ChargentOrders__Payment_Frequency__c = 'Once';
                                cPrincipal.Payment_Type__c = 'O';
                                cPrincipal.Payment_Channel__c = 'W';
                                cPrincipal.Finance_Account_Number__c = finaccountOTP.id;
                                cPrincipal.ChargentOrders__Tokenization__c = bankAccountsMap.get(BankaccntNameotp).ChargentOrders_Tokenization__c;
                                cPrincipal.Next_Withdrawal_Date__c  =   cPrincipal.ChargentOrders__Payment_Start_Date__c;
                                //Changes for RSS-41334 Starts
                                paymentList.add(cPrincipal);
                                /*insert cPrincipal;
                                cPrincipal = [select Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id=:cPrincipal.id];
                                confirmationprincipal = cPrincipal.Confirmation_Number__c;*/
                                //Changes for RSS-41334 Ends
                            }
                        }
                        //Changes for RSS-41334 Starts
                       if(!paymentList.isEmpty())
                                { 
                                  System.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+paymentList);
                                    insert paymentList; 
                                    for(ChargentOrders__ChargentOrder__c paymentRec:paymentList)
                                    {
                                        paymentRec=[Select Confirmation_Number__c,recordtypeid from ChargentOrders__ChargentOrder__c where id=:paymentRec.id];
                                        if(paymentRec.recordtypeid==orderRTMap.get('One_Time_Payment').Id)
                                            confirmationstd=paymentRec.Confirmation_Number__c;
                                        else
                      confirmationprincipal=paymentRec.Confirmation_Number__c;                                            
                                    }
                                   
                                }

                       //Changes for RSS-41334 Ends
                        disableOTPbtn = 'true';
                    }
                    else 
                    {
                        system.debug('In Submit OTP ' + cOrderRecord.recordtype.developername + ' Principal amount ' + PrincipalAmount);
                        ChargentOrders__ChargentOrder__c cOrderUpdate = new ChargentOrders__ChargentOrder__c();
                        cOrderUpdate.id = chargentId;
                        cOrderUpdate.ChargentOrders__Charge_Amount__c = cOrderRecord.recordtype.developername == 'One_Time_Payment' ? Decimal.valueOf(StandardAmount) : Decimal.valueOf(PrincipalAmount) ;
                        cOrderUpdate.ChargentOrders__Payment_Start_Date__c = Date.newInstance(myIntYear, myIntMonth, myIntDate);
                        cOrderUpdate.Payment_Source_Nickname__c = BankaccntNameotp;                       
                        //Changes added to the defect 114031 by Jayashree
                        cOrderUpdate.ChargentOrders__Tokenization__c = bankAccountsMap.get(BankaccntNameotp).ChargentOrders_Tokenization__c;
                        update cOrderUpdate; 
                        if(cOrderRecord.recordtype.developername == 'One_Time_Payment'){
                            ChargentOrders__ChargentOrder__c order = [select Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id=:cOrderUpdate.id];
                            confirmationstd = order.Confirmation_Number__c;
                        }
                        if(cOrderRecord.recordtype.developername == 'Principal_One_Time_Payment'){
                            ChargentOrders__ChargentOrder__c order = [select Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id=:cOrderUpdate.id];
                            confirmationprincipal = order.Confirmation_Number__c;
                        }

                    }
                    // DEFECT 114048 BY OMKAR - ROLLBACK FUNCTION                   
                    EndtimeOfMethodrp = system.currentTimeMillis();
                    if((EndtimeOfMethodrp - StarttimeOfMethodrp) > ActualRedirectTime) {
                        //Roll back
                        Database.rollback(sp);
                        //Redirect to error page
                        PageReference errorPage = new PageReference('/apex/PGCommunityErrorPage?isHonda='+Honda);
                        errorPage.setRedirect(true);
                        return errorPage;
                    }
                    successModeOTP = true;
                    return null;   
                    } Catch ( Exception e ){
                        
                        system.debug(' 4026 log ==> '+ e);      
                        String Stacktrace  = e.getStackTraceString();           
                        Integer Linenumber  = e.getLineNumber();            
                        UtilityClass.logError('Class : MakeAPaymentLandingPage - Method : submitOTP - Line : '+ String.valueOf(Linenumber),Stacktrace,finID,e.getMessage());
                        String errorPageUrl = '/apex/PGCommunityErrorPage?isHonda='+ Honda;
                        PageReference errorPage = new PageReference(errorPageUrl);
                        errorPage.setRedirect(true);
                        return errorPage;                    
                        }
                }


        //End of OTP 
        public pageReference checkPayment(){
            try{
                String paymentValue = Apexpages.currentPage().getParameters().get('paymentValue');
            /*   if(String.isBlank(paymentValue ) || String.isEmpty(paymentValue))
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Payment Amount is required'));
            else
            ApexPages.getMessages().clear();*/
            return null;
            } Catch ( Exception e ){
                logException.Debug('Page','MakeAPaymentLandingPage',e);
                return null;
            }
        }
        
        public pagereference redirectToHFS()
        {
            ApexPages.pageReference pageref;
            pageref = Page.BankAccounts;

            if(mobile==false)
            {
                System.debug('$$$ In redirectToHFS(): ');
                //mobile = false;
                System.debug('$$$ In mobile ELSE Block : ' + mobile);
                if(Honda == true)
                pageref = new pageReference(Label.AccountOverviewURL);
                else 
                pageref = new pageReference(Label.Accura_Account_Overview_URL);
                pageref.setRedirect(true);
            }
            return pageref;
        }
        
        public void checkDevice()
        {
            System.debug('$$$ Before  User-Agent: ');
            Map<String, String> headerlist = ApexPages.currentPage().getHeaders();
            if(headerList.get('User-Agent').contains('Android') || 
                headerList.get('User-Agent').contains('BlackBerry') ||
                headerList.get('User-Agent').contains('IEMobile') || 
                headerList.get('User-Agent').contains('iPad') ||
                headerList.get('User-Agent').contains('iPhone') || 
                headerList.get('User-Agent').contains('iPod'))
            {
                mobile = true;
                System.debug('$$$ In mobile true block: ' + mobile);
            }
            else
            {
                mobile = false;
                System.debug('$$$ In mobile else block Mobile false: ' + mobile);
            }
        }
        
        public void doNothingMethod()
        {

        }
        
    }