global class CreateSCRACaseAction {
    public static Map<String, RecordType> SCRARecordTypesMap =  UtilityClass.getRecordTypesMap('Case');
    
    @InvocableMethod(label='Create SCRA Case')
    global static List<CreateCaseActionResult> CreateSCRACaseAction(List<CreateCaseActionRequest> requests) {
        List<CreateCaseActionResult> results = new List<CreateCaseActionResult>();
        for (CreateCaseActionRequest request : requests) {
            results.add(CreateCase(request));
        }
        return results;
    }
    
    public static CreateCaseActionResult CreateCase(CreateCaseActionRequest request) {
        List<case> lstcase = new List<case>();
        String SCRARecordTypeID = SCRARecordTypesMap.get('SCRA Request').Id;
        SYSTEM.DEBUG('SCRA Record tyope' +SCRARecordTypeID);
        case cse= new case();
        cse.AHFC_Account__c =  request.strahfcaccount;
        //cse.AccountId =  '001e000001cD1O3AAK';
        cse.AccountId = System.Label.SCRA_Account_id;
        cse.Authorized_Agent__c =  request.strAuthorizedUser;
        //cse.ContactId =  '003e000001NzFNUAA3';
        cse.ContactId = System.Label.SCRA_Contact_id;
        //cse.Current_State__c =  request.strState;
        
        if (request.strdob !=''  && request.strdob != null) {
            cse.Date_Of_Birth__c =  Date.valueOf(request.strdob);
        }
        cse.Email__c =  request.strEmail;
        cse.First_Name__c =  request.strFirstName;
        cse.Last_4_Of_the_SSN_TIN__c =  request.strssn2;
        cse.Last_Name__c =  request.strLastName;
        //cse.Middle_Name__c =  request.strMiddleName;
        if (request.strPhoneNumber !=''  && request.strPhoneNumber != null){
            String strPhoneNumber = formatphonenumber(request.strPhoneNumber);
            
            cse.Phone__c =  strPhoneNumber;
        }
        
        /*US 26055 Narain start */
        if (request.strSeletedfinanceId !=''  && request.strSeletedfinanceId != null){
           // String strSeletedfinanceIde = formatstrSeletedfinanceId(request.strSeletedfinanceId);
           
            cse.Finance_Account__c =  request.strSeletedfinanceId;
             
        }
        
        /*US 26055  Narain End*/
        cse.Preferred_Contact_Method__c =  request.strCompref;
        cse.RecordTypeId =  SCRARecordTypeID;
        cse.Status =  'New';
        //cse.Street__c =  request.strStreet;
        //cse.Suffix__c =  request.strSuffix;
        cse.Type =  'SCRA Request';
        //cse.city__c =  request.strCity;
        cse.Current_State__c =  request.strState;
        //cse.postalcode__c =  request.strPostalCode;
        cse.Branch_of_Service__c = request.strbranchOfService;
        if(request.strdateOfActiveDuty !=''  && request.strdateOfActiveDuty != null) {
            cse.Date_of_Active_Duty__c =  Date.valueOf(request.strdateOfActiveDuty);
        }

        cse.Are_you_Service_member__c = request.strAreyoutheServiceMember;
        cse.Do_you_have_additional_documentation__c = request.strAdditionalInfo;
        
        insert cse;        
        cse = [SELECT id, CaseNumber FROM Case WHERE Id = :cse.Id];
        CreateCaseActionResult result = new CreateCaseActionResult();
        result.caseId = cse.Id;
        result.caseNumber = cse.CaseNumber;
        system.debug('**** Case created : '+result);
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
        //@InvocableVariable
        //global String strmailaddr;
        @InvocableVariable
        global String strahfcaccount;
        @InvocableVariable
        global String strAHFCCustomer;
        @InvocableVariable
        global String strAccountId;  //label
        @InvocableVariable
        global Boolean strAuthorizedUser;
        @InvocableVariable
        global String strContactId; //label
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
        global String strCity;
        @InvocableVariable
        global String strPostalCode;
        @InvocableVariable
        global String strbranchOfService;
        @InvocableVariable
        global String strdateOfActiveDuty;
        @InvocableVariable
        global String strAreyoutheServiceMember;
        @InvocableVariable
        global String strAdditionalInfo;
         @InvocableVariable
        global String strSeletedfinanceId; //US 26055 Narain
        
    }
    
    global class CreateCaseActionResult {
        @InvocableVariable
        global ID caseId;
        
        @InvocableVariable
        global string caseNumber;
        
    }
    
    
    class CreateCaseActionException extends Exception {}
}