trigger PeriodicReportAfterUndelete on PeriodicReport__c (after undelete) 
{
	System.debug('## >>> PeriodicReport__c after undelete <<< run by ' + UserInfo.getName());
	
	/*********************************************************************************************
        AP28PeriodicReport
        - set the IsLast Field
    *********************************************************************************************/
    if (PAD.canTrigger('AP28'))
		AP28PeriodicReport.updateIsLast(trigger.new);
		
	System.debug('## >>>  PeriodicReport__c after undelete : END <<<');
}