/***************************************************************************************************
Apex Trigger Name    : UpdateMCContactEmail 
Version            : 1.0 
Created Date       : 26 MARCH 2018
Function           : Before insert trigger on Communication Preferences
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Praveen Shukla               26/03/2018              Original Version
***************************************************************************************************/

trigger UpdateMCContactEmail on Communication_Preferences__c (before insert, before update) {

        if(Trigger.isInsert)
        {
            UpdateMCContactEmailTriggerHelper.onBeforeActions(Trigger.new);
           }
        else 
        { 
            List<Communication_Preferences__c> compList = new List<Communication_Preferences__c>();
            for(Communication_Preferences__c compRec : Trigger.new)
            {
                if(compRec.Email_Address__c != (Trigger.oldMap).get(compRec.Id).Email_Address__c || 
                   compRec.Text_Number__c != (Trigger.oldMap).get(compRec.Id).Text_Number__c){
                       compList.add(compRec);                 
                   }
            }
            if(!compList.isEmpty())
            {
                 UpdateMCContactEmailTriggerHelper.onBeforeActions(compList);
              }
        }
    
    
    }