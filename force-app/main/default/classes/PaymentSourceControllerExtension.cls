public  class PaymentSourceControllerExtension {

    Private Final Payment_Source__c currentRecord;
    public Boolean mobile {get;set;}
     
    public PageReference cancel() {
        return null;
    }


    public PageReference save() {
        return null;
    }
    
    public String bankAccountType{get;set;}
    public Payment_Source__c ps;
    public String finanaceAccountId;
    public Boolean editMode {
        get;
        private set;
    }
    public Boolean reviewMode {
        get;
        private set;
    }
    public Boolean successMode {
        get;
        private set;
    }
    public Boolean bankNameFlag {
        get;
        private set;
    }
    public String reEnterbankNumber {
        get;
        set;
    }
     public String termsAndConditions{
        get;
        set;
    }
    public string poppup {
        get;
        set;
    }
    public boolean csat {
        get;
        set;
    }
    public Boolean displayPopUp{get;set;}
    public String routingNumberError {get;set;}
    
    Map < String, Boolean > routingNumberMap = new Map < String, boolean > ();
    public boolean Honda {
        get;
        set;
    }
    Public PageReference initialize(){
        pageReference pageRef=null;
        if(currentRecord.Id==Null){ 
            currentRecord.Bank_Account_Type__c='Select One';
        }
         
        if ( Apexpages.currentPage().getParameters().get('financeAccount') <> NULL ) {
           /*Changes for Security Vulnerabilities line 66 by Gufran 4/21/2020*/
           // if ( !UserSecurity.ValidateFinNumber(Apexpages.currentPage().getParameters().get('financeAccount')) ) {
            if ( !UserSecurity.ValidateFinNumber(Apexpages.currentPage().getParameters().get('financeAccount').escapeHtml4())) {
                 pagereference p = new pagereference('/apex/UserSecurityNotAuthorized');
                  p.setRedirect(true);
                return p;
            }
        }
        system.debug('Honda is '+Honda);
        return pageRef;
    }
    public list<Payment_Source__c> lstBank {get;set;}
    public boolean prefered {get;set;}
    public String buttonStyle{get;set;}
    
     
    
    public PaymentSourceControllerExtension(ApexPages.StandardController controller) {
        system.debug('Inside controller');
        currentRecord = (Payment_Source__c)Controller.getRecord();
        mobile = false;
        //Honda = true;
        csat = false;
        editMode = true;
        reviewMode = false;
        poppup = '';
        successMode = false;
        bankNameFlag = false;
        displayPopUp = false;
        prefered = false;
        buttonStyle='primary-btn btn-3';
        ps = new Payment_Source__c();
        finanaceAccountId = '';
           /*Changes for Security Vulnerabilities for line 269, 267,280,283 by Gufran 4/21/2020*/        
        finanaceAccountId = ApexPages.CurrentPage().getParameters().get('financeAccount');
        finanaceAccountId = ESAPI.encoder().SFDC_HTMLENCODE(finanaceAccountId);
        //  finanaceAccountId = ApexPages.CurrentPage().getParameters().get('financeAccount').escapeHtml4();    
        // For IE9
        Apexpages.currentPage().getHeaders().put('p3p', 'CP="HONDA"');
        
        lstBank = new list<Payment_Source__c>();
        if(finanaceAccountId != '')
            lstBank = [select id,Preferred_Payment_Source__c from Payment_Source__c where Finance_Account_Number__r.Finance_Account_Number__c=:finanaceAccountId and Status__c = 'Active']; 
        if(!lstBank.isEmpty()){
            for(Payment_Source__c lb : lstBank){
                if(lb.Preferred_Payment_Source__c==true)
                    prefered = true;
            }
        }
        else{
            prefered = false;
        }
        this.ps = (Payment_Source__c) controller.getRecord();
        this.customerAddresInformation();
        if (Apexpages.currentPage().getParameters().get('isReadOnly') != null && Apexpages.currentPage().getParameters().get('isReadOnly') != '' && Apexpages.currentPage().getParameters().get('isReadOnly') == 'true') {
            csat = true;
            buttonStyle='primary-btn btn-3 inactive-btn';
        }
        
        if (finanaceAccountId != '' && finanaceAccountId != null) {
            Finance_Account__c financeAccount = [SELECT id, name, Honda_Brand__c from Finance_Account__c where Finance_Account_Number__c = : finanaceAccountId Limit 1];
            if (financeAccount.Honda_Brand__c == 'AFS') {
                Honda = false;
            } else {
                Honda = true;
            }
            system.debug('Honda is '+Honda);
            this.ps.Finance_Account_Number__c = financeAccount.Id;
            //this.ps.Customer__c = financeAccount.Customer__c; 
        }
    }

    private void customerAddresInformation() {
        this.ps.Billing_First_Name__c = 'John';
        this.ps.Billing_Last_Name__c = 'Doe';
        this.ps.Billing_Street__c = '1295 Charleston Road';
        //this.ps.Billing_Address_Line_2__c = 'New York';
        this.ps.Billing_City__c = 'Mountain View';
        this.ps.Billing_State__c = 'California';
        this.ps.Billing_Zip__c = '94043';
        this.ps.Billing_Country__c = 'US';
        this.ps.Billing_Email__c = 'null@cybersource.com';
        this.ps.Currency__c = 'U.S. Dollar';
    }
    public Pagereference reviewBankAccounts() {
        String BankNickName = '';
        System.debug('Routing Number Map' + routingNumberMap);
        if (this.ps.Bank_Routing_Number__c != null) {
            if (!routingNumberMap.keySet().contains(this.ps.Bank_Routing_Number__c)) {
                
                validateRoutingNumber();
            } else{
                System.debug('Inside else');
                
                //Added for Defect No.114067 by Shubham Malik
                if (Ps.Bank_Account_Number__c <> null && Ps.Bank_Account_Number__c.Length() < 4 ) {
                    Ps.Bank_Account_Number__c= Ps.Bank_Account_Number__c.leftPad(4).replace(' ', '0'); 
                    reEnterbankNumber = Ps.Bank_Account_Number__c ;
                }
                //End of defect 114067
                /*Requirement added as part of defect # 113125*/
                this.ps.Bank_Account_Type__c = bankAccountType;
                if(this.ps.Payment_Source_Nickname__c==null || this.ps.Payment_Source_Nickname__c==''){
                    //Added for defect #113976
                   //Added by Omkar for 114149 defect below null check condition                                       
                    if(String.isNotBlank(ps.Bank_Name__c) && String.isNotBlank(ps.Bank_Account_Type__c)){                    
                        BankNickName = ps.Bank_Name__c + '-' + ps.Bank_Account_Type__c;
                    }   
                    if(BankNickName.length() > 50){
                        ps.Payment_Source_Nickname__c = BankNickName.subString(0,50);    
                    }    
                    else{ 
                        ps.Payment_Source_Nickname__c = BankNickName;
                    }  
                }
                // 114271 Prakash added 
                this.ps.Last_4__c = this.ps.Bank_Account_Number__c.right(4);


                editMode = false;
                reviewMode = true;
            }
        }
        return null;
    }
    public pageReference editBankAccounts() {
        editMode = true;
        reviewmode = false;
        return null;
    }
    public pageReference submitBankAccounts() {
        String gatewayName = Label.GatewayName;
        this.ps.Last_4__c = this.ps.Bank_Account_Number__c.right(4);
        this.ps.Status__c ='Active';
        if(prefered == false){
            this.ps.Preferred_Payment_Source__c = true;
        }
        System.debug('Printing payment source instance: '+ps);
       
       // CALLING THE 'CREATEPS' METHOD FROM PYMNTTOKENIZATIONSERVICE AS PART OF PHOENIX
       PymtTokenizationService.PTSResult rs = PymtTokenizationService.createPS(ps);
       
        System.debug('Token info'+rs);
        if (!rs.success) {
            editMode = false;
            reviewMode = false;
            successMode = false;
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, rs.msg));
        } else {
            editMode = false;
            reviewMode = false;
            successMode = true;
        }
        return null;
    }
    
    
    public pageReference validateRoutingNumber() {
        routingNumberError = null;
        isValidRouting = 'Yes';
        
        
        if ( this.ps.Bank_Routing_Number__c <> NULL ) {
                
            String BankName = LyonsUtils.getRoutingNumber(this.ps.Bank_Routing_Number__c); 
                
            if ( BankName == 'No banks found!' ) {
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Invalid Routing Number'));
                routingNumberError = 'Invalid';
                isValidRouting = 'No';
                return null;
                
            } else {
                 
                this.ps.Bank_Name__c = bankName; 
                bankNameFlag = true;
                isValidRouting = 'Yes';
                routingNumberMap.put(this.ps.Bank_Routing_Number__c, true);
                ApexPages.getMessages().clear();

            }

        }             
        
         
        pageReference ref = ApexPages.currentPage();
        ref.setRedirect(true);
        return null;
    }
    
    
    Public String isValidRouting {get;set;}
    
        public void displayPopUp() {
        displayPopUp = true;
        }

        public void hidePopUp() {
        displayPopUp = false;
        } 

    public pagereference bankAccounts() {
        string pageNameVal = '';
        if (csat == true) {
            pageNameVal = '/apex/BankAccountsLandingPage?finnumber=' + finanaceAccountId + '&isReadOnly=true';
        } else {
            pageNameVal = '/apex/BankAccountsLandingPage?finnumber=' + finanaceAccountId;
        }
        pagereference bankAccPage = new pagereference(pageNameVal);
        return bankAccPage;
    }

    public pagereference paymentPage() {
        //Modified by paramasivan for the migration
        
    string pageNameVal = '';
    if(csat==true){
    pageNameVal = '/apex/MakeAPaymentLandingPage?finnumber='+finanaceAccountId+'&isReadOnly=true&type=3';
    }
    else{
    pageNameVal = '/apex/MakeAPaymentLandingPage?finnumber='+finanaceAccountId+'&type=3';
    }
    pagereference paymentPageVal=new pagereference(pageNameVal);
    
    
    return paymentPageVal;
        return null;
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
            pageref = new pageReference('https://staging.redesign.hondafinancialservices.com/MyAccount/');
            else 
            pageref = new pageReference('https://staging.redesign.acurafinancialservices.com/MyAccount');
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