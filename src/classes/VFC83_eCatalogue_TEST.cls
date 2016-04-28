@isTest
private class VFC83_eCatalogue_TEST 
{
    static testMethod void VFC83_eCatalogue_TEST() 
    {
		Test.startTest();
        
        PageReference VFP83 = Page.VFP83_eCatalogue;
        Test.setCurrentPage(VFP83);
        VFC83_eCatalogue vfc83 = new VFC83_eCatalogue();
        
        Test.stopTest();
    }
}