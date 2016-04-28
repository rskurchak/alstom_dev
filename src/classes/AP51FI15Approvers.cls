/**
 * AP51FI15Approvers Apex Class
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
     ~ Date Created    : 17/10/2013
     ~ Description     : Add 4 FI15 approvers "Country MD", "Country Finance Director", "Platform Controller", "Platform Director"
                         to the Sales Team of the parent Opportunity of the FI15 record, with role = "Other", access rights = "Read-Only".
     ~ Triggers        : FI15AfterInsert, FI15AfterUpdate
     ~ Feature Id      : FEAT#0435
 */
public without sharing class AP51FI15Approvers {
    public static void AddFI15ApproversToSalesTeam(List<FI15__c> listFI15) 
    {
        // Contains Opportunity Team Member to insert 
        List<OpportunityTeamMember> opportunityTeamMemberToInsert = new List<OpportunityTeamMember>();
        // Contains Opportunity Team Member Ids for related FI15 Opportunity
        Set<Id> opportunityTeamMember = new Set<Id>();
        Map<Id,Set<Id>> opportunityTeamMemberFI15 = new Map<Id,Set<Id>>();
        List<Id> OppIds = new List<Id>();
        List<Id>  FIUsers = new List<Id>();
        for (FI15__c fi : listFI15) {
            OppIds.add(fi.Opportunity__c);
            FIUsers.add(fi.CountryMD__c);
            FIUsers.add(fi.CountryFinanceDirector__c);
            FIUsers.add(fi.PlatformController__c);
            FIUsers.add(fi.PlatformDirector__c);
        }
        Set<Id> ActiveUsers = new Set<Id>();
        for(List<User> ActiveUsersList  : [Select Id from User where IsActive = true and Id IN: FIUsers]){
            for (User ActiveUser  : ActiveUsersList) {
                ActiveUsers.add(ActiveUser.Id);
            }
        }
        
        for(List<OpportunityTeamMember> listOpportunityTeamMember : [Select Id, OpportunityId, UserId From OpportunityTeamMember Where OpportunityId IN: OppIds and User.IsActive = true]){
            for (OpportunityTeamMember otm : listOpportunityTeamMember) {
                if(opportunityTeamMemberFI15.get(otm.OpportunityId) == null)
                {
                    opportunityTeamMemberFI15.put(otm.OpportunityId, new Set<Id>{otm.UserId});
                }
                else
                {
                    opportunityTeamMemberFI15.get(otm.OpportunityId).add(otm.UserId);
                }
            }
        }
        // Iterating triggered list of FI15
        for (FI15__c fi : listFI15) {
            
            // contains Opportunity Team Member Id for related FI15 Opportunity
            if(opportunityTeamMemberFI15.get(fi.Opportunity__c) != null)
                opportunityTeamMember = opportunityTeamMemberFI15.get(fi.Opportunity__c);
            // If the first approval user (fi.CountryMD__c) of FI15 not exist on Opportunity Team Member add him
            if(!opportunityTeamMember.Contains(fi.CountryMD__c) && ActiveUsers.contains(fi.CountryMD__c)) {
                opportunityTeamMemberToInsert.add(new OpportunityTeamMember(UserId=fi.CountryMD__c, TeamMemberRole=System.label.LBL0113, OpportunityId=fi.Opportunity__c ));
            }
            
            // If the second approval user (fi.CountryFinanceDirector__c) of FI15 not exist on Opportunity Team Member add him
            if(fi.CountryFinanceDirector__c!=null) {
                 if (!opportunityTeamMember.Contains(fi.CountryFinanceDirector__c) && ActiveUsers.contains(fi.CountryFinanceDirector__c)) {
                    opportunityTeamMemberToInsert.add(new OpportunityTeamMember(UserId=fi.CountryFinanceDirector__c, TeamMemberRole=System.label.LBL0113, OpportunityId=fi.Opportunity__c ));
                    }
            }
            
            // If the third approval user (fi.PlatformController__c) of FI15 not exist on Opportunity Team Member add him
            if(fi.PlatformController__c!=null) {
                if (!opportunityTeamMember.Contains(fi.PlatformController__c) && ActiveUsers.contains(fi.PlatformController__c)) {
                    opportunityTeamMemberToInsert.add(new OpportunityTeamMember(UserId=fi.PlatformController__c, TeamMemberRole=System.label.LBL0113, OpportunityId=fi.Opportunity__c ));
                   }
            }
            
            // If the fourth approval user (fi.PlatformDirector__c) of FI15 not exist on Opportunity Team Member add him
            if(fi.PlatformDirector__c!=null) {
                if (!opportunityTeamMember.Contains(fi.PlatformDirector__c) && ActiveUsers.contains(fi.PlatformDirector__c)) {
                    opportunityTeamMemberToInsert.add(new OpportunityTeamMember(UserId=fi.PlatformDirector__c, TeamMemberRole=System.label.LBL0113, OpportunityId=fi.Opportunity__c ));
                   }
            }
        }
        insert opportunityTeamMemberToInsert;
    }
}