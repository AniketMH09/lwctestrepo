// (c) 2021 LTI.
// Name of the Trigger: AHFC_FinanceAccountTrigger 
// Description : Generic Trigger that handles all events & pass values to Trigger Handler.
// Created by : Supriya Chakraborty | Date : 10 Jul, 2021
// Trigger Type : Original
// Story : 8054

trigger AHFC_FinanceAccountTrigger on Finance_Account__c (before insert) {
    if(Trigger.isInsert && Trigger.isBefore) {
        AHFC_FinanceAccountTriggerHandler.onBeforeInsert(Trigger.New);
    }    
}