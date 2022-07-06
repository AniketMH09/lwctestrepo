/*=====================================================================
* (c) 2018 Appirio - A Wipro Company, Inc
* Name: AHFC_Lease_Extension_Flow_Controller.apex
* Description: Apex controller class for AHFC_Lease_Extension_Flow Lightning Component
* Created Date: 10th Jan 2019
* Created By: Naveen Pilla
*  ===================================================================== */


public without sharing class AHFC_FLOW_Controller {
    
    /*
1.This method will take Encrypted Finance Account Number from URL and Decrypt it into FA Number
2. It will share the finance account with current contact
*/ 
    
    @AuraEnabled
    public static string getFinanceAccountNumber(String FNumber){
        // Decode value
        FNumber = EncodingUtil.urlDecode(FNumber, 'UTF-8');  
        // Decrypt the Encrypted FA Number        
        FNumber =  FNumber.replaceAll('\\s','+');
        FNumber = SFDecrypt(FNumber); 
        
        Boolean isValiduser = false;
        string contactId = null;
        String accountId = null;
        Finance_Account__c FinanceAccount = null;
        boolean isUpdate = false;
        
        /*
We need to store contact (in backend) on Finance Account so Finance acount and chargent orders (which are used in flow)
can be shared with logged in with customer via sharing set.
*/
        
        // Get current community user's contactID
        for(User user : [Select Id, contactID,contact.AccountId from User Where Id = :UserInfo.getUserId()]){
            contactId = user.contactID;
            if(user.contactId != null) {
                accountId = user.contact.AccountId;
            }
        }
        if(FNumber == '') {
            return FNumber;
        }
        // Get Finance Account which needs to be shared with customer via sharing set
        
        for(Finance_Account__c fAccount : [ Select Id, Customer__c, Contact__c, Finance_Account_Number__c from Finance_Account__c 
                                           Where Finance_Account_Number__c = :FNumber ]){
                                               //  SYSTEM.DEBUG('Finance_Account_Number__c-->'+fAccount.Finance_Account_Number__c);
                                               FinanceAccount = fAccount;
                                               if(fAccount.Contact__c != contactId){
                                                   fAccount.Contact__c =  contactId;
                                                   isUpdate = true;
                                               }
                                           }
        
        
        if(FinanceAccount == null){
            return '';
        }
        //fetching the customer finance accounts to check for valid user.
        
        for(Customer_Finance_Account__c cFinanceAcc: [SELECT id,Finance_Account__c,Customer__c FROM Customer_Finance_Account__c
                                                      WHERE Finance_Account__c =: FinanceAccount.Id]) {
                                                          
                                                          if(cFinanceAcc.Customer__c == accountId) {
                                                              isValidUser = True;
                                                          }
                                                          
                                                      }
        
        
        //not valid user show the contact us screen
        if(!isValidUser) {
            
            FNumber =  'INVALID_USER';
            return FNumber;
        }
        // Update contact on finance account if there is contact changed
        try{  
            if(isUpdate) {
                update FinanceAccount;                
            }
            
        }catch(Exception e){
            System.debug('Error while updating Finance Account===='+e.getMessage()); 
        }
        
        return FNumber;
    }
    
    // This method will decrypt the Finance Account Number
    
    @AuraEnabled
    public static string SFDecrypt(string value) {
        string encaValue='';
        // Fetching Encryption setting from custom metadata 
        Encryption_Settings__mdt  EncryptionSetting =  [Select  Encryption_Key__c,Initial_vector__c from Encryption_Settings__mdt where label = :Label.Environment];
        string ekey = EncryptionSetting.Encryption_Key__c;
        string InitialVector = EncryptionSetting.Initial_vector__c;
        
        String decryptedClearText ='';
        try {
            // use decrypt method and return decrypted value
            Blob key = EncodingUtil.convertFromHex(ekey);
            Blob IV = EncodingUtil.convertFromHex(InitialVector);
            
            
            encaValue = EncodingUtil.urlDecode(value, 'UTF-8');  
            encaValue =  encaValue.replaceAll('\\s','+');
            
            Blob encodedEncryptedBlob = EncodingUtil.base64Decode(encaValue);  
            Blob decryptedBlob = Crypto.decrypt('AES256', key , IV,encodedEncryptedBlob);
            
            if(decryptedBlob != null) {
                decryptedClearText = decryptedBlob.toString();
            }
            
            //  Create Error log if account number decrypted as null
            if(decryptedClearText == '') {
                ErrorLog__c errlog = new ErrorLog__c();
                errlog.ExceptionMsg__c= 'Encrypted finance account Number is invalid';
                insert errlog;
            }
            
        }
        catch (Exception ex){            
            
            ErrorLog__c errlog = new ErrorLog__c();
            errlog.ExceptionErrorMessage__c= ex.getMessage();
            insert errlog;
            System.debug('decryptedClearText:='+decryptedClearText);
            
            return decryptedClearText;
        }
        
        return decryptedClearText; 
    }
    //Supriya Chakraborty - LTI - 8-Sep-2021
    //This method will take email address and app id as parameter and will encrypt it. 
    //This value will be used in CIAM registration
    @AuraEnabled
    public static navigationValues getEncryptedValue(string email, string appId){
    
        AHFC_CIAM_Encryption_Settings__mdt encryptDetails=AHFC_CIAM_Encryption_Settings__mdt.getInstance('ENCRYPTION_Details');
        
        String DEFAULT_SETTING_NAME = encryptDetails.DEFAULT_SETTING_NAME__c;
        String HASHING_ALGORITH_32BYTE = encryptDetails.HASHING_ALGORITH_32BYTE__c; //generates a 32 byte blob
        String HASHING_ALGORITHM_16BYTE = encryptDetails.HASHING_ALGORITHM_16BYTE__c; //generates a 16 byte blob
        string ENCRYPTION_KEY = encryptDetails.ENCRYPTION_KEY__c;
        string APP_ID = appId;
        
        Map<String, string> obj = new Map<String, string>();
		obj.put('PAR3', email);        
        String value = (string)JSON.Serialize(obj);       
        
        string iv = string.valueOf(Crypto.getRandomInteger())  ;
        String aesIV = iv + APP_ID;
        Blob data = Blob.valueOf(value);
       
        blob privateKeyBlob = EncodingUtil.base64Decode(ENCRYPTION_KEY);
		Blob hashedPrivateKey = Crypto.generateDigest(HASHING_ALGORITH_32BYTE, privateKeyBlob);

		Blob hashedPrivateKey1 = Crypto.generateDigest(HASHING_ALGORITHM_16BYTE,Blob.valueOf(aesIV));
		Blob encryptedBlob = Crypto.encrypt('AES256',hashedPrivateKey,hashedPrivateKey1,data);

        String b64en= EncodingUtil.base64Encode(encryptedBlob);
        String urlen = EncodingUtil.urlEncode(b64en,'UTF-8');
        
        navigationValues navValues = new navigationValues(urlen,iv,aesIV);
        return navValues;
    }
    
    Public class navigationValues{
        @AuraEnabled public string encryptedUrl;
        @AuraEnabled public string encryptedRandomNumber;
        @AuraEnabled public string aesIV;
        public navigationValues(string urlen,string iv,string aesIVValue){
            encryptedUrl = urlen;    
            encryptedRandomNumber = iv;
            aesIV = aesIVValue;
        }
        
    }    
    
    
    
    
}