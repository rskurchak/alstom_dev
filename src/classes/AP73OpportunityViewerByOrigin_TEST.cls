@isTest
public class AP73OpportunityViewerByOrigin_TEST 
{
	// Creating Test Data for all test methods
	@testSetup static void createTestData() 
    {
        System.debug('## >>> AP73OpportunityViewerByOrigin_TEST @testSetup Started <<< run by ' + UserInfo.getName());
        
        RecordType pxoRT = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'PxO__c' and DeveloperName = :System.Label.LBL0312];
    	
    	Opportunity opp = UtilityTestMethod.getOpportunity();
        insert opp;
		
		// Creating PxO
		PxO__c pxo = new PxO__c();
		pxo.RecordTypeId = pxoRT.Id;
		pxo.Opportunity__c = opp.Id;
		insert pxo;

		// Creating Site (Teranga Unit)
		TerangaUnit__c tu = new TerangaUnit__c();
		tu.TrainsSite__c = true;
		insert tu;

		// Creating PxO Line
		PxOLine__c pxoLine = new PxOLine__c();
		pxoLine.PxO__c = pxo.Id;
		pxoLine.Site__c = tu.Id;
		insert pxoLine;

		// Creating Viewer By Origin
		ViewerByOrigin__c vbo = new ViewerByOrigin__c();
		vbo.TerangaUnit__c = tu.Id;
		vbo.User__c = UserInfo.getUserId();
		insert vbo;

        System.debug('## >>> AP73OpportunityViewerByOrigin_TEST @testSetup : END <<<');
    }

    static testMethod void testViewerByOrigin() 
	{
		// Getting Data
		TerangaUnit__c tu = [Select Id from TerangaUnit__c Limit 1];

		// Creating Viewer By Origin
		ViewerByOrigin__c vbo = new ViewerByOrigin__c();
		vbo.TerangaUnit__c = tu.Id;
		vbo.User__c = UserInfo.getUserId();

		// Testing
		Test.startTest();

		insert vbo;
		update vbo;
		delete vbo;
		undelete vbo;

		Test.stopTest();
	}

	static testMethod void testPxoLine() 
	{
		// Getting Data
		PxO__c pxo = [Select Id from PxO__c Limit 1];
		TerangaUnit__c tu1 = [Select Id from TerangaUnit__c Limit 1];

		// Creating a second Site to test PxO Line update
		TerangaUnit__c tu2 = new TerangaUnit__c();
		tu2.TrainsSite__c = true;
		insert tu2;

		// Creating PxO Line
		PxOLine__c pxol = new PxOLine__c();
		pxol.PxO__c = pxo.Id;
		pxol.Site__c = tu1.Id;

		// Testing
		Test.startTest();

		insert pxol;
		pxol.Site__c = tu2.Id;
		update pxol;
		delete pxol;
		undelete pxol;

		Test.stopTest();
	}
}