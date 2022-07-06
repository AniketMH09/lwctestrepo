/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for RecordTypeUtility
*****************************************************************************/

@isTest
public class RecordTypeUtilityTest{
    private static TestMethod void recordTypeUtility(){
        Map<String,RecordType> orderMap=new Map<String,RecordType>();
        RecordTypeUtility r=new RecordTypeUtility(); 
        orderMap=RecordTypeUtility.getOrderRecordTypes();
        orderMap=RecordTypeUtility.getgatewayRecordTypes();
    }
}