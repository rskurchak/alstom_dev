/*
 AP66Tender APEX Class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 15/09/2014
    ~ Description     : Apex Class 
                        - Add a Chatter Feed on the Parent Opportunity          
*/
public with sharing class AP66Tender 
{
	public static void addOpportunityChatterFeed(list<Tender__c> listTenders)
    {
        List<FeedItem> feedItemsToInsert = new List<FeedItem>();
        
        for (Tender__c tender : listTenders)
        {   
            FeedItem oppFeedItem = new FeedItem();
            oppFeedItem.ParentId = tender.Opportunity__c;
            oppFeedItem.Type = 'TextPost';
            oppFeedItem.Body = System.Label.LBL0301;
            oppFeedItem.Visibility = 'InternalUsers';
            feedItemsToInsert.add(oppFeedItem);
        }
        
        insert feedItemsToInsert;
    }
}