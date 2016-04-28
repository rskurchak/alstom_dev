/**
 * AP49FI15 Apex Class
 *   ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
     ~ Date Created    : 09/10/2013
     ~ Description	   : Add a post for Opportunity Chatter Feed when :
     					- FI15 record is created
						- FI15 record is updated
						- FI15 record is approved
     ~ Triggers		   : FI15AfterInsert, FI15AfterUpdate
     ~ Feature Id      : FEAT#0439 
 */
public with sharing class AP49FI15 {
	public static void addOpportunityChatterPost(list<FI15__c> fi15List, String sBody)
	{
		List<FeedItem> feedItemsToInsert = new List<FeedItem>();
		
		// Getting needed informations on related Opportunity
		Map<Id, FI15__c> fi15Map = new Map<Id, FI15__c>([Select Id, Name, Opportunity__r.Name From FI15__c where Id IN :fi15List]);
		
		for (FI15__c fi15 : fi15List)
		{	
			FeedItem OpportunityFeedItem = new FeedItem();
            OpportunityFeedItem.ParentId = fi15.Opportunity__c;
            OpportunityFeedItem.Type = 'LinkPost';
            OpportunityFeedItem.LinkUrl = '/'+fi15.Id;
            OpportunityFeedItem.Title = 'FI15 ' + fi15.Name;
            OpportunityFeedItem.Body = sBody;
            feedItemsToInsert.add(OpportunityFeedItem);
		}

		insert feedItemsToInsert;
	}
}