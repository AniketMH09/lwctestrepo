/*=====================================================================
* (c) 2019 Appirio - A Wipro Company, Inc
* Name: AHFC_PermSetAssigner.apex
* Description: Called from "AHFC_AssignPermSetToProfile" Class that is called from Process Builder "Add to Permission Set"
* Created Date: 6 March 2019
* Created By: Mohit Parnami
*  ===================================================================== */
public class AHFC_PermSetAssigner {
    
    //Method to assign Permission set to given user Profile
    public static void assignPermissionSetToUser(Id userId) {
        try {  
                    Set<String> setPermissionSetName = new Set<String>();
                    // Get current user profile name  
                    User currentUser = [Select Id, ProfileId, Profile.Name From User Where Id =: userId];
                    // Get custom metadata for given user profile name
                    List<AHFC_Permission_Set_For_Profile__mdt> permissionSetForProfile = [ Select MasterLabel, Permission_Set_Name__c, Profile_Name__c 
                                                                                           From AHFC_Permission_Set_For_Profile__mdt
                                                                                           Where Permission_Set_Name__c != null AND
                                                                                           Profile_Name__c = :currentUser.Profile.Name];
                    if(permissionSetForProfile.isEmpty()) {
                        System.debug('=====Profile dont have permission set associated to it === ');
                        return;
                    } 
                    
                    for(String permissionSet : permissionSetForProfile[0].Permission_Set_Name__c.split(',')) {
                        setPermissionSetName.add(permissionSet);
                    }
                                                                                          
                    if(!setPermissionSetName.isEmpty()) {
                        
                       
                        List<PermissionSetAssignment> permSets = new List<PermissionSetAssignment>();
                        // If permission set not assigned then insert permission set
                        for (PermissionSet commPerm : [select Id from PermissionSet where Name IN: setPermissionSetName]) {
                            PermissionSetAssignment permA = new PermissionSetAssignment();
                            permA.PermissionSetId = commPerm.Id;
                            permA.AssigneeId = userId;
                            permSets.add(permA);
                        }
                        //Insert the perm set assignments
                        if(!permSets.isEmpty()){
                            upsert permSets;
                            System.debug('=====Permission set Inserted====');
                        }    
                       
                    }
                    
                }catch(Exception e){
                    createErrorLog();
                    System.debug('=====There is an Error while assigning permissions set ====' + e.getMessage());
                } 
       }
       
       
      @future
      public static void createErrorLog(){  
            ErrorLog__c errorLog = new ErrorLog__c();
            errorLog.ClassName__c = 'AHFC_PermSetAssigner';
            errorLog.ExceptionMsg__c = ' Acura / Honda Knowledge Permission Set not Inserted';
            if(!Test.isRunningTest()) {
                insert errorLog;
            }
      }
  
       
}