trigger PeriodicReportAfterDelete on PeriodicReport__c (after delete) 
{
	System.debug('## >>> PeriodicReport__c after delete <<< run by ' + UserInfo.getName());
	
	/*********************************************************************************************
        AP28PeriodicReport
        - set the IsLast Field
    *********************************************************************************************/
    if (PAD.canTrigger('AP28'))
		AP28PeriodicReport.updateIsLast(trigger.old);
		
	System.debug('## >>>  PeriodicReport__c after delete : END <<<');
}