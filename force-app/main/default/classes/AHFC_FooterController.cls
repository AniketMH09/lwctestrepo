public class AHFC_FooterController {
    @AuraEnabled
    public static map<string, string> getFooterLinks(){
        map<string, string> footerLinks = new map<string, string>();
        footerLinks.put('HONDA_DOMAIN', System.Label.HONDA_DOMAIN);
        footerLinks.put('ACURA_DOMAIN', System.Label.ACURA_DOMAIN);
        footerLinks.put('AHFC_About_Us_URL_Honda', System.Label.AHFC_About_Us_URL_Honda);
        footerLinks.put('AHFC_About_Us_URL_Acura', System.Label.AHFC_About_Us_URL_Acura);
        footerLinks.put('AHFC_Contact_Us_URL_Honda', System.Label.AHFC_Contact_Us_URL_Honda);
        footerLinks.put('AHFC_Contact_Us_URL_Acura', System.Label.AHFC_Contact_Us_URL_Acura);
        footerLinks.put('AHFC_Privacy_Policy_URL_Honda', System.Label.AHFC_Privacy_Policy_URL_Honda);
        footerLinks.put('AHFC_Privacy_Policy_URL_Acura', System.Label.AHFC_Privacy_Policy_URL_Acura);
        footerLinks.put('AHFC_Terms_And_Conditions_URL_Honda', System.Label.AHFC_Terms_And_Conditions_URL_Honda);
        footerLinks.put('AHFC_Terms_And_Conditions_URL_Acura', System.Label.AHFC_Terms_And_Conditions_URL_Acura);
        footerLinks.put('AHFC_DNS_URL_Honda', System.Label.AHFC_DNS_URL_Honda);
        footerLinks.put('AHFC_DNS_URL_Acura', System.Label.AHFC_DNS_URL_Acura);
        footerLinks.put('AHFC_Footer', System.Label.AHFC_Footer);
        //String startdate = '2019-12-12 11:00:00';
      String startdate =  System.Label.CCPA_START_TIME;
        Datetime startdatetime = Datetime.valueOfGMT(startdate);
       system.debug('startdatetime : ' + startdatetime);
       // Datetime startdatetime2 = Datetime.valueOf(startdate);
        //system.debug('startdatetime : ' + startdatetime2);
        Datetime CurrentDateTime = System.now();
        system.debug(CurrentDateTime);
        if (CurrentDateTime > startdatetime) {
            footerLinks.put('AHFC_New_Footer','Y');
        }
        else {
            footerLinks.put('AHFC_New_Footer','N');
        }
        system.debug(footerLinks.get('AHFC_New_Footer'));
         
        
        
        
        return footerLinks;
    }
}