/*
  Class Test Controller for VFC76_PortalNewsDetail
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
   ~ Date Created    : 26/06/2014 
*/
@isTest
private class VFC76_PortalNewsDetail_TEST {
	static testMethod void testVFC76() {
        System.debug('## >>>>> testing class VFC76_PortalNewsDetail START <<<<<');
        
        News__c newtest = new News__c(Name='Alert test', Language__c = 'EN', Status__c = 'Published', Type__c = 'General', Text__c = 'test text');
        insert newtest;
		note n = new note(parentId=newtest.Id, body='news note', title='news note title', isPrivate=false);
		insert n;        
        
        Test.startTest();
        PageReference VFP76 = Page.VFP76_PortalNewsDetail; 
        Test.setCurrentPage(VFP76);
        ApexPages.currentPage().getParameters().put('Id', newtest.Id);
        VFC76_PortalNewsDetail VFC76 = new VFC76_PortalNewsDetail(new ApexPages.StandardController(newtest));
        Test.stopTest();        
        System.debug('## >>>>> testing class VFC76_PortalNewsDetail END <<<<<');
	}
}