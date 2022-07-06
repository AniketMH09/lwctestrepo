global class UIHelper {
    public String allowCancel {get;set;}
    
    public String epDisplayStatus {get;set;}
    
    public Date paymentDate {get;set;}
   
    public String NWDStr {get;set;}
    
    public UIHelper(ApexPages.StandardController controller) {}
    
    public PageReference isEPCancelledAfterCutoff() {
        
        Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();
        
        try {
            if (NWDStr != null) {
            paymentDate = Date.valueOf(NWDStr);
        }
        } catch (Exception e) {}
        
        if (epDisplayStatus == 'Pending' && paymentDate != null && hfc != null &&
           (paymentDate < System.Today() ||
            (paymentDate == System.Today() && System.now().time() > hfc.CutOff_Time__c.time()))) {
                allowCancel = 'No';
            }
            else {
                allowCancel = 'Yes';
            }
        system.debug('UIHelper epDisplayStatus ' + epDisplayStatus + ' paymentDate ' + paymentDate + ' allowCancel ' + allowCancel);
        
        return null;
    }
    
    Webservice static String canUpdateEPStatus(String displayStatus, Date nextWithdrawalDt) {
        String doCancel;
        
        Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();
        
        if ((displayStatus == 'Pending' || displayStatus == 'Suspended') && nextWithdrawalDt != null && hfc != null &&
           (nextWithdrawalDt < System.Today() ||
            (nextWithdrawalDt == System.Today() && System.now().time() > hfc.CutOff_Time__c.time()))) {
                doCancel = 'No'; 
            }
            else {
                doCancel = 'Yes';
            }
        system.debug('UIHelper displayStatus ' + displayStatus + ' nextWithdrawalDt ' + nextWithdrawalDt + ' doCancel ' + doCancel);
        
        return doCancel;
    }

}