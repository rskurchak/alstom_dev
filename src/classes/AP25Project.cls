/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
 Add Try/Catch
 Remove this box once modification done.
*********************************************************************/
/*
 AP25Project Apex Class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 25/04/2013
    ~ Description     : Apex Class 
                        - Add Project owner in Account Team   
*/
public without sharing class AP25Project 
{   
    public static void deleteAccountTeam(list<Project__c> projectList)
    {
        List<Id> ownerIds = new List<Id>();
        List<Id> accountIds = new List<Id>();
        for (Project__c p : projectList)
        {
            ownerIds.add(p.OwnerId);
            
            if (p.Account__c != null)
                accountIds.add(p.Account__c);
        }
        
        if (accountIds.size() > 0)
        {
            map<String, AccountTeamMember> mapkeyAccountTeam = new map<String, AccountTeamMember>();
            for (AccountTeamMember atm : [Select Id, UserId, AccountId from AccountTeamMember WHERE UserId IN :ownerIds AND AccountId IN :accountIds])
                mapkeyAccountTeam.put(String.valueOf(atm.UserId)+String.valueOf(atm.AccountId), atm);
            
            // To check that user id not on another project
            map<String, Id> mapkeyProject = new map<String, Id>();
            for (Project__c p : [Select Id, OwnerId, Account__c FROM Project__c WHERE OwnerId IN :ownerIds AND Account__c IN :accountIds])
                mapkeyProject.put(String.valueOf(p.OwnerId)+String.valueOf(p.Account__c), p.Id);        
            
            // Creating a Set to avoid duplicates (makes Delete crash)
            // List is used for final delete call, as we can't use Set for delete
            List<AccountTeamMember> accTeamToDelete = new List<AccountTeamMember>();
            Set<Id> accTeamToDeleteIds = new Set<Id>();
            for (Project__c p : projectList)
            {
                // S'il y a une valeur d'AccountTeamMember pour l'ancien User 
                // et qu'il n'est plus sur aucun projet, on le supprime
                if (mapkeyAccountTeam.get(String.valueOf(p.OwnerId)+String.valueOf(p.Account__c)) != null
                    && mapkeyProject.get(String.valueOf(p.OwnerId)+String.valueOf(p.Account__c)) == null
                    && !accTeamToDeleteIds.contains(mapkeyAccountTeam.get(String.valueOf(p.OwnerId)+String.valueOf(p.Account__c)).Id))
                {
                    accTeamToDelete.add(mapkeyAccountTeam.get(String.valueOf(p.OwnerId)+String.valueOf(p.Account__c)));
                    accTeamToDeleteIds.add(mapkeyAccountTeam.get(String.valueOf(p.OwnerId)+String.valueOf(p.Account__c)).Id);
                }
            }
            
            if (accTeamToDelete.size() > 0)
                delete accTeamToDelete;
        }
    }
    
    public static void updateAccountTeam(list<Project__c> projectList)
    {
        List<AccountTeamMember> accTeamList = new List<AccountTeamMember>();
        for (Project__c proj : projectList)
        {
            AccountTeamMember accTeam = new AccountTeamMember(UserId = proj.OwnerId, AccountId = proj.Account__c, TeamMemberRole = 'Other');
            accTeamList.add(accTeam);
        }
        
        if (accTeamList.size() > 0)
            insert accTeamList;
    }
}