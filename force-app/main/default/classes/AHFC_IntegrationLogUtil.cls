/* Apex Class Name       :    AHFC_IntegrationLogUtil
* @description        	 :    This is an Integration utlitiy class.
* Modification Log   	 :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Aniket Pharakate            24 May 2021          Created
* Akash Solanki				  9 July 2020		   Modified - added "getBodyValue" method.
*********************************************************************************/
/**
* @description AHFC_IntegrationLogUtil
**/
public class AHFC_IntegrationLogUtil {
    
    String strClassName;
    String strMethodName; 
    String strWebServiceName; 
    String strObjectName;
    String strMessageId;
    String strRecordId;
    
    public AHFC_IntegrationLogUtil(){
        
    }
    public AHFC_IntegrationLogUtil(String strRecordId, String strClassName, String strMethodName, String strWebServiceName, String strObjectName, String strMessageId){
        this.strRecordId = strRecordId;
        this.strClassName = strClassName;
        this.strMethodName = strMethodName;
        this.strMessageId = strMessageId;
        this.strWebServiceName = strWebServiceName;
        this.strObjectName = strObjectName;
    }
    
    public static Map<String,AHFC_Integration_Setting__mdt> getAllIntegrationSettings(){
        
        Map<String,AHFC_Integration_Setting__mdt> mapIntSettings = new Map<String,AHFC_Integration_Setting__mdt>();
        for(AHFC_Integration_Setting__mdt objSetting :[SELECT ID, MasterLabel,Parameters__c,Endpoint_URL__c,Method__c,HeaderValue__c,Body__c,Path__c,Request_Timeout__c,ServiceName__c,Retry__c,Environment__c,  Success_Status_Codes__c FROM AHFC_Integration_Setting__mdt]){
            mapIntSettings.put(objSetting.Method__c+objSetting.MasterLabel, objSetting);
        }
        return mapIntSettings;
    }
    
    public static Map<String,String> getHeaderValue(String headerJson){
        Map<String,String> mapHeaderKeyToHeaderValue = new Map<String,String>();
        List<Object> headerValueResult = (List<Object>)JSON.deserializeUntyped(headerJson); 
        
        for(Object obj : headerValueResult) { 
            Map<String,Object> mapHeaderKeyToHeaderValueTemp = (Map<String,Object>)obj; 
            
            mapHeaderKeyToHeaderValue.put((String)mapHeaderKeyToHeaderValueTemp.get('key'),(String)mapHeaderKeyToHeaderValueTemp.get('value'));
        }
        return mapHeaderKeyToHeaderValue;
    }
/**
* @description getBodyValue retrieve body json and get the values to be posted as part of request body
* @param bodyJson
* @return Map
* @author Akash Solanki
* @date 7 July 2021
**/
    public static Map<String,String> getBodyValue(String bodyJson){
        Map<String,String> mapHeaderKeyToBodyValue = new Map<String,String>();
        List<Object> bodyValueResult = (List<Object>)JSON.deserializeUntyped(bodyJson); 
        
        for(Object obj : bodyValueResult) { 
            Map<String,Object> mapHeaderKeyToBodyValueTemp = (Map<String,Object>)obj; 
            
            mapHeaderKeyToBodyValue.put((String)mapHeaderKeyToBodyValueTemp.get('key'),(String)mapHeaderKeyToBodyValueTemp.get('value'));
        }
        return mapHeaderKeyToBodyValue;
    }
    
    public static String getUniqueMessageId(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        return guid;
    }
    
    //Written By Aniket P | 24 May'2021
    /*
* Description : This method is used to handle retry mechanism for integrations
* @return List reference : 
*/
    public HttpResponse handleRetryMechanism(HttpRequest objRequest, List<String> lstSuccessStatuses, Integer intRetryCount){
        
        HttpResponse objResponse = new HttpResponse();
        Http      objHttp    = new Http();
        Integer intCount = 0;
        try{
            do {
                //send request
                objResponse = objHttp.send(objRequest);
                
                //break the loop if a success response is received
                if(objResponse<> null && lstSuccessStatuses.contains(String.valueOf(objResponse.getStatusCode()))){
                    break;
                }
                
                //increment the counter
                intCount++;
                if(objResponse<> null && lstSuccessStatuses.contains(String.valueOf(objResponse.getStatusCode()))){
                    break;
                }
                
                //increment the counter
                intCount++;
            }while(intRetryCount!=null && intRetryCount>0 && intCount<=intRetryCount);
            
        }
        catch(Exception e){
            String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();
        }
        system.debug('<<<<objResponse>>>>'+objResponse.getBody());
        return objResponse;
    }

    /**
    * @description check the given FinanceAccount is Archived or not
    *              developed as part of RSS 53280 webProject Bug    
    * @param financeAccountNo
    * @return boolean
    * @author Manikandan Radhakrishnan
    * @date 22 02 2022
    **/
    public static boolean checkFinanceAccountIsArchived(String financeAccountNo){
        
        List<Finance_Account__c> finAccntList = new List<Finance_Account__c>();
        System.debug('financeAccountNo : '+financeAccountNo );

        if(financeAccountNo != null){
            finAccntList  = [SELECT id,AHFC_Fl_Archived__c,Finance_Account_Number__c 
                             FROM Finance_Account__c 
                             WHERE AHFC_Fl_Archived__c = 'Y'
                             AND Finance_Account_Number__c =: financeAccountNo];
            
        }

        if(finAccntList.isEmpty()){
            return false;
        }
        else {
            return true;
        }

    }
}