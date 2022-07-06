Public class PdfBankAccSummaryCont {

    Public Payment_Source__c BankAcc  {get;set;} 
    Public String BankAccNumber {get;set;}
    Public String finnumberWithoutZeroes{get;set;}
    Public PdfBankAccSummaryCont() {
        
       String BankAccId = ApexPages.CurrentPage().getParameters().get('BankAccId') ;
       
      
       if ( !String.isBlank(BankAccId)  ) {
            
            Payment_Source__c[] BankAccs = [SELECT Id, Payment_Source_Nickname__c, Bank_Account_Type__c , Bank_Name__c, Last_4__c, Finance_Account_Number__r.Name
                                                FROM  Payment_Source__c
                                                WHERE id = : BankAccId ];     
        
            if ( !BankAccs.isEmpty() ){
                
                BankAcc = BankAccs[0];
                
               //Defect#114148: Added by Shubham.
               finnumberWithoutZeroes = String.valueOf(Integer.valueOf(BankAcc.Finance_Account_Number__r.Name));
                
                BankAccNumber = 'XXXX-' + BankAcc.Last_4__c ;
            }
         }
       }
    }