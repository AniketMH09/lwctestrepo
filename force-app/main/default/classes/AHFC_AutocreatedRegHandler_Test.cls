@isTest
public class AHFC_AutocreatedRegHandler_Test {
	public static testMethod void autocreatedregtest() {
    
        profile pff =[SELECT p.Name,p.Id from Profile p where p.Name='System Administrator' limit 1];
        UserRole portalRole=[Select Id,PortalAccountID from UserRole where PortalType='None' limit 1];
        SamlSsoConfig saml = [Select ID from SamlSsoConfig limit 1];
        Community comm = [Select Id from Community limit 1];
        
        Account a1= new Account();
        a1.Name='Test Account Name';
       	a1.Source_System__c='B2C';
    	insert a1;
        
        Contact con = new Contact();
        con.AccountId=a1.Id;
        con.LastName='myname';
        insert con;
        
    	User u = new User();
    	u.Username='ashok.raparthi@gmail.com';	
   		u.FederationIdentifier='Test';
    	//u.AccountId=a1.Id;
    	u.Email='ashok.raparthi@gmail.com';
    	u.LastName='test';
    	u.TimeZoneSidKey='America/New_York';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='ISO-8859-1';
        u.ProfileId=pff.Id;
        u.LanguageLocaleKey='en_US';
        u.Alias='testt1';  
        u.FirstName='Test234';
       // u.ContactId=con.Id;     
       // u.UserRoleId=portalRole.Id;
    	insert u; 	
    
        
        Map<String, String> attributes =new Map<String,String>{'UserName'=>u.Username,'Email'=>u.Email,'First Name'=>u.FirstName,'Last Name'=>u.LastName,'User.LocaleSidKey'=>u.LocaleSidKey,'User.EmailEncodingKey'=>u.EmailEncodingKey};
        ID samlSsoProviderId = saml.Id;
        ID communityId=comm.Id;
        ID portalId = portalRole.PortalAccountId;
        String federationIdentifier = u.FederationIdentifier;
        ID userId = u.Id;
    	AHFC_AutocreatedRegHandler myObj= new AHFC_AutocreatedRegHandler();
        
       Test.startTest(); 
       		User u1 = myObj.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, 'Test');
        	System.debug('User-->'+u1);
        	System.assertEquals(u1.Email, u.Email, 'Emails should be same');
        	myObj.updateUser(userId, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, 'Test');
       Test.stopTest();
        
    }
}