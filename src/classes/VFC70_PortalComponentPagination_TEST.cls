/*
  VFC70_PortalComponentPagination_TEST
  Class Test Controller for VFC70_PortalComponentPagination
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
   ~ Date Created    : 17/06/2014 
*/
@isTest
private class VFC70_PortalComponentPagination_TEST {
    public static testMethod void testVFC70() {
        System.debug('## >>>>> testing class VFC70_PortalComponentPagination START <<<<<');
        Account account = UtilityTestMethod.getAccount();
        insert account;
        List<Bulletin__c> Alertlist = UtilityTestMethod.getBulletinList(4, 'Alert',account.Id);
        insert Alertlist;
        Alertlist = [select Id, Name, Text__c, (select Id from Read_Receipts__r) from Bulletin__c];
        List<String> FieldList = new List<String>();
        Test.startTest();
        VFC70_PortalComponentPagination VFC70 = new VFC70_PortalComponentPagination();
        VFC70.idList = Alertlist;
        VFC70.pagesize = 1;
        VFC70.relatedlistname = 'Read_Receipts__r';
        VFC70.GetSObjectRecs();
        List<String> FieldList2 = VFC70.FieldList;
        string relatedlistname2 = VFC70.getrelatedlistname();
        VFC70.setRecords.next();
        Test.stopTest();
        System.debug('## >>>>> testing class VFC70_PortalComponentPagination END <<<<<');
    }
}