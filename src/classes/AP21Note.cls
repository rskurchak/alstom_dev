/*
 AP21Product APEX Class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 21/03/2013
    ~ Description     : Apex Class 
    					- Add a Chatter Feed on the Parent Opportunity			
*/
public with sharing class AP21Note 
{
	public static void newNoteChatterFeed(list<Note> listeNotes)
	{
		List<FeedItem> feedItemsToInsert = new List<FeedItem>();
		
		for (Note n : listeNotes)
		{	
			FeedItem conFeedItem = new FeedItem();
            conFeedItem.ParentId = n.ParentId;
            conFeedItem.Type = 'LinkPost';
            conFeedItem.LinkUrl = '/'+n.Id;
            conFeedItem.Title = n.Title;
            conFeedItem.Body = 'created a new Note.';
            feedItemsToInsert.add(conFeedItem);
		}
		
		insert feedItemsToInsert;
	}
	
	public static void updatedNoteChatterFeed(list<Note> listeNotes)
	{
		List<FeedItem> feedItemsToInsert = new List<FeedItem>();
		
		for (Note n : listeNotes)
		{	
			FeedItem conFeedItem = new FeedItem();
            conFeedItem.ParentId = n.ParentId;
            conFeedItem.Type = 'LinkPost';
            conFeedItem.LinkUrl = '/'+n.Id;
            conFeedItem.Title = n.Title;
            conFeedItem.Body = 'updated a Note.';
            feedItemsToInsert.add(conFeedItem);
		}
		
		insert feedItemsToInsert;
	}
}