public class AHFC_JIT_CommunityUserUtils {
    
    private class JITException extends Exception {}
    
    
    //Just-in-time provisioning for person accounts and user
    public void handleCreatePersonAccountAndUserJIT(User u, Map<String, String> attributes, String federationIdentifier) {
        System.debug('federationIdentifier=='+federationIdentifier);
        System.debug('attributes=='+attributes);
        
        String FEDID = attributes.get('fedId');
        
        if (federationIdentifier == null || federationIdentifier.trim().length() == 0){
            System.debug('Error - no FEDID found in attributes map');
            throw new JITException('Error - no matching user');
        }
        
        RecordType recType = [SELECT id FROM RecordType WHERE SobjectType = 'Account' AND IsPersonType = True];
        String personActRecId = recType.Id;
        
        String firstName = attributes.get('First Name');
        String lastName = attributes.get('Last Name');
        String email = attributes.get('Email');
        String Phone = attributes.get('phone');
        String userid = attributes.get('userId'); //CIAM USer ID
        /*Account newPersonAccount = new Account(
        RecordTypeID=personActRecId,
        FirstName=firstName,
        LastName=lastName,
        AccountNumber=federationIdentifier,
        PersonEmail=email,
        //Phone=phone,                
        External_Id__c=federationIdentifier);*/
        Account newPersonAccount = new Account();
        newPersonAccount.RecordTypeID =  personActRecId;
        if(firstName !=null){
            newPersonAccount.FirstName =  firstName;
        }
        if(lastName.toLowerCase() =='notavailable'){
            newPersonAccount.lastname = email;
        }else{
            newPersonAccount.lastname = lastName;
        }
        
        newPersonAccount.AccountNumber =  federationIdentifier;
        newPersonAccount.PersonEmail =  email;
        newPersonAccount.External_Id__c =  federationIdentifier;
        
        
        try{   
            insert newPersonAccount;
        } catch(DmlException e) {
            System.debug('Error creating Person Account: FEDID:' + attributes.get('User.FederationIdentifier') + e.getMessage());
        }
        
        Id personContactId = [Select Id, PersonContactId from Account where Id = :newPersonAccount.Id][0].PersonContactId;
        
        System.Debug('New person account created! personaccountid: ' + newPersonAccount.Id + ' person contact id: ' + personContactId);
        
        //community profile id you want to use will have to retrieved from the org
        Profile customerProfile = [select id from Profile where name = 'Customer'];
        Id profileId = customerProfile.Id; 
        
        
        System.Debug('Trying to create user');
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = false;
        
        String firstInitial = '';
        if (firstName == NULL) {
            firstInitial = 'x';
        } else {
            if(firstName.length()>0){
                firstInitial = firstName.substring(0,1);
            }
            
        }
        
        if(lastName.toLowerCase() =='notavailable'){
            u.lastname = email;
            lastname = email;
        }else{
            u.lastname = lastName;
        }       
        
        
        Integer llength = lastName.length();
        if (llength > 7) {
            llength = 7;
        }
        
        u.alias = firstInitial + lastName.substring(0,llength);
        system.debug('email=='+email);
        u.email = email;
        
        if(firstName!=null){
            u.firstname = firstName;
        }
        
        
        
        //u.username = email.replace('.com', 'hondatest.com');
        u.username = email + '.' + federationIdentifier;
        u.FederationIdentifier = federationIdentifier;
        u.profileId = profileId;
        u.contactId = personContactId;
        u.AHFC_CIAM_SF_User_Id__c = userid;
        /*u.languagelocalekey = 'en_US';
        u.emailencodingkey = 'UTF-8';
        u.localesidkey = 'en_US';
        u.timezonesidkey = 'America/New_York';*/
        
        
        String uid = UserInfo.getUserId();
        User currentUser = 
            [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
        if(attributes.containsKey('User.LocaleSidKey')) {
            u.LocaleSidKey = attributes.get('User.LocaleSidKey');
        } else {
            u.LocaleSidKey = currentUser.LocaleSidKey;
        }
        if(attributes.containsKey('User.LanguageLocaleKey')) {
            u.LanguageLocaleKey = attributes.get('User.LanguageLocaleKey');
        } else {
            u.LanguageLocaleKey = currentUser.LanguageLocaleKey;
        }
        if(attributes.containsKey('User.EmailEncodingKey')) {
            u.EmailEncodingKey = attributes.get('User.EmailEncodingKey');
        } else {
            u.EmailEncodingKey = currentUser.EmailEncodingKey;
        }
        
        if(attributes.containsKey('User.timezonesidkey')) {
            u.timezonesidkey = attributes.get('User.timezonesidkey');
        } else {
            u.timezonesidkey = currentUser.timezonesidkey;
        }
        
        
        
        u.setOptions(dmo);
        System.Debug('create user end');
    }
    
    //updates person account user for email/phone/first name/last name changes
    public void handleUpdatePersonAccountUserJIT(User u, Map<String, String> attributes, String federationIdentifier){
        String fedId = attributes.get('fedId');
        system.debug('==user=='+u);
        
        if (federationIdentifier == null || federationIdentifier.length() == 0){
            return;
        }
        
        boolean updatePermSets = false;
        List<Account> currentAccount;
        List<User> currentUser = [select id, accountid from User where Id =: u.Id];
        system.debug('==currentUser=='+currentUser);
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = false;
        
        if(currentUser.size()>0){
            currentAccount = [SELECT Id, FirstName, LastName, PersonEmail, PersonContactId FROM Account WHERE Id =:currentUser[0].accountid];
            system.debug('==currentAccount=='+currentAccount);
        }        
        
        if (currentAccount.size() == 0)
            return;
        
        
        String firstName = attributes.get('First Name');
        system.debug('==firstName=='+firstName);
        if(firstName != null){
            u.firstname = firstName;
            currentAccount[0].FirstName = firstName;
        }
        
        String email = attributes.get('Email');
        system.debug('==email=='+email);
        if(email !=null){
            u.email = email;
            currentAccount[0].PersonEmail = email;
        }
        
        String lastName = attributes.get('Last Name');
        system.debug('==lastName=='+lastName);
        if(lastName.toLowerCase() =='notavailable'){
            u.lastname = email;
            currentAccount[0].LastName = email;
            lastname = email;
        }else{
            u.lastname = lastName;
            currentAccount[0].LastName = lastName;
        } 
        
        
        update currentAccount;
        system.debug('Account update successful==');
        
        u.setOptions(dmo);  
        update u;
        system.debug('User update successful==');
        
    }
    
    
}