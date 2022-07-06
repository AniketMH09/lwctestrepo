/* 
* Apex Class Name   :   AHFC_eConfigResponseHandler
* @description      :	US 3855 - This response from AHFC_EConfigIntegrationHandler will be parsed in this class.
* Modification Log  :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               7th JULY 2021          Created
*********************************************************************************/
/**
* @description AHFC_eConfigResponseHandler 
*/
public class AHFC_eConfigResponseHandler {
    
    @AuraEnabled
    public Mot mot {get;set;}
    
    /**
* @description Mot Root Node
*/
    public class Mot {
        
        @AuraEnabled
        public Db_results db_results {get;set;} 
    }
    
    /**
* @description Db_results This will have the results of all the image paths
*/
    public class Db_results {
        
        @AuraEnabled
        public Messages messages {get;set;} 
        
        @AuraEnabled
        public Vins vins {get;set;} 
        
        @AuraEnabled
        public Dependency_info dependency_info {get;set;} 
    }
    
    /**
* @description Messages 
*/
    public class Messages {
        
        @AuraEnabled
        public Message message {get;set;} 
    }
    
    /**
* @description Vins 
*/
    public class Vins {
        
        @AuraEnabled
        public List<Vin> vin {get;set;} 
    }
    /**
* @description Dependency_info 
*/    
    public class Dependency_info {
        
        @AuraEnabled
        public List<Dependency> dependency {get;set;} 
        
        @AuraEnabled
        public Cache cache {get;set;} 
    }
    
    /**
* @description Message 
*/    
    public class Message {
        
        @AuraEnabled
        public String msg_type {get;set;}
        
        @AuraEnabled
        public String msg_number {get;set;} 
        
        @AuraEnabled
        public String cdata_section {get;set;} // in json: #cdata-section
    }
    /**
* @description Vin 
*/    
    public class Vin {
        
        @AuraEnabled
        public String vin_number {get;set;}
        
        @AuraEnabled
        public String error_code {get;set;}
        
        @AuraEnabled
        public String error_action {get;set;}
        
        @AuraEnabled
        public String error_reason {get;set;}
        
        @AuraEnabled
        public Model model {get;set;} 
    }
    
    /**
* @description Model 
*/    
    public class Model {
        
        @AuraEnabled
        public String id {get;set;} 
        
        @AuraEnabled
        public String model_group_name {get;set;} 
        
        @AuraEnabled
        public String trim_name {get;set;} 
        
        @AuraEnabled
        public String trans_name {get;set;}
        
        @AuraEnabled
        public String make {get;set;} 
        
        @AuraEnabled
        public String division_cd {get;set;} 
        
        @AuraEnabled
        public String model_name {get;set;} 
        
        @AuraEnabled
        public String model_year {get;set;} 
        
        @AuraEnabled
        public Colors colors {get;set;}   
    }
    /**
* @description Colors 
*/    
    public class Colors {
        
        public List<Color> color {get;set;} 
    }
    /**
* @description Color 
*/    
    public class Color {
        
        @AuraEnabled
        public String id {get;set;}
        
        @AuraEnabled
        public String color_type {get;set;} 
        
        @AuraEnabled
        public String name {get;set;} 
        
        @AuraEnabled
        public String color_cd {get;set;} 
        
        @AuraEnabled
        public String mfg_color_cd {get;set;} 
        
        @AuraEnabled
        public String base_color_name {get;set;} 
        
        @AuraEnabled
        public assets assets {get;set;}
    }
    /**
* @description assets 
*/    
    public class assets {
        
        @AuraEnabled
        public list<asset> asset {get;set;} 
    }
    /**
* @description asset 
*/    
    public class asset {
        
        @AuraEnabled
        public String id {get;set;} 
        
        @AuraEnabled
        public String type_cd {get;set;}
        
        @AuraEnabled
        public String view_cd {get;set;} 
        
        @AuraEnabled
        public String path {get;set;} 
    }
    /**
* @description Dependency 
*/   
    public class Dependency {
        
        @AuraEnabled
        public String name {get;set;} 
        
        @AuraEnabled
        public String filename {get;set;} 
        
        @AuraEnabled
        public String type {get;set;} 
    }   
    /**
* @description Cache 
*/    
    public class Cache {
        
        @AuraEnabled
        public String filename {get;set;} 
    }
    
    /**
* @description parse - The response body from AHFC_EConfigIntegrationHandler will be deserialized using this method.
* @param  json 
* @return object 
**/    
    public static AHFC_eConfigResponseHandler parse(String json){
        return (AHFC_eConfigResponseHandler) System.JSON.deserialize(json, AHFC_eConfigResponseHandler.class);
        
    }
}