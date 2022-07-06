/***************************************************************************************************
Apex Trigger Name    : CreateOrUpdateMarketingContact 
Version            : 1.0 
Created Date       : 23 MARCH 2018
Function           : Before insert trigger on MC Notification
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               23/03/2018              Original Version
***************************************************************************************************/

trigger CreateOrUpdateMarketingContact on MC_Notification__c (before insert) { 
        CreateOrUpdateContactHandler.createUpdateContact(Trigger.new);
}