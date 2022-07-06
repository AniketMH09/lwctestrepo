public without sharing class POV_Controller {
    @AuraEnabled(cacheable = true)
    public static string getVisualforceOrigin() {
        string visualOrigin = '';
        string baseUrl = URL.getOrgDomainUrl().toExternalForm(); 
        // Expected Format = https://domain.my.salesforce.com
        // Expected Format for DE, Sandbox & Production ORgs = domain--c.visualforce.com
        visualOrigin = baseUrl.split('.my.')[0] + '--c.' + 'visualforce.com';
        return visualOrigin;
    }
}