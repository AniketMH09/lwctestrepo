public class CIAMRegistration {
    
    public String Email {get;set;}
    
    public String AccountN {get;set;}
       
    public static string encryption(string plainText) {
       system.debug('plainText=='+plainText);
        //Keys & Ids
        string appId = 'production';
        string key = 'Zu5X9w6aVRe0qXT0vXQsUTmVPDxjeZ9W';
        string encryptedText = plainText;
        string CIAMAppIdACU = '0sp2h000000CaVE';
        string returnURL = 'https://www.google.co.in';
        
        
        //Encrypt piece
        Integer iv = Crypto.getRandomInteger();  
        String aesIV = iv.format() + CIAMAppIdACU;
        Blob targetMD5 = Blob.valueOf('MD5String');
        Blob hashmd5 = Crypto.generateDigest('MD5', targetMD5);
        Blob targetSHA256 = Blob.valueOf('MD5String');
        Blob hashSHA256 = Crypto.generateDigest('MD5', targetSHA256);
        Blob key1 = Crypto.generateAesKey(256);
        Blob data = Blob.valueOf(encryptedText);
        Blob encrypted = Crypto.encryptWithManagedIV('AES256', key1, data);
        System.debug(EncodingUtil.convertToHex(encrypted));
        string url = '&r=' + iv + '&RelayState=' + returnURL + '&u=' + EncodingUtil.convertToHex(encrypted) + '&cmpid=' + 'WELCOME' + '&m=' + 'e';
        system.debug('### URL --> ' + url);
        return url;
    }

    public PageReference login() {
        Customer_Finance_Account__c[] cdetails = [select id, Is_Active__c, Finance_Account__r.Finance_Account_Number__c from Customer_Finance_Account__c where Is_Active__c = true and Finance_Account__r.Finance_Account_Number__c =: AccountN];
        //User[] udetails = [select Id, IsActive, Email from User where email =: Email];
        if (cdetails.size() > 0) {
            PageReference rePage = new PageReference('https://www.google.co.in');
            rePage.setRedirect(true);
            return rePage;
        } else {
            
            
            Map<String, string> obj = new Map<String, string>();
			obj.put('PAR3', Email);
			System.debug('PAR3=='+JSON.Serialize(obj));
            //String redirectCIAMURL = encryption(Email+AccountN);
            String redirectCIAMURL = (string)encryption(JSON.Serialize(obj));
            
            System.debug('@@@redirectCIAMURL--> ' + redirectCIAMURL);
           // string ciamurl = 'https://uat-ciam.cs195.force.com/acurafinance/s/login/SelfRegister?app=0sp3p000000k9cQ&'; 
            string ciamurl = 'https://qa-onehonda.cs36.force.com/acurafinance/s/login/SelfRegister?app=0sp2h000000CaVE&'; 
            ciamurl += redirectCIAMURL;
            System.debug('$$$CIAMURL--> ' + ciamurl);
            PageReference rePage = new PageReference(ciamurl);
            system.debug('redirectCIAMURL' + rePage);
            rePage.setRedirect(true);
            return rePage;
        }

    }
}