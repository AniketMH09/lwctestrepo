public class NewBankAccountContainerControllerExt {
	public Id financeAccountId {get;set;}
    public Id testId1 {get;set;}
    public string errorMessage {get;set;}
    
    public NewBankAccountContainerControllerExt(ApexPages.standardSetController con){
      testId1 = ApexPages.currentPage().getParameters().get('Finance_Account__c');
      financeAccountId = ApexPages.currentPage().getParameters().get('id');      
        
    }
    
    public pageReference doProcessing(){
    
       integer recurringflag=0; 
       
       string fno = '';
       
       List<Finance_Account__c> lstFinanceAccount = [select Finance_Account_Number__c from Finance_Account__c where id =:financeAccountId] ; 
       if(lstFinanceAccount.size()>0)
       {
           fno = lstFinanceAccount[0].Finance_Account_Number__c;           
       }
     

        
       List<Payment_Source__c> lstPaymentSource = Database.query('select Bank_Name__c,Payment_Source_Nickname__c,Last_4__c,Preferred_Payment_Source__c,Status__c from Payment_Source__c where Finance_Account_Number__c =:financeAccountId');
              
       if(lstPaymentSource.size()>0){
           for(Payment_Source__c currentRecord : lstPaymentSource)
           {
               if(currentRecord.Status__c == 'Active') 
               { 
                    recurringflag=recurringflag+1; 
               } 
               
           }
           system.debug('recurringflag=='+recurringflag);
          
           
           if(recurringflag >= 4) 
           { 
                errorMessage = 'Only four bank accounts can be associated with this finance account'; 
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, errorMessage);
                ApexPages.addMessage(msg);
        
                return null;    
               
           }
           else
           {
           	  return  RedirectToPage(fno);
             
           }         
           
       }
    return RedirectToPage(fno);
    }
    
    public pageReference RedirectToPage(string fno)
    {
    System.debug('Enteringg Redirect==');
      string operation = 'create';
      PageReference redirect =  new PageReference('/apex/VF1_RoutingNumber');
      redirect.setRedirect(true);
      redirect.getParameters().put('finnumber',financeAccountId);
      redirect.getParameters().put('op',operation);
      System.debug('Closing Redirect=='+redirect);       
      return redirect;
         
         
         
    }
}