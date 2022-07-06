trigger deleteSuspense on Suspense__c (before delete) {
if(trigger.isdelete){
        for(Suspense__c s:trigger.old){
           s.adderror('Suspense Item cannot be deleted');
        }
    }
}