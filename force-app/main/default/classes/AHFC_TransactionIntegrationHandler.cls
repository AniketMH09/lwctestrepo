/* Apex Class Name     :    AHFC_TransactionIntegrationHandler
*  description         :    This Class is used to get all transaction history details related to Service Account
*  Modification Log    :
* ---------------------------------------------------------------------------
*  Developer                   Date                   Description       RSS
* --------------------------------------------------------------------------- 
*  ANIKET PHARAKATE             20 May 2021               Created
*  MANIKANDAN RADHAKRISHNAN     03 Mar 2022               Modified      53820
*********************************************************************************/
public without sharing class AHFC_TransactionIntegrationHandler {
    
    public static Map<String,AHFC_Integration_Setting__mdt> mapIntSettings = AHFC_IntegrationLogUtil.getAllIntegrationSettings();
    public static final String GETTRANSACTIONHISTORY = 'GETTRANSACTIONHISTORY';
    public static Datetime datTNow = System.now();
    
    
    /*Written By Aniket P | 20 may'2021
     *
     * @Method Name : handletransactionhistory
     * @description:  to be called from UI
     */
    @AuraEnabled 
    public static string handletransactionhistory(string strFinanceAccount,date dtfromdate,date dttodate){
       
        string strresponsebody;
        // Start - Record access check - Aniket Pharakate 11-Nov-2021
        boolean isUserAuth = UserSecurity.ValidateFinNumberInit(strFinanceAccount);        
        if(!isUserAuth){
            return 'invalid access';
        }
        // End - Record access check - Aniket Pharakate 11-Nov-2021

        if(AHFC_IntegrationLogUtil.checkFinanceAccountIsArchived(strFinanceAccount)){
            system.debug('Archived Account');
            return null;
        }else{
            system.debug('Non Archived Accounts');
            AHFC_TransactionIntegrationUtil objIntHandler = new AHFC_TransactionIntegrationUtil();
            AHFC_Integration_Setting__mdt objSetting=mapIntSettings.get(GETTRANSACTIONHISTORY);
            Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
            String strMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId();
            if(mapHeaderKeyToValue!=null && !mapHeaderKeyToValue.isEmpty() && String.isNotBlank(strMessageId)){
                if(mapHeaderKeyToValue.containsKey('hondaHeaderType.messageId')){
                    mapHeaderKeyToValue.put('hondaHeaderType.messageId', strMessageId);
                }
                if(mapHeaderKeyToValue.containsKey('collectedTimeStamp')){
                    mapHeaderKeyToValue.put('collectedTimeStamp', String.valueOf(datTNow));
                }
                if(mapHeaderKeyToValue.containsKey('lookupID') &&
                strFinanceAccount!=null){
                    mapHeaderKeyToValue.put('lookupID',strFinanceAccount);
                }
                if(mapHeaderKeyToValue.containsKey('fromDate') &&
                dtfromdate!=null){
                    mapHeaderKeyToValue.put('fromDate',string.valueof(dtfromdate));
                }
                else if(mapHeaderKeyToValue.containsKey('fromDate') &&
                        dtfromdate==null){
                            mapHeaderKeyToValue.remove('fromDate');
                        }
                if(mapHeaderKeyToValue.containsKey('toDate') &&
                dttodate!=null){
                    mapHeaderKeyToValue.put('toDate',string.valueof(dttodate));
                }
                else if(mapHeaderKeyToValue.containsKey('toDate') &&
                        dttodate==null){
                            mapHeaderKeyToValue.remove('toDate');
                        }
            }
        
            if(!mapHeaderKeyToValue.isEmpty() && objSetting!=null ){
                strresponsebody=objIntHandler.makeTransactionhistoryCallout(mapHeaderKeyToValue,objSetting);
            }
        
            return strresponsebody;
        }
    }
    
}