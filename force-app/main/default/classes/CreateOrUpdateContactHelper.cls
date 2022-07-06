/***************************************************************************************************
Apex Class Name    : CreateOrUpdateContactHepler 
Version            : 1.0 
Created Date       : 23 MARCH 2018
Function           : This class is helper for CreateOrUpdateMarketingContact trigger and used to create a new contact if not exist 
					 and update corresponding Finance Account,Communication Preferences & MC Notification records accordingly. 
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               23/03/2018              Original Version
***************************************************************************************************/

public class CreateOrUpdateContactHelper {
    
 /*  Method Name:createOrUpdateContacts()
  *  Parameters: Map of Finance Account Id with list of corresponding MC_Notification__c records
  *  Return Type: void
  */
    
    public static void createOrUpdateContacts(Map<Id,List<MC_Notification__c>> mcNMap)
    {
        List<Contact> createNewContRecs = new List<Contact>();
        Map<Id,Contact> contactMap = new Map<Id,Contact>();
        Map<Id,Communication_Preferences__c> comPMap = new Map<Id,Communication_Preferences__c>();        
        
        try{
            Map<id,Finance_Account__c> finAccMap = new Map<id,Finance_Account__c>([Select id, Name, Eligible_For_MC_Connector__c from Finance_Account__c where id in : mcNMap.keySet()]);
            //Create Map of Finance Account with corresponding contacts
            for(Contact contRec : [Select Finance_Account__c, Id, LastName, Email, MobilePhone,
                                 Eligible_For_MC_Connector__c from Contact where Finance_Account__c =: mcNMap.keySet() and Eligible_For_MC_Connector__c = true])
            {
                contactMap.put(contRec.Finance_Account__c,contRec); 
            }
            //Create Map of Finance Account with communication preferences contacts
            for(Communication_Preferences__c compRec : [Select Finance_Account_Number__c, Email_Address__c,
                                                      Text_Number__c from Communication_Preferences__c where Finance_Account_Number__c =: mcNMap.keySet() ])
            {
                comPMap.put(compRec.Finance_Account_Number__c,compRec);
            }
            
        for(Id accId:mcNMap.keySet())        
            {    
                //If contact exist update MC Notification with Contact Id
                if(Null!=contactMap.get(accId))
                {
                    for(MC_Notification__c mcnObj : mcNMap.get(accId))
                    {  
                        mcnObj.Contact__c = (contactMap.get(accId)).Id;                
                    }
                }
                
                //If contact is not available create a new
                else
                {
                    MC_Notification__c mcnObject = (mcNMap.get(accId)).get(0);
                    Contact contRec = new Contact();  
                    contRec.LastName = (mcnObject.Last_Name__c) != null ? mcnObject.Last_Name__c : (finAccMap.get(accId)).name;
                    contRec.Finance_Account__c = mcnObject.Finance_Account__c;
                    contRec.Eligible_For_MC_Connector__c = True;
                    if(Null != comPMap.get(accId))
                    {
                        contRec.Email = (comPMap.get(accId)).Email_Address__c;
                        contRec.MobilePhone = (comPMap.get(accId)).Text_Number__c;   
                    } 			 
                    createNewContRecs.add(contRec);
                }
            }
            
            //Insert new contact and update corresponding Fincance Account & Communication Preferences
            if(!createNewContRecs.isEmpty())
            {
                
                Database.SaveResult[] srList = Database.insert(createNewContRecs, false);
                List<Id> sucContactRecIds = new List<Id>();
                Map<Id,Id> finAccIds = new Map<Id,Id>();
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        sucContactRecIds.add(sr.getId());
                    }  
                    else
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Database error occured while insertion:'+ err.getMessage()+'for following fields:'+err.getFields());
                        } 
                }
                for(Contact conRec:[Select Id,Finance_Account__c,Eligible_For_MC_Connector__c from Contact where id in : sucContactRecIds])
                {
                    finAccIds.put(conRec.Finance_Account__c,conRec.Id);
                }
                List<Finance_Account__c> finAccList = new List<Finance_Account__c>();
                List<Communication_Preferences__c> comPList = new List<Communication_Preferences__c>();
                //Update related Finance_Account__c,Communication_Preferences__c & MC_Notification__c Records.
                for( Id accId:finAccIds.keySet())
                {   
                    Finance_Account__c finAcc = finAccMap.get(accId);
                    finAcc.Eligible_For_MC_Connector__c = true;
                    finAccList.add(finAcc);
                    Communication_Preferences__c compRec = comPMap.get(accId);
                    if(compRec!= null)
                    { 
                        compRec.Eligible_For_MC_Connector__c = true;
                        comPList.add(compRec);
                    }
                    for(MC_Notification__c mcObj : mcNMap.get(accId))
                    {
                       mcObj.Contact__c = finAccIds.get(accId);
                    }
                }
                
                if(!finAccList.isEmpty())
                {
                    Database.update(finAccList,false);
                }
                if(!comPList.isEmpty())
                {
                    Database.update(comPList,false);
                }
            }    
        }
   	  catch(Exception exe)
        {
            System.debug('Exception occured:'+exe.getStackTraceString()+exe.getMessage());
        }
    }   
}