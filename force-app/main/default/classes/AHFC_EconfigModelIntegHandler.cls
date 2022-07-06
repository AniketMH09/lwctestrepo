/* 
* Apex Class Name   :   AHFC_EconfigModelIntegHandler
* @description      :	US 6697 - The Econfig webservice will return the images respective to the Model Id for powersports
* Modification Log  :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               26 JULY 2021          Created For US 6697
*********************************************************************************/
/**
* @description AHFC_EconfigModelIntegHandler 
*/
public without sharing class AHFC_EconfigModelIntegHandler {
    /**
* @description generateJSONContent
* @param  modelId 
* @return JSONReq  This is the request body which will be send to the web service call
**/
    public static Map<String,AHFC_Integration_Setting__mdt> mapIntSettings = AHFC_IntegrationLogUtil.getAllIntegrationSettings();
    
    public static final String POWERSPORTECONFIG = 'POSTECONFIGPOWERSPORTS';
    
    @AuraEnabled
    public static String generateJSONContent(String modelId) {
        
        AHFC_Integration_Setting__mdt objSetting=mapIntSettings.get(POWERSPORTECONFIG);
        Map<String,String> mapBodyKeyToValue = AHFC_IntegrationLogUtil.getBodyValue(objSetting.Body__c);
        
        String jsonReq = '{'; 		
        jsonReq+= '"mit":{';
        jsonReq+= '"@mit_version_number":"'+mapBodyKeyToValue.get('@mit_version_number')+'",';
        jsonReq+= '"@mit_version_date":"'+mapBodyKeyToValue.get('@mit_version_date')+'",';
        jsonReq+= '"client_info":{';           
        jsonReq+= '"@application_id":"'+mapBodyKeyToValue.get('@application_id')+'",';
        jsonReq+= '"@echo_input":"'+mapBodyKeyToValue.get('@echo_input')+'",';   
        jsonReq+= '"@server_ip":"'+mapBodyKeyToValue.get('@server_ip')+'",';   
        jsonReq+= '"@session_id":"'+mapBodyKeyToValue.get('@session_id')+'",';   
        jsonReq+= '"@domain":"'+mapBodyKeyToValue.get('@domain')+'",';
        jsonReq+= '"@environment":"'+mapBodyKeyToValue.get('@environment')+'"';
        jsonReq+= '},';
        jsonReq+= '"input_parameters":{';
        jsonReq+= '"required": {';
        jsonReq+= '"source_cd": "'+mapBodyKeyToValue.get('source_cd')+'",';
        jsonReq+= '"site_cd": "'+mapBodyKeyToValue.get('site_cd')+'",';
        jsonReq+= '"category_cd": "'+mapBodyKeyToValue.get('category_cd')+'",';
        jsonReq+= '"division": {';		
        jsonReq+= '"@version_num": "'+mapBodyKeyToValue.get('@version_num')+'",';
        jsonReq+= '"#text": "'+mapBodyKeyToValue.get('#text')+'"';
        jsonReq+= '},';
        jsonReq+= '"models": {';
        jsonReq+= '"model": [';  
        jsonReq+= modelId;
        jsonReq+= ']}},';   
        jsonReq+= '"optional": {';   
        jsonReq+= '"assets": {';   
        jsonReq+= '"@suppress_asset_name": "'+mapBodyKeyToValue.get('@suppress_asset_name')+'",';
        jsonReq+= '"@suppress_asset_description": "'+mapBodyKeyToValue.get('@suppress_asset_description')+'",';   
        jsonReq+= '"asset": [';   
        jsonReq+= '{';
        jsonReq+= '"@type_cd": "MCGMHRIMG",';
        jsonReq+= '"@source_cd": "MOTORCYCLE"';
        jsonReq+= '},';
       /* jsonReq+= '{';
        jsonReq+= '"@type_cd": "OL_MDL",';
        jsonReq+= '"@source_cd": "OWNERLINK"';
        jsonReq+= '},'; */
        jsonReq+= '{';
        jsonReq+= '"@type_cd": "OL_MDLBIG",';
        jsonReq+= '"@source_cd": "OWNERLINK"';
        jsonReq+= '}]}}},';
        jsonReq+= '"private":{';
        jsonReq+= '"template_info": {';  
        jsonReq+= '"@class": "'+mapBodyKeyToValue.get('@class')+'",';   
        jsonReq+= '"@filename": "'+mapBodyKeyToValue.get('@filename')+'",';   
        jsonReq+= '"@xsd": "'+mapBodyKeyToValue.get('@xsd')+'",';   
        jsonReq+= '"@method": "'+mapBodyKeyToValue.get('@method')+'"';   
        jsonReq+= '},';   
        jsonReq+= '"stored_procedure":{';   
        jsonReq+= '"@name": "'+mapBodyKeyToValue.get('@name')+'"';   
        jsonReq+= '}}}}';
        
        return jsonReq;
    }
    
    /**
* @description getHttpRequest
* @param  modelId 
* @return request This is the final request object which will be send to the Econfig Power sports Web Service
**/
    public static HttpRequest getHttpRequest(String modelId){
        AHFC_Integration_Setting__mdt objSetting=mapIntSettings.get(POWERSPORTECONFIG);
        Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c); // calling this AHFC_IntegrationLogUtil class to deserialize the json response stored for headers and body in GETECONFIG record of AHFC_Integration_Setting__mdt custom metadata.
        String appId = objSetting.Parameters__c;
        String uniqueMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId(); // get unique honda header message id from getUniqueMessageId method in AHFC_IntegrationLogUtil class. 
        String requestBody = generateJSONContent(modelId);
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:AHFC_EconfigPowersportsWebservice/?appid='+appId); // Named credential - AHFC_EconfigWebService
        request.setTimeout(Integer.valueOf(objSetting.Request_Timeout__c)); 
        request.setMethod('POST');
        if(mapHeaderKeyToValue.containsKey('hondaHeaderType.messageId')){
            mapHeaderKeyToValue.put('hondaHeaderType.messageId',uniqueMessageId);
        }
        for(String key : mapHeaderKeyToValue.keySet()){
            request.setHeader(key,mapHeaderKeyToValue.get(key)); // Header values coming from POWERSPORTECONFIG record of AHFC_Integration_Setting__mdt custom metadata.
        }
        request.setBody(requestBody);
        
        return request;
    }
    
    /**
* @description GetEconfigResponse - This is the main method which will return the image path responses from Model Id.
* @param  modelId 
* @return responseBody
**/
    @AuraEnabled
    public static String getEconfigResponse(String modelId){
        
        Map<String,String> pathMap = new Map<String,String>();
        map<String,Object> mapOfModelIdAndPaths = new map<String,Object>();
        map<String,String> mapOfModelIdAndyear = new map<String,String>();
        String responseBody;
        String jsonFinalString = '';
        Integer statusCode;
        String status='';
        try{
            HttpRequest request= getHttpRequest(modelId);
            HttpResponse response = new Http().send(request);
            responseBody = response.getbody();
            system.debug('xxx'+responseBody);
            responseBody = responseBody.replace('@', '');
            //responseBody = responseBody.replace('-', '_'); //asset-color-match
            responseBody = responseBody.replace('asset-color-match', 'asset_color_match');
            system.debug('yyy'+responseBody);
            statusCode	= response.getStatusCode();
            status = response.getStatus();
            system.debug('133'+responseBody);
            if(statusCode == 200){
                AHFC_EconfigModelResponseHandler jsonApex =  AHFC_EconfigModelResponseHandler.parse(responseBody);
                system.debug('zzz'+jsonApex);
                list<AHFC_EconfigModelResponseHandler.Model> parsedModelIds = jsonApex.Mot.db_results.models.model;
                for(AHFC_EconfigModelResponseHandler.Model modelIds : parsedModelIds){
                    List<String> colorIdModel = new List<String>();
                    mapOfModelIdAndyear.put(modelIds.id, modelIds.model_year);
                    for(AHFC_EconfigModelResponseHandler.Exteriorcolor colorIdsOfModel : modelIds.colors.exteriorcolor){   
                        
                        colorIdModel.add(colorIdsOfModel.id);
                        pathMap.put(modelIds.id,colorIdModel[0]); // putting model id and first color id in the list in this map
                    }
                }
                
                list<AHFC_EconfigModelResponseHandler.Asset_Z> parsedModelAssets = jsonApex.Mot.db_results.assets.asset;
                if(pathMap!=null){
                    for(String modelIds :pathMap.keyset()){
                        map<String,String> assetColorAndPathMap = new Map<String,String>();
                        for(AHFC_EconfigModelResponseHandler.Asset_Z assets : parsedModelAssets){
                            //If condition added if color code is not present in asset 1/4/2022-- aniket
                            if(assets.asset_color_match != null){
                                String assetColId = assets.asset_color_match.color.id;
                                assetColorAndPathMap.put(assetColId,assets.path); // map of asset color id and path of the image
                            }
                            
                        }
                        system.debug('qqq'+mapOfModelIdAndyear);
                        if(assetColorAndPathMap !=null){
                            system.debug('uuu'+assetColorAndPathMap);
                            if(assetColorAndPathMap.get(pathMap.get(modelIds)) != null){
                                
                            
                            String finalPath = assetColorAndPathMap.get(pathMap.get(modelIds)); // based on model id we will get color id and based on color id , we will get path of image here.
                            if(finalPath.toUpperCase().contains('OWNERLINK')){ //for ownerlink in the path we will prepend the domain in the below custom label
                                system.debug('ppp');
                                if(Integer.valueOf(mapOfModelIdAndyear.get(modelIds)) <= 2014){
                                     finalPath = System.label.AHFC_EconfigHondaURL + finalPath+'?ps=true';
                                }else {
                                   finalPath = System.label.AHFC_EconfigHondaURL + finalPath;  
                                }
                               
                            } 
                           // else if(finalPath.toLowercase().contains('_/media')){  //for media in the path we will prepend the domain in the below custom label
                             else if(finalPath.toLowercase().contains('/media')){  
                                //finalPath = finalPath.replace('_','-');
                                system.debug('bbb');
                                 if(Integer.valueOf(mapOfModelIdAndyear.get(modelIds)) <= 2014){
                                    finalPath = System.label.AHFC_EconfigPowerSportsURL +finalPath+'?ps=true'; 
                                 }else {
                                    finalPath = System.label.AHFC_EconfigPowerSportsURL +finalPath; 
                                 }
                                
                            }
                            system.debug('ccc'+finalPath);
                            mapOfModelIdAndPaths.put(modelIds,finalPath);
                            finalPath = '';
                            jsonFinalString = JSON.serialize(mapOfModelIdAndPaths);
                            system.debug('ddd'+mapOfModelIdAndPaths);
                                }
                        }
                    }
                }
            }else{
                jsonFinalString =  'Error: ' +statusCode + ', '+status; //if web service status code is not 200 then error string will be returned
            } 
        }catch(Exception e){
            system.debug('mmmm'+e.getStackTraceString());
            jsonFinalString = 'Error: '+e.getMessage();
            ErrorLog__c errlog = new ErrorLog__c();
            errlog.ExceptionErrorMessage__c= e.getMessage(); //Insert the catch block exception into the error log object.
            insert errlog;
        }
        system.debug('jsonFinalString-----> '+jsonFinalString);
        return jsonFinalString;
    }
}