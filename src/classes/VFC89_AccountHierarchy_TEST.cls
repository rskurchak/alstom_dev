/**
 * This class contains unit tests for validating the behavior of VFC89_AccountHierarchy Apex Class
 * and triggers.
 *   ~ Author          : Antonin MAIGNE ~ antonin.maigne@cgi.com
     ~ Date Created    : 04/02/2015
 */
@isTest
private class VFC89_AccountHierarchy_TEST 
{
    static testMethod void VFC89_AccountHierarchy_TEST() 
    {   
        Account globalAccount = UtilityTestMethod.getAccounts(1).get(0);
        globalAccount.IsAGlobalAccount__c = true;
        insert globalAccount;
        
        Account childAccount = UtilityTestMethod.getAccounts(1).get(0);
        childAccount.ParentId = globalAccount.Id;
        insert childAccount;
        
        Test.startTest();
        
        PageReference VFP89 = Page.VFP89_AccountHierarchy; 
        Test.setCurrentPage(VFP89);
        ApexPages.currentPage().getParameters().put('Id', childAccount.Id);
        VFC89_AccountHierarchy vfc89 = new VFC89_AccountHierarchy();
        vfc89.setcurrentId(childAccount.Id);
        List<VFC89_AccountHierarchy.ObjectStructureMap> osm = vfc89.getObjectStructure();
        osm.get(0).getnodeId();
        osm.get(0).getlevelFlag();
        osm.get(0).getcloseFlag();
        osm.get(0).getnodeType();
        osm.get(0).getcurrentNode();
        osm.get(0).getAccount();
        
        osm.get(0).setnodeId('0');
        osm.get(0).setlevelFlag(true);
        osm.get(0).setlcloseFlag(true);
        osm.get(0).setnodeType('start');
        osm.get(0).setcurrentNode(false);
        osm.get(0).setAccount(globalAccount);
        
        Test.stopTest();
    }
}