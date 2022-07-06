// (c) 2018 Appirio, Inc.
// Name of the Trigger: AHFC_CaseTrigger 
// Description : Generic Trigger that handles all events & pass values to Trigger Handler.
// Created by : Karunakar Pulkam | Date : 12 Dec, 2018
// Trigger Type : Original
// Task : T-762513 | Story : S-581023

trigger AHFC_CaseTrigger on Case (after insert, after update, before insert, before update) {

// Calling Dispatcher in AHFC_CaseTriggerHandler

    if(TriggerRules__c.getOrgDefaults() != null &&
       TriggerRules__c.getOrgDefaults().CaseTrigger__c){ 
           System.debug('AHFC_CaseTrigger1##############'); 
           if(Trigger.isInsert && Trigger.isBefore) {
               AHFC_CaseTriggerHandler.onBeforeInsert(Trigger.New,Trigger.oldMap);
           }
            if(Trigger.isInsert && Trigger.isAfter) {                
                AHFC_CaseTriggerHandler.onAfterInsert(Trigger.New,Trigger.oldMap);                
            }
           /*
           if(Trigger.isUpdate && Trigger.isAfter) {                
               AHFC_CaseTriggerHandler.onAfterUpdate(Trigger.New);
           }*/
       }                                    

}