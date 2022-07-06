trigger AHFC_Customer_Finance_AccountTrigger on Customer_Finance_Account__c (after insert) {
   
    map<Id,Customer_Finance_Account__c> custFinacc = new map<Id,Customer_Finance_Account__c>();
    List<Id> custFinaccId = new List<Id>();
    for(Customer_Finance_Account__c cfa:Trigger.new)
    {
       custFinacc.put(cfa.Finance_Account__c,cfa);
       custFinaccId.add(cfa.Finance_Account__c);
    }
    List<Finance_Account__c> fac = [Select ID,AHFC_Last_Active_User__c,OwnerId from Finance_Account__c where id in: custFinaccId];
    List<Finance_Account__c> updatedFinacc = new List<Finance_Account__c>();
    for(Finance_Account__c finacc:fac)
    {
        Customer_Finance_Account__c cfa = custFinacc.get(finacc.Id);
        finacc.AHFC_Last_Active_User__c = cfa.OwnerId;
        updatedFinacc.add(finacc);
    }
    if(updatedFinacc.size()>0)
    {
        update updatedFinacc;
    }
    
    

}