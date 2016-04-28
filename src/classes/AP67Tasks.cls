/*
 AP67Tasks APEX Class
    ~ Author          : Tiantian HE ~ tiantian.he@cgi.com 
    ~ Date Created    : 23/02/2015
    ~ Description     : Apex Class 
                        CR-0686 - Indicate if the Find Plan (Opportunity Assessment) has Action Plans (Task).          
*/
public with sharing class AP67Tasks {
	
	public static void checkFindPlanHasActionPlans(list<Task> listTasks) {
		
    	// Collect the Id of all the concerned Opportunities
        Set<Id> opptyIds = new Set<Id>();
        for (Task actionPlan: listTasks) {
        	if (actionPlan.type == 'Find Plan' && actionPlan.whatId != null) {
        		opptyIds.add(actionPlan.whatId);
        	}
        }
        
        // Determine if the find plan of Opportunity has at least 1 Action Plan
		List<OpportunityAssessment__c> listFindPlans = new List<OpportunityAssessment__c>();
        // Query All Oppties within the Ids concerned by trigger included Action Plans (Tasks)
        // In this query, we will get the Oppty Id, the related Find Plan Id and the list of Action Plans (with or without)
		for (Opportunity oppty: [Select Id, (SELECT Id FROM Opportunity.Opportunity_Assessments__r), (SELECT Id, Subject, Type FROM Opportunity.Tasks WHERE Type='Find Plan') FROM Opportunity WHERE Id IN :opptyIds]) {
			System.debug('###### oppty: ' + oppty + ', oppty.Opportunity_Assessments__r: ' + oppty.Opportunity_Assessments__r + ', oppty.Tasks: ' + oppty.Tasks);
			if (oppty.Opportunity_Assessments__r.size() > 0) {
				OpportunityAssessment__c findPlan = new OpportunityAssessment__c(Id=oppty.Opportunity_Assessments__r.get(0).Id);
				findPlan.TECH_HasActionPlans__c = (oppty.Tasks.size() > 0);
				listFindPlans.add(findPlan);
			}
		}
		System.debug('###### listFindPlans to update: ' + listFindPlans);
		
		// Update the list of Find Plans
		update listFindPlans;
    }

}