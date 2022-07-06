/* Apex Class Name       :    AHFC_FinanceAccountTriggerHelper
* (c) LTI
*  @description         :    Handler of Finance Account Trigger Helper
*  Modification Log   :
* ---------------------------------------------------------------------------
*  Developer                   Date                   Description
* --------------------------------------------------------------------------- 
*  Supriya Chakraborty         10 Jul 2021               Created
*/
public with sharing class AHFC_FinanceAccountTriggerHelper {
    public static void populateNickName(List<Finance_Account__c>newList){
                      
        for(Finance_Account__c theFinanceAccount : newList){           
            
            switch on theFinanceAccount.AHFC_Product_Type__c {
                when 'Powersports','Marine','Power Equipment' {
                    if(theFinanceAccount.AHFC_Vehicle_Year__c == NULL && String.isBlank(theFinanceAccount.AHFC_Vehicle_Model__c)){
               			theFinanceAccount.AHFC_Product_Nickname__c = 'Honda';
            		}
                    else if(theFinanceAccount.AHFC_Vehicle_Year__c != NULL && String.isBlank(theFinanceAccount.AHFC_Vehicle_Model__c)){
               			theFinanceAccount.AHFC_Product_Nickname__c =string.valueOf(theFinanceAccount.AHFC_Vehicle_Year__c) + 'Honda';
            		}
                    else if(theFinanceAccount.AHFC_Vehicle_Year__c == NULL && !String.isBlank(theFinanceAccount.AHFC_Vehicle_Model__c)){
               			//theFinanceAccount.AHFC_Product_Nickname__c =string.valueOf(theFinanceAccount.AHFC_Vehicle_Year__c) + 'Honda';
            		}
                }
                when 'Auto' {
                    if(theFinanceAccount.AHFC_Vehicle_Year__c == NULL && String.isBlank(theFinanceAccount.AHFC_Vehicle_Model__c) && String.isBlank(theFinanceAccount.AHFC_Vehicle_Make__c)){
               			//theFinanceAccount.AHFC_Product_Nickname__c = 'My Product'; //confirmation required
            		}
                    else if(theFinanceAccount.AHFC_Vehicle_Year__c == NULL && String.isBlank(theFinanceAccount.AHFC_Vehicle_Make__c)){
               			theFinanceAccount.AHFC_Product_Nickname__c =theFinanceAccount.AHFC_Vehicle_Model__c;
            		}
                    else if(theFinanceAccount.AHFC_Vehicle_Year__c == NULL && String.isBlank(theFinanceAccount.AHFC_Vehicle_Model__c)){
               			theFinanceAccount.AHFC_Product_Nickname__c =theFinanceAccount.AHFC_Vehicle_Make__c;
            		}
                    else if(String.isBlank(theFinanceAccount.AHFC_Vehicle_Make__c) && String.isBlank(theFinanceAccount.AHFC_Vehicle_Model__c)){
               			//Will be populated based on the modelid - confirmation required
                        //theFinanceAccount.AHFC_Product_Nickname__c =string.valueOf(theFinanceAccount.AHFC_Vehicle_Year__c) + 'Honda';
            		}
                }
                when 'Other' {
                    if(theFinanceAccount.AHFC_Vehicle_Year__c == NULL && String.isBlank(theFinanceAccount.AHFC_Vehicle_Model__c) && String.isBlank(theFinanceAccount.AHFC_Vehicle_Make__c)){
               			theFinanceAccount.AHFC_Product_Nickname__c = 'My Product';
            		}
                    else if(theFinanceAccount.AHFC_Vehicle_Year__c == NULL && String.isBlank(theFinanceAccount.AHFC_Vehicle_Make__c)){
               			theFinanceAccount.AHFC_Product_Nickname__c =theFinanceAccount.AHFC_Vehicle_Model__c; // confirmation required
            		}
                    else if(theFinanceAccount.AHFC_Vehicle_Year__c == NULL && String.isBlank(theFinanceAccount.AHFC_Vehicle_Model__c)){
               			theFinanceAccount.AHFC_Product_Nickname__c =theFinanceAccount.AHFC_Vehicle_Make__c; // confirmation required
            		}
                    else if(String.isBlank(theFinanceAccount.AHFC_Vehicle_Make__c) && String.isBlank(theFinanceAccount.AHFC_Vehicle_Model__c)){
               			theFinanceAccount.AHFC_Product_Nickname__c =string.valueOf(theFinanceAccount.AHFC_Vehicle_Year__c); // confirmation required
            		}
                    else if(String.isBlank(theFinanceAccount.AHFC_Vehicle_Make__c)){
               			theFinanceAccount.AHFC_Product_Nickname__c =string.valueOf(theFinanceAccount.AHFC_Vehicle_Year__c) + theFinanceAccount.AHFC_Vehicle_Model__c;
            		}
                    else if(String.isBlank(theFinanceAccount.AHFC_Vehicle_Model__c)){
               			theFinanceAccount.AHFC_Product_Nickname__c =string.valueOf(theFinanceAccount.AHFC_Vehicle_Year__c) + theFinanceAccount.AHFC_Vehicle_Make__c;
            		}
                    else if(theFinanceAccount.AHFC_Vehicle_Year__c == NULL){
               			theFinanceAccount.AHFC_Product_Nickname__c =theFinanceAccount.AHFC_Vehicle_Make__c + theFinanceAccount.AHFC_Vehicle_Model__c;
            		}
                }
                when else {
                    theFinanceAccount.AHFC_Product_Nickname__c = 'My Product';
                }
            }
            
        }
        
             
    }
}