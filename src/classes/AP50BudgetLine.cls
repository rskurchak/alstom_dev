/**
 * AP49FI15 Apex Class
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
     ~ Date Created    : 09/10/2013
     ~ Description	   : Add a post for FI15 Chatter Feed when :
						 - a child Budget Line record is created.
						 - a child Budget Line Amount field is modified.
     ~ Triggers		   : BudgetLineAfterInsert, BudgetLineAfterUpdate
     ~ Feature Id	   : FEAT#0440
 */
public with sharing class AP50BudgetLine {
	public static void addFI15ChatterPost(list<BudgetLine__c> budgetLineList, String sBody)
	{
		List<FeedItem> feedItemsToInsert = new List<FeedItem>();
		
		// Getting needed informations on related BudgetLine
		Map<Id, BudgetLine__c> budgetLineMap = new Map<Id, BudgetLine__c>([Select Id, Name, FI15__r.Name From BudgetLine__c where Id IN :budgetLineList]);
		
		// Set feed items from BudgetLine informations
		for (BudgetLine__c budgetLine : budgetLineList)
		{	
			FeedItem FI15FeedItem = new FeedItem();
            FI15FeedItem.ParentId = budgetLine.FI15__c;
            FI15FeedItem.Type = 'LinkPost';
            FI15FeedItem.LinkUrl = '/'+budgetLine.Id;
            FI15FeedItem.Title = 'Budget Line ' + budgetLine.Name;
            FI15FeedItem.Body = sBody;
            feedItemsToInsert.add(FI15FeedItem);
		}
		// Insert Feed Items for FI15
		insert feedItemsToInsert;
	}
}