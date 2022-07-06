/* Apex Class Name   :    aHFC_PayoffCalendarController
    * Description        :    class used by aHFC_PayoffCalendar lwc component to fetch default values required for the components
    * Modification Log   :
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    * Vishnu            		JUN 21 2021             	Created
*********************************************************************************/
public without sharing class AHFC_PayoffCalendarController {

    /**
     * @author Vishnu JUN 21 2021
     * @description method to fetch value from database and assign to wrapper variable and return as value
     * @param recID:Finance_Account__c recId to retrive Finance_Account__c account record values
     * @return object reference : wrapper class financeAccountDetail
	*/
    @AuraEnabled(cacheable=true)
    public static financeAccountDetails fetchFinanceAccountDetails(string recID){
        

        
        list <Finance_Account__c> financeAccList = [Select Id,Honda_Brand__c,AHFC_Product_Type__c,AHFC_Product_Nickname__c,Finance_Account_Number__c,Maturity_Date__c,AHFC_Web_Payoff_Calendar__c,
                                                    Fl_Refinanced__c,Account_Type__c FROM Finance_Account__c Where Id =:recID Limit 1];
      
        // Start - Record access check - Supriya Chakraborty 11-Nov-2021        
        boolean isUserAuth = UserSecurity.ValidateFinNumberInit(financeAccList[0].Finance_Account_Number__c);        
        if(!isUserAuth){
            throw new AuraHandledException('invalid access');            
        } 
        // End - Record access check - Supriya Chakraborty 11-Nov-2021
        
        
        
        financeAccountDetails fad =  new financeAccountDetails();
        fad.accId = recID;
        fad.isAccHappyPath = false;
        fad.isAcc500 = false;
        fad.isAccClosed = false;
        fad.isPayOff = false;
        fad.isPurchase = false;
        fad.isHonda = false;
        fad.isAccTypeBalloon = false;
        boolean FlRefinanced;
        
		//check whether financeAcclist has any record
        //no for loop required since list should have only one record
        if(financeAccList != null && financeAccList.size()>0){
            fad.maturityDate = financeAccList[0].Maturity_Date__c;
            fad.accName = financeAccList[0].AHFC_Product_Nickname__c != null ? financeAccList[0].AHFC_Product_Nickname__c : '';
            fad.accNo = financeAccList[0].Finance_Account_Number__c;
            fad.accType = financeAccList[0].Account_Type__c;
            FlRefinanced = financeAccList[0].Fl_Refinanced__c;
            fad.productType = financeAccList[0].AHFC_Product_Type__c;
            
            if(String.isNotBlank(financeAccList[0].Honda_Brand__c) && financeAccList[0].Honda_Brand__c.equalsIgnoreCase('AFS')){
                fad.isAcura = true;
            } 
            if(String.isNotBlank(financeAccList[0].Honda_Brand__c) && financeAccList[0].Honda_Brand__c.equalsIgnoreCase('HFS')){
                fad.isHonda = true;
            }
            
            if(financeAccList[0].AHFC_Web_Payoff_Calendar__c == AHFC_GlobalConstans.AcctTypeHappyPath){
               fad.isAccHappyPath = true;
            }else if(financeAccList[0].AHFC_Web_Payoff_Calendar__c == AHFC_GlobalConstans.AcctType500){
               fad.isAcc500 = true;
            }
            else if(financeAccList[0].AHFC_Web_Payoff_Calendar__c == AHFC_GlobalConstans.AcctTypeClosed){
               fad.isAccClosed = true;
            }
            
            if((financeAccList[0].Account_Type__c == AHFC_GlobalConstans.AcctTypeBalloon && FlRefinanced) || (financeAccList[0].Account_Type__c == AHFC_GlobalConstans.AcctTypeRetail )){
                 fad.isPayOff = true; 
            }else{
                fad.isPurchase = true;      
                if(financeAccList[0].Account_Type__c == AHFC_GlobalConstans.AcctTypeBalloon){
                    fad.isAccTypeBalloon = true;    
                }
            }
            
        }
        
        return fad;        
    }
	
    /**
     * @author Vishnu JUN 21 2021
     * @description wrapper class for holding default record values
	**/
    public class financeAccountDetails{
        @AuraEnabled public string accId;
        @AuraEnabled public string productType;
        @AuraEnabled public boolean isHonda;
        @AuraEnabled public boolean isAcura;
        @AuraEnabled public string accName;
        @AuraEnabled public string accType;
        @AuraEnabled public boolean isAccHappyPath;
        @AuraEnabled public boolean isAcc500;
        @AuraEnabled public boolean isAccClosed;
        @AuraEnabled public string RecTypName;
        @AuraEnabled public Date maturityDate;
        @AuraEnabled public boolean isPayOff;
        @AuraEnabled public boolean isPurchase;
        @AuraEnabled public boolean isAccTypeBalloon;
        @AuraEnabled public string accNo;
    }
}