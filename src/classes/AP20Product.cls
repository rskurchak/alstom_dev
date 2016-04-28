/*
 AP20Product APEX Class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 21/03/2013
    ~ Description     : Apex Class 
                        - Add a Chatter Feed on the Parent Opportunity          
*/
public with sharing class AP20Product 
{
    public static void addOpportunityInsertChatterFeed(list<Product__c> listeProducts)
    {
        List<FeedItem> feedItemsToInsert = new List<FeedItem>();
        
        for(Product__c prod : listeProducts)
        {
            String message = System.Label.LBL0005;
            message = message + '.';
            
            FeedItem oppFeedItem = new FeedItem();
            oppFeedItem.ParentId = prod.Opportunity__c;
            oppFeedItem.Type = 'LinkPost';
            oppFeedItem.LinkUrl = '/'+prod.Id;
            oppFeedItem.Title = 'Product ' + prod.Name;
            oppFeedItem.Body = message;
            feedItemsToInsert.add(oppFeedItem);
        }
        
        insert feedItemsToInsert;
    }
    
    public static void addOpportunityUpdateChatterFeed(list<Product__c> listeNewProducts, map<Id, Product__c> mapOldProducts)
    {
        List<FeedItem> feedItemsToInsert = new List<FeedItem>();
        
        String productLineLabel = Schema.Product__c.fields.ProductLine__c.getDescribe().getLabel();
        String platformLabel= Schema.Product__c.fields.Platform__c.getDescribe().getLabel();
        String productLineShareLabel = Schema.Product__c.fields.Contribution__c.getDescribe().getLabel();
        
        for(Product__c prod : listeNewProducts)
        {
            String message = System.Label.LBL0006;
            
            if (prod.ProductLine__c != mapOldProducts.get(prod.Id).ProductLine__c)
                message = message + '\n - ' + productLineLabel + ' from ' + ((mapOldProducts.get(prod.Id).ProductLine__c != null)?mapOldProducts.get(prod.Id).ProductLine__c:'a blank value') + ' to ' + ((prod.ProductLine__c != null)?prod.ProductLine__c:'a blank value');

            if (prod.Platform__c != mapOldProducts.get(prod.Id).Platform__c)
                message = message + '\n - ' + platformLabel + ' from ' + ((mapOldProducts.get(prod.Id).Platform__c != null)?mapOldProducts.get(prod.Id).Platform__c:'a blank value') + ' to ' + ((prod.Platform__c != null)?prod.Platform__c:'a blank value');
        
            if (prod.Contribution__c != mapOldProducts.get(prod.Id).Contribution__c)
                message = message + '\n - ' + productLineShareLabel + ' from ' + ((mapOldProducts.get(prod.Id).Contribution__c != null)?String.valueOf(mapOldProducts.get(prod.Id).Contribution__c):'a blank value') + ' to ' + ((prod.Contribution__c != null)?String.valueOf(prod.Contribution__c):'a blank value');
            
            FeedItem oppFeedItem = new FeedItem();
            oppFeedItem.ParentId = prod.Opportunity__c;
            oppFeedItem.Type = 'LinkPost';
            oppFeedItem.LinkUrl = '/'+prod.Id;
            oppFeedItem.Title = 'Product ' + prod.Name;
            oppFeedItem.Body = message;
            feedItemsToInsert.add(oppFeedItem);
        }
        
        insert feedItemsToInsert;
    }
}