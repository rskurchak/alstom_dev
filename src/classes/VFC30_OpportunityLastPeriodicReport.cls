/*
 VFC30_OpportunityLastPeriodicReport 
    ~ Author            : Fabien TAILLON ~ fabien.taillon@cgi.com
    ~ Modification Date : 08/07/2013
    ~ Description       : Controller of VFP30_OpportunityLastPeriodicReport Page
*/
public with sharing class VFC30_OpportunityLastPeriodicReport 
{
	private Opportunity opportunity;
	public PeriodicReport__c periodicReport {get;set;}
	
	public VFC30_OpportunityLastPeriodicReport(ApexPages.StandardController controller)
	{
		this.opportunity = (Opportunity)controller.getRecord();
		
		if (opportunity != null)
		{
			List<PeriodicReport__c> listPr = [Select Id, ReportDate__c, LastInformation__c from PeriodicReport__c where Opportunity__c = :this.opportunity.Id and IsLast__c = true Limit 1];
				
			if (listPr.size() > 0)
				periodicReport = listPr.get(0);
			else
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, System.label.LBL0059));
		}
	}
}