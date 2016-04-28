/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Add assert
   + test should contain fail scenario (ie : case where there is a loop)
 Remove this box once modification done.
*********************************************************************/

/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com
 *   ~ Date Created    : 21/08/2013
 */
@isTest
private class AP29CompetitorContact_Test {

    static testMethod void AP29CompetitorContact_Test() {
        CompetitorsContact__c globalCompetitorContact = UtilityTestMethod.getCompetitorsContacts(1).get(0);
        insert globalCompetitorContact;
        
        CompetitorsContact__c childCompetitorContact = UtilityTestMethod.getCompetitorsContacts(1).get(0);
        childCompetitorContact.ReportsTo__c = globalCompetitorContact.Id;
        insert childCompetitorContact;
        
        CompetitorsContact__c globalCompetitorContact2 = UtilityTestMethod.getCompetitorsContacts(1).get(0);
        globalCompetitorContact2.ReportsTo__c = childCompetitorContact.Id;
        insert globalCompetitorContact2;
        
        Test.startTest();
        
        // Test the update triggers
        update globalCompetitorContact2;
        
        // Test the hierarchical component
        PageReference VFP32 = Page.VFP32_CompetitorsContactHierarchy; 
        Test.setCurrentPage(VFP32);
        ApexPages.currentPage().getParameters().put('Id', childCompetitorContact.Id);
        VFC32_ContactCompetitorHierarchy vfc32 = new VFC32_ContactCompetitorHierarchy(new ApexPages.StandardController(childCompetitorContact));
        vfc32.setcurrentId(childCompetitorContact.Id);
        List<VFC32_ContactCompetitorHierarchy.ObjectStructureMap> osm = vfc32.getObjectStructure();
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
        osm.get(0).setContact(globalCompetitorContact);
        
        Test.stopTest();
    }
}