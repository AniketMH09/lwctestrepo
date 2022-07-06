public without sharing class  SCRA_SelectedfinanceAccountList {
 
     @AuraEnabled
    public static Map<String, String> getFinanceAccountnumberList(String userId)
    {         
        	Map<String, String> financeAccountValue = new Map<String, String>();
  			string contactRecid=[SELECT Id, AccountId, ContactId FROM User where id =:userId].ContactId;
            string accRecid=[SELECT Id, AccountId, ContactId FROM User where id =:userId].AccountId;
			
     		List<Customer_Finance_Account__c> financeAccountList = new   List<Customer_Finance_Account__c>();
        
     if(contactRecid != null)
      {
      	     financeAccountList = [SELECT Id, Finance_Account__c, Is_Active__c, Customer__c, Finance_Account__r.AHFC_Product_Name__c, Finance_Account__r.Finance_Account_Number__c FROM Customer_Finance_Account__c where Customer__c =:accRecid AND Is_Active__c != false]; 
      			
      }
        
     if(financeAccountList.size() >0 && financeAccountList != null)
     {              
               		

        for(Customer_Finance_Account__c financeAccountrecord : financeAccountList)
        {
            
          string concatenateFA;
         			 

              	  if(financeAccountrecord.Finance_Account__r.AHFC_Product_Name__c !=null && financeAccountrecord.Finance_Account__r.AHFC_Product_Name__c !='')
                        { 
                             concatenateFA= financeAccountrecord.Finance_Account__r.AHFC_Product_Name__c + ' - ' +financeAccountrecord.Finance_Account__r.Finance_Account_Number__c;
              							

                        }
         
                   else
                       {
                              concatenateFA= financeAccountrecord.Finance_Account__r.Finance_Account_Number__c;
            								

                       }
           
  					financeAccountValue.put(financeAccountrecord.Finance_Account__c, concatenateFA);
            
                }
         
         return financeAccountValue;
      			

     }
          
     else
     	{
         return null; 
            
    	}
    }  
}