trigger PaymentTrigger on ChargentOrders__ChargentOrder__c (before insert, after insert, before update, after update) {
    
    new PaymentTriggerHandler().run();
    
}