public without sharing class AHFC_Case_List_View {
    
    @AuraEnabled(cacheable=true)
    public static List<Case> getBranchData(string finid){
        List<Case> lstcase = new List<Case>();
        List<Customer_Finance_Account__c> junctionacc = [select id, name,Customer__c from Customer_Finance_Account__c where Finance_Account__c = :finid];
       
        if(junctionacc.size() > 0){
          lstcase = [select id,CaseNumber,OwnerId,Owner.Name,Type,CreatedDate,Status,Case_Reason__c,ClosedDate from case where AccountId = :junctionacc[0].Customer__c and recordType.Name = 'CCPA']; 
        }
        
        return lstcase;
    }

}