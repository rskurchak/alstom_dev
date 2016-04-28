/*
 AP02Opportunity apex class
   ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
    ~ Date Created    : 06/07/2012 
    ~ Description     : Apex Class 
                        - automatically create an OpportunityActor for the Opportunity Account
*/
public class AP02Opportunity 
{
    // automatically create an OpportunityActor for the Opportunity Account
    // context : Opportunity After Insert
    public static void createOpportunityActors(List<Opportunity> opportunities) 
    {
        System.debug('## >>> Starting AP02Opportunity.createOpportunityActors <<<');
        
        List<OpportunityActor__c> oppActors2Insert = new List<OpportunityActor__c>(); 
        for(Opportunity opp : opportunities)
            oppActors2Insert.add(new OpportunityActor__c(RecordTypeId=UtilityTestMethod.oppActorRecTypes.get('OpportunityActorAccounts'), Account__c=Opp.AccountId, Opportunity__c=opp.Id, Role__c=System.Label.LBL0002));
        
        if(oppActors2Insert.size() > 0)
            insert oppActors2Insert;
        System.debug('## >>> End AP02Opportunity.createOpportunityActors<<<');
    }   
    
    public static void updateOpportunityActors(map<ID, Opportunity> newMap, map<ID, Opportunity> oldMap)
    {
        System.debug('## >>> Starting AP02Opportunity.updateOpportunityActors <<<');
        
        List<OpportunityActor__c> oppActorsToDelete = new List<OpportunityActor__c>();
        List<OpportunityActor__c> oppActorsToUpsert = new List<OpportunityActor__c>();
        
        for (Opportunity oppWithOppActors : [Select Id, AccountId, (Select Id, Opportunity__c, Account__c  from OpportunityActors__r where Role__c = :System.Label.LBL0002) from Opportunity where Id IN :newMap.keySet()])
        {
            boolean oppActorFound = false;
            
            for (OpportunityActor__c oppActor : oppWithOppActors.OpportunityActors__r)
            {
                if (oppActor.Account__c == newMap.get(oppWithOppActors.Id).AccountId)
                {
                    // Si l'Opportunity Actor existe déjà avec le role Customer pour le nouveau Compte
                    // On le supprime et on le recréera après, + simple si on rentre dans les 2 if
                    oppActorsToDelete.Add(oppActor);
                }
                else if (oppActor.Account__c == oldMap.get(oppWithOppActors.Id).AccountId)
                {
                    // Si on trouve l'ancien Opportunity Actor, on le met à jour avec le nouveau Compte
                    oppActorFound = true;
                    oppActor.Account__c = newMap.get(oppWithOppActors.Id).AccountId;
                    oppActorsToUpsert.add(oppActor);
                }
            }
            
            if (!oppActorFound)
                oppActorsToUpsert.add(new OpportunityActor__c(RecordTypeId = UtilityTestMethod.oppActorRecTypes.get('OpportunityActorAccounts'), Account__c = oppWithOppActors.AccountId, Opportunity__c = oppWithOppActors.Id, Role__c = System.Label.LBL0002));
        }
        
        if (oppActorsToDelete.size() > 0)
            delete oppActorsToDelete;
        
        if (oppActorsToUpsert.size() > 0)   
            upsert oppActorsToUpsert;
            
        System.debug('## >>> End AP02Opportunity.updateOpportunityActors<<<');
    }
}