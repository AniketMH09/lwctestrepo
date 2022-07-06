/*******************************************************************************************************
    * @author  : VEERARAJ
    * @date    : 20 JULY 2015
    * @modified :   
    * @group    :  
    * @group-content : 
    * @description : This Class updates the Recurring Payment records to 'Cancelled'of the LMC Finance Account with Scheduled_EasyPay_Amount__c > 0 AND Payment_Due_Date__c = 4000-12-31
    * This Batch class to be schedule after all the playbook process in production.
********************************************************************************************************/
 

global class UpdateEasyPayStatusforLMCAccs implements Database.Batchable<sObject>,Database.Stateful {  

    /*******************************************************************************************************
    * @description : BATCH CLASS STRT METHOD  
    * @param :   
    * @param : 
    * @return :  LIST OF PAYMENT RECORDS
    * @example 
    *  
    *******************************************************************************************************/ 
    global Database.QueryLocator start(Database.BatchableContext BC){  
       
       List<Finance_Account__c> listOfFA = [SELECT Id, Finance_Account_Number__c
                                               FROM Finance_Account__c
                                              WHERE Region_Code__c = 'LMC' AND 
                                                    Payment_Due_Date__c = 4000-12-31 AND 
                                                    Id IN (SELECT Finance_Account_Number__c 
                                                               FROM ChargentOrders__ChargentOrder__c 
                                                            WHERE Finance_Account_Number__c != '')];
   
       String QueryofPayments = 'SELECT id,RecordType.Name,Payment_Display_Status__c,Finance_Account_Number__c FROM ChargentOrders__ChargentOrder__c WHERE RecordType.Name = \'Recurring Payment\' AND Payment_Display_Status__c != \'stopped\' AND ChargentOrders__Charge_Amount__c > 0 AND Finance_Account_Number__c in :listOfFA';
       return Database.getQueryLocator(QueryofPayments);  
    }  
    
    /*******************************************************************************************************
    * @description : BATCH CLASS EXECUTE METHOD  
    * @param :   
    * @param : 
    * @return :  
    * @example : UPDATE THE PAYMENT STATUS TO CANCELLED 
    *  
    *******************************************************************************************************/ 
    global void execute(Database.BatchableContext BC, List<ChargentOrders__ChargentOrder__c> ListofPayments){  
    
        //PAYMENT LIST TO UPDATE THE STATUS
        list < ChargentOrders__ChargentOrder__c > paysToUpdate = new list < ChargentOrders__ChargentOrder__c > ();
        
        
        if( !ListofPayments.isEmpty() ) {
            
            //ITERATE ALL THE QUERIED PAYMENT RECORD LIST
            for(ChargentOrders__ChargentOrder__c P: ListofPayments){  
                ChargentOrders__ChargentOrder__c newCO = new ChargentOrders__ChargentOrder__c();
                newCO.id = p.id;
                newCO.Payment_Display_Status__c =  'Cancelled'; 
                paysToUpdate.add(newCO);
            }  
            
            
            //UPDATE THE PAYMENT RECORDS    
            if(!paysToUpdate.isEmpty()) {
                Database.update(paysToUpdate);  
            }
            
         }
    }  
    
    
    /*******************************************************************************************************
    * @description : BATCH CLASS FINISH METHOD  
    * @param :   
    * @param : 
    * @return :  
    * @example 
    *  
    *******************************************************************************************************/ 
    global void finish(Database.BatchableContext BC) {

    }
      
}