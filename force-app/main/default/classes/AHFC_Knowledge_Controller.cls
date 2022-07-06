// 
// (c) 2018 Appirio, Inc.
//
// Controller class for the lightning component "AHFC_CheckLoginUser" for private knowledge Access 
// 
//
// 01 Feburay 2019     Harish Khatri   Original
//
public without sharing class AHFC_Knowledge_Controller {
    
    // Label Declarations
    static final string HONDA_DOMAIN = Label.HONDA_DOMAIN;
    static final string ACURA_DOMAIN = Label.ACURA_DOMAIN;
    static final string ACURA_GUEST_PROFILE = 'Acura Help Center Profile';
    static final string HONDA_GUEST_PROFILE = 'Honda Help Center Profile';
    public static String currentRequestURL = (Test.isRunningTest()) ? ACURA_DOMAIN : URL.getCurrentRequestUrl().toString();
    
    //The method assign the needed permission set for showing the Honda/Acura Articles and redirect to help home screen for private knowledge
    @AuraEnabled
    public static string checkLoginUser(){
        
        // Variable declarations
        // Declared URL as empty string
        String url = '';
        boolean IsGuestUser = true;
        System.debug('===Current URL is: ' + currentRequestURL); 
        // We need to check the current logged in user profile Where it is Guest OR Customer
        if(currentRequestURL.contains(HONDA_DOMAIN) || currentRequestURL.contains(ACURA_DOMAIN)){
            try{
                IsGuestUser = IsCurrentUserIsGuestUser();
                /* If it is Guest profile then it should redirect to public knowledge */
                if(IsGuestUser) {
                    
                    //Get the permission set Name based on the domain
                    if(currentRequestURL.contains(HONDA_DOMAIN)){
                        url = Label.AHFC_Port + HONDA_DOMAIN;
                    } else if(currentRequestURL.contains(ACURA_DOMAIN)){
                        url = Label.AHFC_Port + ACURA_DOMAIN;
                    }
                }
                /* If it is not Guest user then redirect to private knowledge */
                else if(!IsGuestUser){    
                    if(currentRequestURL.contains(HONDA_DOMAIN)){
                        url = Label.Honda_Private_Knowledge_URL ;
                    } else if(currentRequestURL.contains(ACURA_DOMAIN)){
                        url = Label.Acura_Private_Knowledge_URL ;
                    }
                }
                
            }catch(Exception e){
                
                    ErrorLog__c errorLog = new ErrorLog__c();
                    errorLog.ClassName__c = 'AHFC_Knowledge_Controller';
                    errorLog.ExceptionMsg__c = e.getMessage();
                if(!Test.isRunningTest()){
                    insert errorLog;
                }
            }
        } else{
                try{
                System.debug('===No Acura / Honda domain found==');        
                ErrorLog__c errorLog = new ErrorLog__c();
                errorLog.ClassName__c = 'AHFC_Knowledge_Controller';
                errorLog.ExceptionMsg__c = 'No Acura / Honda domain found';
                if(!Test.isRunningTest()){
                	insert errorLog;
                }
                }catch(Exception e){
                    System.debug('===Error on inserting Error log'); 
                }
            
        }  
        /* If currentRequestURL doesn't contains HONDA_DOMAIN or Acura_DOMAIN, 
         * URL will have empty string as value.*/
        if(url != '')
        {
            return url;
        }
        else{
            return '';
        }
        
        
    }
    // Method to check where current user is Guest user or not
    public static boolean IsCurrentUserIsGuestUser(){
        
        boolean IsGuest = true;
        try{
            String[] ss = new String[]{ Label.AHFC_HondaCommunityPermset, Label.AHFC_AcuraCommunityPermset}; 
            Set<Id> permIds = new Set<Id>();
            List<PermissionSet> CommPerms = [select Id from PermissionSet where name IN: ss];
            for (PermissionSet commPerm : CommPerms) {
                permIds.add(CommPerm.Id);
            }
            //Now see if there are already assignments
            List<PermissionSetAssignment> permSets = [ SELECT Id FROM PermissionSetAssignment WHERE
                                                       PermissionSetId IN :permIds AND AssigneeId =: UserInfo.getUserId() ];
            if(permSets.size() > 0){
                IsGuest = false;
            }
        }catch(Exception e){
            System.debug('=error in IsCurrentUserIsGuestUser=='); 
        }
        return IsGuest;
    }
    
}