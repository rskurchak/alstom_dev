trigger ProjectAfterUpdate on Project__c (after update) 
{
	System.debug('## >>> Project after update <<< run by ' + UserInfo.getName());

    /**********************************************************************************************
        AP25Project - Update Account Team
    ***********************************************************************************************/
    if (PAD.canTrigger('AP25'))
    {
    	List<Project__c> projectTeamToDelete = new List<Project__c>();
        List<Project__c> projectTeamToUpdate = new List<Project__c>();
        for (Project__c proj : Trigger.new)
        {
            if (proj.OwnerId != Trigger.oldMap.get(proj.Id).OwnerId
            	|| proj.Account__c != Trigger.oldMap.get(proj.Id).Account__c) 
            {
            	projectTeamToDelete.add(Trigger.oldMap.get(proj.Id));
            	
            	if (proj.Account__c != null)
            		projectTeamToUpdate.add(proj);
            }
        }
        
        /* Remove deletion due to an impact with CR-0699, see CR-0802 */
        /*
        if (projectTeamToDelete.size() > 0)
			AP25Project.deleteAccountTeam(projectTeamToDelete);
		*/

        if (projectTeamToUpdate.size() > 0)
			AP25Project.updateAccountTeam(projectTeamToUpdate);
    }
    
    System.debug('## >>> Project after update : END <<<');
}