trigger ProjectAfterDelete on Project__c (after delete) 
{
	System.debug('## >>> Project after delete <<< run by ' + UserInfo.getName());

    /**********************************************************************************************
        AP25Project - Update Account Team
    ***********************************************************************************************/
    /* Remove deletion due to an impact with CR-0699, see CR-0802 */
    /*
    if (PAD.canTrigger('AP25'))
		AP25Project.deleteAccountTeam(Trigger.old);
    */
    
    System.debug('## >>> Project after delete : END <<<');
}