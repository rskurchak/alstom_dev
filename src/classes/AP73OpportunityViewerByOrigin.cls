public without sharing class AP73OpportunityViewerByOrigin
{
	/* Generic method that will do the job */
	public static void updateSalesTeamForViewerByOrigin(Set<Id> opportunityIdList, Set<Id> usersIds) 
	{
		// Deleting previous Sales Team with "Viewer by Origin" Reason
		List<OpportunityTeamMember> oppTeamToDelete = new List<OpportunityTeamMember>();
		
		// Filter on usersIds if list is provided, otherwise get everything
		if (usersIds != null)
		{
			oppTeamToDelete = [Select Id from OpportunityTeamMember where Reason__c = :System.label.LBL0342 and OpportunityId IN :opportunityIdList and UserId IN :usersIds];
		}
		else
		{
			oppTeamToDelete = [Select Id from OpportunityTeamMember where Reason__c = :System.label.LBL0342 and OpportunityId IN :opportunityIdList];
		}
		delete oppTeamToDelete;

		// Getting the list of Users to add to the Sales Team
		Map<Id, Set<Id>> mapOpptyUsers = new Map<Id, Set<Id>>();

		for (TerangaUnit__c tu : [Select Id, (Select PxO__r.Opportunity__c From PxO_Lines__r where PxO__r.Opportunity__c IN :opportunityIdList), 
									(Select Id, Name, TerangaUnit__c, User__c From Viewers_by_Origin__r) From TerangaUnit__c where Id IN (Select TerangaUnit__c from ViewerByOrigin__c)])
		{
			// Getting the list of Viewers for this Site
			Set<Id> setViewerIds = new Set<Id>();
			for (ViewerByOrigin__c vbu : tu.Viewers_by_Origin__r)	
				setViewerIds.add(vbu.User__c);

			// For all Opportunities (from opportunityIdList) linked to this Site, add the list of related users
			for (PxOLine__c pxol : tu.PxO_Lines__r)
			{
				// If there are already some Users for this Opportunity, just add them to the list
				if (mapOpptyUsers.get(pxol.PxO__r.Opportunity__c) != null)
				{
					Set<Id> setUserIds = mapOpptyUsers.get(pxol.PxO__r.Opportunity__c);
					setUserIds.addAll(setViewerIds);
					mapOpptyUsers.put(pxol.PxO__r.Opportunity__c, setUserIds);
				}
				else
				{
					Set<Id> setUserIds = new Set<Id>();
					mapOpptyUsers.put(pxol.PxO__r.Opportunity__c, setViewerIds);
				}
			}
		}

		// Constructing 2 lists because @future methods only accept primitive data types (WTF !)
		List<Id> oppIdList = new List<Id>();
		List<Id> userIdList = new List<Id>();
		for (Id oppId : mapOpptyUsers.keySet())
		{
			for (Id userId : mapOpptyUsers.get(oppId))
			{
				oppIdList.add(oppId);
				userIdList.add(userId);
			}
		}

		// If limit is exceeded, use future method
		if (Limits.getDMLRows() + oppIdList.size() > Limits.getLimitDMLRows())
		{
			// Adding Users to the Sales Team - Using @future to prevent DML Limit
			addUsersToSalesTeamFuture(oppIdList, userIdList);
		}
		else
		{
			addUsersToSalesTeam(oppIdList, userIdList);
		}
	}

	/* Overrided method that will get the Opportunities Ids from Viewers by Origin */
	public static void updateSalesTeamForViewerByOrigin(List<ViewerByOrigin__c> listVbo)
	{
		Set<Id> terangaUnitsIds = new Set<Id>();
		Set<Id> userIds = new Set<Id>();

		for (ViewerByOrigin__c vbo : listVbo)
		{
			terangaUnitsIds.add(vbo.TerangaUnit__c);
			// Adding users updated, to prevent updating all Opportunity Team Members
			userIds.add(vbo.User__c);
		}

		Set<Id> relatedOpptyIds = new Set<Id>();
		for (TerangaUnit__c tu : [Select Id, (Select PxO__r.Opportunity__c From PxO_Lines__r) from TerangaUnit__c where Id IN :terangaUnitsIds])
		{
			for (PxOLine__c pxol : tu.PxO_Lines__r)
			{
				relatedOpptyIds.add(pxol.PxO__r.Opportunity__c);
			}
		}
		
		if (relatedOpptyIds.size() > 0)
			updateSalesTeamForViewerByOrigin(relatedOpptyIds, userIds);
	}

	/* Overrided method that will get the Opportunities Ids from PxO Lines */
	public static void updateSalesTeamForViewerByOrigin(List<PxOLine__c> listPxoLines)
	{
		Set<Id> relatedOpptyIds = new Set<Id>();
		for (PxOLine__c pxol : [Select PxO__r.Opportunity__c From PxOLine__c where Id IN :listPxoLines])
		{
			relatedOpptyIds.add(pxol.PxO__r.Opportunity__c);
		}
		
		if (relatedOpptyIds.size() > 0)
			updateSalesTeamForViewerByOrigin(relatedOpptyIds, null);
	}

	// Adding Users to the Sales Team
	static void addUsersToSalesTeam(List<Id> oppIdList, List<Id> userIdList)
	{
		List<OpportunityTeamMember> oppTeamMembers = new List<OpportunityTeamMember>();
		for (Integer i = 0; i < oppIdList.size(); i++)
		{
			OpportunityTeamMember otm = new OpportunityTeamMember(UserId = userIdList.get(i), OpportunityId = oppIdList.get(i), TeamMemberRole = 'Other', Reason__c = System.Label.LBL0342);
			oppTeamMembers.add(otm);
		}

		// Insert the list of users in the Sales Team
		if (oppTeamMembers.size() > 0)
			insert oppTeamMembers;
	}

	@future 
	static void addUsersToSalesTeamFuture(List<Id> oppIdList, List<Id> userIdList)
	{
		addUsersToSalesTeam(oppIdList, userIdList);
	}
}