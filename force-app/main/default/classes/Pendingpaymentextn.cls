public class Pendingpaymentextn {
    public ChargentOrders__ChargentOrder__c cor{get;set;}
    public boolean cancelPopupdisplay {get;set;}
    public ChargentOrders__ChargentOrder__c recurringPay{get;set;}
    public List<ChargentOrders__ChargentOrder__c> oneTimePay{get;set;}
    public List<ChargentOrders__ChargentOrder__c> oneTimePayFlagchk{get;set;}
    public Finance_Account__c financeAccount {get; set;}
    public Boolean cutOffFlag{get;set;}
    public boolean csat {get;set;}
    public Boolean pastDueStatus {get;set;}
    public Boolean Honda{get;set;}
    public Map<String,RecordType>  orderRTMap ; 
    public string financeAccountId ;
    /*Changes for Sec Vul at line 146,184*/
    public String fId = ApexPages.CurrentPage().getParameters().get('finnumber');
    //fId = ESAPI.encoder().SFDC_HTMLENCODE(fId);
    public Boolean mobile {get;set;}
    public String isReadonlyParam {get; set;}
    public String cutOffTime {get;set;}
    public Boolean showOneTimePay {get;set;}
    public static Honda_Finance__c hondaCT {get;set;}
    public String PaymentAuthorizedOn {get;set;}              //Added as part of 43711 September release
    
    //USER SECURITY AUTHORZIATION
    Public PageReference init(){
        
         
        if ( Apexpages.currentPage().getParameters().get('finnumber') <> NULL ) {
        /*Changes propsed for Security Vulnerabilities against line 28 -- Gufran Date 4/20/2020*/ 
        //    if ( !UserSecurity.ValidateFinNumber(Apexpages.currentPage().getParameters().get('finnumber')) ) {
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
    
    public boolean getchrRec(){
      //String fId = ApexPages.CurrentPage().getParameters().get('finnumber');
        boolean b = true;
        for(ChargentOrders__ChargentOrder__c cr: [select id, RecordTypeId, RecordType.DeveloperName, Payment_Source_Nickname__c, Payment_Display_Status__c, ChargentOrders__Charge_Amount__c, Finance_Account_Number__r.Finance_Account_Number__c,Finance_Account_Number__r.Fl_Recurring_Payment_Eligible_Web__c  from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Finance_Account_Number__c=:fId AND RecordType.DeveloperName ='Recurring_Payment' and Payment_Display_Status__c != 'Cancelled' and Payment_Display_Status__c != 'Stopped' and Payment_Display_Status__c != 'Complete']){
            b = false;
        }
        
        return b;
    }
    
    public Pendingpaymentextn(ApexPages.StandardController controller) {
        
    }
    
    //DEFECT 114195 BY SARV 25-MAY-2016 STARTS
    Public Void OnLoad () {
        
        try {
        
                mobile = false;
                hondaCT = Honda_Finance__c.getOrgDefaults();
                cutOffTime = hondaCT.CutOff_Time__c.format('h:mm a') ;
               /*Changes propsed for Security Vulnerabilities against line 144,182 -- Gufran Date 4/20/2020*/ 
               String fId = ApexPages.CurrentPage().getParameters().get('finnumber');
               fId  = ESAPI.encoder().SFDC_HTMLENCODE(fId );
               // String fId = ApexPages.CurrentPage().getParameters().get('finnumber');
                String isReadonlyParam = ApexPages.CurrentPage().getParameters().get('isReadOnly');
                orderRTMap = RecordTypeUtility.getOrderRecordTypes();
                oneTimePay = new List<ChargentOrders__ChargentOrder__c>  ();
                
               // For IE9
               Apexpages.currentPage().getHeaders().put('p3p', 'CP="HONDA"');
               
               //Added for CSAT check
                csat = false;
                if (Apexpages.currentPage().getParameters().get('isReadOnly') != null && Apexpages.currentPage().getParameters().get('isReadOnly') != '' && Apexpages.currentPage().getParameters().get('isReadOnly') == 'true') {
                    csat = true;
                    //system.debug('CSAT'+csat );
                }
                
                financeAccount = [SELECT id,Finance_Account_Number__c,Past_Amount_Due__c,Payment_Due_Date__c,Honda_Brand__c,Fl_Recurring_Payment_Eligible_Web__c from Finance_Account__c where Finance_Account_Number__c=:fId Limit 1 ];
                System.debug('financeAccount =====> '+financeAccount.Id);
    
                if(financeAccount.Honda_Brand__c == 'AFS'){
                     Honda = false;
                } else {
                     Honda = true;
                }
                // Defect:114271 -- Adding last4 Digits of Bank Account Number
                // RSS-44869 'Last_Extraction_Date__c' added to query
                List<ChargentOrders__ChargentOrder__c> orderList = [select id, RecordTypeId, RecordType.DeveloperName, Payment_Source_Nickname__r.Name, Payment_Source_Nickname__r.Payment_Source_Nickname__c,Payment_Source_Nickname__r.last_4__c,ChargentOrders__Payment_Start_Date__c , ChargentOrders__Next_Transaction_Date__c,Next_Withdrawal_Date__c, Payment_Display_Status__c, ChargentOrders__Charge_Amount__c, Finance_Account_Number__r.Finance_Account_Number__c, Last_Extraction_Date__c  from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Finance_Account_Number__c=:fId AND RecordType.DeveloperName ='Recurring_Payment' AND Payment_Display_Status__c != 'Cancelled' ORDER BY CreatedDate DESC LIMIT 1];

                if(orderList.size() > 0) {
                    recurringPay = orderList[0];
                }
                // Defect:114271 -- Adding last4 Digits of Bank Account Number
                oneTimePay = [select id, RecordTypeId, RecordType.DeveloperName, Payment_Source_Nickname__r.Payment_Source_Nickname__c,Payment_Source_Nickname__r.last_4__c,last_4__c, Payment_Type__c, Confirmation_Number__c, ChargentOrders__Payment_Start_Date__c, ChargentOrders__Next_Transaction_Date__c, Payment_Display_Status__c, ChargentOrders__Charge_Amount__c, Finance_Account_Number__r.Fl_Payoff_Payment_Eligible_Web__c, Finance_Account_Number__r.Finance_Account_Number__c,Finance_Account_Number__r.Fl_OneTime_Payment_Eligible_Web__c,CreatedDate,PaymentAuthorizedOn__c  from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Finance_Account_Number__c=:fId AND ((RecordType.DeveloperName ='One_Time_Payment' AND Finance_Account_Number__r.Fl_OneTime_Payment_Eligible_Web__c = True) OR (RecordType.DeveloperName ='Payoff_Payment' AND Finance_Account_Number__r.Fl_Payoff_Payment_Eligible_Web__c = True) OR (RecordType.DeveloperName ='Principal_One_Time_Payment' AND Finance_Account_Number__r.Fl_OneTime_Payment_Eligible_Web__c = True)) AND (Payment_Display_Status__c in('Pending') OR Payment_Display_Status__c in('Processing') OR Payment_Display_Status__c in('Researching')) ORDER BY CreatedDate DESC];                
                oneTimePayFlagchk = [select id, RecordTypeId, RecordType.DeveloperName, Payment_Source_Nickname__r.Payment_Source_Nickname__c, Payment_Type__c, Confirmation_Number__c, ChargentOrders__Payment_Start_Date__c, ChargentOrders__Next_Transaction_Date__c, Payment_Display_Status__c, ChargentOrders__Charge_Amount__c, Finance_Account_Number__r.Finance_Account_Number__c, Finance_Account_Number__r.Fl_OneTime_Payment_Eligible_Web__c,Finance_Account_Number__r.Fl_Payoff_Payment_Eligible_Web__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.Finance_Account_Number__c=:fId AND ((RecordType.DeveloperName ='One_Time_Payment' AND Finance_Account_Number__r.Fl_OneTime_Payment_Eligible_Web__c = False) OR (RecordType.DeveloperName ='Payoff_Payment' AND Finance_Account_Number__r.Fl_Payoff_Payment_Eligible_Web__c = FALSE) OR (RecordType.DeveloperName ='Principal_One_Time_Payment' AND Finance_Account_Number__r.Fl_OneTime_Payment_Eligible_Web__c = False)) AND (Payment_Display_Status__c in('Pending') OR Payment_Display_Status__c in('Processing')) ORDER BY CreatedDate DESC];
                 
                 if ( oneTimePay.isEmpty()  ) {
                     showOneTimePay = False ;
                 } else {
                      showOneTimePay = True ;
                 }
                // Date myDate = System.today();           //Added as part of 43711 September release
                 //PaymentAuthorizedOn = myDate.format();  //Added as part of 43711 September release
                 
                 Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();
                 // Converted the datetime to string for including time comparison
                
                  if(System.now().time() < hfc.CutOff_Time__c.time()){
                   system.debug('==Is Cutoff==');
                      cutOffFlag = true;
                      
                  }else{
                      cutOffFlag = false;
                  }   
                    
                 //Past Due Status check 
                if(financeAccount.past_amount_due__c > 0) {
                    List<ChargentOrders__ChargentOrder__c> cOrdersLis = new List<ChargentOrders__ChargentOrder__c>();
                    if(orderRTMap.containsKey('One_Time_Payment')) {
                        cOrdersLis = [select id,ChargentOrders__Charge_Amount__c,ChargentOrders__Payment_Start_Date__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__r.id = :financeAccount.id and recordtypeid = :orderRTMap.get('One_Time_Payment').Id and Payment_Display_Status__c in('Pending')];    
                    }
                    Decimal sumOfPayments = 0.0;
                    if(cOrdersLis.size() > 0) {
                    
                        for(ChargentOrders__ChargentOrder__c c : cOrdersLis ) {
                            if(c.ChargentOrders__Charge_Amount__c != null && c.ChargentOrders__Payment_Start_Date__c < financeAccount.Payment_Due_Date__c )
                            sumOfPayments += c.ChargentOrders__Charge_Amount__c ;
                
                        }
                    }    
                
                        if(sumOfPayments <= financeAccount.Past_Amount_Due__c  ) {
                            pastDueStatus = true; 
                        }
                        
                  
               }   
                           
               
           } Catch  (Exception e) {
               UtilityClass.logErrorResp('Pendingpaymentextn', e.getmessage(), fId , fId, e.getStackTraceString() +'\n' +e.getLineNumber() );
           } 
    }
    //DEFECT 114195 BY SARV 25-MAY-2016 ENDS
    
    public void showPopup() {
    //system.debug('Hi'+cancelPopupdisplay);
        cancelPopupdisplay = true;
    } 
    
    public void hidePopup() {  
    //system.debug('Hello'+cancelPopupdisplay);
        cancelPopupdisplay = false;    
    }
    
    public PageReference CancelPayment() {
    
        String cId = ApexPages.CurrentPage().getParameters().get('cancelpayId');       
        if(cId != null) {
        
            try {
                //Below query change added by Jayashree for defect 114165
                ChargentOrders__ChargentOrder__c  p = [SELECT Id, Payment_Display_Status__c,Duplicate_Key_Tracker__c,Finance_Account_Number__r.Finance_Account_Number__c,Recordtype.developername FROM ChargentOrders__ChargentOrder__c where Id = :cId Limit 1];
                p.Payment_Display_Status__c = 'Cancelled';
                p.ChargentOrders__Payment_Status__c = 'Complete';
                //Below changes added to the defect 114165 by Jayashree 
                if(p.Recordtype.developername == 'Recurring_Payment'){
                 p.Duplicate_Key_Tracker__c = p.Finance_Account_Number__r.Finance_Account_Number__c + 'Recurring_Payment' + 'INACTIVE' + Datetime.now();
                }
                
                if(p.Recordtype.developername == 'Payoff_Payment'){
                 p.Duplicate_Key_Tracker__c = p.Finance_Account_Number__r.Finance_Account_Number__c + 'Payoff_Payment' + 'INACTIVE' + Datetime.now();
                }
                //End of defect 114165
                update p;
                
            } Catch ( Exception e ){
                           
                UtilityClass.logErrorresp('Pendingpaymentextn', e.getmessage(), fId , fId, e.getStackTraceString() +'\n' +e.getLineNumber() );
                //UtilityClass.logError('Class : Pending payment Cancel- Method : submitRP - Line : '+ String.valueOf(Linenumber),Stacktrace,financeAccountId,e.getMessage());
                String errorPageUrl = '/apex/PGCommunityErrorPage?isHonda='+ Honda;
                PageReference errorPage = new PageReference(errorPageUrl);
                errorPage.setRedirect(true);
                return errorPage;
                
            }    
           
        }
        
        PageReference pageRef = new PageReference(System.Label.System_CL0018+fId);
        pageRef.setRedirect(true);
        return pageRef;
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
            pageref = new pageReference('https://staging.redesign.hondafinancialservices.com/MyAccount/');
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