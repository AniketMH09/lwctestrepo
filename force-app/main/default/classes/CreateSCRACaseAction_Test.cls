@isTest
public class CreateSCRACaseAction_Test {

    @IsTest
    static void testCreateCaseActionResult(){
        
        CreateSCRACaseAction.CreateCaseActionRequest csar = UtilityClass_Test.getCreateCaseActionRequest();
        CreateSCRACaseAction.CreateCase(csar);
        
    }

}