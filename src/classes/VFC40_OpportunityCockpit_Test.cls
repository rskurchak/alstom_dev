/**
 * This class contains unit tests for validating the behavior of VFC40_OpportunityCockpit Apex Class
 * and triggers.
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com
     ~ Date Created    : 04/09/2013
 */
@isTest
private class VFC40_OpportunityCockpit_Test {

    static testMethod void myUnitTest() {
         // data testing
        System.debug('## Create Account ..');
        Account account = UtilityTestMethod.getAccount();
        insert account;
       
        System.debug('## Create Opportunity');
        Opportunity opp = UtilityTestMethod.getOpportunityWithBOID();
        opp.ATRegion__c = 'France';
        opp.AccountId = account.Id;
        insert opp;
        
        Tender__c tender = UtilityTestMethod.getTender(opp.Id);
        insert tender;
        
        OpportunityAssessment__c oppAssessment = UtilityTestMethod.getOpportunityAssessement();
        oppAssessment.Opportunity__c = opp.Id;
        oppAssessment.AssessmentVersion__c = '01';
        oppAssessment.TECH_CustomerVisions__c = '%F%%R%%F%%R%';
        
        oppAssessment.Status__c = 'Open';
        oppAssessment.TECH_SalesTeam__c = '%F%%R%%F%%R%';
        oppAssessment.TECH_Partners__c = '%F%%R%%F%%R%';
        oppAssessment.TECH_OppAssessmentActors__c = 'Competitor 1%F%2%F%null%F%null%F%null%F%null%F%null%F%null%F%false%F%false%F%false%F%false%F%null%F%null%F%null%F%null%F%null%F%null%R%Alstom%F%1%F%Prd%F%Serv%F%Bimage%F%Relation%F%Str%F%weak%F%true%F%true%F%true%F%true%F%with%F%info%F%Gorilla CommentsGorilla CommentsGorilla CommentsGorilla CommentsGorilla CommentsGorilla CommentsGorilla CommentsGorilla CommentsGorilla CommentsGorilla Comments%F%null%F%null%F%null%R%';
        insert oppAssessment;
        
        Test.startTest();
        
        PageReference VFP40 = Page.VFP40_Cockpit_FindWin; 
        Test.setCurrentPage(VFP40);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        VFC40_OpportunityCockpit vfc40 = new VFC40_OpportunityCockpit(new ApexPages.StandardController(opp));
        String testVar = vfc40.htmlErrorMessage;

        Test.stopTest();
    }
}