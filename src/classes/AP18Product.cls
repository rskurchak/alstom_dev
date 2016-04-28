/*
 AP18Product apex class
   	~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com
    ~ Date Created    : 19/02/2013
    ~ Description     : Apex Class 
                        - automatically update the related Opportunity : 'TECH_Platforms1' and 'TECH_Platforms2' summary fields  
                        FEAT#0683 - C. Averseng - Add same update on related Tenders
	~ Author          : Antonin MAIGNE ~ antonin.maigne@cgi.com
    ~ Date Created    : 09/02/2015
    ~ Description     : CR-0697 - Tech_Products field
*/
public without sharing class AP18Product 
{
    public static void updateOppPlatformSummary(List<Product__c> lProducts)
    {
        list<Id> idOpportunities = new list<Id>();
        list<Tender__c> lTenders = new list<Tender__c>();
        for (Product__c p : lProducts)
            idOpportunities.add(p.Opportunity__c);
        
        list<Opportunity> lOpportunities = [Select Id, TECH_Platforms1__c, TECH_Platforms2__c, (Select Id, Platform__c from Other_Products__r order by Platform__c asc), Tender__c from Opportunity where Id in :idOpportunities];
        for (Opportunity opp : lOpportunities)
        {
            // Summary must start and finish with ';' for sharing rules
            String platformSummary1 = ';';
            String platformSummary2 = ';';
            Set<String> platforms = new Set<String>();
            for (Product__c prod : opp.Other_Products__r)
            {
                if (!platforms.contains(prod.Platform__c) && prod.Platform__c != null)
                {
                    platforms.add(prod.Platform__c);
                    
                    if ((platformSummary1 + prod.Platform__c + ';').length() < 255)
                        platformSummary1 = platformSummary1 + prod.Platform__c + ';';
                    else
                        platformSummary2 = platformSummary2 + prod.Platform__c + ';';
                }
            }
            
            opp.TECH_Platforms1__c = platformSummary1;
            if (platformSummary2.length() > 1)
                opp.TECH_Platforms2__c = platformSummary2;
                
             if (opp.Tender__c != null)
            {
                lTenders.add(new Tender__c(Id = opp.Tender__c, TECH_Platforms1__c = opp.TECH_Platforms1__c, TECH_Platforms2__c = opp.TECH_Platforms2__c));
            }
        }
        
        update lOpportunities;
        update lTenders;
    }
    
    public static void updateOppProductSummary(List<Product__c> lProducts)
    {
        List<Id> idOpportunities = new List<Id>();        
        for (Product__c p : lProducts)
        {
        	idOpportunities.add(p.Opportunity__c);
        }
                    
        List<Opportunity> lOpportunities = [SELECT Id, TECH_Products__c, (SELECT Id, Product__c FROM Other_Products__r ORDER BY Product__c ASC), Tender__c FROM Opportunity WHERE Id IN: idOpportunities];
        for (Opportunity opp : lOpportunities)
        {
            // Summary must start and finish with ';' for sharing rules
            String productSummary = ';';
            Set<String> products = new Set<String>();
            for (Product__c prod : opp.Other_Products__r)
            {
                if (!products.contains(prod.Product__c) && prod.Product__c != null)
                {
                    products.add(prod.Product__c);
                    productSummary = productSummary + prod.Product__c + ';';
                }
            }            
            opp.TECH_Products__c = productSummary;               		
        }        
        update lOpportunities;        
    }
}