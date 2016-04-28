@isTest
private class WebPortalPartsListController_TEST 
{
	static testMethod void WebPortalPartsListController_Category() 
	{
		PartAndRepair__c pr = new PartAndRepair__c(Category__c='APS');
		insert pr;

		Test.startTest();

		PageReference wpPartsList = Page.WebPortalPartsList; 
        Test.setCurrentPage(wpPartsList);
		wpPartsList.getParameters().put('partId', 'badId');

        WebPortalPartsListController wpPartsListCtrl = new WebPortalPartsListController();
		wpPartsListCtrl.categoryFilter = 'APS';
        ApexPages.StandardSetController setCtrl = wpPartsListCtrl.setCtrl;
        List<FoundPart> listPR = wpPartsListCtrl.listPR;
        wpPartsListCtrl.filter();
		wpPartsListCtrl.showPartDetailContact();

		Test.stopTest();
	}

	static testMethod void WebPortalPartsListController_Search() 
	{
		PartAndRepair__c pr = new PartAndRepair__c();
		insert pr;

		Test.startTest();

		PageReference wpPartsList = Page.WebPortalPartsList; 
        Test.setCurrentPage(wpPartsList);
        
        WebPortalPartsListController wpPartsListCtrl = new WebPortalPartsListController();
        wpPartsListCtrl.searchText = 'Awesome';
        ApexPages.StandardSetController setCtrl = wpPartsListCtrl.setCtrl;

		Test.stopTest();
	}
}