/* Apex Class Name       :    AHFC_Contact_Page_Controller
*  description           :    This Class is used to get all  details related to Contact Us page
*  Modification Log      :
* ---------------------------------------------------------------------------
*  Developer                   Date                   Description
* --------------------------------------------------------------------------- 
*  ANIKET PHARAKATE             12 Aug 2021               Created 
*/
public without sharing class AHFC_Contact_Page_Controller {
    
    /**
    * @description This method will return branch custom metadata
    * @author Aniket | 12 Aug 2021 
    * @return boolean
    **/
    @AuraEnabled(cacheable=true)
    public static List<AHFC_Branch_Data__mdt> getBranchData(){
        List<AHFC_Branch_Data__mdt> brachList = [SELECT Id,afs_phone__c,branch_cd__c,cust_service_hours__c,phone__c from AHFC_Branch_Data__mdt];
        return brachList;
    }
    /**
     * @description This method will return Error Notification  metadata
     * @author Aniket | 12 Aug 2021 
     * @return boolean
     **/
    @AuraEnabled(cacheable=true)
    public static List<AHFC_Contact_Us_page_Error_State__mdt> getErrorNotification(){
        List<AHFC_Contact_Us_page_Error_State__mdt> errorState = [SELECT Id,AHFC_experiencing_high_call_volume__c from AHFC_Contact_Us_page_Error_State__mdt];
        return errorState;
    }
    
    /**
* @description This method will return address h custom metadata
* @author Aniket | 12 Aug 2021 
* @return boolean
**/
    @AuraEnabled(cacheable=true)
    public static List<AHFC_Contact_Address__mdt> getAddressData(){
        List<AHFC_Contact_Address__mdt> addressList = [SELECT Id,acct_type_cd__c,addr_line1__c,addr_line2__c,branch_addr_type__c,branch_cd__c,city__c,state_cd__c,zip__c from AHFC_Contact_Address__mdt];
        return addressList;
    }
    
    /**
* @description This method will return finance account data
* @author Aniket | 12 Aug 2021 
* @return boolean
**/
    @AuraEnabled(cacheable=true)
    public static List<Finance_Account__c> finData(string finid){
        List<Finance_Account__c> finList = [SELECT Id,Origination_Branch_Code__c,Honda_Brand__c,Account_Type__c,AHFC_Product_Type__c,Finance_Account_Number__c from Finance_Account__c where Id = :finid  limit 1];
        // Start - Record access check - Supriya Chakraborty 11-Nov-2021        
        boolean isUserAuth = UserSecurity.ValidateFinNumberInit(finList[0].Finance_Account_Number__c);        
        if(!isUserAuth){
            throw new AuraHandledException('invalid access');            
        } 
        // End - Record access check - Supriya Chakraborty 11-Nov-2021
        return finList;
    }
    
    
     /**
    * @description This method will return state custom metadata
    * @author Aniket | 20 Aug 2021 
    * @return boolean
    **/
    @AuraEnabled(cacheable=true)
    public static List<AHFC_States__mdt> getStateData(){
        List<AHFC_States__mdt> stateList = [SELECT Id,branch_cd__c,lmc_phone__c,prod_div_cd__c,state_cd__c,zip_begin__c,zip_end__c from AHFC_States__mdt];
        return stateList;
    }
    
    
     
    
}