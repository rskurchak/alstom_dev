/*
	BatchAccountTeamSharing
    ~ Author          : Fabien Taillon ~ fabien.taillon@cgi.com 
    ~ Date Created    : 12/06/2013
    ~ Description     : Apex Batch to add new Account Team Members to Project Sharing
    /*
~ Modification Log 
~ ============================================================================= 
~ Ver  Date            Author                 Modification 
~ ---  ---------       -----------            ----------------------------------------------- 
~ X.1 23-Jan-2015      Rajendra S. Nagar      INC000004687087
    
*/
global class BatchAccountTeamSharing implements Database.Batchable<SObject>, Database.Stateful 
{
	global String query;
	
	global Database.QueryLocator start(Database.BatchableContext BC) 
	{ 
		return Database.getQueryLocator(query); 
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope)
    {  
    	List<Id> listAccountIds = new List<Id>();
    	for(sObject S : scope)
        	listAccountIds.add(S.Id);
        
        //X.1 
        //Get all the project for current account
        list<id> prjIdList = new list<id>();
        //X.1 
        
    	map<Id, List<AccountTeamMember>> mapAccountIdTeamMember = new map<Id, List<AccountTeamMember>>();
    	
    	for(AccountTeamMember accTeam : [Select Id, AccountId, UserId from AccountTeamMember where AccountId IN :listAccountIds AND UserId NOT IN (Select Id From User where IsActive = false)])
        {    
            if (mapAccountIdTeamMember.get(accTeam.AccountId) != null)
            {
            	List<AccountTeamMember> atm = mapAccountIdTeamMember.get(accTeam.AccountId);
            	atm.add(accTeam);
            	mapAccountIdTeamMember.put(accTeam.AccountId, atm);
        	}
        	else
        	{
        		List<AccountTeamMember> atm = new List<AccountTeamMember>();
            	atm.add(accTeam);
            	mapAccountIdTeamMember.put(accTeam.AccountId, atm);
        	}
        }
        
        
        // Getting Account Owner
        map<Id, Account> mapAccountOwners = new map<Id, Account>([Select Id, OwnerId from Account where Id IN :listAccountIds]);
        
        List<Project__Share> listProjectShare = new List<Project__Share>();
        for (Project__c projet : [Select Id, Account__c from Project__c where Account__c IN :listAccountIds])
        {
        	prjIdList.add(projet.id);//X.1
        	if (mapAccountOwners.get(projet.Account__c) != null)
        		listProjectShare.add(new Project__Share(ParentId = projet.Id, rowCause = Schema.Project__Share.rowCause.Account_Team__c, UserOrGroupId = mapAccountOwners.get(projet.Account__c).OwnerId, AccessLevel = 'Edit'));
        	
        	// Test to see if there is Account Team, and not only Account Owner
        	if (mapAccountIdTeamMember.get(projet.Account__c) != null)
        		for (AccountTeamMember accTeamMember : mapAccountIdTeamMember.get(projet.Account__c))
    				listProjectShare.add(new Project__Share(ParentId = projet.Id, rowCause = Schema.Project__Share.rowCause.Account_Team__c, UserOrGroupId = accTeamMember.UserId, AccessLevel = 'Edit'));
        }
        
        //X.1 - Update start
        // Deleting existing ones
        List<Project__Share> projectShareToDelete = [Select Id From Project__Share where rowCause = :Schema.Project__Share.rowCause.Account_Team__c and ParentId IN :prjIdList];
        delete projectShareToDelete;
        //X.1 - Update End
        
        if (listProjectShare.size() > 0)
        	insert listProjectShare;
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
			mail.setSubject('BatchAccountTeamSharing - '+a.Status);
			mail.setPlainTextBody('Batch Process has completed. '+a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });	
		}
	}
}