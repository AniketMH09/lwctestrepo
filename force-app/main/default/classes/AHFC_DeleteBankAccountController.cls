public without sharing class AHFC_DeleteBankAccountController {
    @AuraEnabled 
    public static String deleteBankAcc(Id recordId){
        String msg='';
        List<Payment_Source__c> accountsToDelete = [select Id, Payment_Source_Nickname__c, Status__c from Payment_Source__c where Id =:recordId];
        List<ChargentOrders__ChargentOrder__c> chargentOrdertoDelete = [select Payment_Display_Status__c from ChargentOrders__ChargentOrder__c where Payment_Source_Nickname__c=:recordId];
        String displayStatus;
        Boolean isPending = false;
        for(Integer i=0;i<chargentOrdertoDelete.size();i++) 
        { 
            displayStatus = ChargentOrdertoDelete[i].Payment_Display_Status__c;
            
            if(displayStatus=='Pending' || displayStatus=='Suspended' || displayStatus=='Processing' || displayStatus=='Stopped' ){
                isPending = true;                
            }
        }
        
        if(isPending){
            msg = 'Account cannot be deleted';
        }
        
        String bankObjectStat = accountsToDelete[0].Status__c; 
        if(bankObjectStat == 'Deleted' ) 
        { 
            msg = 'Bank account has already been deleted.'; 
            
        }
        else if(bankObjectStat == 'Active' && isPending) {
            msg = 'Bank account associated with pending payments cannot be deleted.'; 
            
        }else{
            accountsToDelete[0].Status__c = 'Deleted';
            try{
                update accountsToDelete;
                msg = 'Account succesfully deleted';
            }
            catch(Exception e){
                System.debug('Error while uopdateing accountToDel--- '+e.getMessage());
            }
            
        }
        return msg;    
    }
}