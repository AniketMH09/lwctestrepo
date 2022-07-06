@isTest(SeeAllData=false)
public class SCRA_FLOW_Controller_Test {
    
    public testmethod static void getfinaccnumber() {
       
         profile p = [select id, name from Profile where usertype = 'CspLitePortal' and name =: 'Customer' limit 1];
        Profile adminP = [Select id from Profile where usertype = 'Standard' and name = 'System Administrator' limit 1];
        UserRole adminR = [select id, Name from UserRole where PortalType = 'None' limit 1];
        //profile p1 = [select id, name from Profile where id =: userinfo.getProfileId()];
        
        //User u = [Select id,username from user where profileId =: UserInfo.getProfileId() and isActive = true limit 1]; 
        //User u = [Select id,username from user where userroleId !=null and isActive = true and Profile.name = 'System Administrator'  limit 1];     
        
        User user;
        String orgId = UserInfo.getOrganizationId();
        String dateString = 
        String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        //Contact c = [Select id from Contact where LastName = 'Contact Last Name' limit 1];
        
        User adminU = new User();
        adminU.ProfileId = adminP.id;
        adminU.UserRoleId = adminR.id;
        adminU.EmailEncodingKey = 'ISO-8859-1';
        adminU.LanguageLocaleKey = 'en_US';
        adminU.TimeZoneSidKey = 'America/New_York';
        adminU.LocaleSidKey = 'en_US';
        adminU.FirstName = 'Admin first12';
        adminU.LastName = 'User67';
        adminU.Username = uniqueName + '@test' + orgId + '.org';   
        adminU.CommunityNickname = 'testUser123Admin';
        adminU.Alias = 't1';
        adminU.Email = uniqueName + '@testAdmin' + orgId + '.org';
        adminU.IsActive = true;
        insert adminU;
        
        Finance_Account__c fAccount;
       Customer_Finance_Account__c cFinanceAcc;
        Account ac;
        Contact con;
        // Account ac = new Account(name ='Grazitti') ;
           // insert ac;       
           /// con = new Contact(LastName ='testCon',AccountId = ac.Id);
           // insert con;
          
        system.runAs(adminU){
            
            // ac = new Account(Name='Test Account Name');
          //insert ac;
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
          user.FirstName = 'first12ab';
          user.LastName = 'last1234';
          user.Username = uniqueName + 'ab12@test' + orgId + '.org';   
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
        
       fAccount = new Finance_Account__c(Finance_Account_Number__c = '00000422318042',Contact__c=con.Id);
            insert fAccount;
            
            cFinanceAcc = new Customer_Finance_Account__c(Finance_Account__c=fAccount.Id,Customer__c=ac.Id);
              insert   cFinanceAcc;

             
 
        }
           // insert FA Acccount
            
         //////////////////////////////////////////////// Encrypted Dummy Data
          Encryption_Settings__mdt  EncryptionSetting =  [Select  Encryption_Key__c,Initial_vector__c from Encryption_Settings__mdt where label = :Label.Environment];
        /*Encryption_Settings__mdt  EncryptionSetting =  new Encryption_Settings__mdt();
        	EncryptionSetting.Encryption_Key__c = '14e1d997bf332f01c15fc2f14ccde235b4baf4cfd08ef7a771d9391d6a95e487';
        	EncryptionSetting.Initial_vector__c = 'c83ab487f80dae7423ab544dcb0928da';
        	EncryptionSetting.Label = 'Stage';    
        insert EncryptionSetting;*/
        
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
        Test.startTest();
        	System.runAs(user){
            // Call method to execute
            String Fnumber = SCRA_FLOW_Controller.getFinanceAccountNumber(urlen);
            String Fnumber1 = SCRA_FLOW_Controller.getFinanceAccountNumber('test');
			SCRA_FLOW_Controller.SFDecrypt(b64en);            
            //System.assertEquals(fAccount.Finance_Account_Number__c, Fnumber);
            
             //System.assertEquals(fAccount.Finance_Account_Number__c, SCRA_FLOW_Controller.SFDecrypt(b64en));
             SCRA_FLOW_Controller.getFinanceAccountNumber('');
        Test.stopTest();
        } }
    
    
    
    public testmethod static void getfinaccnumber1() {
       
         profile p = [select id, name from Profile where usertype = 'CspLitePortal' and name =: 'Customer' limit 1];
        Profile adminP = [Select id from Profile where usertype = 'Standard' and name = 'System Administrator' limit 1];
        UserRole adminR = [select id, Name from UserRole where PortalType = 'None' limit 1];
        //profile p1 = [select id, name from Profile where id =: userinfo.getProfileId()];
        
        //User u = [Select id,username from user where profileId =: UserInfo.getProfileId() and isActive = true limit 1]; 
        //User u = [Select id,username from user where userroleId !=null and isActive = true and Profile.name = 'System Administrator'  limit 1];     
        
        User user;
        String orgId = UserInfo.getOrganizationId();
        String dateString = 
        String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        //Contact c = [Select id from Contact where LastName = 'Contact Last Name' limit 1];
        
        User adminU = new User();
        adminU.ProfileId = adminP.id;
        adminU.UserRoleId = adminR.id;
        adminU.EmailEncodingKey = 'ISO-8859-1';
        adminU.LanguageLocaleKey = 'en_US';
        adminU.TimeZoneSidKey = 'America/New_York';
        adminU.LocaleSidKey = 'en_US';
        adminU.FirstName = 'Admin first12';
        adminU.LastName = 'User67';
        adminU.Username = uniqueName + '@test' + orgId + '.org';   
        adminU.CommunityNickname = 'testUser123Admin';
        adminU.Alias = 't1';
        adminU.Email = uniqueName + '@testAdmin' + orgId + '.org';
        adminU.IsActive = true;
        insert adminU;
        
        Finance_Account__c fAccount;
       Customer_Finance_Account__c cFinanceAcc;
        Account ac;
        Contact con;
        // Account ac = new Account(name ='Grazitti') ;
           // insert ac;       
           /// con = new Contact(LastName ='testCon',AccountId = ac.Id);
           // insert con;
          
        system.runAs(adminU){
            
            // ac = new Account(Name='Test Account Name');
          //insert ac;
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
          user.FirstName = 'first12ab';
          user.LastName = 'last1234';
          user.Username = uniqueName + 'ab12@test' + orgId + '.org';   
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
        
       fAccount = new Finance_Account__c(Finance_Account_Number__c = '00000422318042',Contact__c=con.Id);
            insert fAccount;
            
            cFinanceAcc = new Customer_Finance_Account__c(Finance_Account__c=fAccount.Id,Customer__c=ac.Id);
              insert   cFinanceAcc;

             
 
        }
           // insert FA Acccount
            
         //////////////////////////////////////////////// Encrypted Dummy Data
            Encryption_Settings__mdt  EncryptionSetting =  new Encryption_Settings__mdt();
        	EncryptionSetting.Encryption_Key__c = 'be4de1e7b22994f956fcfde6666d6c71fd4b2c6bc89e02d1deeaea3948c00b43';
        	EncryptionSetting.Initial_vector__c = 'd4a7f1ca06153ba3e9f4ea2b8c111151';
        	EncryptionSetting.Label = 'Sandbox';
        
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
        Test.startTest();
        	System.runAs(user){
            // Call method to execute
            String Fnumber = SCRA_FLOW_Controller.getFinanceAccountNumber(urlen);
            String Fnumber1 = SCRA_FLOW_Controller.getFinanceAccountNumber('test');
            SCRA_FLOW_Controller.SFDecrypt(b64en);
            //System.assertEquals(fAccount.Finance_Account_Number__c, Fnumber);
            
             //System.assertEquals(fAccount.Finance_Account_Number__c, SCRA_FLOW_Controller.SFDecrypt(b64en));
             SCRA_FLOW_Controller.getFinanceAccountNumber('');
        Test.stopTest();
        } }
    
    
    
}