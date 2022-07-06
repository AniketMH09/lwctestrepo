public class RecordTypeUtility {
    public static Map<String,RecordType> orderRecordTypes = new Map<String, RecordType>() ;
    public static Map<String,RecordType> gatewayRecordTypes = new Map<String,RecordType>() ;
    public static Map<String,RecordType> getOrderRecordTypes(){
        if(!orderRecordTypes.isEmpty()){
            return orderRecordTypes;
            
        }
        else{
            for(RecordType orderRT : [Select Id, SobjectType, Name, DeveloperName from RecordType where Sobjecttype='ChargentOrders__ChargentOrder__c']){
                orderRecordTypes.put(orderRT.DeveloperName, orderRT);
            }
                return orderRecordTypes;
        }
    }
    public static Map<String,RecordType> getgatewayRecordTypes(){
        if(!gatewayRecordTypes.isEmpty()){
            return gatewayRecordTypes;
        }
        else{
            for(RecordType gatewayRT : [Select Id, SobjectType, Name, DeveloperName from RecordType where Sobjecttype='ChargentBase__Gateway__c']){
                gatewayRecordTypes.put(gatewayRT.DeveloperName, gatewayRT);
            }    
            return gatewayRecordTypes;
        }
    }
}