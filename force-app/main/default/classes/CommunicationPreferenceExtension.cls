public  class CommunicationPreferenceExtension {

    //Test Jenkins Deployment from Dev to QA

    public string financeAccountId;
    public Boolean ChangesMade {get;set;}
    public Boolean cancelBtnDisable{get;set;}
    public Communication_Preferences__c cp {
        get;
        set;
    }
    public list < Finance_Account__c > financeAccount;
    public string EmailAddress {
        get;
        set;
    }
    public Boolean paperAndStmt;
    public string Textnumber {
        get;
        set;
    }
    public boolean accOverviewdisplayPopup {
        get;
        set;
    }
    public boolean canceldisplayPopup {
        get;
        set;
    }

    public boolean chkBox {
        get;
        set;
    }
    public Communication_Preferences__c comPrf;
    List < Communication_Preferences__c > cps = new List < Communication_Preferences__c > ();
    public boolean csat {
        get;
        set;
    }
    public boolean Honda {
        get;
        set;
    }

    //Added by 11167678 for SMSNotification   
    public boolean oldPayRemTxt {
        get;
        set;
    }
    public boolean oldPayConfTxt {
        get;
        set;
    }
    public boolean oldEsyComTxt {
        get;
        set;
    }
    
    public Communication_Preferences__c cPref {
    get;
    set;
    }
    public boolean disablePaperStatements {get; set;}
    public String plainTextNumber;
    Public string finNumber ;
    //USER SECURITY AUTHORZIATION
    Public PageReference init(){
                
        if ( Apexpages.currentPage().getParameters().get('finnumber') <> NULL ) {
        /*Changes made for Security Vulnerabilities at line 71 made by gufran on 4/21/2020*/
           // if ( !UserSecurity.ValidateFinNumber(Apexpages.currentPage().getParameters().get('finnumber')) ) {
                  if ( !UserSecurity.ValidateFinNumber(Apexpages.currentPage().getParameters().get('finnumber').escapeHtml4())) {
                 pagereference p = new pagereference('/apex/UserSecurityNotAuthorized');
                  p.setRedirect(true);
                return p;
            } else {
                //DEFECT 114195 BY SARV 25-MAY-2016
                OnLoad ();
            }
        }
        return null;
    }
    
    public CommunicationPreferenceExtension(ApexPages.StandardController controller) {
        cp = (Communication_Preferences__c) controller.getRecord();
      cPref =(Communication_Preferences__c) controller.getRecord();
    }
    
     //DEFECT 114195 BY SARV 25-MAY-2016 STARTS
    Public Void OnLoad () {
        /*Changes made for Security Vulnerabilities at line 192,228,296,323 made by gufran on 4/21/2020 for RSS 49578*/
        //finNumber = ApexPages.CurrentPage().getParameters().get('finnumber').escapeHtml4();
        finNumber = ApexPages.CurrentPage().getParameters().get('finnumber');
        finNumber = ESAPI.encoder().SFDC_HTMLENCODE(finNumber);
            
        try {
            financeAccount = new list < Finance_Account__c > ();
            
            csat = false;
            cancelBtnDisable = false;
            disablePaperStatements = false;
            
            
            
            // For IE9
            Apexpages.currentPage().getHeaders().put('p3p', 'CP="HONDA"');
    
            if (Apexpages.currentPage().getParameters().get('isReadOnly') != null && Apexpages.currentPage().getParameters().get('isReadOnly') != '' && Apexpages.currentPage().getParameters().get('isReadOnly') == 'true') {
                csat = true;
            }
            //For identifying Honda and Acura brands
            
            if (finNumber != '') {
                financeAccount = [SELECT id, Finance_Account_Number__c,Region_Code__c, Honda_Brand__c, Fl_Suppress_All_Notifications__c from Finance_Account__c where Finance_Account_Number__c = : finNumber Limit 1];
                integer comcnt = 0;
                comcnt = [select count() from Communication_Preferences__c where Finance_Account_Number__c = : financeAccount[0].id LIMIT 1];
                
                //Added by Omkar for the defect 114116
                 if(financeAccount != null && financeAccount.size() > 0 && financeAccount[0].Region_Code__c == 'NRC')
                  {                    
                      disablePaperStatements = true;
                  }
                if (financeAccount.size() > 0) {
                        if (financeAccount[0].Honda_Brand__c == 'AFS') {
                            Honda = false;
                        } else {
                            Honda = true;
                        }
                    }
                if (comcnt > 0) {
                
                    comPrf = [SELECT Id, Email_Address__c, Text_Number__c, Days_Prior_Reminder__c, Account_Status_Updates_via_Email__c, Account_Status_Updates_via_Text__c, Payment_Reminders_via_Email__c, Payment_Reminders_via_Text__c, 
                                        Payment_Confirmations_via_Email__c, Payment_Confirmations_via_Text__c, EasyPay_Communications_via_Email__c, 
                                        EasyPay_Communications_via_Text__c, Paperless_Statements_Letters__c, Unsubscribe_from_all__c, 
                                        Finance_Account_Number__c 
                                    FROM Communication_Preferences__c 
                                    WHERE Finance_Account_Number__c = : financeAccount[0].id LIMIT 1];
                    //New DSX Field added to query
                    if (comPrf.id != null) {
                        cp.Id = comPrf.id;
                    }
                    
                    if(comPrf.Email_Address__c != cPref.Email_Address__c || comPrf.Text_Number__c != cPref.Text_Number__c || comPrf.Days_Prior_Reminder__c != cPref.Days_Prior_Reminder__c ||
                    comPrf.Account_Status_Updates_via_Email__c != cPref.Account_Status_Updates_via_Email__c || comPrf.Account_Status_Updates_via_Text__c != cPref.Account_Status_Updates_via_Text__c ||
                    comPrf.Payment_Reminders_via_Email__c != cPref.Payment_Reminders_via_Email__c || comPrf.Payment_Reminders_via_Text__c  != cPref.Payment_Reminders_via_Text__c || comPrf.Payment_Confirmations_via_Email__c != cPref.Payment_Confirmations_via_Email__c || comPrf.Payment_Confirmations_via_Text__c  != cPref.Payment_Confirmations_via_Text__c || comPrf.EasyPay_Communications_via_Email__c != cPref.EasyPay_Communications_via_Email__c || comPrf.EasyPay_Communications_via_Text__c != cPref.EasyPay_Communications_via_Text__c || comPrf.Paperless_Statements_Letters__c != cPref.Paperless_Statements_Letters__c || comPrf.Unsubscribe_from_all__c != cPref.Unsubscribe_from_all__c )
                    changesMade = true;
                    else
                    changesMade = false;
                    //New DSX Field check added 
                    
    
                    // Set finance account number and customer to the comm preference which are required
                    cp.Finance_Account_Number__c = financeAccount[0].id;
                    List < Customer_Finance_Account__c > persons = [Select Id, Customer__c from Customer_Finance_Account__c where Finance_Account__c = : cp.Finance_Account_Number__c LIMIT 1];
                    if (persons != null && persons.size() > 0) {
                        cp.Customer__c = persons[0].Customer__c;
                        
                    }
                    if(comPrf.Email_Address__c != null && comPrf.Email_Address__c != ''){
                        EmailAddress = comPrf.Email_Address__c;
                        cp.Email_Address__c = comPrf.Email_Address__c;
                    }else{
                        EmailAddress = '';
                        cp.Email_Address__c = '';
                    }
                    if(!String.isBlank(comPrf.Text_Number__c))
                    {
                    plainTextNumber= comPrf.Text_Number__c.replace('(','').replace(')','').replace('-','').replace('(','').replace(' ','');
                    }
                    cp.Text_Number__c = String.isBlank(comPrf.Text_Number__c) ? comPrf.Text_Number__c :  plainTextNumber ;
                    cp.Days_Prior_Reminder__c = comPrf.Days_Prior_Reminder__c;
                    cp.Account_Status_Updates_via_Email__c = comPrf.Account_Status_Updates_via_Email__c;
                    cp.Account_Status_Updates_via_Text__c = comPrf.Account_Status_Updates_via_Text__c;
                    cp.Payment_Reminders_via_Email__c = comPrf.Payment_Reminders_via_Email__c;
                    //Modified by 11167678 for SMS Notification
                    oldPayRemTxt = cp.Payment_Reminders_via_Text__c = comPrf.Payment_Reminders_via_Text__c;
                    cp.Payment_Confirmations_via_Email__c = comPrf.Payment_Confirmations_via_Email__c;
                    //Modified by 11167678 for SMS Notification
                    oldPayConfTxt = cp.Payment_Confirmations_via_Text__c = comPrf.Payment_Confirmations_via_Text__c;
                    cp.EasyPay_Communications_via_Email__c = comPrf.EasyPay_Communications_via_Email__c;
                    //Modified by 11167678 for SMS Notification        
                    oldEsyComTxt = cp.EasyPay_Communications_via_Text__c = comPrf.EasyPay_Communications_via_Text__c;
                    paperAndStmt = comPrf.Paperless_Statements_Letters__c;
                    cp.Paperless_Statements_Letters__c = comPrf.Paperless_Statements_Letters__c;
                    
                    cp.Terms_Condtions_Accepted__c = false;
                    cp.Unsubscribe_from_all__c = comPrf.Unsubscribe_from_all__c;
                    system.debug('Hello' + cp.Email_Address__c);
                    setclosePopUp(false);
                }
            }
        
        } Catch  (Exception e) {
            UtilityClass.logErrorResp('CommunicationPreferenceExtension', e.getmessage(), finNumber , finNumber, e.getStackTraceString() +'\n' +e.getLineNumber() );
        } 
    }
    //DEFECT 114195 BY SARV 25-MAY-2016 ENDS
    
    public void save() {
        
        try {
            Boolean successFlag = false;
            //Added by omkar for 114116 defect
            if((paperAndStmt != cp.Paperless_Statements_Letters__c || EmailAddress != cp.Email_Address__c) && financeAccount != null && financeAccount.size() > 0 && financeAccount[0].Region_Code__c != 'NRC')
            {
                System.debug('Service called');
                UpdateEDeliveryPreferenceService edeliveryService = new UpdateEDeliveryPreferenceService();
           /*Changes made for Security Vulnerabilities at line 206 made by gufran on 4/21/2020*/
               successFlag = edeliveryService.updateEDeliveryPreference(cp.Paperless_Statements_Letters__c, cp.Email_Address__c, ApexPages.CurrentPage().getParameters().get('finnumber'));
               //successFlag = ESAPI.encoder().SFDC_HTMLENCODE(successFlag);
               // successFlag = edeliveryService.updateEDeliveryPreference(cp.Paperless_Statements_Letters__c, cp.Email_Address__c, ApexPages.CurrentPage().getParameters().get('finnumber'));
                System.debug('Boolean Flag' + successFlag);
            }
            // Successfully updated in the CASS system, so updating the same in SFDC , Else we are not calling the eDelivery Service so update it in SFDC
            if (disablePaperStatements || successFlag == true || (successFlag == false && (paperAndStmt == cp.Paperless_Statements_Letters__c && EmailAddress == cp.Email_Address__c))) {
                cp.Statements_Letters__c = cp.Paperless_Statements_Letters__c ? 'eDelivery' : 'Paper';
    
                setclosePopUp(true);
                closePopUp = true;
                // default cp record is inserted through Informatica that is not an indication of cp being set by user for the first time. Is_Comm_Pref_Set__c = true indicates 
                // an user activity has set the cp that drives welcome notification
                cp.Is_Comm_Pref_Set__c = true;
                upsert(cp);
                
                
            }
            // Update EDelivery preference is not successfull and showing the error msg , changes not saved.
            else {
           
                /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
                RetryCallout.Retrycallout(cp.Email_Address__c,ApexPages.CurrentPage().getParameters().get('finnumber'),cp.Paperless_Statements_Letters__c,string.valueof(cp.id));
                 /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
                showCancelPopup();
               // ();
            }
        } Catch  (Exception e) {
            UtilityClass.logErrorResp('CommunicationPreferenceExtension', e.getmessage(), finNumber , finNumber, e.getStackTraceString() +'\n' +e.getLineNumber() );
        } 
    }
   
   

    Boolean closePopUp;
    public Boolean getclosePopUp() {
        return closePopUp;
    }

    public void setclosePopUp(Boolean b) {
        closePopUp = b;
    }


    public void hidePopup() {
        setclosePopUp(false);

    }

    public void showpopUpAccOverview() {
        accOverviewdisplayPopup = true;
    }

    public void hidepopUpaccOverview() {
        accOverviewdisplayPopup = false;
    }

    public void showCancelPopup() {
        canceldisplayPopup = true;

    }
    
    Public PageReference ValidateCancelBtn(){
       
        try {
        
            PageReference P;
            
            if(comPrf.Email_Address__c != cPref.Email_Address__c || comPrf.Text_Number__c != cPref.Text_Number__c || comPrf.Days_Prior_Reminder__c != cPref.Days_Prior_Reminder__c ||
            comPrf.Account_Status_Updates_via_Email__c != cPref.Account_Status_Updates_via_Email__c || 
            comPrf.Account_Status_Updates_via_Text__c != cPref.Account_Status_Updates_via_Text__c || 
            comPrf.Payment_Reminders_via_Email__c != cPref.Payment_Reminders_via_Email__c || comPrf.Payment_Reminders_via_Text__c  != cPref.Payment_Reminders_via_Text__c || comPrf.Payment_Confirmations_via_Email__c != cPref.Payment_Confirmations_via_Email__c || comPrf.Payment_Confirmations_via_Text__c  != cPref.Payment_Confirmations_via_Text__c || comPrf.EasyPay_Communications_via_Email__c != cPref.EasyPay_Communications_via_Email__c || comPrf.EasyPay_Communications_via_Text__c != cPref.EasyPay_Communications_via_Text__c || comPrf.Paperless_Statements_Letters__c != cPref.Paperless_Statements_Letters__c || comPrf.Unsubscribe_from_all__c != cPref.Unsubscribe_from_all__c )
            changesMade = true;
            else
            changesMade = false;
            //New DSX Field check added 
            
            system.debug(ChangesMade);
            system.debug(comPrf.Payment_Confirmations_via_Text__c);
            system.debug(cPref.Payment_Confirmations_via_Text__c);
            
            if(changesMade == false){
            if(Honda == true)
            P = new pageReference('https://staging.redesign.hondafinancialservices.com/MyAccount/');
            else
            P = new pageReference('https://staging.redesign.acurafinancialservices.com/MyAccount');
    
            P.setRedirect(true);
            }
            if(changesMade == true){
            accOverviewdisplayPopup = true;
            P = null;
            }
            
            return P;
        } Catch  (Exception e) {
            UtilityClass.logErrorResp('CommunicationPreferenceExtension', e.getmessage(), finNumber , finNumber, e.getStackTraceString() +'\n' +e.getLineNumber() );
        } 
        
        return  null;
    }

    public void hideCancelPopup() {
        canceldisplayPopup = false;
    }
     

    public pagereference accountOverview() {

        Pagereference pageRef = new PageReference(System.Label.System_CL0022); // To show popup when account overview icon is clicked
        return pageRef;
    }

    //added
    public Boolean getHeaderDisplay() {
    
        try {
            // this.cp = (Communication_Preferences__c)controller.getRecord();
            Finance_Account__c financeAccount = [SELECT id, Finance_Account_Number__c,Region_Code__c, Fl_Suppress_All_Notifications__c from Finance_Account__c where Finance_Account_Number__c = : ApexPages.CurrentPage().getParameters().get('finnumber') Limit 1];
            //this.cp.Finance_Account_Number__c= financeAccount.Id;
            return financeAccount.Fl_Suppress_All_Notifications__c;
        
        } Catch  (Exception e) {
            UtilityClass.logErrorResp('CommunicationPreferenceExtension', e.getmessage(), finNumber , finNumber, e.getStackTraceString() +'\n' +e.getLineNumber() );
        } 
        
        return null;
    }

}