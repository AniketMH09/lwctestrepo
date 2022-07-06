trigger SuspenseTrigger on Suspense__c (before update) {
    List <Suspense__c> updatedListToInsert= new List <Suspense__c>();
    for (Suspense__c suspenseObj: Trigger.new) {
   
            Boolean blnOwnerChanged =false;
            Boolean blnUserChanged =false;
            Boolean blnClearedAction=false;
   
            //Suspense__c NewSuspense = Trigger.new; 
            Suspense__c OldSuspense = Trigger.oldMap.get(suspenseObj.ID); 
   
            if(OldSuspense.User__c != suspenseObj.User__c)
            {    
                blnUserChanged = true;        
            }
            
            if(OldSuspense.OwnerId!= suspenseObj.OwnerId)
            {    
                blnOwnerChanged = true;        
            }  
            if(OldSuspense.Operator_Action_Taken__c!= suspenseObj.Operator_Action_Taken__c)
            {    
                blnClearedAction= true;        
            }    
    
    
            if(OldSuspense.Process_Status__c!= suspenseObj.Process_Status__c  && suspenseObj.Process_Status__c !='' )
            {    
                 suspenseObj.Pending_Date__c=date.today();       
            }  
    
            if (blnUserChanged)
            {                  
                suspenseObj.OwnerId=suspenseObj.User__c;
            }
            if (blnOwnerChanged )
            {
                suspenseObj.User__c= suspenseObj.OwnerId;
            }   
   
            if (blnClearedAction)
            {
            System.Debug(' *** Operator Action Taken  ==> ' + suspenseObj.Operator_Action_Taken__c);
                if(suspenseObj.Operator_Action_Taken__c!='')
                {
                    suspenseObj.Completed_By__c=UserInfo.getName();
                    suspenseObj.Completed_Date__c=date.today();
                }
                else
                {
                    suspenseObj.Completed_By__c='';
                    suspenseObj.Completed_Date__c=null;
                }
                if (suspenseObj.Operator_Action_Taken__c==null)
                {
                    suspenseObj.Completed_By__c='';
                    suspenseObj.Completed_Date__c=null;
                }
            }
        if (!system.isBatch())
        {
            SuspenseCallOut.makeHttpCallforSuspense( suspenseObj.ID );  
        }
    }
}