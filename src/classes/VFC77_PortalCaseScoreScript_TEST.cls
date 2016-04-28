/*
  Class Test Controller for VFC77_PortalCaseScoreScript
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
   ~ Date Created    : 01/07/2014 
*/
@isTest
private class VFC77_PortalCaseScoreScript_TEST {
	static testMethod void testVFC77() {
        System.debug('## >>>>> testing class VFC77_PortalCaseScoreScript START <<<<<');
        
        Case casetest = new Case(subject='case test', Status = 'Closed', Type = 'Technical question');
        insert casetest;

        Test.startTest();
        PageReference VFP77 = Page.VFP77_PortalCaseScoreScript; 
        Test.setCurrentPage(VFP77);
        ApexPages.currentPage().getParameters().put('Id', casetest.Id);
        VFC77_PortalCaseScoreScript VFC77 = new VFC77_PortalCaseScoreScript(new ApexPages.StandardController(casetest));
        VFC77.doSave();
        Test.stopTest();        
        System.debug('## >>>>> testing class VFC77_PortalCaseScoreScript END <<<<<');
	}
}