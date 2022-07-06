/***************************************************************************************************
    Apex Class Name    : UpdateMCContactEmailTriggerHelper 
    Version            : 1.0 
    Created Date       : 02 APRIL 2018
    Function           : This is a helper class for UpdateMCContactEmail trigger
                              and updates the changed email id and Text number details in MC Contact
                              as per changes done in communication preferences.
    Modification Log   :
    -----------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ----------------------------------------------------------------------------                 
    * Praveen Shukla              02/04/2018              Original Version
    ***************************************************************************************************/
    
    
    public class UpdateMCContactEmailTriggerHelper 
    {
      public static void onBeforeActions(List<Communication_Preferences__c> cpList)
      {
            Map<Id,Communication_Preferences__c> financeAccountIdMap = new Map<Id,Communication_Preferences__c>();      
             try{
                 
              for(Communication_Preferences__c cp: cpList)
              {
                 financeAccountIdMap.put(cp.Finance_Account_Number__c,cp);                   
              }
                  
          List<Contact>  contactsList = [SELECT Finance_Account__c, Email, MobilePhone  FROM Contact where Finance_Account__c IN : financeAccountIdMap.keySet()];
         
              if(!contactsList.isEmpty())
              {
              for(Contact con: contactsList)
              {
                  con.Email=(financeAccountIdMap.get(con.Finance_Account__c)).Email_Address__c;
                  con.MobilePhone=(financeAccountIdMap.get(con.Finance_Account__c)).Text_Number__c;                             
              }   
              update contactsList;
            }  
          }
          
         
          catch(Exception exe)
        {
            System.debug('Exception occured:'+exe.getStackTraceString()+exe.getMessage());
        }
          
      }
          
          }