/**
 * This class contains unit tests for validating the behavior of VFC29_CompetitorHierarchy Apex Class
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com
     ~ Date Created    : 08/07/2013
 */
@isTest
private class VFC29_CompetitorHierarchy_TEST 
{
    static testMethod void VFC29_CompetitorHierarchy_TEST() 
    {	
    	Competitor__c globalCompetitor = UtilityTestMethod.getCompetitors(1).get(0);
    	globalCompetitor.IsAGlobalCompetitor__c = true;
        insert globalCompetitor;
        
       	Competitor__c childCompetitor = UtilityTestMethod.getCompetitors(1).get(0);
    	childCompetitor.GlobalCompetitor__c = globalCompetitor.Id;
        insert childCompetitor;
        
        Test.startTest();
        
        PageReference VFP29 = Page.VFP29_CompetitorHierarchy; 
        Test.setCurrentPage(VFP29);
        ApexPages.currentPage().getParameters().put('Id', childCompetitor.Id);
        VFC29_CompetitorHierarchy vfc29 = new VFC29_CompetitorHierarchy();
        vfc29.setcurrentId(childCompetitor.Id);
        List<VFC29_CompetitorHierarchy.ObjectStructureMap> osm = vfc29.getObjectStructure();
        osm.get(0).getnodeId();
        osm.get(0).getlevelFlag();
        osm.get(0).getcloseFlag();
        osm.get(0).getnodeType();
        osm.get(0).getcurrentNode();
        osm.get(0).getCompetitor();
        
        osm.get(0).setnodeId('0');
        osm.get(0).setlevelFlag(true);
        osm.get(0).setlcloseFlag(true);
        osm.get(0).setnodeType('start');
        osm.get(0).setcurrentNode(false);
        osm.get(0).setCompetitor(globalCompetitor);
        
        Test.stopTest();
    }
}