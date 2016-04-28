/*
 AP46ApproverGroup 
    ~ Author            : fabien.taillon@cgi.com
    ~ Modification Date : 22/10/2013
    ~ Description       : Update Tender Sharing List from Approver Group 
     ~ Feature Id	   : FEAT#0595
 *   ~ Author          : yamyle Merle-Remond ~ yamyle.merle-remond@axoa.fr 
     ~ Date Created    : 15/04/2014
     ~ Description     : Correction Sales Team Manually Added.
*/
public without sharing class AP46ApproverGroup 
{
	public static void updateTenderSharingList(List<TenderSubmission__c> listTS) 
	{
		List<Id> tendersIds = new List<Id>();
		for (TenderSubmission__c ts : listTS)
			tendersIds.add(ts.Tender__c);
		
		List<ApproverGroup__c> listAG = [Select Id from ApproverGroup__c where Submission__c IN :listTS ALL ROWS];
		
		updateTenderSharingList(tendersIds);
	} 
	
	public static void updateTenderSharingList(List<ApproverGroup__c> listAG) 
	{
		// Not querying ApproverGroup directly to make it work for delete trigger
		List<Id> tenderSubmissionsIds = new List<Id>();
		for (ApproverGroup__c ag : listAG)
			tenderSubmissionsIds.add(ag.Submission__c);
		
		List<Id> tendersIds = new List<Id>();	
		for (TenderSubmission__c ts : [Select Id, Tender__c from TenderSubmission__c where Id IN :tenderSubmissionsIds])
			tendersIds.add(ts.Tender__c);
		
		updateTenderSharingList(tendersIds);
	}
	
	public static void updateTenderSharingList(List<Id> tendersIds) 
	{
		// Deleting old Tender Share
		List<Tender__Share> tenderShareToDelete = [Select Id from Tender__Share where rowCause = :Schema.Tender__Share.rowCause.SubmissionApproval__c and ParentId IN :tendersIds];
		delete tenderShareToDelete;
		
		// Deleting old Opportunity Team Members
		Set<Id> oppIds = new Set<Id>();
		for (Tender__c tender : [Select Id, Opportunity__c from Tender__c where Id IN :tendersIds])
			if (tender.Opportunity__c != null)
				oppIds.add(tender.Opportunity__c);
		
		List<OpportunityTeamMember> oppTeamToDelete = [Select Id from OpportunityTeamMember where Reason__c = :System.label.LBL0123 and OpportunityId IN :oppIds];
		delete oppTeamToDelete;
		
		//Correction Override Sales Team Member
		Set<Id> UserOppTeamAutreReason = new Set<Id>();
		for (OpportunityTeamMember oppTeamAutreReason : [Select Id, UserId from OpportunityTeamMember where OpportunityId IN :oppIds]){
			UserOppTeamAutreReason.add(oppTeamAutreReason.UserId);
		}
		// Getting new Approvers
		Set<String> uniqueTenderShare = new Set<String>();
		List<Tender__Share> newTenderShares = new List<Tender__Share>();
		List<OpportunityTeamMember> newOppTeam = new List<OpportunityTeamMember>();
		List<Id> opportunitiesIds = new List<Id>();
		for (ApproverGroup__c approver : [Select Id, Approver1__c, Approver1__r.IsActive, Approver2__c, Approver2__r.IsActive, 
												 Approver3__c, Approver3__r.IsActive, Approver4__c, Approver4__r.IsActive, 
												 Approver5__c, Approver5__r.IsActive, Approver6__c, Approver6__r.IsActive, 
												 Approver7__c, Approver7__r.IsActive, Approver8__c, Approver8__r.IsActive, 
												 Approver9__c, Approver9__r.IsActive, Approver10__c, Approver10__r.IsActive,
												 Submission__r.Tender__c, Submission__r.Tender__r.Opportunity__c from ApproverGroup__c where Submission__c IN 
												 (Select Id from TenderSubmission__c where Tender__c IN :tendersIds)])
		{
			for (Integer i = 1; i < 11; i++)
			{
				if (approver.get('Approver'+i+'__c') != null)
				{
					if (!uniqueTenderShare.contains(approver.Submission__r.Tender__c + '' + approver.get('Approver'+i+'__c'))
						&& (boolean)approver.getSObject('Approver'+i+'__r').get('IsActive'))
					{
						uniqueTenderShare.add(approver.Submission__r.Tender__c + '' + approver.get('Approver'+i+'__c'));
						newTenderShares.add(new Tender__Share(ParentId = approver.Submission__r.Tender__c, rowCause = Schema.Tender__Share.rowCause.SubmissionApproval__c, UserOrGroupId = (Id)approver.get('Approver'+i+'__c'), AccessLevel = 'Edit'));
						//Correction Override Sales Team Member
						//if (approver.Submission__r.Tender__r.Opportunity__c != null)
						if (approver.Submission__r.Tender__r.Opportunity__c != null && !UserOppTeamAutreReason.contains((Id)approver.get('Approver'+i+'__c')))
						{
							newOppTeam.add(new OpportunityTeamMember(UserId = (Id)approver.get('Approver'+i+'__c'), OpportunityId = approver.Submission__r.Tender__r.Opportunity__c, TeamMemberRole = 'Other', Reason__c = System.Label.LBL0123));
							opportunitiesIds.add(approver.Submission__r.Tender__r.Opportunity__c);
						}
					}
				}
			}
		}
		
		if (newTenderShares.size() > 0)
			insert newTenderShares;
			
		if (newOppTeam.size() > 0)
		{
			insert newOppTeam;
			
			List<OpportunityShare> oppShare = new List<OpportunityShare>();
			// Update OpportunityAccessLevel because this field is updatable but not creatable
			for (Opportunity opp : [Select Id, (Select Id, UserId From OpportunityTeamMembers where Reason__c = :System.label.LBL0123), (Select Id, UserOrGroupId From Shares where RowCause = 'Team') From Opportunity where Id IN :opportunitiesIds])
			{
				Set<Id> userTenderShare = new Set<Id>();
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
}