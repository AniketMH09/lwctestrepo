//Appirio Inc.
//Created By:- Anirudh
//Created Date:-13/march/2019
//Purpose:-test class for AHFC_Lease_Extension_Controller

@isTest
public class AHFC_Lease_Extension_Controller_Test {
    
    //method to get the maturity date
    @isTest
    public static void testLeaseExtension() {
     String currentMdate = '2019-06-06';
     System.Assert(AHFC_Lease_Extension_Controller.getNextMaturityDate(currentMdate,2)!= null);
     currentMdate = '';
     System.Assert(AHFC_Lease_Extension_Controller.getNextMaturityDate(currentMdate,2)== null);  
    }
    
    //Method to cover try catch block
    @isTest
    public static void testLeaseExtensionWithWrongDate() {
     String currentMdate = '2019-06';
        try {
        	AHFC_Lease_Extension_Controller.getNextMaturityDate(currentMdate,2);  
        } catch(Exception e) {
        }
     
     
    }
}