/* Apex Class Name       :    AHFC_ContractViewIntegrationHandler
* @description        :    This Class is used to get all contract details related to finance Account
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* --------------------------------------------------------------------------- 
* satish Lokinindi            24 JUN 2021              Created
*********************************************************************************/
public without sharing class AHFC_ContractViewIntegrationHandler {
    public static Map<String,AHFC_Integration_Setting__mdt> mapIntSettings = AHFC_IntegrationLogUtil.getAllIntegrationSettings();
    public static final String GETCONTRACTS = 'GETGETCONTRACTS';
    public static final String TOKENCONTRACTS = 'POSTTOKENCONTRACTS';
    public static final String SEARCHCONTRACTS = 'POSTSEARCHCONTRACTS';
    
    /**
* @description     searchContracts to search the contracts from docufree
* @param           fiannceaccountNumber
* @return          SearchWrapper 
*/
    @AuraEnabled 
    public static SearchWrapper searchContracts(string fID){
        // Start - Record access check - Supriya Chakraborty 11-Nov-2021
        boolean isUserAuth = UserSecurity.ValidateFinNumberInit(fID);
        if(!isUserAuth){
            throw new AuraHandledException('invalid access');            
        } 
        // End - Record access check - Supriya Chakraborty 11-Nov-2021
        
        string accessToken = getaccesstoken();
        SearchWrapper wrap = new SearchWrapper();
        string finId;
        if(fID.length()>9){
        finId= fID.right(9);   
        }
        else{
        finId= fID;   
        }
        //Logic for contract search
        AHFC_Integration_Setting__mdt objSettingsearch= mapIntSettings.get(SEARCHCONTRACTS);
        Integer intTimeOutsearch = (objSettingsearch.Request_Timeout__c == NULL)?Integer.valueOf(AHFC_GlobalConstans.DEFAULTTIMEOUT):Integer.valueOf(objSettingsearch.Request_Timeout__c);     
        Map<String,String> mapHeaderKeyToValuesearch = AHFC_IntegrationLogUtil.getHeaderValue(objSettingsearch.HeaderValue__c);
        //added by saikiran
        String uniqueMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId(); // get unique honda header message id from getUniqueMessageId method in AHFC_IntegrationLogUtil class.
        if(mapHeaderKeyToValuesearch.containsKey('hondaHeaderType.messageId')){
            mapHeaderKeyToValuesearch.put('hondaHeaderType.messageId',uniqueMessageId);
         }
         //END
        mapHeaderKeyToValuesearch.put('Authorization','Bearer '+accessToken);
        String responsebody = '{"target":"File","root": {"id": 2, "type": "cabinet" },"includeIndex":1,"queries":[{"field":"Index","indexId":1,"terms":"'+finId+'"},{"chain":"And","field":"Index","indexId":3,"terms":"Contract"}]}';
        HttpRequest objsearchRequest = prepareRequest(responsebody,objSettingsearch.Method__c,intTimeOutsearch,objSettingsearch.Endpoint_URL__c,mapHeaderKeyToValuesearch);
        Http searchhttp = new Http();
        HttpResponse searchresp = searchhttp.send(objsearchRequest); 
        if(searchresp.getStatuscode()==200){
            String searchrespbody = searchresp.getBody();
            Map<String, Object> searchdeserialize = (Map<String, Object>) JSON.deserializeUntyped(searchrespbody);
            Integer total = Integer.valueof(searchdeserialize.get('total'));
            wrap.validSearch = total==1?true:false;
            if(total==1){
                list<Object> objlist = (list<Object>)searchdeserialize.get('items');
                Map<String, Object> filemap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(objlist[0]));
                Map<String, Object> fileinsidemap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(filemap.get('file')));
                wrap.contractId = String.valueof(fileinsidemap.get('id'));
            }
        }
        return wrap;
    }
    /**
* @description     getaccesstoken to get the access token for Docufree
* @param           Authorization
* @return          string 
*/
    public static String getaccesstoken(){
        //Logic to fetch accesstoken
        string accessToken;
        AHFC_Integration_Setting__mdt objSetting= mapIntSettings.get(TOKENCONTRACTS);
        Integer intTimeOut = (objSetting.Request_Timeout__c == NULL)?Integer.valueOf(AHFC_GlobalConstans.DEFAULTTIMEOUT):Integer.valueOf(objSetting.Request_Timeout__c);     
        Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
        //added by saikiran
        String uniqueMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId(); // get unique honda header message id from getUniqueMessageId method in AHFC_IntegrationLogUtil class.
        if(mapHeaderKeyToValue.containsKey('hondaHeaderType.messageId')){
            mapHeaderKeyToValue.put('hondaHeaderType.messageId',uniqueMessageId);
         }
         //end
        String payload = 'grant_type='+EncodingUtil.urlEncode('client_credentials','UTF-8')+'&scope='+EncodingUtil.urlEncode('df_api','UTF-8');
        HttpRequest objRequest = prepareRequest(payload,objSetting.Method__c,intTimeOut,objSetting.Endpoint_URL__c,mapHeaderKeyToValue);
        Http tokenhttp = new Http();
        HttpResponse tokenresp = tokenhttp.send(objRequest); 
        system.debug('tokenresponsesss--->'+tokenresp);
        if(tokenresp.getStatuscode()==200){
            String tokenbody = tokenresp.getBody();
            Map<String, Object> tokendeserialize = (Map<String, Object>) JSON.deserializeUntyped(tokenbody);
            accessToken = String.valueof(tokendeserialize.get('access_token'));
        }
        return accessToken;
    }
    /**
* @description     getContracts to get the contract pdf from docufree
* @param           contractId
* @return          String 
*/
    @AuraEnabled 
    public static String getContracts(string contractId){
        //Logic to download contract
        string accessToken = getaccesstoken();
        String contractbody;
        AHFC_Integration_Setting__mdt objSetting= mapIntSettings.get(GETCONTRACTS);
        Integer intTimeOut = (objSetting.Request_Timeout__c == NULL)?Integer.valueOf(AHFC_GlobalConstans.DEFAULTTIMEOUT):Integer.valueOf(objSetting.Request_Timeout__c);     
        Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
        mapHeaderKeyToValue.put('Authorization','Bearer '+accessToken);
        //added by saikiran
        String uniqueMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId(); // get unique honda header message id from getUniqueMessageId method in AHFC_IntegrationLogUtil class.
        if(mapHeaderKeyToValue.containsKey('hondaHeaderType.messageId')){
            mapHeaderKeyToValue.put('hondaHeaderType.messageId',uniqueMessageId);
         }
         //end
        String endpoint = objSetting.Endpoint_URL__c;
        endpoint+='?f='+contractId;
        
        HttpRequest objRequest = prepareRequest(null,objSetting.Method__c,intTimeOut,endpoint,mapHeaderKeyToValue);
        Http gethttp = new Http();
        HttpResponse resp = gethttp.send(objRequest); 
        if(resp.getStatuscode()==200){
            contractbody =  EncodingUtil.base64encode(resp.getBodyAsBlob());  
        }   
        return contractbody;
    }
    /**
* @description     prepareRequest to prepare the HTTP request content.
* @param           
* @return          HTTPRequest 
*/
    public static HTTPRequest prepareRequest(String strRequestBody, String strMethodName,Integer intTimeOut,String strEndPoint,Map<String,String> mapHeaderKeyToValue){
        HttpRequest request = new HttpRequest() ;
        request.setEndpoint(strEndPoint);
        for(String key : mapHeaderKeyToValue.keySet()){
            request.setHeader(key,mapHeaderKeyToValue.get(key));
        }
        if(String.isNotBlank(strRequestBody)){
            request.setbody(strRequestBody);
        }
        request.setMethod(strMethodName);
        request.setTimeOut(intTimeOut);
        
        return request;
    }
    /**
* @description     wrapper class
*
*/
    public class SearchWrapper{

        @auraEnabled public boolean validSearch{get;set;}

        @auraEnabled public string contractId{get;set;}
    }
}