/* Apex Class Name   :    AHFC_MarketingTileController
* @Description        :    This Class is used to retrieve boolean and string values based on the Payment Options criteria .
* Modification Log   :
* --------------------------------------------------------------------------- 
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               Jun 29 2021             Created
*********************************************************************************/
public without sharing class AHFC_paymentOptionsController {

    /*
    * @author Prabu JUN 29 2021
    * @Method Name : paymentFlagRetrieve
    * @description:  retrieve boolean and string values based on the Payment Options criteria
    * @param : Finance Account Id
    */
    @AuraEnabled(cacheable = true)
    public static PaymentWrapper paymentFlagRetrieve(String FinanceId){ 
        system.debug('PaymtApexEntry-->');
         Boolean isHondaPaymentOption = false;
         Boolean isAcuraPaymentOption = false;      
        
         PaymentWrapper paymentWrap = new PaymentWrapper();        
                        
        List<Finance_Account__c> finAcc = [select id,Honda_Brand__c,AHFC_Garaging_State__c,Account_Type__c,AHFC_Product_Type__c,Maturity_Date__c from Finance_Account__c where id = :FinanceId];
        if(finAcc!=null && !finAcc.isEmpty() && finAcc.size()>0 )
        {
                if(finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.HFS || finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.HFSP)
            {
                isHondaPaymentOption = true;
            }
            else if(finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.AFS)              
            {
                isAcuraPaymentOption = true;
            }
            else
            {
                isHondaPaymentOption =false;
                isAcuraPaymentOption =false;
            }
            
    }
         paymentWrap.finId = finAcc[0].id;
            paymentWrap.hondaPayment = isHondaPaymentOption ;
            paymentWrap.acuraPayment = isAcuraPaymentOption;
            paymentWrap.isState = finAcc[0].AHFC_Garaging_State__c;
            return paymentWrap; 
        
    }
        
    /*
    * @author Prabu JUN 25 2021
    * @description:  Wrapper class - 
    */
    public without sharing class PaymentWrapper{
        @AuraEnabled
        public String finId {get;set;}
        @AuraEnabled
        public Boolean hondaPayment {get;set;}
        @AuraEnabled
        public Boolean acuraPayment {get;set;}        
        @AuraEnabled
        public String isState{get;set;}  
    }    
}