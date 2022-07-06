public with sharing class RoutingNumberExtension {


    public Payment_Source__c ps {
        get;
        set;
    } 
    public String finanaceAccountId{
        get;
        set;
    } 
    public Boolean showFin {
        get;
        set;
    }
    public Boolean showCust {
        get;
        set;
    }
    public Boolean successMode {
        get;
        private set;
    }
    public Boolean bankNameFlag {
        get;
        private set;
    }
    public Boolean bankDeletedFlag {
        get;
        private set;
    }
    public String operation {
        get;
        private set;
    }

    Map < String, Boolean > routingNumberMap = new Map < String, boolean > ();

    public RoutingNumberExtension(ApexPages.StandardController controller) {
        ps = new Payment_Source__c();
        list < Payment_Source__c > pSource = new list < Payment_Source__c > ();
        String financeAcc;
        String custAcc;
        /*Changes propsed for Security Vulnerabilities against line 70, 83-- Gufran Date 4/20/2020*/
        //String financeAcc = Apexpages.currentPage().getParameters().get('finNumber');
        //String financeAcc = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('finNumber'));
        if(Apexpages.currentPage().getParameters().get('finNumber') != null)
          //  financeAcc = Apexpages.currentPage().getParameters().get('finNumber').escapeHtml4();
              financeAcc = Apexpages.currentPage().getParameters().get('finNumber');
              financeAcc = ESAPI.encoder().SFDC_HTMLENCODE(financeAcc);
        		System.debug('==financeAcc=='+ financeAcc);
       // String custAcc = Apexpages.currentPage().getParameters().get('custNumber');
        //String custAcc = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('custNumber'));
        if(Apexpages.currentPage().getParameters().get('custNumber') != null)
             //custAcc = Apexpages.currentPage().getParameters().get('custNumber').escapeHtml4();
               custAcc = Apexpages.currentPage().getParameters().get('custNumber');
               custAcc = ESAPI.encoder().SFDC_HTMLENCODE(custAcc);
        	   System.debug('==custAcc=='+ custAcc);
        String recordId = Apexpages.currentPage().getParameters().get('id');
        recordId = ESAPI.encoder().SFDC_HTMLENCODE(recordId);
        System.debug('==recordId=='+ recordId);
        operation = Apexpages.currentPage().getParameters().get('op');
        System.debug('==operation=='+ operation);
        operation = ESAPI.encoder().SFDC_HTMLENCODE(operation);
        Integer bankCount;
        bankDeletedFlag = false;
        
        //QUERY THE BANK RECORD IF IT IS EDIT MODE
        if ( String.isNotBlank(recordId) ) {
            pSource = [ SELECT Name, Finance_Account_Number__c, Bank_Account_Number__c, Payment_Source_Nickname__c, Status__c, Bank_Account_Type__c, 
                                Bank_Name__c, Bank_Routing_Number__c, Preferred_Payment_Source__c, Customer__c 
                            FROM Payment_Source__c 
                            WHERE  id = : recordId];
            System.debug('==pSource=='+ pSource);
        }


        if (pSource.size() > 0) {
            ps = pSource[0];
            
            if ( ps.Status__c == 'Deleted' ) {
                System.debug('==deleted==');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Bank account has already been deleted'));
                bankDeletedFlag = true;
            }
            
        } else {
            if (Apexpages.currentPage().getParameters().get('finNumber') != null && Apexpages.currentPage().getParameters().get('finNumber') != '') {
                System.debug('==line81==');
                this.ps.Finance_Account_Number__c = financeAcc;

                System.Debug(' financeAcc ==> ' + financeAcc);

                Customer_Finance_Account__c[] CustFinAcc = [SELECT Id, Customer__c FROM Customer_Finance_Account__c WHERE Finance_Account__c = : financeAcc];
                System.Debug(' CustFinAcc ==> ' + CustFinAcc);

                if (!CustFinAcc.isEmpty()) {
                    this.ps.Customer__c = CustFinAcc[0].Customer__c;
                }
                
                
            } else {
                this.ps.Customer__c = custAcc;
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Something is wrong in validating routing number , try after some time'));
            }
			System.debug('==line106==');
            bankCount = [select count() from Payment_Source__c where Finance_Account_Number__c = : financeAcc and Status__c = : 'Active'];
            if (bankCount == 0) {
                this.ps.Preferred_Payment_Source__c = true;
            }

        }



         
        // 114103 - Default to Active Status
        ps.Status__c = 'Active' ;
        successMode = false;
        bankNameFlag = false;

        finanaceAccountId = '';

        // this.ps = (Payment_Source__c)controller.getRecord();

        finanaceAccountId = this.ps.Finance_Account_Number__c;   

		System.debug('==line128==');
        //System.debug('Inside Constructor'+ ps);
    }

    Public Pagereference init(){
        String recordId = Apexpages.currentPage().getParameters().get('id') ;
        system.debug('==init=='+recordId);
        if ( String.isNotBlank(recordId) ) {
            Pagereference ViewPage  = new Pagereference('/'+recordId); 
            ViewPage.setredirect(true);
            system.debug('==init1=='+ViewPage);
            return ViewPage;
        }
        
        return null;
    }

    // METHOD TO VALIDATE THE ROUTINBG NUMBER WITH LYONS WEBSERVICE
    // WILL BE CALLED IN VFPAGE WHEN THE ROUTING NUMBER FIELD VALUE ISCHANGED.
    // Method was updated for 113802 
    Public pageReference validateRoutingNumber() {
		String BankName = '';
        ApexPages.getMessages().clear();

        if ( ps.Bank_Routing_Number__c <> NULL ) {
            //AHFC_AddPaymentSourceClass addPaymentSource = new AHFC_AddPaymentSourceClass();
            BankName	= AHFC_AddPaymentSourceClass.retrieveBankName(this.ps.Bank_Routing_Number__c);
            //BankName = LyonsUtils.getRoutingNumber(this.ps.Bank_Routing_Number__c); 
                
            if ( BankName == 'No banks found!' ) {
                // Defect: 114112 - Omkar
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Enter a valid 9-digit routing number.'));
                return null;
                
            } else {
                 
                this.ps.Bank_Name__c =  BankName  ; 
                bankNameFlag = true;

            }

        }                    
        return null;
    }


    Public Void SaveRec() {

        System.debug('  SaveRec ==> ');
        
        // 114067 Start by prakash
        //Ps.Bank_Account_Number__c.addError('Either email or phone must be defined');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Either email or phone must be defined'));
        //114067 End 
        //return null;
    }

    Public Boolean FormValidations() {

        Boolean isValid = True;
        System.debug('RoutingNumberExtension - operation - ' + operation);
        if (operation == 'create' && Ps.Bank_Account_Number__c == null) {
            // 114067 Start by prakash
           // Ps.Bank_Account_Number__c.addError('Enter a Bank Account Number');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Enter a Bank Account Number'));
            //114067 End
            isValid = False;
        }
        
        if (Ps.Bank_Account_Number__c <> null && !Ps.Bank_Account_Number__c.isNumeric() ) {
            
            // 114067 Start by prakash
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Enter a Valid Bank Account Number'));
            //Ps.Bank_Account_Number__c.addError('Enter a Valid Bank Account Number');
            // 114067 End 
            isValid = False;
        }
        
        if (Ps.Bank_Account_Type__c == null) {
            
            // 114067 Start by prakash
            //Ps.Bank_Account_Type__c.addError('Select a bank account type');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Select a bank account type'));
            // 114067 End 
            isValid = False;
        }
        if (Ps.Status__c == null) {
        
             // 114067 Start by prakash
           // Ps.Status__c.addError('Select a Status');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Select a Status'));
            // 114067 End 
            isValid = False;
        }
        if (Ps.Bank_Name__c == null) {
        
             // 114067 Start by prakash
           // Ps.Bank_Name__c.addError('Enter a Bank Account Name');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Enter a Bank Account Name'));
             // 114067 End
            isValid = False;
        }
        if (Ps.Status__c != null && Ps.Status__c == 'Deleted' && Ps.Preferred_Payment_Source__c == true) {
            // 114067 Start by prakash
           // Ps.Status__c.addError('If status is deleted then the Bank Account can not be select as Preferred');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'If status is deleted then the Bank Account can not be select as Preferred'));
            // 114067 End 
            isValid = False;
        }
        if (Ps.Bank_Routing_Number__c == NUll ) {
             // 114067 Start by prakash
           // Ps.Bank_Routing_Number__c.addError('Enter a valid 9-digit routing number.');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Enter a valid 9-digit routing number'));
             // 114067 End
            isValid = False;
        }
        //Added this code by Supriya Chakraborty 8-October-2021
        if (Ps.Payment_Source_Nickname__c != NUll && Ps.Payment_Source_Nickname__c.Length()>21) {            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Payment Source Nickname should not be more than 21 character'));
            isValid = False;
        }
         //Added for Defect No.114067 by Shubham Malik
            
        if (Ps.Bank_Account_Number__c <> null && Ps.Bank_Account_Number__c.Length() < 4 ) {
            Ps.Bank_Account_Number__c= Ps.Bank_Account_Number__c.leftPad(4).replace(' ', '0'); 
            isValid = True;
        }
        
        System.debug(' isValid ==> ' + isValid);
        return isValid;

    }

    public pagereference save() {
        pagereference ps1;


        try {

            if (FormValidations()) {

                if (operation == 'create') {
                
                
                
                    if (ps.Bank_Account_Number__c != null && ps.Bank_Account_Number__c.length() > 4) {
                        ps.Last_4__c = ps.Bank_Account_Number__c.substring(ps.Bank_Account_Number__c.length() - 4);
                    }else {
                        ps.Last_4__c = ps.Bank_Account_Number__c; // Defect: 114067 -Shubham
                    }
                      // CHANGING THE TYPE TO PYMNTTOKENIZATIONSERVICE.PTSRESULT AS PART OF PHOENIX
                   PymtTokenizationService.PTSResult result = PaymentsUtils.GetBankToken(ps);

                    if (result.success) {

                        ps.ChargentOrders_Tokenization__c = result.token;

                        // Modified to prepopulate the Name field in Payment Section - Test Modification.
                        //Modified this code by Supriya Chakraborty 8-October-2021
                        if (ps.Payment_Source_Nickname__c == null || ps.Payment_Source_Nickname__c == '') {
                            //Added for defect #113976
                            //String BankNickName = ps.Bank_Name__c + '-' + ps.Bank_Account_Type__c;
                            
                            String bankNickName = '';
                            String bankNameTrimmmed ='';
                            if(ps.Bank_Name__c.length() >= 12 )
                            {
                               bankNameTrimmmed  = ps.Bank_Name__c.substring(0,12);
                            }
                            else
                            {
                                bankNameTrimmmed = ps.Bank_Name__c;
                            }   
                            bankNickName = bankNameTrimmmed+'-'+ ps.Bank_Account_Type__c;                            
							ps.Payment_Source_Nickname__c = bankNickName;
                        }

                        if (bankDeletedFlag == true) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are not allowed to edit this Bank Account Since the status is Deleted.'));
                            return null;
                        }
                        
                        
                        System.debug('ps.Bank_Account_Number__c----------------upsert'+ps.Bank_Account_Number__c );
                        upsert ps;
                        
                       

                        //ps1 = new pagereference(System.Label.System_CL0002 + ps.Finance_Account_Number__c);
                        Finance_Account__c acct = [Select Id From Finance_Account__c Where Id = : ps.Finance_Account_Number__c LIMIT 1];
                        ps1 = new ApexPages.StandardController(acct).view();
                        ps1.setredirect(true);
                        return ps1;

                    } else {
            // Defect: 114112 - Omkar
            // SIT bug : 22304 -modified by sagar 
                         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Bank Account cannot be saved at this time due to a system error, please try again later.Error code: 1501'));
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.AHFC_Payment_Source_Creation_Error_Message));
                         return null;
                    }
                } else if (operation != 'create') {
                    System.debug('Sankalan - In Edit');
                    //
                    if (ps.Payment_Source_Nickname__c == null || ps.Payment_Source_Nickname__c == '') {

                            //Added for defect #113976
                            String BankNickName = ps.Bank_Name__c + '-' + ps.Bank_Account_Type__c;
                            if(BankNickName.length() > 50){
                                ps.Payment_Source_Nickname__c = BankNickName.subString(0,50);    
                            }    
                            else{ 
                                ps.Payment_Source_Nickname__c = BankNickName;
                            }  

                    }

                    if (bankDeletedFlag == true) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are not allowed to edit this Bank Account Since the status is Deleted.'));
                        return null;
                    }
                    
                    System.debug('ps.Bank_Account_Number__c----------------update '+ps.Bank_Account_Number__c );

                    update ps;

                    //ps1 = new pagereference(System.Label.System_CL0002 + ps.Finance_Account_Number__c);
                    Finance_Account__c acct = [Select Id From Finance_Account__c Where Id = : ps.Finance_Account_Number__c LIMIT 1];
                    ps1 = new ApexPages.StandardController(acct).view();
                    ps1.setredirect(true);
                    return ps1;
                }

            }
            
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Bank Account cannot be saved at this time due to a system error, please try again later.Error code: 1501'));
            return null;
        }
        return ps1;

    }

    public pagereference cancel() {

        pagereference ps1;
        if (Apexpages.currentPage().getParameters().get('id') != null && Apexpages.currentPage().getParameters().get('id') != '') {
            ps1 = new pagereference(System.Label.System_CL0002 + ps.Finance_Account_Number__c);
        } else {
            if (Apexpages.currentPage().getParameters().get('finNumber') != null && Apexpages.currentPage().getParameters().get('id') != '')

            {
                ps1 = new pagereference(System.Label.System_CL0002 + Apexpages.currentPage().getParameters().get('finNumber'));

            } else {
                ps1 = new pagereference(System.Label.System_CL0002 + Apexpages.currentPage().getParameters().get('custNumber'));
            }
        }
        return ps1;
    }
}