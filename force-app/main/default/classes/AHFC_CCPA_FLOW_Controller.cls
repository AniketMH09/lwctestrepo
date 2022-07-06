public without sharing class AHFC_CCPA_FLOW_Controller {
     
     /*
          1.This method will take Encrypted Finance Account Number from URL and Decrypt it into FA Number
          2. It will share the finance account with current contact
    */ 
    @AuraEnabled
    public static string getFinanceAccountNumber(String FNumber){
        
         
         return FNumber; 
    }
     
    // This method will decrypt the Finance Account Number
    
    public static string SFDecrypt(string value) {
             
            // Fetching Encryption setting from custom metadata 
            Encryption_Settings__mdt  EncryptionSetting =  [Select  Encryption_Key__c,Initial_vector__c from Encryption_Settings__mdt where label = :Label.Environment];
            string ekey = EncryptionSetting.Encryption_Key__c;
            string InitialVector = EncryptionSetting.Initial_vector__c;
            
            String decryptedClearText ='';
            try {
               // use decrypt method and return decrypted value
                Blob key = EncodingUtil.convertFromHex(ekey);
                Blob IV = EncodingUtil.convertFromHex(InitialVector);
                
                System.debug('@@@@'+key + '====='+IV);
                Blob encodedEncryptedBlob = EncodingUtil.base64Decode(value);  
                Blob decryptedBlob = Crypto.decrypt('AES256', key , IV,encodedEncryptedBlob);
                
                if(decryptedBlob != null) {
                    decryptedClearText = decryptedBlob.toString();
                }
                System.debug('@@@@$$ '+decryptedClearText);
                //  Create Error log if account number decrypted as null
                if(decryptedClearText == '') {
                    ErrorLog__c errlog = new ErrorLog__c();
                    errlog.ExceptionMsg__c= 'Encrypted finance account Number is invalid';
                    insert errlog;
                }

            }
            catch (Exception ex){
                System.debug('@@@@=== ' + ex.getMessage()); 
                ErrorLog__c errlog = new ErrorLog__c();
                errlog.ExceptionErrorMessage__c= ex.getMessage();
                insert errlog;
                System.debug('decryptedClearText:='+decryptedClearText);
                
                return decryptedClearText;
            }
            System.debug('decryptedClearText='+ decryptedClearText);
            return decryptedClearText; 
     }

    
    
    
    
    
    
}