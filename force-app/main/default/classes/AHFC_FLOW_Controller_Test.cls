/*=====================================================================
* (c) 2019 Appirio - A Wipro Company, Inc
* Name: AHFC_FLOW_Controller_Test.apex
* Description: Unit Test class for AHFC_FLOW_Controller_Test Apex Controller 
* Created Date: 17th Jan 2019
* Created By: Alla Chaitanya Reddy
*  ===================================================================== */

@isTest
public class AHFC_FLOW_Controller_Test {

    @isTest
    public static void getfinaccnumber() {
       
         profile p = [select id, name from Profile where usertype = 'CspLitePortal' and name =: 'Customer' limit 1];
        //profile p1 = [select id, name from Profile where id =: userinfo.getProfileId()];
        
        //User u = [Select id,username from user where profileId =: UserInfo.getProfileId() and isActive = true limit 1]; 
        User u = [Select id,username from user where userroleId !=null and isActive = true and Profile.name = 'System Administrator'  limit 1];     
        
        Contact con;
        Account ac;
        User user;
        String orgId = UserInfo.getOrganizationId();
        String dateString = 
        String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
       // Account ac = new Account(name ='Grazitti') ;
           // insert ac;       
           /// con = new Contact(LastName ='testCon',AccountId = ac.Id);
           // insert con;
        system.runAs(u){
            
             ac = new Account(Name='Test Account Name');
          insert ac;
         
          con = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
          insert con;
         
          user = new User();
          user.ProfileID = p.id;
          user.EmailEncodingKey = 'ISO-8859-1';
          user.LanguageLocaleKey = 'en_US';
          user.TimeZoneSidKey = 'America/New_York';
          user.LocaleSidKey = 'en_US';
          user.FirstName = 'first';
          user.LastName = 'last';
          user.Username = uniqueName + '@test' + orgId + '.org';   
          user.CommunityNickname = 'testUser123';
          user.Alias = 't1';
          user.Email = uniqueName + '@test' + orgId + '.org';
          user.IsActive = true;
          user.ContactId = con.Id;
         
          insert user;         
            
            // system.assertEquals(p.Id, UserInfo.getProfileId());
           /* u1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, ContactId = con.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
            insert u1; 
            
            cuser = [select id from user where username = 'standarduser@testorg.com' limit 1];  
            */
            
 
        }
        
        Finance_Account__c fAccount = new Finance_Account__c(Finance_Account_Number__c = '00000422318042',Contact__c=con.Id);
            insert fAccount;
            
            Customer_Finance_Account__c cFinanceAcc = new Customer_Finance_Account__c(Finance_Account__c=fAccount.Id,Customer__c=ac.Id);
              insert   cFinanceAcc;

            // insert FA Acccount
            
         //////////////////////////////////////////////// Encrypted Dummy Data
            Encryption_Settings__mdt  EncryptionSetting =  [Select  Encryption_Key__c,Initial_vector__c from Encryption_Settings__mdt where label = :Label.Environment];
            string ekey = EncryptionSetting.Encryption_Key__c;
            string InitialVector = EncryptionSetting.Initial_vector__c;
            Blob key = EncodingUtil.convertFromHex(ekey);
            Blob IV = EncodingUtil.convertFromHex(InitialVector);
            Blob data = Blob.valueOf(fAccount.Finance_Account_Number__c);
            Blob encrypted = Crypto.encrypt('AES256', key, IV, data);
            String b64en= EncodingUtil.base64Encode(encrypted);
            String urlen = EncodingUtil.urlEncode(b64en,'UTF-8');
            system.debug('acc'+urlen);
        //////////////////////////////////////////////////////      
           
        System.runAs(user){
            // Call method to execute
            String Fnumber = AHFC_FLOW_Controller.getFinanceAccountNumber(urlen);
            String Fnumber1 = AHFC_FLOW_Controller.getFinanceAccountNumber('test');
            
            System.assertEquals(fAccount.Finance_Account_Number__c, Fnumber);
            
            System.assertEquals(fAccount.Finance_Account_Number__c, AHFC_FLOW_Controller.SFDecrypt(b64en));
             AHFC_FLOW_Controller.getFinanceAccountNumber('');
        
        } 
    }
    
    @isTest
    public static void getEncryptedValueTest() {
        
        AHFC_CIAM_Encryption_Settings__mdt encryptDetails=AHFC_CIAM_Encryption_Settings__mdt.getInstance('ENCRYPTION_Details');
        
        String DEFAULT_SETTING_NAME = encryptDetails.DEFAULT_SETTING_NAME__c;
        String HASHING_ALGORITH_32BYTE = encryptDetails.HASHING_ALGORITH_32BYTE__c; //generates a 32 byte blob
        String HASHING_ALGORITHM_16BYTE = encryptDetails.HASHING_ALGORITHM_16BYTE__c; //generates a 16 byte blob
        string ENCRYPTION_KEY = encryptDetails.ENCRYPTION_KEY__c;
        string APP_ID = '0sp2h000000CaVE';
        
        Map<String, string> obj = new Map<String, string>();
        obj.put('PAR3', 'supriya.chakraborty@lntinfotech.com');
        
        String value = (string)JSON.Serialize(obj);		        
        Blob data = Blob.valueOf(value);
        
        String iv = string.valueOf(Crypto.getRandomInteger());        
        String aesIV = iv + APP_ID;
                
        blob privateKeyBlob = EncodingUtil.base64Decode(ENCRYPTION_KEY);
        Blob hashedPrivateKey = Crypto.generateDigest(HASHING_ALGORITH_32BYTE, privateKeyBlob);
        
                
        Blob hashedPrivateKey1 = Crypto.generateDigest(HASHING_ALGORITHM_16BYTE,Blob.valueOf(aesIV));
        Blob encryptedBlob = Crypto.encrypt('AES256',hashedPrivateKey,hashedPrivateKey1,data);
        
        String b64en= EncodingUtil.base64Encode(encryptedBlob);
        String urlen = EncodingUtil.urlEncode(b64en,'UTF-8');
       
        
        AHFC_FLOW_Controller.navigationValues objDec = new AHFC_FLOW_Controller.navigationValues(urlen,iv,aesIV);
        objDec = AHFC_FLOW_Controller.getEncryptedValue('supriya.chakraborty@test.com', '0sp2h000000CaVE');
    }
        
}