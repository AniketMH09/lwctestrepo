/*=====================================================================
* (c) 2019 Appirio - A Wipro Company, Inc
* Name: AHFC_AssignPermSetToProfile.apex
* Description: Called from Process Builder "Add to Permission Set"
* Created Date: 6 March 2019
* Created By: Mohit Parnami
*  ===================================================================== */
public class AHFC_AssignPermSetToProfile {
    //Method to assign Permission set to Custom Profile
	@InvocableMethod
    public static void assignPermissionSet(List<Id> userId) {
        if(!userId.isEmpty()) {
            AHFC_PermSetAssigner.assignPermissionSetToUser(userId[0]);
        }
    }
}