public with sharing class SitemapController 
{
	public List<PartAndRepair__c> listParts {get;set;} 

	public SitemapController() 
	{
		listParts = [Select Id from PartAndRepair__c];
	}
}