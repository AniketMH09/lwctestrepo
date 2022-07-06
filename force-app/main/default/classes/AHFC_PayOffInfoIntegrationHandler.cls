/* Apex Class Name       :    AHFC_PayOffInfoIntegrationHandler
* Description            :    This Class is used to get all payOff details
* Modification Log       :
* ---------------------------------------------------------------------------------------
* Developer                          Date                         Description     RSS
* ---------------------------------------------------------------------------------------
* Prabu Mohanasundaram               26th JUNE 2021               Created
* Manikandan Radhakrishnan           03   MAR  2022               Modified        53820
************************************************************************************************/

public class AHFC_PayOffInfoIntegrationHandler {
    public static Map<String,AHFC_Integration_Setting__mdt> mapIntSettings = AHFC_IntegrationLogUtil.getAllIntegrationSettings();
    public static final String GETPAYOFFINFO = AHFC_GlobalConstans.GETPAYOFFINFO;
    public static Datetime datTNow = System.now();
    @AuraEnabled
    public static string handlePayoffInfo(string strFinanceAccount,date dtChargeOffDate,date dtEffectiveDate){
        System.debug('dtEffectiveDate--->'+dtEffectiveDate+'--->'+strFinanceAccount+'--->'+dtChargeOffDate);
       // strFinanceAccount ='00000438705024';
       // dtChargeOffDate=Date.valueOf('2021-05-27');
       // dtEffectiveDate = Date.valueOf('2021-05-27');
        String strResponseBody;
        /***
         * Added the code as part of RSS 53820 to prevent the webservice call 'GetPayoffInfo'
         * for Archived Finance Accounts
         * 
         ***/
        if(!String.isBlank(strFinanceAccount) && AHFC_IntegrationLogUtil.checkFinanceAccountIsArchived(strFinanceAccount)){
                system.debug('Archived Account');
                return null;
        }else{  
            if(!String.isBlank(strFinanceAccount)){

                AHFC_PayOffInfoIntegrationUtil objIntHandler = new AHFC_PayOffInfoIntegrationUtil();
                AHFC_Integration_Setting__mdt objSetting=mapIntSettings.get(GETPAYOFFINFO);
                system.debug('objSetting -->'+objSetting);
                Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
                String strMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId();
                System.debug('mapHeaderKeyToValue-->'+mapHeaderKeyToValue);
                if(mapHeaderKeyToValue!=null && !mapHeaderKeyToValue.isEmpty() && String.isNotBlank(strMessageId)){
                    if(mapHeaderKeyToValue.containsKey('hondaHeaderType.messageid')){
                        mapHeaderKeyToValue.put('hondaHeaderType.messageId', strMessageId);
                    }
                    if(mapHeaderKeyToValue.containsKey('collectedTimeStamp')){
                        mapHeaderKeyToValue.put('collectedTimeStamp', String.valueOf(datTNow));
                    }
                    if(mapHeaderKeyToValue.containsKey('lookupID') &&
                    strFinanceAccount!=null){
                        mapHeaderKeyToValue.put('lookupID',strFinanceAccount);
                    }
                    if(mapHeaderKeyToValue.containsKey('chargeOffDate') &&
                    dtChargeOffDate!=null){
                        mapHeaderKeyToValue.put('chargeOffDate',string.valueof(dtChargeOffDate));
                    }
                    if(mapHeaderKeyToValue.containsKey('effectiveDate') &&
                    dtEffectiveDate!=null){
                        System.debug('I am here');
                        mapHeaderKeyToValue.put('effectiveDate',string.valueof(dtEffectiveDate));
                        System.debug('mapHeaderKeyToValue-->'+mapHeaderKeyToValue);
                    }
                }
                system.debug('mapHeaderKeyToValue -->'+mapHeaderKeyToValue);
                if(!mapHeaderKeyToValue.isEmpty() && objSetting!=null ){
                    strresponsebody=objIntHandler.makePayOffCallout(mapHeaderKeyToValue,objSetting);
                    system.debug('Responsesss-->'+strresponsebody);
                }
            }  
            return strresponsebody;
        }
    }
}