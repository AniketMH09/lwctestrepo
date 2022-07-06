public class Sample { 
    public String Email { get; set; }
    public String AccountN { get; set; }
    public static String encryption(String plainText){
    	string appId = 'production';
        string key = 'Zu5X9w6aVRe0qXT0vXQsUTmVPDxjeZ9W';
        string encryptedText = plainText;
        String CIAMAppId = '0sp3p000000k9cQ';
		Integer iv = Crypto.getRandomInteger(); //Integer.valueof(Math.random());
        String aesIV = iv.format() + CIAMAppId;
        Blob targetMD5 = Blob.valueOf('ExampleMD5String');
		Blob hashmd5 = Crypto.generateDigest('MD5', targetMD5);
        Blob targetSHA256 = Blob.valueOf('ExampleMD5String');
		Blob hashSHA256 = Crypto.generateDigest('MD5', targetSHA256);
        Blob key1 = Crypto.generateAesKey(256);
        //String Dencry = String.valueOf(Email);
        Blob data = Blob.valueOf('varsha.patel@lntinfotech.com' + '00000400412590');
		Blob encrypted = Crypto.encryptWithManagedIV('AES256', key1, data);
        //String algorithmName = 'RSA-SHA256';
		//String key2 = '';
		//Blob privateKey = EncodingUtil.base64Decode(key2);
		//Blob input = Blob.valueOf('ExampleMD5String');
		//Crypto.sign(algorithmName, input, privateKey);
        return 'r=' + iv + '&u=' + encrypted;
    }
    
    public PageReference login() {
        Customer_Finance_Account__c[]  cdetails = [select id, Is_Active__c, Finance_Account__r.Finance_Account_Number__c from Customer_Finance_Account__c where Is_Active__c = true and Finance_Account__r.Finance_Account_Number__c =: AccountN];
        User[] udetails = [select Id, IsActive, Email from User where email =: Email];
        if(udetails.size() > 0 && cdetails.size() > 0){
            PageReference rePage = new PageReference('https://www.google.co.in');
            /*
            String redirectCIAMURL = encryption('ExampleMD5String');
            PageReference rePage = new PageReference('https://uat-ciam.cs195.force.com/acurafinance/s/login/SelfRegister?app=0sp3p000000k9cQ&'+redirectCIAMURL);
        	system.debug('redirectCIAMURL' + rePage);*/
        	rePage.setRedirect(true);
        	return rePage;
        }else{
            String redirectCIAMURL = encryption('ExampleMD5String');
            PageReference rePage = new PageReference('https://uat-ciam.cs195.force.com/acurafinance/s/login/SelfRegister?app=0sp3p000000k9cQ&'+redirectCIAMURL);
        	system.debug('redirectCIAMURL' + rePage);
            rePage.setRedirect(true);
        	return rePage;
        }
        
    }
}