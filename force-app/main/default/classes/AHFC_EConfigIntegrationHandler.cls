/* 
* Apex Class Name   :   AHFC_EConfigIntegrationHandler
* @description      :	US 3855 - The Econfig webservice will return the images respective to the VIN Number.
* Modification Log  :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               5th JULY 2021          Created
*********************************************************************************/
/**
* @description AHFC_EConfigIntegrationHandler 
*/
public without sharing class AHFC_EConfigIntegrationHandler {
    
    public static Map<String,AHFC_Integration_Setting__mdt> mapIntSettings = AHFC_IntegrationLogUtil.getAllIntegrationSettings();
    public static final String GETECONFIG = 'POSTGETECONFIG';
    
    /**
* @description generateJSONContent
* @param  inpVin 
* @return JSONReq  This is the request body which will be send to the web service call
**/
    @AuraEnabled
    public static String generateJSONContent(String inpVin) {
        
        AHFC_Integration_Setting__mdt objSetting=mapIntSettings.get(GETECONFIG);
        Map<String,String> mapBodyKeyToValue = AHFC_IntegrationLogUtil.getBodyValue(objSetting.Body__c);
        
        String jsonReq = '{'; 		// json request body and configurable via GETECONFIG record of AHFC_Integration_Setting__mdt custom metadata.
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
        jsonReq+= '"required":{';
        jsonReq+= '"vins":{';
        jsonReq+= '"vin":[';
        jsonReq+= inpVin; 			//input Vin Number list will come from the UI 
        jsonReq+= ']}},';
        jsonReq+= '"optional":{';
        jsonReq+= '"assets":{';
        jsonReq+= '"@suppress_asset_name":"'+mapBodyKeyToValue.get('@suppress_asset_name')+'",';
        jsonReq+= '"@suppress_asset_description":"'+mapBodyKeyToValue.get('@suppress_asset_description')+'",';  
        jsonReq+= '"asset":['; 
        jsonReq+= '{';   
        jsonReq+= '"@type_cd":"IMGOVERLAY",';   
        jsonReq+= '"@view_cd":"34FRONT"';   
        jsonReq+= '},';  
        jsonReq+= '{'; 
        jsonReq+= '"@type_cd":"BASECAR",';   
        jsonReq+= '"@view_cd":"34FRONT"';   
        jsonReq+= '}';
        jsonReq+= ']}}},';
        jsonReq+= '"private":{';
        jsonReq+= '"@check_sum":"'+mapBodyKeyToValue.get('@check_sum')+'",';
        jsonReq+= '"template_info":{';   
        jsonReq+= '"@filename":"'+mapBodyKeyToValue.get('@filename')+'",';   
        jsonReq+= '"@method":"'+mapBodyKeyToValue.get('@method')+'",';   
        jsonReq+= '"@class":"'+mapBodyKeyToValue.get('@class')+'",';   
        jsonReq+= '"@xsd":"'+mapBodyKeyToValue.get('@xsd')+'"';   
        jsonReq+= '},';   
        jsonReq+= '"stored_procedure":{';   
        jsonReq+= '"@name":"'+mapBodyKeyToValue.get('@name')+'"';   
        jsonReq+= '}}}}';
        
        return jsonReq;
    }
    
    /**
* @description getHttpRequest
* @param  inpVin 
* @return request This is the final request object which will be send to the Econfig Web Service
**/
    public static HttpRequest getHttpRequest(String inpVin){
        
        AHFC_Integration_Setting__mdt objSetting=mapIntSettings.get(GETECONFIG);
        Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c); // calling this AHFC_IntegrationLogUtil class to deserialize the json response stored for headers and body in GETECONFIG record of AHFC_Integration_Setting__mdt custom metadata. 
        String appId = objSetting.Parameters__c;
        String uniqueMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId(); // get unique honda header message id from getUniqueMessageId method in AHFC_IntegrationLogUtil class. 
        String requestBody = generateJSONContent(inpVin);
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:AHFC_EconfigWebService/?appid='+appId); // Named credential - AHFC_EconfigWebService
        request.setTimeout(Integer.valueOf(System.label.Fiserv_Statements_TimeOut)); 
        request.setMethod('POST');
        if(mapHeaderKeyToValue.containsKey('hondaHeaderType.messageId')){
            mapHeaderKeyToValue.put('hondaHeaderType.messageId',uniqueMessageId);
        }
        for(String key : mapHeaderKeyToValue.keySet()){
            request.setHeader(key,mapHeaderKeyToValue.get(key)); // Header values coming from GETECONFIG record of AHFC_Integration_Setting__mdt custom metadata.
        }
        request.setBody(requestBody);
        
        return request;
    }
    /**
* @description GetEconfigResponse - This is the main method which will return the image path responses from VIN Number list.
* @param  inpVin 
* @return jsonStringFinal  Final Parsed response which will have key as VIN Number and value as Image Paths of the vehicle.
**/
    @AuraEnabled
    public static String getEconfigResponse(String inpVin){
        
        Map<String,String> pathMap = new Map<String,String>();
        Map<String,object> mapVinAndColor = new Map<String,object>();
        Map<String,String> mapVinAndModelYear = new Map<String,String>();
        Map<String,String> mapVinAndMake = new Map<String,String>();
        string jsonStringFinal = '';
        String responseBody;
        String vinNumber = '';
        Integer statusCode;
        String status='';
        try{
            HttpRequest request= getHttpRequest(inpVin);
            HttpResponse response = new Http().send(request);
            responseBody = response.getbody();
            responseBody = responseBody.replace('number', 'vin_number'); 	// changed number in response body to vin_number as number is not a supported naming convention for the variable in apex
            responseBody = responseBody.replace('#cdata-section', 'cdata_section'); 	// changed #cdata-section in response body to cdata_section as # is not a supported naming convention for the variable in apex
            responseBody = responseBody.replace('@', '');	// changed @ prefixed parameters in response body to blank as @ is not a supported naming convention for the variable in apex
            statusCode	= response.getStatusCode();
            status = response.getStatus();
            system.debug('126>>'+responseBody);
            if(statusCode == 200){
                AHFC_eConfigResponseHandler jsonApex =  AHFC_eConfigResponseHandler.parse(responseBody);
                system.debug('129'+jsonApex);
                list<AHFC_eConfigResponseHandler.Vin> parsedVinArray = jsonApex.Mot.db_results.vins.vin; // parsing upto list of vin in Vins class
               system.debug('131'+parsedVinArray);
                for(AHFC_eConfigResponseHandler.Vin vin : parsedVinArray){
                    if(vin.error_code == null){
                        List<AHFC_eConfigResponseHandler.Color> color =   vin.model.colors.color; //parsing upto list of color in colors class
                        vinNumber = vin.vin_number;
                        mapVinAndColor.put(vinNumber,color);		// map of key as vin number and values as color list
                        mapVinAndModelYear.put(vinNumber,vin.model.model_year); //mapVinAndMake
                        mapVinAndMake.put(vinNumber,vin.model.make);
                    }if(vin.error_code != null){ // if status code of web service is 200 still there are errors then it will be handled here as the response has error object in it too for handling errors like invalid vin input and no vin.
                        jsonStringFinal = 'Error: '+ vin.error_code + ' - ' + vin.error_action + ' - ' + vin.error_reason;
                        vinNumber = vin.vin_number;
                        pathMap.put(vinNumber,jsonStringFinal);
                    }
                }
                system.debug('143'+mapVinAndColor);
                if(mapVinAndColor != null){
                    for(String vinNumberString : mapVinAndColor.keyset()){
                        List<AHFC_eConfigResponseHandler.Color> colorOfVin = (List<AHFC_eConfigResponseHandler.Color>) mapVinAndColor.get(vinNumberString); // get list of color related to the vin number
                        
                        for(AHFC_eConfigResponseHandler.Color col :colorOfVin){
                            if(col.assets != null){
                                list <AHFC_eConfigResponseHandler.asset> asset  = new list <AHFC_eConfigResponseHandler.asset>();
                                asset = col.assets.asset; // parse upto asset object inside the assets object in color list
                                system.debug('asset>>'+asset);
                                //system.debug('xxxx>>'+jsonApex.Mot.db_results.);
                                for(AHFC_eConfigResponseHandler.asset assetData: asset){
                                    if(assetData != null){
                                       system.debug('xxx>>>'+mapVinAndModelYear.get(vinNumberString));//mapVinAndMake
                                        if(Integer.valueOf(mapVinAndModelYear.get(vinNumberString)) <= 2018 && mapVinAndMake.get(vinNumberString) == 'Honda'){
                                          pathMap.put(vinNumberString,assetData.path+'?css=true');  
                                        }else {
                                          pathMap.put(vinNumberString,assetData.path); 
                                        }
                                       
                                       
                                        jsonStringFinal = JSON.serialize(pathMap); // jsonStringFinal will have map of key as vin number and values as Image path
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                jsonStringFinal =  'Error: ' +statusCode + ', '+status; //if web service status code is not 200 then error string will be returned
            } 
        }catch(Exception e){
            jsonStringFinal = 'Error: '+ e.getMessage();
            ErrorLog__c errlog = new ErrorLog__c();
            errlog.ExceptionErrorMessage__c= jsonStringFinal; //Insert the catch block exception into the error log object.
            insert errlog;
        }
        system.debug('jsonStringFinal----> '+jsonStringFinal);
        return jsonStringFinal;
    }
}