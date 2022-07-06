global class CheckEligibility {
    @InvocableMethod(label='CheckPymt Ext Eligibility')
    global static List<CheckExtEligibilityResult> CheckPymtExtEligibility(List<String> lstfinid) {
        list<CheckExtEligibilityResult> results = new list<CheckExtEligibilityResult>();
        date matdatecheck = (date.today()).adddays(60);
        system.debug('matdatecheck =>' + matdatecheck);
        String caseType = System.Label.AHFC_PE_Case_Type;
        String caseTitle = System.Label.AHFC_PE_Case_Title;
        
        
        map<id,finance_account__c> finmap = new map<id,finance_account__c>([Select id, 
                                                                            Region_Code__c,
                                                                            Account_Type__c,
                                                                            Maturity_Date__c
                                                                            from finance_account__c where
                                                                            id in :lstfinid
                                                                            and account_type__c in ('Retail','Lease')                                       
                                                                            and Region_Code__c in ('101', '102', '103', '104', '105', '106', '107', '108', '109', 'LMC')
                                                                            and Maturity_Date__c >= :matdatecheck
                                                                           ]);
        
        map<id,finance_account__c> finezpaymap = new map<id,finance_account__c>([Select id, Account_Type__c
                                                                                 from finance_account__c where
                                                                                 id in (select Finance_Account_Number__c from ChargentOrders__ChargentOrder__c
                                                                                        where Finance_Account_Number__c in :lstfinid  
                                                                                        and Payment_Display_Status__c = 'Pending'
                                                                                        and recordtype.developername = 'Recurring_Payment')                            
                                                                                 
                                                                                 
                                                                                ]);
        
        map<id,finance_account__c> fincasemap = new map<id,finance_account__c>([Select id, Account_Type__c
                                                                                from finance_account__c where
                                                                                id in (SELECT Finance_Account__c FROM Case where 
                                                                                       Finance_Account__c in :lstfinid 
                                                                                       and Type = :caseType
                                                                                       and Subject = :caseTitle
                                                                                      )                            
                                                                                
                                                                                
                                                                               ]);
        
        
        
        
        for (string finid :lstfinid){
            system.debug('finid =>' + finid );
            CheckExtEligibilityResult result = new CheckExtEligibilityResult();
            if (finmap.containsKey(finid) && !(fincasemap.containsKey(finid)) && (finezpaymap.containsKey(finid))) {
                result.eligible = true;
                result.finId = finid;
                result.pendingcase = false;
                result.hasezpay = true;
            }
            else if (finmap.containsKey(finid) && !(fincasemap.containsKey(finid)) && !(finezpaymap.containsKey(finid))) {
                result.eligible = true;
                result.finId = finid;
                result.pendingcase = false;
                result.hasezpay = false;
            }
            else if (finmap.containsKey(finid) && (fincasemap.containsKey(finid))) {
                result.eligible = false;
                result.finId = finid;
                result.pendingcase = true;
                result.hasezpay = true;
            }
            else  {
                result.eligible = false;
                result.finId = finid;
                result.pendingcase = false;
                result.hasezpay = true;
            }
            
                
                
                system.debug('Eligible =>' + result.eligible );
                results.add(result);
            }
            return results;
        }
        
        public static CheckExtEligibilityResult CheckAcctEligibility(String finid) {
            Boolean eligible;
            CheckExtEligibilityResult result = new CheckExtEligibilityResult();
            result.eligible = true;
            result.finId = finid;
            return result;
        }
        
        
        
        global class CheckExtEligibilityResult {
            @InvocableVariable
            global ID finId;
            
            @InvocableVariable
            global boolean eligible;
            
            @InvocableVariable
            global boolean pendingcase;
            
            @InvocableVariable
            global boolean hasezpay;
            
        }
        
        
        class CheckEligibilityException extends Exception {}
    }