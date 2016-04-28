@isTest
private class SitemapController_TEST 
{	
	@isTest static void SitemapController_TEST() 
	{
		PartAndRepair__c pr = new PartAndRepair__c();
		insert pr;

		Test.startTest();

		PageReference smp = Page.Sitemap; 
        Test.setCurrentPage(smp);
		SitemapController smc = new SitemapController();

		Test.stopTest();
	}
}