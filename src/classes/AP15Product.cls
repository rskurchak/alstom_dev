/*
 AP15Product apex class
   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com
    ~ Date Created    : 15/02/2013 
    ~ Description     : Apex Class 
                        - automatically update the related Opportunity : 'Product Line' summary fields 
                        FEAT#0683 - C. Averseng - Add same update on related Tenders
                        04/06/2014 - C. Averseng - "without sharing" required by Tender update
*/
public without sharing class AP15Product 
{
    public static void updateOppProductLineSummary(List<Product__c> lProducts)
    {
        list<Id> idOpportunities = new list<Id>();
        list<Tender__c> lTenders = new list<Tender__c>();
        for (Product__c p : lProducts)
            idOpportunities.add(p.Opportunity__c);
            
        list<Opportunity> lOpportunities = [Select Id, (Select Id, ProductLine__c , Leading__c from Other_Products__r order by ProductLine__c, Leading__c desc), ProductLines__c, Tender__c from Opportunity where Id in :idOpportunities];
        for (Opportunity opp : lOpportunities)
        {
            String prodLineSummary = '';
            Set<String> prodLines = new Set<String>();
            for (Product__c prod : opp.Other_Products__r)
            {
                if (!prodLines.contains(prod.ProductLine__c))
                {
                    prodLines.add(prod.ProductLine__c);
                    if (prod.Leading__c)
                        prodLineSummary = prodLineSummary + prod.ProductLine__c + ' ' + System.Label.LBL0004 + '; ';
                    else
                        prodLineSummary = prodLineSummary + prod.ProductLine__c + '; ';
                }
            }
            
            if (prodLineSummary.length() >= 2)
                prodLineSummary = prodLineSummary.substring(0, prodLineSummary.length()-2);
                
            opp.ProductLines__c = prodLineSummary;
            
            if (opp.Tender__c != null)
            {
                lTenders.add(new Tender__c(Id = opp.Tender__c, ProductLines__c = opp.ProductLines__c));
            }
        }
        
        update lOpportunities;
        update lTenders;

    }
}