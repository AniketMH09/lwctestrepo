public class NewPaymentContainerControllerExt {

	public Id testId {get;set;}
    public Id testId1 {get;set;}
    public Id testId2 {get;set;}
    public string errorMessage {get;set;}
    public NewPaymentContainerControllerExt(ApexPages.standardSetController con){
               
       testId1 = ApexPages.currentPage().getParameters().get('Finance_Account__c');
       testId2 = ApexPages.currentPage().getParameters().get('id');
         
        
    }
    
    public pageReference doProcessing(){
    
       integer recurringflag=0; 
       integer onetimeflag =0; 
       string fno = '';
       
       List<Finance_Account__c> lstFinanceAccount = [select Finance_Account_Number__c from Finance_Account__c where id =:testId2] ; 
       if(lstFinanceAccount.size()>0)
       {
           fno = lstFinanceAccount[0].Finance_Account_Number__c;
           
       }
       List<ChargentOrders__ChargentOrder__c> lstChargentOder = Database.query('Select id,recordtype.id,recordtype.developername,ChargentOrders__Payment_End_Date__c,Confirmation_Number__c,Monthly_Payment_Amount__c,Payment_Source_Nickname__c,Payment_Display_Status__c from ChargentOrders__ChargentOrder__c where Finance_Account_Number__c =:testId2');
       
       
       if(lstChargentOder.size()>0){
           for(ChargentOrders__ChargentOrder__c currentRecord : lstChargentOder)
           {
               if(currentRecord.RecordType.DeveloperName == 'Recurring_Payment' && currentRecord.Payment_Display_Status__c == 'Pending') 
               { 
                    recurringflag=recurringflag+1; 
               } 
               if((currentRecord.RecordType.DeveloperName == 'One_Time_Payment' || 
                    currentRecord.RecordType.DeveloperName == 'Principal_One_Time_Payment' || 
                    currentRecord.RecordType.DeveloperName == 'Payoff_Payment' ) && 
                    currentRecord.Payment_Display_Status__c == 'Pending' ) 
               { 
                    onetimeflag=onetimeflag+1; 
               } 
           }
                      
           if(recurringflag >= 1 && onetimeflag >=6) 
           { 
                
                errorMessage = 'Only six pending one-time payments and one Recurring Payment schedule are allowed at a time'; 
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
    	
      PageReference redirect =  new PageReference('/apex/RecordTypeSelectionPage');
      redirect.setRedirect(true);
      redirect.getParameters().put('finnumber',fno);
            
      return redirect;           
         
         
    }
    
}