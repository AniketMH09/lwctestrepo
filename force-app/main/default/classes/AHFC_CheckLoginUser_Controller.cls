// 
// (c) 2018 Appirio, Inc.
//
// Controller class for the lightning component "AHFC_CheckLoginUser" for private knowledge Access 
// 
//
// 01 Feburay 2019     Harish Khatri   Original
//
public without sharing class AHFC_CheckLoginUser_Controller {
    
    // Label Declarations
    static final string HONDA_DOMAIN = Label.HONDA_DOMAIN;
    static final string ACURA_DOMAIN = Label.ACURA_DOMAIN;
    static final string HONDA_COMMUNITY_PERMSET = Label.AHFC_HondaCommunityPermset;
    static final string ACURA_COMMUNITY_PERMSET = Label.AHFC_AcuraCommunityPermset;
    static final string SESSION_ID = Label.AHFC_SessionID;
    static final string createdbyAHFC = Label.AHFC_CreatedByAHFc;
    public static String currentRequestURL = (Test.isRunningTest()) ? ACURA_DOMAIN : URL.getCurrentRequestUrl().toString();
    
    
    
    //The method assign the needed permission set for showing the Honda/Acura Articles and redirect to help home screen for private knowledge
    @AuraEnabled
    public static string checkLoginUser(){
        
        // Variable declarations
        String permissionSetName = null;
        String url = null;
        try{
        if(currentRequestURL.contains(HONDA_DOMAIN) || currentRequestURL.contains(ACURA_DOMAIN)){
            
            //Get the permission set Name based on the domain
            if(currentRequestURL.contains(HONDA_DOMAIN)) {
                url = Label.AHFC_Port +HONDA_DOMAIN;
                permissionSetName = HONDA_COMMUNITY_PERMSET;
            } else if(currentRequestURL.contains(ACURA_DOMAIN)) {
                url = Label.AHFC_Port + ACURA_DOMAIN;
                permissionSetName = ACURA_COMMUNITY_PERMSET;
            }else {
                System.debug('==URL not set as Acura/Honda===');
            }
            
            
            if(permissionSetName != null) {
                
                try {
                    activatePermissionSet(permissionSetName);
                    
                    }catch(Exception e){
                        createErrorLog();   
                   }
            }else {                
                System.debug('==Permission Set not found===');
            }
            
            
      }else {
          System.debug('==URL not set as Acura/Honda===');
      }
      
      }catch(Exception e){
            createErrorLog();   
            System.debug('==Permission Set not found===');
      }
      
      return url;
    }
    
    
    public static void activatePermissionSet(String permissionSetName){
        
        PermissionSet permissionSetRec = null;
        String sessionId = null;
        String[] ss = new String[]{ Label.AHFC_HondaCommunityPermset, Label.AHFC_AcuraCommunityPermset}; 
        Set<Id> permIds = new Set<Id>();
        // Query the permission set Honda/Acura and Activate permission set for current user based on community 
        // in which customer logged in
        try {
            
            for(PermissionSet pSet : [SELECT Id, Name FROM PermissionSet WHERE name = :permissionSetName LIMIT 1]){
                permissionSetRec = pSet;
            }
            //Get the session id
            if(!Test.isRunningTest()) {
                Map<String, String> sessionManagement = Auth.SessionManagement.getCurrentSession();
                sessionId = sessionManagement.get(SESSION_ID);
            }
            if(!Test.isRunningTest() && (sessionId ==null || permissionSetRec == null)){
                return;
            }
            
            // Check whether permission set assigned to user or not so then it can activated
            List<PermissionSet> CommPerms = [select Id from PermissionSet where name IN: ss];
            for (PermissionSet commPerm : CommPerms) {
                permIds.add(CommPerm.Id);
            }
            
            
            List<PermissionSetAssignment> permSets = [ SELECT Id FROM PermissionSetAssignment WHERE
                                                       PermissionSetId IN :permIds AND AssigneeId =: UserInfo.getUserId() ];
            // If permission set not assigned to user then it cannot be activated so return it    
            if(permSets.size() == 0 && !Test.isRunningTest()){
               System.debug('===Permission set not assigned to Customer==');
               return;
            } 
           
            // Check if there is already param set assigned to same user
            List<SessionPermSetActivation> alreadyExistingSession = [SELECT id,AuthSessionId FROM SessionPermSetActivation 
                                                                     WHERE AuthSessionId =:sessionId];
            // Activate the permission set
            if(alreadyExistingSession == null ||alreadyExistingSession.isEmpty()) {
                SessionPermSetActivation activation = new SessionPermSetActivation();
                activation.AuthSessionId = sessionId;
                activation.PermissionSetId = permissionSetRec.Id;
                activation.Description = createdbyAHFC; 
                insert activation;
                } 
            } catch(Exception e){
                createErrorLog();
            }       
    }
    
    @future
    public static void createErrorLog(){  
            ErrorLog__c errorLog = new ErrorLog__c();
            errorLog.ClassName__c = 'AHFC_CheckLoginUser_Controller';
            errorLog.ExceptionMsg__c = 'Permission Set not Activated';
            if(!Test.isRunningTest()) {
                insert errorLog;
            }
    }
    
    
}