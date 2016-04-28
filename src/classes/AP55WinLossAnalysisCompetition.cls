/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Not bulkified : 2 SOQL query in loop
 Remove this box once modification done.
*********************************************************************/
/*
 AP55WinLossAnalysisCompetition 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 24/10/2013
    ~ Description       : Create child Competition records related to WLA
                          Copying information from Opportunity Actor records related to the same Opportunity Of WLA.
     ~ Triggers         : WinLossAnalysisAfterInsert
     ~ Feature Id       : FEAT#0456 
	~ Author          : Tiantian HE ~ tiantian.he@cgi.com
    ~ Date Created    : 19/02/2015
    ~ Description     : CR-0708 - TECH_Competitions field
     ~ Triggers       : CompetitionAfterInsert, CompetitionAfterUpdate, CompetitionAfterDelete, CompetitionAfterUndelete
     ~ Feature Id     : FEAT#0787
*/
/* 
     Bug fix 20/10/2014 by C. Averseng : set "without sharing" instead of "with sharing"
     If the user performing the action doesn't have visibility rights on the Account referenced by the Opportunity Actor,
     then the insert of the Competition record (with the reference to the same Account) failed.
*/     
public without sharing class AP55WinLossAnalysisCompetition {
    public static void CreateWLACompetitionChildFromOppActor(List<WinLossAnalysis__c> lstWinLoss) {
        
        // Contains Opportunity actors where role is "Competitor"
        List<OpportunityActor__c> oppActors = new List<OpportunityActor__c>();
        
        // Contains the specific 'Alstom' competitor
        List<OpportunityActor__c> oppActorsAlstom = new List<OpportunityActor__c>();
        
        // Contains Competitions to insert
        List<Competition__c> listCompetitionsToInsert = new List<Competition__c>();
        String recTypeId;
        
        for(WinLossAnalysis__c winLossSub : lstWinLoss) {
            // Getting needed informations on competitor from Opportunity actor
            oppActors = [SELECT Id, Role__c, RecordTypeId, Competitor__c, Account__c FROM OpportunityActor__c WHERE Opportunity__c =: winLossSub.Opportunity__c and Role__c =: System.label.LBL0125];
            
            // Getting needed informations on Alstom competitor from Opportunity actor
            oppActorsAlstom = [SELECT Id, Role__c, RecordTypeId, Competitor__c, Account__c FROM OpportunityActor__c WHERE Opportunity__c =: winLossSub.Opportunity__c and Competitor__c =: System.label.LBL0008];
            
            if (oppActors.size() > 0) {
                for(OpportunityActor__c oppAct : oppActors) {
                    if(oppAct.RecordTypeId == UtilityTestMethod.oppActorRecTypes.get('OpportunityActorAccounts')) {
                        // Getting Account record Type Id for competition if the record type of opportunity actor is "OpportunityActorAccounts"
                        recTypeId = UtilityTestMethod.competitionRecTypes.get('Account');
                    }
                    else {
                        // Getting Competitor record Type from competition if the record type of opportunity actor is "OpportunityActorCompetitors"
                        recTypeId = UtilityTestMethod.competitionRecTypes.get('Competitor');
                    }
                    if(recTypeId != null && recTypeId.length()>15) {
                        recTypeId = recTypeId.Substring(0,15);
                    }
                    // Add a new Competition to the list
                    listCompetitionsToInsert.add(new Competition__c(WinLossAnalysis__c = winLossSub.Id, Account__c = oppAct.Account__c, Competitor__c = oppAct.Competitor__c, RecordTypeId = recTypeId));
                }
            }
            
            if (oppActorsAlstom.size() == 0) {
                    recTypeId = UtilityTestMethod.competitionRecTypes.get('Competitor');
                    // add a new Competition with alstom competitor
                    listCompetitionsToInsert.add(new Competition__c(WinLossAnalysis__c = winLossSub.Id, Competitor__c = System.label.LBL0008, RecordTypeId = recTypeId.Substring(0,15)));
            }
            
        }
        insert listCompetitionsToInsert;
    }
    
    /**
     * CR-0708 Concatenate in one field the list of the competitions.
     */
    public static void concatenateWLACompetitions(List<Competition__c> listCompetitions) {
    	
    	// Gather all the concerned WLA Id
    	Set<Id> setWLAIds = new Set<Id>();
    	for (Competition__c competition: listCompetitions) {
    		setWLAIds.add(competition.WinLossAnalysis__c);
    	}
    	
    	// Query all the concerned WLA with list of Competitions
    	List<WinLossAnalysis__c> listWLA = [SELECT Id, (SELECT Account__r.Name, Competitor__r.Name FROM WinLossAnalysis__c.Competitions__r) FROM WinLossAnalysis__c WHERE Id IN :setWLAIds];
    	
    	// Concatenate the Competition names for each WLA
    	for (WinLossAnalysis__c wla: listWLA) {
    		String tech_Competitions = '';
    		if (wla.Competitions__r.size() > 0) {
    			for (Competition__c comp: wla.Competitions__r) {
    				String compName = (comp.Account__r.Name != null && comp.Account__r.Name != '')? comp.Account__r.Name : comp.Competitor__r.Name;
    				if (compName != null && compName != '' && !compName.contains('Alstom') && !compName.contains('ALSTOM')) {
    					tech_Competitions += compName + ';';
    				}
    			}
    			// Contatenation must start and finish with ';'
    			if (tech_Competitions != '') {
    				tech_Competitions = ';' + tech_Competitions;
    			}
    		}
    		wla.TECH_Competitions__c = tech_Competitions;
    	}
    	
    	// Update concerned WLA
    	update listWLA;
    }
}