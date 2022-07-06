public class CiamRegistrationTest {
    
    public void GenerateValue(){
        String DEFAULT_SETTING_NAME = 'Default';
    String HASHING_ALGORITH_32BYTE = 'SHA-256'; //generates a 32 byte blob
    String HASHING_ALGORITHM_16BYTE = 'MD5'; //generates a 16 byte blob
    string ENCRYPTION_KEY = 'Zu5X9w6aVRe0qXT0vXQsUTmVPDxjeZ9W';
    string APP_ID = '0sp2h000000CaVE';
    
    Map<String, string> obj = new Map<String, string>();
    
    obj.put('PAR3', 'supriya.chakraborty@lntinfotech.com');
    //string value  ='{"PAR3":supriya.chakraborty@lntinfotech.com}'; // (string)JSON.Serialize(obj);
    String value = (string)JSON.Serialize(obj);                              
    system.debug('data=='+value);
    Blob data = Blob.valueOf(value);
    
    String iv = string.valueOf(Crypto.getRandomInteger());
    system.debug('IV=='+iv);
    String aesIV = iv + APP_ID;
    system.debug('aesIV=='+aesIV);
    
    blob privateKeyBlob = EncodingUtil.base64Decode(ENCRYPTION_KEY);
    Blob hashedPrivateKey = Crypto.generateDigest(HASHING_ALGORITH_32BYTE, privateKeyBlob);
    
    
    //Blob hashedPrivateKey = Crypto.generateDigest(HASHING_ALGORITHM_16BYTE,Blob.valueOf(aesIV));
    //Blob encryptedBlob = Crypto.encrypt('AES256',Blob.valueOf(ENCRYPTION_KEY),hashedPrivateKey,data);
    
    Blob hashedPrivateKey1 = Crypto.generateDigest(HASHING_ALGORITHM_16BYTE,Blob.valueOf(aesIV));
    Blob encryptedBlob = Crypto.encrypt('AES256',hashedPrivateKey,hashedPrivateKey1,data);
    
    String b64en= EncodingUtil.base64Encode(encryptedBlob);
    String urlen = EncodingUtil.urlEncode(b64en,'UTF-8');
    system.debug('urlen=='+urlen);
    
    
    ////Decryption 
    //String DEFAULT_SETTING_NAME = 'Default';
    //String HASHING_ALGORITH_32BYTE = 'SHA-256'; //generates a 32 byte blob
    //String HASHING_ALGORITHM_16BYTE = 'MD5'; //generates a 16 byte blob
    //string ENCRYPTION_KEY = 'Zu5X9w6aVRe0qXT0vXQsUTmVPDxjeZ9W';
    //string APP_ID = '0sp2h000000CaVE';
    //string r = '1952702988';
    //String iv = r + APP_ID;  //'19527029880sp2h000000CaVE';
    
    string value2=urlen; //'1fWcEZrBqUNKNZMbtUWijYCjuQbqcIwOxUajK6O0lA4mYY8996OTs85s2bF7TDxe';
    
    blob privateKeyBlob2 = EncodingUtil.base64Decode(ENCRYPTION_KEY);
    Blob hashedPrivateKey2 = Crypto.generateDigest(HASHING_ALGORITH_32BYTE, privateKeyBlob2);
    
    
    string finalValue = EncodingUtil.urlDecode(value2, 'UTF-8');  
    finalValue =  finalValue.replaceAll('\\s','+');
    
    Blob data2 = EncodingUtil.base64Decode(finalValue);       
    Blob hashedIV = Crypto.generateDigest(HASHING_ALGORITHM_16BYTE,Blob.valueOf(aesIV));
    Blob decryptedBlob = Crypto.decrypt('AES256',hashedPrivateKey2,hashedIV,data2);
    system.debug('decryptedBlob=='+ decryptedBlob.toString());
    
    string CIAMURL = 'https://qa-onehonda.cs36.force.com/acurafinance/s/login/SelfRegister?app=' + APP_ID + '&r='+ iv + '&RelayState=%2Fcustomer%2Fs%2Fadd-a-finance-account%3Fencea%3DEKHDKIJVLOYnfMUZetaY7PpFpsvLoIrcRSkpF7Ql%2FsUiPfS8AOPvN9CvcJpC7Ari&u=' + value2 + '&cmpid=WELCOME&brand=acura&m=e';
    system.debug ('CIAMURL===>' + CIAMURL);
    }
    
    
    
}