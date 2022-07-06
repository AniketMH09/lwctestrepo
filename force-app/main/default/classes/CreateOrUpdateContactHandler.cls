/***************************************************************************************************
Apex Class Name    : CreateOrUpdateContactHandler 
Version            : 1.0 
Created Date       : 23 MARCH 2018
Function           : This class is handler for CreateOrUpdateMarketingContact trigger 
					 and used to create Finance Account and corresponding MC Notification records map and to invoke CreateOrUpdateContactHelper
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               23/03/2018              Original Version
***************************************************************************************************/
public class CreateOrUpdateContactHandler {

 /*  Method Name:createUpdateContact()
  *  Parameters: List of MC_Notification__c
  *  Return Type: void
  * Method is used to invoke Helper class method for eligible records.
  */
    public static void createUpdateContact(List<MC_Notification__c> mcNList)
    {
       
        Map<Id,List<MC_Notification__c>> mcnMap = new Map<Id,List<MC_Notification__c>>();
        if(!mcNList.isEmpty())
        {
            for(MC_Notification__c mcnObj : mcNList)
           {   
               if(Null == mcnMap.get(mcnObj.Finance_Account__c))
               {
                 mcnMap.put(mcnObj.Finance_Account__c,new List<MC_Notification__c>{mcnObj});   
               } 
               else
               {
                   mcnMap.get(mcnObj.Finance_Account__c).add(mcnObj);
               }
           }
                     
           CreateOrUpdateContactHelper.createOrUpdateContacts(mcnMap);
        }
    }
}