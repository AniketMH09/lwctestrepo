public with sharing class NEWCommunicationPreferenceInlineAgent {
    public string financeAccountId {get;Set;}
    public Communication_Preferences__c cp {
        get;
        set;
    }
    
    public string URL;
    public string EmailAddress;
    public String paperAndStmt;
    public List < Finance_Account__c > financeAccount;
    public Boolean isReadOnly {
        get;
        set;
    }
    public Integer errorFlag = 0; 
    
    Public String TextNumber {get;set;} 
    public boolean disableInput{get; set;}
     
    
    public NEWCommunicationPreferenceInlineAgent(ApexPages.StandardController controller) {
        cp = (Communication_Preferences__c) controller.getRecord();        
        isReadOnly = false;
       
        EmailAddress = cp.Email_Address__c;
        if ( !String.isBlank(TextNumber) ) {
        system.debug('Coming in');
            TextNumber = cp.Text_Number__c.replace('(','').replace(')','').replace('-','').replace('(','').replace(' ','');
        }else{
            TextNumber = cp.Text_Number__c;
        }    
        system.debug(EmailAddress );
        paperAndStmt = cp.Statements_Letters__c;
        
        financeAccount = [Select id, Honda_Brand__c,Region_Code__c,Finance_Account_Number__c from Finance_Account__c where id = : cp.Finance_Account_Number__c LIMIT 1];
        financeAccountId = financeAccount.get(0).id;
        //checks if the page is for insert or update for how to load
        Id recordId = controller.getId();        
        if (recordId == null) {
            isReadOnly = true;
        } else {
            isReadOnly = false;
            
        }
               
        // Added by Omkar for the defect 114116
        if(financeAccount != null && financeAccount.size() > 0 && financeAccount[0].Region_Code__c == 'NRC')
        {
           disableInput = true;
        }
        //set whether page should be opened in detail or edit mode
        isReadOnly = true;
        Map<String,String> parameters = ApexPages.currentPage().getparameters();
        
        //--------------start: Added by Supriya to make it work on lightning console------//
        if(UserInfo.getUiThemeDisplayed() == 'Theme3')
        {
        	//classic code
            if(parameters.get('retURL') == null){
                isReadOnly = false;
            }            
        }
        else if(UserInfo.getUiThemeDisplayed() == 'Theme4d' || UserInfo.getUiThemeDisplayed() == 'Theme4u')
        {
        // LEX code or Lightning Console view
        system.debug('==LEX==');
        	if(parameters.get('retURL').contains('actionName=view')){
            	isReadOnly = false;
        	}	
        }
        /*if(parameters.get('retURL') == null){
            isReadOnly = false;
        }
        if(parameters.get('retURL').contains('actionName=view')){
            isReadOnly = false;
        }*/
      	//--------------end: Added by Supriya to make it work on lightning console------//
        
    }

    //get list of field history for comm pref to show as related list
    public list < Communication_Preferences__history > gethistory() {
        list < Communication_Preferences__history > history = new list < Communication_Preferences__history > ();
        history = [select CreatedDate, field, CreatedById, id, NewValue from Communication_Preferences__history
        where parentId = : cp.id];
        return history;
    }

    public PageReference updateEdeliveryPreference() {
        System.debug('Inside Update Edelivery Preference');
        FormValidations();
         
       if(errorFlag == 0){  
        financeAccount = [Select id, Honda_Brand__c,Region_Code__c, Finance_Account_Number__c from Finance_Account__c where id = : cp.Finance_Account_Number__c LIMIT 1];
         Boolean successFlag = true;
        if (cp.Statements_Letters__c == 'Paper') {
            cp.Paperless_Statements_Letters__c = false;
        } else if (cp.Statements_Letters__c == 'eDelivery') {
            cp.Paperless_Statements_Letters__c = true;
        }
        cp.Text_Number__c = TextNumber ;        
           
           //Added by Omkar for 114116 defect
        if (financeAccount.size() > 0 && (EmailAddress != cp.Email_Address__c || paperAndStmt != cp.Statements_Letters__c) && financeAccount != null && financeAccount.size() > 0 && financeAccount[0].Region_Code__c != 'NRC') 
        {
            
            system.debug('==update edelivery start=='+financeAccount[0].Finance_Account_Number__c);
            UpdateEDeliveryPreferenceService edeliveryService = new UpdateEDeliveryPreferenceService();
            successFlag = edeliveryService.updateEDeliveryPreference(cp.Paperless_Statements_Letters__c,cp.Email_Address__c,financeAccount[0].Finance_Account_Number__c);
            System.debug('Boolean Flag2' + successFlag);
            //successFlag = true;
        }
        
       
        // Successfully updated in the CASS system, so updating the same in SFDC
        if (successFlag || (successFlag == false && (EmailAddress == cp.Email_Address__c && paperAndStmt == cp.Statements_Letters__c))) {
            try {
            system.debug('-----SUCCESS FLAG IF*****---'+successFlag+'-----EmailAddress ---'+EmailAddress+
        '-----cp.Email_Address__c---'+'---paperAndStmt---'+paperAndStmt +'---cp.Statements_Letters__c---'+cp.Statements_Letters__c);
                // default cp record is inserted through Informatica that is not an indication of cp being set by user for the first time. Is_Comm_Pref_Set__c = true indicates 
                // an user activity has set the cp that drives welcome notification    
                cp.Is_Comm_Pref_Set__c = true;
                System.debug('inside boolean');
                upsert(cp);
                isReadOnly = false;
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'EDelivery preferences has been updated successfully'));
                return null;
            } catch (Exception ex) {}
        }

        // Update EDelivery preference is not successfull and showing the error msg , changes not saved.
        else {
        system.debug('-----SUCCESS FLAG---'+successFlag+'-----EmailAddress ---'+EmailAddress+
        '-----cp.Email_Address__c---'+'---paperAndStmt---'+paperAndStmt +'---cp.Statements_Letters__c---'+cp.Statements_Letters__c);
        RetryCallout.Retrycallout(cp.Email_Address__c,financeAccount[0].Finance_Account_Number__c,cp.Paperless_Statements_Letters__c,string.valueof(cp.id));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'EDelivery preferences is not updated successfully'));
            return null;
        }
          }
 return null;  
     }  
        
    
    public PageReference updateReadOnly() {
        System.debug('Inside Update Read Only');
        isReadOnly = true;
        return null;
    }
    
    Public Void FormValidations(){
    
          errorFlag = 0;
          // EMAIL ADDRESS VALIDATIONS
           system.debug('====='+cp.Email_Address__c);
          String EmailAddress = cp.Email_Address__c ;
          if( cp.Account_Status_Updates_via_Email__c || cp.Payment_Confirmations_via_Email__c || cp.Payment_Reminders_via_Email__c || cp.EasyPay_Communications_via_Email__c || cp.Statements_Letters__c == 'eDelivery' ) {
              //New DSX Field check added 
              if ( String.isBlank(EmailAddress) ) {
                  errorFlag = 1; 
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Enter Email Address'));
              }  
          }
          system.debug('Text num validations ' + TextNumber + String.isBlank(TextNumber) + ' ' + TextNumber.isNumeric() + ' ' +TextNumber.length());
          // TEXT NUMBER VALIDATIONS
          
               
                  
              if( cp.Account_Status_Updates_via_Text__c || cp.Payment_Confirmations_via_Text__c || cp.Payment_Reminders_via_Text__c || cp.EasyPay_Communications_via_text__c  ) {
                  //New DSX Field check added 
                  if ( String.isBlank(TextNumber) ) {
                      errorFlag = 1; 
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Enter a 10-digit Text Number'));
                  }
                  
              }
              
              if ( !String.isBlank(TextNumber) ) {
                  if ( !TextNumber.isNumeric() ) {
                          errorFlag = 1; 
                          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Enter a 10-digit Text Number'));
                      } 
                  if ( TextNumber.length() <> 10 ) {
                      errorFlag = 1; 
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Enter a 10-digit Text Number'));
                  }
             }
          
          // STATEMENTS & LETTERS VALIDATION 
          IF ( cp.Statements_Letters__c == 'Both' ) {
              errorFlag = 1; 
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Enter valid Statements & Letters'));
          }
          
          system.debug('Error flag is ' + errorFlag);
    }
    
    
 }