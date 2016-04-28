@IsTest
public class CaseSurveyContExtTest {

    @IsTest
    public static void testSave_CheckSurveyTakenDate() {
        Case c = newCase();
        CaseSurveyContExt ext = extension(c);
        
        ext.save();
        
        System.assertEquals(System.today(), c.Survey_Taken_Date__c);
    }

    @IsTest
    public static void testSave_CheckSurveyComplete() {
        Case c = newCase();
        CaseSurveyContExt ext = extension(c);
        
        PageReference pageReference = ext.save();
        System.assert(pageReference.getUrl().endsWith('/CaseWithDetail?id=' + c.Id), 'Actual result is: ' + pageReference.getUrl() + ' Case Id = ' + c.Id);
    }

    @IsTest
    public static void testCheckSurvey_NotCompleted() {
        Case c = newCase();
        CaseSurveyContExt ext = extension(c);
        
        PageReference pageReference = ext.checkSurvey();
        
        System.assertEquals(null, pageReference);
    }

    @IsTest
    public static void testReopenRequest_CheckRedirect() {
        Case c = newCase();
        c.Quality_of_Request_Resolution__c = 4;
        c.Rapidity_of_request_resolution__c = 2;
        CaseSurveyContExt ext = extension(c);
        PageReference pageReference = ext.reopenRequest();
        System.assert(pageReference.getUrl().endsWith('?id=' + c.Id));
    }

    @IsTest
    public static void testReopenRequest_CheckSurveySubmittedAsWell() {
        Case c = newCase();
        c.Quality_of_Request_Resolution__c = 4;
        c.Rapidity_of_request_resolution__c = 2;
        CaseSurveyContExt ext = extension(c);
        PageReference pageReference = ext.reopenRequest();
        
        Case savedCase = [select Id, Survey_Taken_Date__c, Quality_of_Request_Resolution__c, Rapidity_of_request_resolution__c from Case where Id = :c.Id];
        System.assertEquals(4, savedCase.Quality_of_Request_Resolution__c);
        System.assertEquals(2, savedCase.Rapidity_of_request_resolution__c);
        System.assertEquals(System.today(), savedCase.Survey_Taken_Date__c);
    }
    
    private static CaseSurveyContExt extension(Case c) {
        return new CaseSurveyContExt(new ApexPages.StandardController(c));
    }
    
    private static Case newCase() {
        Case c = new Case(Status = 'New');
        insert c;
        return c;
    }
}