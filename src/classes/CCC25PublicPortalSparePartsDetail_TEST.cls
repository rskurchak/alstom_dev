/*
  CCC25PublicPortalSparePartsDetail_TEST
  Class Test Controller for CCC25PublicPortalSparePartsDetail
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
   ~ Date Created    : 17/06/2014 
*/
@isTest
private class CCC25PublicPortalSparePartsDetail_TEST {
    public static testMethod void testCCC25() {
        System.debug('## >>>>> testing class CCC25PublicPortalSparePartsDetail START <<<<<');
        PartAndRepair__c part = new PartAndRepair__c(name='testpart', Category__c='Brakes', ApplicationsEN__c='example apps');
        insert part;
		Test.startTest();
        CCC25PublicPortalSparePartsDetail CCC25_Id = new CCC25PublicPortalSparePartsDetail();
        CCC25_Id.SparePartId = part.Id;
        CCC25_Id.setRecords.next();
        List<PartAndRepair__c> listp = CCC25_Id.ListPR;
        CCC25PublicPortalSparePartsDetail CCC25_Cat = new CCC25PublicPortalSparePartsDetail();
        CCC25_Cat.Category = part.Category__c;
        CCC25_Cat.setRecords.next();
        Test.stopTest();
        System.debug('## >>>>> testing class CCC25PublicPortalSparePartsDetail END <<<<<');
    }
}