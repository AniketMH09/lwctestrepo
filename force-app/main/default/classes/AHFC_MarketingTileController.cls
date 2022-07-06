/* Apex Class Name   :    AHFC_MarketingTileController
* @Description        :    This Class is used to retrieve boolean values based on the Marketing Logos criteria .
* Modification Log   :
* --------------------------------------------------------------------------- 
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               Jun 22 2021             Created
* Aniket                             Aug 24 2021             modified
* Narain              			     Jan 11 2022             Modified
*********************************************************************************/
public without sharing class AHFC_MarketingTileController {
    
    /*
    * @author Prabu JUN 25 2021
    * @Method Name : marketingFlagRetrieve
    * @description:  retriving the boolean values based on the Marketing Logos criteria 
    * @param : Finance Account Id
    */
    @AuraEnabled(cacheable = true)
    public static MarketingWrapper marketingFlagRetrieve(String FinanceId){  
        Boolean isHondaAuto = false;
        Boolean isAcuraAuto = false;
        Boolean isMarine = false;
        Boolean isPowerSports = false;
        Boolean isPowerEquipment = false;
        Boolean isHondaEOT = false;
        Boolean isAcuraEOT = false;       
        
        Boolean isAcurafourMthEOT = false;       
        Boolean isHondafourMthEOT = false;   
        
      //  Date lttwelveMth = Date.today().addDays(-365); not in use 

        MarketingWrapper marketingWrap = new MarketingWrapper();        
                        
        List<Finance_Account__c> finAcc = [select id,Honda_Brand__c,Account_Type__c,AHFC_Product_Type__c,Maturity_Date__c,FL_LE_Eligibility__c from Finance_Account__c where id = :FinanceId];
        
        Date todayValue = Date.valueOf(Date.today()); 
      
        Integer daysLefttoMaturity = todayValue.daysBetween(finAcc[0].Maturity_Date__c);//added for RSS 53493 by Narain ltfourMthEOT
 
        
        if(finAcc!=null && !finAcc.isEmpty() && finAcc.size()>0 )
        {
           
             //RSS 53493 start by Narain
             if(finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.HFS && 
                    finAcc[0].AHFC_Product_Type__c == AHFC_GlobalConstans.Auto && 
                    finAcc[0].Account_Type__c == AHFC_GlobalConstans.AcctTypeLease && daysLefttoMaturity < 365 )
            {
                
                
                 if(daysLefttoMaturity <= 120 &&  System.Label.AHFC_Inventory_Shortage_Switch  == 'true')
                {
                   
                     isHondafourMthEOT = true;

                }
                    
                else {
                    isHondaEOT = true;
                }
                
            }
            else if(finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.AFS && finAcc[0].AHFC_Product_Type__c == AHFC_GlobalConstans.Auto
                    && finAcc[0].Account_Type__c == AHFC_GlobalConstans.AcctTypeLease && daysLefttoMaturity < 365 )
            {
               
                 if(daysLefttoMaturity <= 120 &&  System.Label.AHFC_Inventory_Shortage_Switch  == 'true')
                {
                 
                    isAcurafourMthEOT = true;
                }
                else{
                     isAcuraEOT = true;
                }

            }
             
            //RSS 53493 end by Narain

            else if(finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.HFS && finAcc[0].AHFC_Product_Type__c == AHFC_GlobalConstans.Auto 
              /*&& daysLefttoMaturity > 365*/) //bug 25777
               //added for RSS 53493 ltfourMthEOT && daysLefttoMaturity >= 120 
            { 
                 	isHondaAuto = true;
                    
            
            }
            else if(finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.AFS && finAcc[0].AHFC_Product_Type__c == AHFC_GlobalConstans.Auto 
                  /* && daysLefttoMaturity > 365 */) //bug 25777//added for RSS 53493 ltfourMthEOT && daysLefttoMaturity >= 120
             
            {
                isAcuraAuto = true;
                 
            }
            
            else if(finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.HFSP && finAcc[0].AHFC_Product_Type__c == AHFC_GlobalConstans.Marine )
            {
                isMarine = true;
            }
            else if(finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.HFSP && finAcc[0].AHFC_Product_Type__c == AHFC_GlobalConstans.Powersports )
            {
                isPowerSports = true;
            }
                else if(finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.HFSP && finAcc[0].AHFC_Product_Type__c == AHFC_GlobalConstans.PowerEquipment )
            {
                isPowerEquipment = true;
            }
            
            
            else if(finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.HFS && finAcc[0].AHFC_Product_Type__c == 'Other' )
            {
                isHondaAuto = true;
            }
			else if(finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.AFS && finAcc[0].AHFC_Product_Type__c == 'Other' )
            {
               isAcuraAuto = true;
                  
            }
			else if(finAcc[0].Honda_Brand__c == AHFC_GlobalConstans.HFSP && finAcc[0].AHFC_Product_Type__c == 'Other' )
            {
                isPowerSports = true;
            }
            else
            {
                isHondaAuto =false;
                isAcuraAuto =false;
                isMarine = false;
                isPowerSports = false;
                isPowerEquipment=false;
                isHondaEOT =false;
                isAcuraEOT=false;
                isAcurafourMthEOT = false;   //RSS 53493 by Narain    
         		isHondafourMthEOT = false;   //RSS 53493 by Narain
            }
			}
            marketingWrap.finId = finAcc[0].id;
            marketingWrap.hondaAuto = isHondaAuto ;
            marketingWrap.acuraAuto = isAcuraAuto;
            marketingWrap.marine = isMarine;
            marketingWrap.powerSports = isPowerSports;
            marketingWrap.powerEquipment = isPowerEquipment;
            marketingWrap.hondaEOT = isHondaEOT;
            marketingWrap.acuraEOT = isAcuraEOT;
        	marketingWrap.hondafourMthEOT=isHondafourMthEOT;
       		marketingWrap.acurafourMthEOT=isAcurafourMthEOT;
             return marketingWrap; 
        
    }
        
    /*
    * @author Prabu JUN 25 2021
    * @description:  Wrapper class - 
    */
    public without sharing class MarketingWrapper{
        @AuraEnabled
        public String finId {get;set;}
      
        @AuraEnabled
        public Boolean hondaAuto {get;set;}
        @AuraEnabled
        public Boolean acuraAuto {get;set;}        
        @AuraEnabled
        public Boolean marine{get;set;}        
        @AuraEnabled
        public Boolean powerSports{get;set;}
        @AuraEnabled
        public Boolean powerEquipment{get;set;}
        @AuraEnabled
        public Boolean hondaEOT{get;set;}
        @AuraEnabled
        public Boolean acuraEOT{get;set;}
        @AuraEnabled
        public Boolean hondafourMthEOT{get;set;}//RSS 53493 by Narain
        @AuraEnabled
        public Boolean acurafourMthEOT{get;set;}//RSS 53493 by Narain
  
       
    }    
}