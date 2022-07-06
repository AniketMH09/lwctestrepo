/* 
* Apex Class Name   :   AHFC_EconfigModelResponseHandler
* @description      :	US 6697 - This response from AHFC_EconfigModelIntegHandler will be parsed in this class.
* Modification Log  :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               27th JULY 2021          Created For US 6697
*********************************************************************************/
/**
* @description AHFC_EconfigModelIntegHandler 
*/
public class AHFC_EconfigModelResponseHandler {
    
    public class Assets_Z {
        public List<Asset_Z> asset {get;set;} 
    }
    public Mot mot {get;set;} 
    
    public class Asset_color_match {
        public AssetColor color {get;set;} 
    } 
    public class AssetColor {
		public String id {get;set;} 
	}
    public class Mot {
        public Db_results db_results {get;set;} 
    }
    
    public class Db_results {
        public Assets_Z assets {get;set;} 
        public Models models {get;set;} 
    }
    
    public class Asset_Z {
        public String id {get;set;} 
        public String type_cd {get;set;} 
        public String name {get;set;} 
        public String path {get;set;} 
        public Asset_color_match asset_color_match {get;set;} // in json: asset-color-match
    }
    
    public class Model {
        public String id {get;set;} 
        public String model_name {get;set;}
        public String model_year {get;set;}
        public Assets assets {get;set;}
        public Colors colors {get;set;}
    }
    
    public class Colors {
		public List<Exteriorcolor> exteriorcolor {get;set;} 
	}
    public class Exteriorcolor {
		public String id {get;set;} 
	}
    public class Assets {
		public List<Asset> asset {get;set;} 
	}
    
    public class Asset {
        public String id {get;set;} 
    }
    
    public class Models {
        public List<Model> model {get;set;} 
    }
    
    /**
* @description parse - The response body from AHFC_EconfigModelIntegHandler will be deserialized using this method.
* @param  json 
* @return object 
**/    
    public static AHFC_EconfigModelResponseHandler parse(String json){
        return (AHFC_EconfigModelResponseHandler) System.JSON.deserialize(json, AHFC_EconfigModelResponseHandler.class);
        
    }
}