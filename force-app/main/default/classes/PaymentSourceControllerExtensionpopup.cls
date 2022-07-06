public  class PaymentSourceControllerExtensionpopup {
    public Payment_Source__c ps{get;set;}
    public String finanaceAccountId ; 
    public Boolean editMode {get; private set;}
    public Boolean reviewMode {get;private set;}
    public Boolean successMode {get;private set;}
    public Boolean bankNameFlag{get;private set;}
    public String reEnterbankNumber{get;set;}
    public boolean csat{get;set;}
    public string categoryname{get;set;}
    public boolean displaypopup_bank{get;set;}
    Map<String,Boolean> routingNumberMap = new Map<String,boolean>();
    public boolean Honda{get;set;}
    
    // For storing Last 4 digit in the UI
    public string tempBankAccNumber {get; set;}
     
    // Added to avoid conflict of flags with MPLP controller
    public Boolean bankEditMode {get; private set;}
    public Boolean bankReviewMode {get;private set;}
    public Boolean bankSuccessMode {get;private set;}
    public String routingNumberError {get;set;}
    public String bankAccountType{get;set;}
    public list<Payment_Source__c> lstBank {get;set;}
    public boolean prefered {get;set;}
    public String preferedBankName{get;set;}
    
    public PaymentSourceControllerExtensionpopup(ApexPages.StandardController controller) {
        categoryname = '';
        displaypopup_bank = false;
        Honda = true;
        csat = false;
        editMode = false;
        reviewMode = false;
        successMode = false;
        prefered = false;
        
        // the above variable conflict with MPLP controller. Therefore setting new variables
        bankeditMode = true;
        bankreviewMode = false;
        banksuccessMode = false;
        
        bankNameFlag = false;
        ps = new Payment_Source__c();
        ps.Bank_Account_Type__c='Select One';
        finanaceAccountId = '';
         /*Changes proposed for Security Vulnerabilities against line 257,260 -- Gufran Date 4/20/2020*/ 
        finanaceAccountId = ApexPages.CurrentPage().getParameters().get('finnumber');
        finanaceAccountId = ESAPI.encoder().SFDC_HTMLENCODE(finanaceAccountId);
       //finanaceAccountId = ApexPages.CurrentPage().getParameters().get('finnumber');
        lstBank = new list<Payment_Source__c>();
        system.debug('*** finanaceAccountId value ==> ' + finanaceAccountId);
        if(String.IsNotBlank(finanaceAccountId))
     //   if(finanaceAccountId != '')
            lstBank = [select id,Preferred_Payment_Source__c,Payment_Source_Nickname__c from Payment_Source__c where Finance_Account_Number__r.Finance_Account_Number__c=:finanaceAccountId and Status__c = 'Active']; 
        if(!lstBank.isEmpty()){
            for(Payment_Source__c lb : lstBank){
                if(lb.Preferred_Payment_Source__c==true){
                    prefered = true;
                    preferedBankName = lb.id;
                }    
            }
        }
        else{
            prefered = false;
        }
        
        //this.ps = (Payment_Source__c)controller.getRecord();
        if(Apexpages.currentPage().getParameters().get('isReadOnly')!=null && Apexpages.currentPage().getParameters().get('isReadOnly')!='' && Apexpages.currentPage().getParameters().get('isReadOnly')=='true'){
            csat = true;
        }
       /*Changes proposed for Security Vulnerabilities against line 245,248 -- Gufran Date 4/20/2020*/ 
       finanaceAccountId = ApexPages.CurrentPage().getParameters().get('finnumber');
        finanaceAccountId = ESAPI.encoder().SFDC_HTMLENCODE(finanaceAccountId);
       //finanaceAccountId = ApexPages.CurrentPage().getParameters().get('finnumber');
        if(finanaceAccountId != '' && finanaceAccountId != null){
        
            // 114252 Prakash Start 
            List<Finance_Account__c> finAccList = new List<Finance_Account__c>();
            
            finAccList = [SELECT id,name,Honda_Brand__c from Finance_Account__c where Finance_Account_Number__c=:finanaceAccountId Limit 1 ];
            
            if(finAccList != null && !finAccList.isEmpty() && finAccList[0].Honda_Brand__c == 'AFS'){
                Honda = false;
            }
            else{
                Honda = true;
            }
            this.ps.Finance_Account_Number__c= finAccList != null && !finAccList.isEmpty() ? finAccList[0].Id : NULL;
            
            // 114252 Prakash End 
            //this.ps.Customer__c = financeAccount.Customer__c;
            customerAddresInformation();
            
            System.debug('Inside Constructor'+ ps);
        }
    }
    
    private void customerAddresInformation(){
     /*   this.ps.Billing_First_Name__c = 'First Name';
        this.ps.Billing_Last_Name__c = 'Last Name';
        this.ps.Billing_Street__c = '33rd street west';
        //this.ps.Billing_Address_Line_2__c = 'New York';
        this.ps.Billing_City__c = 'New York';
        this.ps.Billing_State__c = 'NY';
        this.ps.Billing_Zip__c = '10001';
        this.ps.Billing_Country__c = 'US';
        this.ps.Billing_Email__c = 'null@cybersource.com'; */
        
        this.ps.Billing_First_Name__c = 'John';
        this.ps.Billing_Last_Name__c = 'Doe';
        this.ps.Billing_Street__c = '1295 Charleston Road';
        // this.ps.Billing_Address_Line_2__c = 'New York';
        this.ps.Billing_City__c = 'Mountain View';
        this.ps.Billing_State__c = 'California';
        this.ps.Billing_Zip__c = '94043';
        this.ps.Billing_Country__c = 'US';
        this.ps.Billing_Email__c = 'null@cybersource.com';
        this.ps.Currency__c = 'U.S. Dollar';
    }
    public Pagereference reviewBankAccounts(){
        System.debug('Routing Number Map'+routingNumberMap);
        if(this.ps.Bank_Routing_Number__c!=null){
            if(!routingNumberMap.keySet().contains(this.ps.Bank_Routing_Number__c)){ 
                System.debug('ReviewBankAccounts called');
                validateRoutingNumber();

            }
            else{
                System.debug('Inside else');
                
                //Added for Defect No.114067 by Shubham Malik
                if (Ps.Bank_Account_Number__c <> null && Ps.Bank_Account_Number__c.Length() < 4 ) {
                    Ps.Bank_Account_Number__c= Ps.Bank_Account_Number__c.leftPad(4).replace(' ', '0'); 
                    reEnterbankNumber = Ps.Bank_Account_Number__c ;
                }
                
                this.ps.Bank_Account_Type__c = bankAccountType;
                if(this.ps.Payment_Source_Nickname__c == null || this.ps.Payment_Source_Nickname__c == ''){
                    //Added for defect #113976
                    String BankNickName = ps.Bank_Name__c + '-' + ps.Bank_Account_Type__c;
                    if(BankNickName.length() > 50){
                        ps.Payment_Source_Nickname__c = BankNickName.subString(0,50);    
                    }    
                    else{ 
                        ps.Payment_Source_Nickname__c = BankNickName;
                    }  
                }
                
                
                
              //  editMode = false;
              //  reviewMode = true; 
                bankeditMode = false;
                bankreviewMode = true;
            }
        }
        
        tempBankAccNumber = 'XXXX-' + (this.ps.Bank_Account_Number__c).right(4);
        system.debug('In review bank accs ' + tempBankAccNumber);
        
        return null;
    }
    public pageReference editBankAccounts(){
      //  editMode = true;
      //  reviewmode = false; 
        bankeditMode = true;
        bankreviewmode = false;
        return null;
    }
    public pageReference submitBankAccounts(){
      //  system.debug('In Submit Bank Accs ' + this.ps.Bank_Account_Number__c );
        this.ps.Last_4__c = this.ps.Bank_Account_Number__c.right(4);
        this.ps.Status__c ='Active';
        System.debug('Payment Source Instance: '+this.ps);
         if(prefered == false){
            this.ps.Preferred_Payment_Source__c = true;
            preferedBankName = this.ps.id;
        }
        
        // CALLING THE 'CREATEPS' METHOD FROM PYMNTTOKENIZATIONSERVICE AS PART OF PHOENIX
        PymtTokenizationService.PTSResult rs= PymtTokenizationService.createPS(ps);
        
        System.debug('Tokenization Result'+rs);
        if(!rs.success){
             bankeditMode = false;
            bankreviewMode = false;
            banksuccessMode = false;
            // DEFECT 114069 - MANOJ
            ps = NULL ;
            //system.debug('failuretest');
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,rs.msg));
           
        }
        else{
          //  editMode = false;
          //  reviewMode = false;
          //  successMode = true; 
            bankeditMode = false;
            bankreviewMode = false;
            banksuccessMode = true;
            system.debug('successtest');
        }
        return null;
    }
    
    public pagereference checkData(){
        
        categoryname = ApexPages.currentPage().getParameters().get('transactionType') ;
        displaypopup_bank = true;
        
        return null;
    }
    public pageReference validateRoutingNumber(){
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
        system.debug('################'+bankNameFlag);
        return null;
    }
    
    Public String isValidRouting {get;set;}
    
    public pagereference bankAccounts(){
        string pageNameVal = '';
        if(csat==true){
            pageNameVal = '/apex/BankAccountsLandingPage?finnumber='+finanaceAccountId+'&isReadOnly=true';
        }
        else{
            pageNameVal = '/apex/BankAccountsLandingPage?finnumber='+finanaceAccountId;
        }
        pagereference bankAccPage=new pagereference(pageNameVal);
        return bankAccPage;
    }
    
    public pagereference paymentPage(){
        string pageNameVal = '';
        if(csat==true){
            pageNameVal = '/apex/MakeAPaymentLandingPage?finnumber='+finanaceAccountId+'&isReadOnly=true';
        }
        else{
            pageNameVal = '/apex/MakeAPaymentLandingPage?finnumber='+finanaceAccountId;
        }
        pagereference paymentPageVal=new pagereference(pageNameVal);
        return paymentPageVal;
    }
    
    //for displaying popup
    public void showpopup(){
        displaypopup_bank = true;
    }
    //for closing popup
    public void cancelpopup(){
        displaypopup_bank = false;
        system.debug('testtttt@@@@@@@@@@@@@'+displaypopup_bank);
        
    }
    
    public Pagereference closeBankPopup(){
        displaypopup_bank = false;
        return null;
        
     }
    
}