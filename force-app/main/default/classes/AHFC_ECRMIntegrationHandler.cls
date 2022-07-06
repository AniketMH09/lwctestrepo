/*Apex Class Name   :   AHFC_ECRMIntegrationHandler
* Description       :   This class is used to Validate the Customer entered address
* Created By        :   Kanagaraj
* Created on        :   25/5/2021
*********************************************************************************/
public class AHFC_ECRMIntegrationHandler {
    public ValidatedAddressWrapper validaddress;
    public ValidatedAddressWrapper parserXML(String toParse)
    {	
        validaddress = new ValidatedAddressWrapper();
        DOM.Document doc = new DOM.Document();
        try{
            doc.load(toParse);
            DOM.XMLNode root = doc.getRootElement();
            traverseThroughXML(root);
        }catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage());
            ApexPages.addMessage(msg);
            return validaddress;
        }
        return validaddress;
    }
    
     public void traverseThroughXML(DOM.XMLNode node) 
    {
        string messageCode;
        string failLevelCode;
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) 
        {
          
            if(node.getName().equalsIgnoreCase(system.label.address))
            {
                 
                for (Dom.XMLNode child: node.getChildElements()) {
                    if(child.getName()== system.label.addressLine1){
                        validaddress.addressLine1 = child.getText();
                        system.debug('addressLine1 '+ validaddress.addressLine1);
                    }
                    if(child.getName() == system.label.addressLine2){
                        validaddress.addressLine2 = child.getText();
                        system.debug('addressLine2 '+ validaddress.addressLine2);
                    }    
                    if(child.getName() == system.label.soap_response_city){
                        validaddress.city = child.getText();
                        system.debug('city '+validaddress.city);
                    }
                    if(child.getName() == system.label.state){
                        validaddress.state = child.getText();
                        system.debug('state '+validaddress.state);
                    }
                    if(child.getName() == system.label.zip){
                        validaddress.zip = child.getText();
                        system.debug('zip '+validaddress.zip);
                    }
                    if(child.getName() == system.label.failLevelCode){
                        validaddress.failLevelCode = child.getText();
                        system.debug('failLevelCode '+ child.getText());
                    }
                    // Added by Kanagaraj for US_10480 & US_10481
                    if(child.getName() == system.label.plus4){
                        validaddress.plus4 = child.getText();
                        system.debug('plus4 '+ child.getText());
                    }
                }
	
            }
            if(node.getName().equalsIgnoreCase(system.label.messageCode)){
                messageCode = node.getText();
                system.debug('messageCode '+ messageCode);
            }
            
           for (Dom.XMLNode child: node.getChildElements()) 
            {
              traverseThroughXML(child);
            }
        }
        
    }
    public class ValidatedAddressWrapper {
        @AuraEnabled
        public string addressLine1;
        @AuraEnabled
        public string addressLine2;
        @AuraEnabled
        public string city;
        @AuraEnabled
        public String state;
        @AuraEnabled
        public String zip;
        @AuraEnabled
        public String failLevelCode;
        @AuraEnabled
        public String plus4;
    } 

}