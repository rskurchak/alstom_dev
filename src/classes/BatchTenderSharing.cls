/*
    BatchTenderSharing
    ~ Author          : Fabien Taillon ~ fabien.taillon@cgi.com 
    ~ Date Created    : 23/10/2013
    ~ Description     : Apex Batch to add new Tender Manual Sharing to Opportunity Team
                      : FEAT#0544 YMR. Bug: Batch Tender Sharing. Systematically schedule a new Batch Tender Sharing 3 minutes
                      : previous one is successfully executed.
*/
global class BatchTenderSharing implements Database.Batchable<SObject>
{
    global String query;
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    { 
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {  
        List<Tender__c> listTenders = new List<Tender__c>();
        Set<Id> oppIds = new Set<Id>();
        for(sObject S : scope)
        {
            Tender__c t = (Tender__c) S;
            listTenders.add(t);
            oppIds.add(t.Opportunity__c);
        }
        
        Set<Id> ActiveUsers = new Set<Id>();
        for(List<User> ActiveUsersList  : [Select Id from User where IsActive = true]){
            for (User ActiveUser  : ActiveUsersList) {
                ActiveUsers.add(ActiveUser.Id);
            }
        }
        // Not adding Opportunity Id, because if there is no more Tender Share, Opportunity is not in the list but Opportunity Team Member needs to be deleted
        List<OpportunityTeamMember> oppTeamToDelete = [Select Id from OpportunityTeamMember where Reason__c = :System.label.LBL0122 and TeamMemberRole = 'Other' and OpportunityAccessLevel = 'Read' and OpportunityId IN : oppIds];
        delete oppTeamToDelete;
        
        map<Id, Set<Id>> mapOppIdTeamIdOtherReason = new map<Id, Set<Id>>();
        for (Opportunity opp : [Select Id, (Select Id, UserId From OpportunityTeamMembers where Reason__c != :System.label.LBL0122 or TeamMemberRole != 'Other' or OpportunityAccessLevel != 'Read') From Opportunity where Id IN : oppIds])
        {
            for (OpportunityTeamMember otm : opp.OpportunityTeamMembers)
            {
                if (mapOppIdTeamIdOtherReason.get(opp.Id) != null)
                {
                    Set<Id> teamIds = mapOppIdTeamIdOtherReason.get(opp.Id);
                    teamIds.add(otm.UserId);
                    mapOppIdTeamIdOtherReason.put(opp.Id, teamIds);
                }
                else
                {
                    Set<Id> teamIds = new Set<Id>();
                    teamIds.add(otm.UserId);
                    mapOppIdTeamIdOtherReason.put(opp.Id, teamIds);
                }
            }
        }

        List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>();
        map<Id, Set<Id>> mapOppIdTeamId = new map<Id, Set<Id>>();
        for (Tender__c tender : [SELECT Id, Opportunity__c, (Select Id, ParentId, UserOrGroupId, AccessLevel from Shares where RowCause = 'Manual') From Tender__c WHERE Id IN :listTenders])
        {
            for (Tender__Share ts : tender.Shares)
            
            {
                // Adding only Users, no Roles or Groups
                if (((String)ts.UserOrGroupId).substring(0, 3) == '005')
                {
                    Set<Id> teamIdsOtherReason = new Set<Id>();
                    if (mapOppIdTeamIdOtherReason.get(tender.Opportunity__c) != null)
                    {
                        teamIdsOtherReason = mapOppIdTeamIdOtherReason.get(tender.Opportunity__c);
                    }
                    //if (ActiveUsers.contains(ts.UserOrGroupId)){
                    if (ActiveUsers.contains(ts.UserOrGroupId) && (teamIdsOtherReason.size() == 0 || (teamIdsOtherReason.size()!=0 && !teamIdsOtherReason.contains(ts.UserOrGroupId)))){
                        oppTeam.add(new OpportunityTeamMember(UserId = ts.UserOrGroupId, OpportunityId = tender.Opportunity__c, TeamMemberRole = 'Other', Reason__c = System.Label.LBL0122));
                        
                        // Need to update rights later for Read Write
                        if (ts.AccessLevel == 'Edit')
                        {
                            if (mapOppIdTeamId.get(tender.Opportunity__c) != null)
                            {
                                Set<Id> teamIds = mapOppIdTeamId.get(tender.Opportunity__c);
                                teamIds.add(ts.UserOrGroupId);
                                mapOppIdTeamId.put(tender.Opportunity__c, teamIds);
                            }
                            else
                            {
                                Set<Id> teamIds = new Set<Id>();
                                teamIds.add(ts.UserOrGroupId);
                                mapOppIdTeamId.put(tender.Opportunity__c, teamIds);
                            }
                        }
                    }
                }
            }
        }
        
        if (oppTeam.size() > 0)
        {
            insert oppTeam;
            
            // Update OpportunityAccessLevel because this field is updatable but not creatable
            List<OpportunityShare> oppShare = new List<OpportunityShare>();
            for (Opportunity opp : [Select Id, (Select Id, UserId From OpportunityTeamMembers where Reason__c = :System.label.LBL0122), (Select Id, UserOrGroupId From Shares where RowCause = 'Team') From Opportunity where Id IN :mapOppIdTeamId.keySet()])
            {
                Set<Id> userTenderShare = mapOppIdTeamId.get(opp.Id);
                for (OpportunityTeamMember otm : opp.OpportunityTeamMembers)
                    userTenderShare.add(otm.UserId);
                    
                for (OpportunityShare os : opp.Shares)
                {
                    if (userTenderShare.contains(os.UserOrGroupId))
                    {
                        os.OpportunityAccessLevel = 'Edit';
                        oppShare.add(os);
                    }
                }
            }
            
            if (oppShare.size() > 0)
                update oppShare;
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        if(a.NumberOfErrors > 0)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{System.label.LBL0058});
            mail.setReplyTo('noreply@salesforce.com');
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('BatchTenderSharing - '+a.Status);
            mail.setPlainTextBody('Batch Process has completed. '+a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        // FEAT#0544
        if(!Test.isRunningTest()) {
            BatchTenderSharing bts = new BatchTenderSharing();
            bts.query = 'Select Id, Opportunity__c from Tender__c where Opportunity__c != null';
            String cronID = System.scheduleBatch(bts, 'Batch Tender Sharing', 3); 
            // FEAT#0544
        }
    }
}