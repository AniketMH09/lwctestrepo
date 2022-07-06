global class LyonsUtils{
    
    /* RSS 48414 - REST API method started */
    Public Static String getRoutingNumber( String RoutingNumber ){
        try {
            LyonsCredentials__c LCred = LyonsCredentials__c.getOrgDefaults();
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            HttpRequest requestforBank = new HttpRequest();
            HttpResponse responseforBank = new HttpResponse();
            request.setEndpoint('callout:lyons_REST/Logon');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            LyonsCredentials__c LyonCred = LyonsCredentials__c.getOrgDefaults();
            JSONGenerator jsonbody = JSON.createGenerator(true);    
            jsonbody.writeStartObject();      
            jsonbody.writeStringField('companyId',LyonCred.CompanyId__c);
            jsonbody.writeStringField('userName',LyonCred.User_Name__c);
            jsonbody.writeStringField('password',LyonCred.Password__c);
            jsonbody.writeEndObject();    
            String jsonform = jsonbody.getAsString();
            request.setbody(jsonform);
            request.setMethod('POST');
            response = h.send(request);
            string lyonToken = jsonprocessing(response.getbody(),'token');
            requestforBank.setEndpoint('callout:lyons_REST/GetPrimaryInstitutionDetails');
            requestforBank.setHeader('Content-Type', 'application/json;charset=UTF-8');
            JSONGenerator gen = JSON.createGenerator(true);    
            gen.writeStartObject();      
            gen.writeStringField('token',lyonToken);
            gen.writeStringField('rtn',RoutingNumber);
            gen.writeStringField('country','US');
            gen.writeStringField('includeInactive','false');
            gen.writeStringField('includeWireSearch','true');
            gen.writeStringField('includeHistory','false');
            gen.writeEndObject();    
            String jsonS = gen.getAsString();
            requestforBank.setbody(jsonS);
            requestforBank.setMethod('POST');
            responseforBank = h.send(requestforBank);
            Map<String, Object> respinst = (Map<String, Object>) JSON.deserializeUntyped(responseforBank.getbody());
            Map<String, Object> respbank =(Map<String, Object>)respinst.get('institution');
            string result;
            if(respbank != null){
                result = (string)respbank.get('name');
            }else{
                string errorMessage = (string)respinst.get('errorMessage'); 
                if(errorMessage == 'No primary financial institutions found'){
                    result = 'No banks found!'; 
                }else{
                    UtilityClass.logErrorResp('Lyons Routing Number Validation', 'Web service callout failed!', RoutingNumber , 'Routing # ' + RoutingNumber, errorMessage );
                   	result = null ; 
                }
            }
            system.debug('<<<result>>>>'+result);
            return result;
        }Catch ( Exception e){
            // LOG EXCEPTION IN ERROR LOG OBJECT
            UtilityClass.logErrorResp('Lyons Routing Number Validation', 'Web service callout failed!', RoutingNumber , 'Routing # ' + RoutingNumber, e.getmessage()  );
            return null ;
        }
        return null;
    }
global static String jsonprocessing(String inputJsonResponse, string keyname){
         
     JSONParser parser = JSON.createParser(inputJsonResponse);    
     String fieldvalue= '';
     while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                    while(parser.nextToken() != null){
                        fieldvalue = parser.getText();
                        break;
                    }
                    
                }else if(fieldName == keyname) {
                    fieldvalue = parser.getText();
                }
            }   
     }
    return fieldvalue;
  }
  /* RSS 48414 - REST API method ended*/
}