//This class provides logic for inbound just-in-time provisioning of single sign-on users in your Salesforce organization.
global class AHFC_AutocreatedRegHandler implements Auth.SamlJitHandler {
  
  private class JitException extends Exception{}

  private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId,
    String federationIdentifier, Map<String, String> attributes, String assertion) {
    system.debug('federationIdentifier --> ' + federationIdentifier);
    system.debug('attributes --> ' + attributes);
        
        if (create ){
            System.Debug('In create for Community user');            
            AHFC_JIT_CommunityUserUtils utils = new AHFC_JIT_CommunityUserUtils();
            utils.handleCreatePersonAccountAndUserJIT(u, attributes,federationIdentifier);
        }
        else{
            AHFC_JIT_CommunityUserUtils utils = new AHFC_JIT_CommunityUserUtils();
            utils.handleUpdatePersonAccountUserJIT(u, attributes,federationIdentifier);
            System.Debug('In update for Community user');
        }
  }

  global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
   String federationIdentifier, Map<String, String> attributes, String assertion) {
    User u = new User();
    handleJit(true, u, samlSsoProviderId, communityId, portalId,
    federationIdentifier, attributes, assertion); 
    return u;
  }

  global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
    String federationIdentifier, Map<String, String> attributes, String assertion) {
    User u = [SELECT Id, FirstName, ContactId FROM User WHERE Id=:userId];
    handleJit(false, u, samlSsoProviderId, communityId, portalId,
      federationIdentifier, attributes, assertion); 
  }
    
}