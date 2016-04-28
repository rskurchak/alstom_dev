/**
 * This class contains unit tests for validating the behavior of VFC31_ContactHierarchy Apex Class
 * and triggers.
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com
     ~ Date Created    : 19/08/2013
 */
@isTest
private class VFC31_ContactHierarchy_TEST 
{
    static testMethod void VFC31_ContactHierarchy_TEST() 
    {   
        Contact globalContact = UtilityTestMethod.getContacts(1).get(0);
        insert globalContact;
        
        Contact childContact = UtilityTestMethod.getContacts(1).get(0);
        childContact.ReportsToId = globalContact.Id;
        insert childContact;
        
        Test.startTest();
        
        PageReference VFP29 = Page.VFP31_ContactHierarchy; 
        Test.setCurrentPage(VFP29);
        ApexPages.currentPage().getParameters().put('Id', childContact.Id);
        VFC31_ContactHierarchy vfc31 = new VFC31_ContactHierarchy(new ApexPages.StandardController(childContact));
        vfc31.setcurrentId(childContact.Id);
        List<VFC31_ContactHierarchy.ObjectStructureMap> osm = vfc31.getObjectStructure();
        osm.get(0).getnodeId();
        osm.get(0).getlevelFlag();
        osm.get(0).getcloseFlag();
        osm.get(0).getnodeType();
        osm.get(0).getcurrentNode();
        osm.get(0).getContact();
        
        osm.get(0).setnodeId('0');
        osm.get(0).setlevelFlag(true);
        osm.get(0).setlcloseFlag(true);
        osm.get(0).setnodeType('start');
        osm.get(0).setcurrentNode(false);
        osm.get(0).setContact(globalContact);
        
        Test.stopTest();
    }
}