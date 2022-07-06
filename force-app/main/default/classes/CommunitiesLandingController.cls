/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
    //String startUrl = System.currentPageReference().getParameters().get('eUserIdent');
    //system.debug('@@@startUrl --> ' + startUrl);
        return Network.communitiesLanding();
    }
    
    public CommunitiesLandingController() {}
}