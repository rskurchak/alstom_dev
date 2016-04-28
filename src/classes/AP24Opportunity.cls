/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
 insert try{} catch{} arount insert + dml.optAllOrNone = false;  
 for mass updates (avoid a mass rollout in case of an error)
 Remove this box once modification done.
*********************************************************************/
/*
 AP24Opportunity Apex Class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 16/04/2013
    ~ Description     : Apex Class 
                        - Delete related Opportunity Actors     
*/
public without sharing class AP24Opportunity 
{
    public static void deleteOpportunityActors(list<Opportunity> oppList)
    {
        List<OpportunityActor__c> oppActorToDelete = [Select Id From OpportunityActor__c where Opportunity__c IN :oppList];
        
        if (oppActorToDelete.size() > 0)
            delete oppActorToDelete;
    }
    
    public static void undeleteOpportunityActors(list<Opportunity> oppList)
    {
        List<OpportunityActor__c> oppActorToUndelete = [Select Id From OpportunityActor__c where Opportunity__c IN :oppList and isDeleted = true ALL ROWS];
        
        if (oppActorToUndelete.size() > 0)
            undelete oppActorToUndelete;
    }
}