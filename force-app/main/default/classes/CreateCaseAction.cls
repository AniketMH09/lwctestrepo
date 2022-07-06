global class CreateCaseAction {
    @InvocableMethod(label='Create Case')
    global static List<CreateCaseActionResult> CreateCases(List<CreateCaseActionRequest> requests) {
        List<CreateCaseActionResult> results = new List<CreateCaseActionResult>();
        for (CreateCaseActionRequest request : requests) {
            results.add(CreateCase(request));
        }
        return results;
    }
     
    public static CreateCaseActionResult CreateCase(CreateCaseActionRequest request) {
        List<case> lstcase = new List<case>();
        String NewCaseId = '';
        String CCPARecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CCPA').getRecordTypeId();
        SYSTEM.DEBUG( CCPARecordTypeID);
        case cse= new case();
        cse.AHFC_Account__c =  request.strahfcaccount;
        if (request.strAHFCCustomer == 'Yes') cse.AHFC_Customer__c = true ;
        else       cse.AHFC_Customer__c = false;
        
        cse.Authorized_Agent__c =  request.strAuthorizedUser;
        
        cse.Current_State__c =  request.strState;
        string profileName = AHFC_DashboardController.getProfileName();
        if(String.isNotBlank(profileName) && profileName.equals('Customer')){
             List<User> lstUser = [SELECT contactid, accountId from User where id=: Userinfo.getUserid()];
            
             if(!lstUser.isEmpty() && lstUser[0].accountId != null){
                cse.AccountId = lstUser[0].accountId;
             }
             if(!lstUser.isEmpty() && lstUser[0].contactid != null){
                cse.ContactId = lstUser[0].contactid;
             }  
        }else {
            cse.AccountId =  request.strAccountId;
            cse.ContactId =  request.strContactId;
        }
        
        if (request.strdob !=''  && request.strdob != null) cse.Date_Of_Birth__c =  Date.valueOf(request.strdob);
        cse.Email__c =  request.strEmail;
        cse.First_Name__c =  request.strFirstName;
        cse.Honda_Acura_Care__c =  request.strContract;
        cse.Last_4_Of_the_SSN_TIN__c =  request.strssn2;
        cse.Last_Name__c =  request.strLastName;
        cse.Middle_Name__c =  request.strMiddleName;
        cse.Origin =  request.strOrigin;
        if (request.strPhoneNumber !=''  && request.strPhoneNumber != null){
            String strPhoneNumber = formatphonenumber(request.strPhoneNumber);
            
            cse.Phone__c =  strPhoneNumber;
        }
        cse.Preferred_Contact_Method__c =  request.strCompref;
        cse.RecordTypeId =  CCPARecordTypeID;
        cse.Salutation__c =  request.strSalutation;
        cse.Serial_No__c =  request.Serial_No;
        cse.Status =  'New';
        cse.Street__c =  request.strStreet;
        cse.Suffix__c =  request.strSuffix;
        cse.Type =  request.strCaseType;
        cse.VIN__c =  request.strVIN;
        cse.city__c =  request.strCity;
        cse.country__c =  request.strCountry;
        cse.postalcode__c =  request.strPostalCode;
        cse.Mailing_Address__c = request.strmailaddr;
        
        insert cse;
        NewCaseId = cse.Id;
        
        cse = [SELECT id, CaseNumber FROM Case WHERE Id = :cse.Id];
        CreateCaseActionResult result = new CreateCaseActionResult();
        result.caseId = cse.Id;
        result.caseNumber = cse.CaseNumber;
        
        return result;
        
        
        
        
    }
    
    public static String formatphonenumber(String cphone) {
        String fphone = cphone.replaceAll('\\D','');
        
        if (fphone.length() == 10) {
            fphone = formatphonenum(fphone);
            return fphone;
        }
        else {
            return cphone;
        }
        
    }
    
    static String formatphonenum (String s) {
        s = '(' + s.substring(0, 3) + ') ' + s.substring(3, 6) + '-' + s.substring(6);
        return s;
    }
    
    global class CreateCaseActionRequest {
        @InvocableVariable
        global String strmailaddr;
        @InvocableVariable
        global String strahfcaccount;
        @InvocableVariable
        global String strAHFCCustomer;
        @InvocableVariable
        global String strAccountId;
        @InvocableVariable
        global Boolean strAuthorizedUser;
        @InvocableVariable
        global String strContactId;
        @InvocableVariable
        global String strState;
        @InvocableVariable
        global String strdob;
        @InvocableVariable
        global String strEmail;
        @InvocableVariable
        global String strFirstName;
        @InvocableVariable
        global String strContract;
        @InvocableVariable
        global String strssn2;
        @InvocableVariable
        global String strLastName;
        @InvocableVariable
        global String strMiddleName;
        @InvocableVariable
        global String strOrigin;
        @InvocableVariable
        global String strPhoneNumber;
        @InvocableVariable
        global String strCompref;
        @InvocableVariable
        global String strCaseRecordTypeId;
        @InvocableVariable
        global String strSalutation;
        @InvocableVariable
        global String Serial_No;
        @InvocableVariable
        global String strStreet;
        @InvocableVariable
        global String strSuffix;
        @InvocableVariable
        global String strCaseType;
        @InvocableVariable
        global String strVIN;
        @InvocableVariable
        global String strCity;
        @InvocableVariable
        global String strCountry;
        @InvocableVariable
        global String strPostalCode;
        
    }
    
    global class CreateCaseActionResult {
        @InvocableVariable
        global ID caseId;
        
        @InvocableVariable
        global string caseNumber;
        
    }
    
    
    class CreateCaseActionException extends Exception {}
}