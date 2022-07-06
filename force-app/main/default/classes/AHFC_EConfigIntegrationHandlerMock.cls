/* Apex Class Name       :    AHFC_EConfigIntegrationHandlerMock
* @description        	 :    Mock Callout Class for AHFC_EConfigIntegrationHandlerTest
* Modification Log   	 :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               7th July 2021          Created
*********************************************************************************/
/**
* @description AHFC_EConfigIntegrationHandlerMock
**/
public class AHFC_EConfigIntegrationHandlerMock implements HttpCalloutMock {
    /**
* @description respond
* @param request
* @return response mock response
**/
    public HTTPResponse respond(HTTPRequest request) {
        // Create a mock response
        HttpResponse response = new HttpResponse();
        String jsonResponse = '{"mot":{"@id":"1","input_parameters":{"required":{"vins":{"vin":[{"@vin_number":"1HGCV1E3XLA000482","@division_cd":"AA"},{"@vin_number":"5FPYK3F10MB000075","@division_cd":"AA"}]}},"optional":{"assets":{"@suppress_asset_name":"false","@suppress_asset_description":"false","asset":[{"@type_cd":"IMGOVERLAY","@view_cd":"34FRONT"},{"@type_cd":"BASECAR","@view_cd":"34FRONT"}]}}},"db_results":{"@when_cached":"","@from_cache":"false","@cached_by":"","messages":{"message":{"@msg_type":"Informational","@msg_number":"5000","#cdata-section":"No warnings."}},"vins":{"vin":[{"@number":"1HGCV1E3XLA000482","model":{"@id":"CV1E3LEW","@model_group_name":"Accord Sedan","@trim_name":"Sport","@trans_name":"6 Speed Manual","@make":"Honda","@division_cd":"A","@model_name":"ACCORD 1.5T SPORT","@model_year":"2020","colors":{"color":[{"@id":"401","@color_type":"I","@name":"Black","@color_cd":"BK"},{"@id":"8889","@color_type":"E","@name":"Platinum White Pearl","@color_cd":"WB","@mfg_color_cd":"NH-883P","@base_color_name":"White","assets":{"asset":[{"@id":"1334523","@type_cd":"BASECAR","@view_cd":"34FRONT","@path":"https://automobiles.honda.com/-/media/Honda-Automobiles/Vehicles/2020/Accord Sedan/AW/Carshot/carshot_AccordSedan_front_ACCORD15TSPORT_2020_PlatinumWhitePearl_CV1E3LEW_NH-883P.png"}]}}]},"accessories":null,"marketing_texts":null}},{"@number":"5FPYK3F10MB000075","model":{"@id":"YK3F1MEW","@model_group_name":"Ridgeline","@trim_name":"AWD SPORT","@trans_name":"9 Speed Automatic","@make":"Honda","@division_cd":"A","@model_name":"RIDGELINE AWD SPORT","@model_year":"2021","colors":{"color":[{"@id":"401","@color_type":"I","@name":"Black","@color_cd":"BK"},{"@id":"9126","@color_type":"E","@name":"Radiant Red Metallic Ii","@color_cd":"RE","@mfg_color_cd":"R-580M","assets":{"asset":[{"@id":"1362436","@type_cd":"BASECAR","@view_cd":"34FRONT","@path":"https://automobiles.honda.com/-/media/Honda-Automobiles/Vehicles/2021/Ridgeline/AW/Carshot/carshot_Ridgeline_front_RIDGELINEAWDSPORT_2021_RadiantRedMetallicIi_YK3F1MEW_R-580M.png"}, { "@id": "1334649","@type_cd": "BASECAR","@view_cd": "34REAR","@path": "https://automobiles.honda.com/-/media/Honda-Automobiles/Vehicles/2020/Accord Sedan/AW/Carshot/carshot_AccordSedan_rear_ACCORD15TSPORT_2020_PlatinumWhitePearl_CV1E3LEW_NH-883P.png"}]}}]},"accessories":{"accessory":[{"@op_cd":"RIDGE21334","@name":"HPD PACKAGE","@is_ppo":"1","@quantity":"1","@labor_time":"0.00","@msrp":"2800.00"},{"@op_cd":"RIDGE21407","@name":"HPD PACKAGE","@is_ppo":"1","@quantity":"1","@labor_time":"0.00","@msrp":"2800.00"}]},"marketing_texts":null}}]},"dependency_info":{"dependency":[{"@name":".2020.Accord Sedan","@filename":"","@type":"ModelGroup"},{"@name":".2021.Ridgeline","@filename":"","@type":"ModelGroup"}],"cache":{"@filename":""}}},"private":{"server_info":{"@server_ip":"10.177.9.61","@host_name":"CUA43362WEB326"},"errors":{"@base_exception_guid":"","@exception_level":"","@exception_type":""}}}}';
        response.setBody(jsonResponse);
        response.setStatusCode(200);
        return response; 
    }
}