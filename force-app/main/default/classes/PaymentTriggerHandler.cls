public class PaymentTriggerHandler extends BaseTriggerHandler {
    
    private List <ChargentOrders__ChargentOrder__c> orders = new List <ChargentOrders__ChargentOrder__c> ();
    private Map <Id, ChargentOrders__ChargentOrder__c> oldOrderMap = new Map <Id, ChargentOrders__ChargentOrder__c> ();
    private Map <Id, ChargentOrders__ChargentOrder__c> newOrderMap = new Map <Id, ChargentOrders__ChargentOrder__c> ();
    
    public override void beforeInsert() {
        if(BaseTriggerHandler.isUserSession) {
          ManagePaymentService.beforeInsertRules(Trigger.new);
       }
 }
    
    public override void afterInsert() {
        
        if(BaseTriggerHandler.isUserSession) {
            // Execute business rules to be fired for Customer or Agent based actions
            
            // Sync easy pay amounts on the finance account
            ManagePaymentService.afterInsertRules(Trigger.new);
            
            // Send confirmation notification via sms
            SMSDeliveryService.sendPymtConfBySMS(Trigger.new, Trigger.oldMap);
            
            // Send confirmation notification via email
            EmailDeliveryService.sendPymtEmailConfirmation(Trigger.new, Trigger.oldMap, 'Insert');
            
            // Send payment information to CASS for notestamp - INT 31
            this.sendPymtForNotestamp(Trigger.new, null);          
           }
        else {
            // Fire rules for INT 6B run
            ManagePaymentService.afterInsertRules(Trigger.new);
        }
        }
    
    public override void beforeUpdate() {
        
        if(!BaseTriggerHandler.isUserSession) {
            // Execute before update business ruless
            // 1. Updating Next Withdrawal Date
            // 2. Marking Easy pay status to Complete
            ManagePaymentService.beforeUpdateRules(Trigger.newMap, Trigger.oldMap);
            
        } else {
            ManagePaymentService.beforeUpdateRulesForUsers(Trigger.newMap, Trigger.oldMap);
        }
    }
    
    public override void afterUpdate() {
        
        if(BaseTriggerHandler.isUserSession) {
            // Execute business rules to be fired for Customer or Agent based actions
            // Send confirmation notification via sms
            SMSDeliveryService.sendPymtConfBySMS(Trigger.new, Trigger.oldMap);
            
            // Send confirmation notification via email
            EmailDeliveryService.sendPymtEmailConfirmation(Trigger.new, Trigger.oldMap, 'Update');
            
            // Send payment information to CASS for notestamp - INT 31
            sendPymtForNotestamp(Trigger.new, Trigger.oldMap);
        }
        /*
        // batch context
        else {
            // Execute all the afterUpdate business rules -
            ManagePaymentService.afterUpdateRules(Trigger.newMap, Trigger.oldMap);
        } */
           
        
    }
    
    // CassCallout - INT 31 to send payments to CASS for notestamp update
    public void sendPymtForNotestamp(List < SObject > newOrders, Map <Id, SObject > oldOrders ) {
        // 114159 start - Prakash
      //Added String constants for QC #114159 
      final String NEW_PAYMENT = 'New';
      final String MODIFIED_PAYMENT = 'Modified';
      final String CANCELLED_PAYMENT = 'Cancelled';   
      // 114159 end- Prakash
        String RecurringRecordTypeId = Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
 
        if (  Trigger.isAfter && trigger.isInsert ) {  
                    for(SObject item: newOrders) { 
                        ChargentOrders__ChargentOrder__c a = (ChargentOrders__ChargentOrder__c)item;
                        if ( a.RecordTypeId != RecurringRecordTypeId ) {
                            CASSCallOut.MakeHttpCall( a.Id,NEW_PAYMENT); // 114159 - Prakash
                        }
                    }
        
                } else if ( Trigger.isAfter && trigger.isUpdate  ) {
                    
                    for ( SObject item : newOrders ) {
                        ChargentOrders__ChargentOrder__c a = (ChargentOrders__ChargentOrder__c)item;
                        
                        // OLD FIELD VALUES TO COMPARE, WHEN ANY FOLLOWING FIELDS ARE CHANGED TO MAKE THE CASS CALLOUT
                        ChargentOrders__ChargentOrder__c x = (ChargentOrders__ChargentOrder__c)oldOrders.get(a.Id);
                             
                         // MAKE CASS CALLOUT WHEN THERE IS CHANGE IN FOLLOWING FIELDS && STATUS IS PENDING
                         if  ( a.RecordTypeId != RecurringRecordTypeId  && a.Payment_Display_Status__c == 'Pending'  && 
                              ( x.ChargentOrders__Payment_Start_Date__c != a.ChargentOrders__Payment_Start_Date__c ||
                                x.ChargentOrders__Charge_Amount__c      != a.ChargentOrders__Charge_Amount__c      ||
                                x.Payment_Source_Nickname__c            != a.Payment_Source_Nickname__c  ) ) {
                                   
                                CASSCallOut.MakeHttpCall( a.Id,MODIFIED_PAYMENT);  // 114159 - Prakash 
                                   
                          }  else if (  a.RecordTypeId != RecurringRecordTypeId && ( x.Payment_Display_Status__c <> 'Cancelled' && a.Payment_Display_Status__c == 'Cancelled' ) ) {
                              // MAKE CASS CALLOUT WHEN PAYMENT IS GETTING CANCELLED
                              CASSCallOut.MakeHttpCall( a.Id, CANCELLED_PAYMENT );  // 114159 - Prakash
                          }       
                    }                
                }
                
         // Change the boolean isAlreadyExecuted to True to stop the recursive
          BaseTriggerHandler.isAlreadyExecuted = True;       
    }     
}