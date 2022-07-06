/*******************************************************************************************************
* @author      : Needa Shaikh - 9th March 2022.
* @Company     : LTI
* @description : RSS 53698 Adhoc Notification Records are updated with Unsubscribe from All field of Communication Prefernces.
Finance Account Id is used to find corresponding Communication Prefence and all adhoc records are updated.
********************************************************************************************************/

global  class AdhocNotifiUnsubscribeBatch implements Database.Batchable<sObject>,Database.Stateful{
    global String query;
    global Integer count = 0;
    global String errorMessageString = '';
    global String exceptionMessage = '';
    
    global Database.QueryLocator start (Database.BatchableContext bc) {
        query ='Select Id,Finance_Account__c FROM Adhoc_Notification__c where Adhoc_Email_Batch_Processed__c = false and Finance_Account__c!= null';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc , List<Adhoc_Notification__c> adhocList){  
        System.debug(adhocList);
        try{    
            //Creating new list of adhoc records to be updated.
            List<Adhoc_Notification__c> updatedAdhocList = new List<Adhoc_Notification__c>();
            
            //Creating Map to store adhoc records corresponding to Finance Account Id.
            Map<Id,Adhoc_Notification__c> finAccAdhocMap = new Map<Id,Adhoc_Notification__c>();

            //Creating Map to store adhoc records corresponding to Finance Account Number.
            Map<String,Adhoc_Notification__c> finAccNumAdhocMap = new Map<String,Adhoc_Notification__c>();

            //List to store Fin Acc Number string
            List<String> FinAccNumList = new List<String>();
            
            //Creating Map to store Unsubscribe from All field of Communication Prefences corresponding to Finance Account Id.
            Map<Id,Communication_Preferences__c> finAccComPrefMap = new Map<Id,Communication_Preferences__c>();
            
            

            for(Adhoc_Notification__c adhocObj : adhocList){
                String finAccNumber = adhocObj.Finance_Account__c;
                //Obtaining 14 digit Finance Account Number (including leading zeroes)
                finAccNumber = finAccNumber.leftPad(14,'0');
                FinAccNumList.add(finAccNumber);
                finAccNumAdhocMap.put(finAccNumber,adhocObj);
            }
            
            List<Finance_Account__c> finAccRecList = [Select Id,Finance_Account_Number__c from Finance_Account__c where Finance_Account_Number__c in :FinAccNumList];
            System.debug('Finance Account Record List : '+finAccRecList); 
            for(Finance_Account__c finAccRec : finAccRecList){
                System.debug('Id successfully found for --> '+finAccRec.Finance_Account_Number__c);
                finAccAdhocMap.put(finAccRec.Id,finAccNumAdhocMap.get(finAccRec.Finance_Account_Number__c)); 
            }

            //Fetching Communication Prefence Record(Unsubscribe From All field) using Finance Account Id
            List<Communication_Preferences__c> comPrefRecList = [Select Id,Finance_Account_Number__c,Unsubscribe_from_all__c from Communication_Preferences__c where Finance_Account_Number__c in :finAccAdhocMap.keySet()];
            System.debug('Communication Preference Record List : '+comPrefRecList); 
             
            if(finAccAdhocMap!=null){  
                for(Communication_Preferences__c comPrefRec : comPrefRecList){
                    if(comPrefRec.Finance_Account_Number__c!=null){
                        finAccComPrefMap.put(comPrefRec.Finance_Account_Number__c,comPrefRec);  
                    }
                }

                for(Id finAccId : finAccAdhocMap.keySet()){
                    Adhoc_Notification__c adhocRec = finAccAdhocMap.get(finAccId);

                    //Updating Adhoc Notification Record with lookup Finance Account Value.
                    adhocRec.Finance_Account_Value__c = finAccId;
					System.debug('Finance Account Lookup updated successfully--> '+adhocRec.Finance_Account_Value__c);
                    if(finAccComPrefMap.get(finAccId) != null){
                        //Updating Adhoc Notification Record with Unsubscribe From All value.
                        adhocRec.Unsubscribe_from_all__c = finAccComPrefMap.get(finAccId).Unsubscribe_from_all__c;
                        System.debug('Adhoc Unsubscribe_from_all updated successfully--> '+adhocRec.Unsubscribe_from_all__c);
                        //Updating Adhoc Notification Record with Adhoc Email_Batch_Processed as true.
                        adhocRec.Adhoc_Email_Batch_Processed__c = true;
                        System.debug('Adhoc_Email_Batch_Processed updated successfully--> '+adhocRec.Adhoc_Email_Batch_Processed__c);
                    }
                    updatedAdhocList.add(adhocRec);
                }
            }
            
            
            Database.SaveResult[] srList = Database.update(updatedAdhocList, false);
            for(Integer i = 0; i<updatedAdhocList.size();i++){
                Database.SaveResult sr = srList[i];
                Adhoc_Notification__c aRec = updatedAdhocList[i];
                if (!sr.isSuccess()){
                    count += 1;
                    errorMessageString += aRec.Finance_Account__c + ' ,  ';
                    for(Database.Error err : sr.getErrors()) {                 
                        exceptionMessage = err.getStatusCode() + ' : ' + err.getMessage();
                    }
                }              
            }

        }
        catch(Exception e){
            System.debug(e.getMessage());
        }       
    }
    
    
    global void finish(Database.BatchableContext bc){
        if(count>0){
            errorMessageString = 'Failed to insert '+count+' adhoc records with Fin Acc Num: ' + errorMessageString ;
            errorMessageString = errorMessageString.removeEnd(' ,  ');
            errorMessageString+='.';
            System.debug('Exception String --> '+errorMessageString);
            ErrorLog__c errorLog = UtilityClass.errorLogDetails('AdhocNotifiUnsubscribeBatch',exceptionMessage,'','');
            errorLog.ExceptionErrorMessage__c = errorMessageString;
         
            try{            
				insert errorLog;
                System.debug('Inserted error log record: '+errorLog);
          }
            catch(Exception e){                
                System.debug('Error inserting error log record: '+e.getMessage());
            }
        }
    }

}