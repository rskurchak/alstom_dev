/**
 * This class contains unit tests for validating the behavior of VFC19_ContactFrequencyMatrix Apex classes 
 	and VFP19_ContactFrequencyMatrix
 * Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 16/11/2012
 */
@isTest
private class VFC19_ContactFrequencyMatrix_TEST
{
    static testMethod void testVFC12() 
    {
    	System.debug('## >>>>> testing class VFC19_ContactFrequencyMatrix START <<<<<');
    	
    	System.debug('## Create Account');	 
        Account acc = UtilityTestMethod.getAccount();
        insert acc;
        
        System.debug('## Create Opportunity');
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = acc.Id;
        insert opp;
        
        System.debug('## Create Contact');
		List<Contact> contacts =  UtilityTestMethod.getContacts(3);
		insert contacts;
		
		System.debug('## Create BuyingProcess Stake holder');
		List<BuyingProcessStakeholder__c> bps = UtilityTestMethod.getBuyingProcessStakeholders(3);
		for(BuyingProcessStakeholder__c b : bps)
		{
			Integer i = 0;
			b.Opportunity__c = opp.id;
			b.ContactName__c = contacts.get(i).Id;
			i++;
		}
		insert bps;
		
		System.debug('## Create Alstom Employee');
		List<AlstomEmployee__c> employees = UtilityTestMethod.getAlstomEmployees(3);
		insert employees;
		
		System.debug('## Create Alstom Relations');
		AlstomRelationship__c relation = UtilityTestMethod.getAlstomRelationship();
		relation.AlstomEmployee__c = employees.get(0).Id;
		relation.FrequencyOfContacts__c = 'Frequent';
		relation.Stakeholder__c = bps.get(0).Id;
		insert relation;
		
		AlstomRelationship__c emptyRelation = UtilityTestMethod.getAlstomRelationship();
		emptyRelation.AlstomEmployee__c = employees.get(1).Id;
		emptyRelation.Stakeholder__c = bps.get(1).Id;
		insert emptyRelation;

        Test.startTest();
	        // apex class and visualforce page testing
	        PageReference vfp19 = Page.VFP19_ContactFrequencyMatrix; 
	        vfp19.getParameters().put('oppId', opp.Id);  
	        Test.setCurrentPage(vfp19);
	        
	        // Add parameters to page URL
			VFC19_ContactFrequencyMatrix vfc19 = new VFC19_ContactFrequencyMatrix();
	        System.debug(vfc19.opp);
		Test.StopTest();	        
    	
    	System.debug('## >>>>> testing class VFC19_ContactFrequencyMatrix END <<<<<');
    }
}