/*
 AP67Tasks_TEST apex class
   ~ Author          : Tiantian HE ~ tiantian.he@cgi.com 
    ~ Date Created    : 24/02/2015 
    ~ Description     : Test Class for AP67Tasks.
*/
@isTest
private class AP67Tasks_TEST {
	
	static testMethod void testCheckFindPlanHasActionPlans() {
        System.debug('## >>>>> testing class AP67Tasks_TEST method testCheckFindPlanHasActionPlans() START <<<<<');
        Test.startTest();
        
        Opportunity oppty1 = UtilityTestMethod.getOpportunity();
        Opportunity oppty2 = UtilityTestMethod.getOpportunity();
        List<Opportunity> listOppties = new List<Opportunity>();
        listOppties.add(oppty1);
        listOppties.add(oppty2);
        insert listOppties;
        
        OpportunityAssessment__c findPlanOppty1 = new OpportunityAssessment__c(Opportunity__c = oppty1.Id);
        OpportunityAssessment__c findPlanOppty2 = new OpportunityAssessment__c(Opportunity__c = oppty2.Id);
        List<OpportunityAssessment__c> listFindPlans = new List<OpportunityAssessment__c>();
        listFindPlans.add(findPlanOppty1);
        listFindPlans.add(findPlanOppty2);
        insert listFindPlans;
        
        // inserted/updated/undeleted Action Plans (existing)
		Task actionPlan1 = new Task(WhatId = oppty1.Id, Type = 'Find Plan', Subject = 'Action Plan 1');
		Task actionPlan2 = new Task(WhatId = oppty1.Id, Type = 'Find Plan', Subject = 'Action Plan 2');
		List<Task> listTasks = new List<Task>();
		listTasks.add(actionPlan1);
		listTasks.add(actionPlan2);
		insert listTasks;
		// deleted Action Plan (non-existing)
		Task actionPlan3 = new Task(WhatId = oppty2.Id, Type = 'Find Plan', Subject = 'Action Plan 3');
		listTasks.add(actionPlan3);
		
		// update the TECH_HasActionPlans__c field for the Find Plans
		AP67Tasks.checkFindPlanHasActionPlans(listTasks);
		
		// assert result
		List<OpportunityAssessment__c> listFindPlansResult = [SELECT Id, TECH_HasActionPlans__c FROM OpportunityAssessment__c WHERE Id = :findPlanOppty1.Id OR Id = :findPlanOppty2.Id];
		for (OpportunityAssessment__c findPlanResult: listFindPlansResult) {
			if (findPlanResult.Id == findPlanOppty1.Id) {
				System.assertEquals(true, findPlanResult.TECH_HasActionPlans__c);
				continue;
			}
			if (findPlanResult.Id == findPlanOppty2.Id) {
				System.assertEquals(false, findPlanResult.TECH_HasActionPlans__c);
				continue;
			}
		}
		
		// trigger code coverage
		actionPlan1.WhatId = oppty2.Id;
		update actionPlan1;
		delete actionPlan1;
		undelete actionPlan1;
        
        Test.stopTest();        
        System.debug('## >>>>> testing class AP67Tasks_TEST method testCheckFindPlanHasActionPlans() END <<<<<');
	}

}