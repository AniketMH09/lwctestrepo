/* Apex Class Name   :    AHFC_MakePaymentController
* @Description       :    This Class is used to get payment information
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Edwin                       28-June 2021             Created US:4710

*********************************************************************************/

public without sharing class AHFC_MakePaymentController {
    
     /*
        * Description : This method is used to check easypay is active for the particular finance account
        * @return object reference : Return whether easypay is active or not
	*/
    @AuraEnabled(cacheable=true)
    public static boolean activeEasyPay(Id finAccId){
        
        List<ChargentOrders__ChargentOrder__c> charOrder = [SELECT id, Finance_Account_Number__c, RecordType.Name
                                                            FROM ChargentOrders__ChargentOrder__c 
                                                            WHERE Finance_Account_Number__c = :finAccId AND RecordType.Name ='Recurring Payment' 
                                                            AND Payment_Display_Status__c = 'Pending'
                                                            LIMIT 1];
        boolean isActiveEasyPay = !charOrder.isEmpty();
        return isActiveEasyPay;
    }
    
}