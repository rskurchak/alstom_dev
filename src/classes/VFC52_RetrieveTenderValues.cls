public with sharing class VFC52_RetrieveTenderValues 
{
	TenderSubmission__c tenderSubmission {get;set;}
	
	public VFC52_RetrieveTenderValues(ApexPages.StandardController controller) 
	{
        this.tenderSubmission = (TenderSubmission__c)controller.getRecord();
	}
	
	public PageReference retrieveTenderValues()
	{
		if (tenderSubmission != null && tenderSubmission.Id != null)
		{
			List<TenderSubmission__c> listTender = new List<TenderSubmission__c>();
			listTender.add(tenderSubmission);
			
			try 
			{
				AP43TenderSubmission.getAmountsInformations(listTender);
				update listTender;
			}
			catch (Exception e)
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
				return null;
			}
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must specify a Tender Submission Id.'));
			return null;
		}
		
		return new PageReference('/'+tenderSubmission.Id);
	}
	
	public PageReference back()
	{
		return new PageReference('/'+tenderSubmission.Id);
	}
}