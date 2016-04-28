/*
 AP19Opportunity apex class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 19/02/2013
    ~ Description     : Apex Class 
                        - calculate Field Sum of Global + all Child Opportunities Selling Prices on Global Opportunity          
*/
public without sharing class AP19Opportunity 
{
    public static void initGlobalSellingPrice(list<Opportunity> globalOpps)
    {
        for(Opportunity o : globalOpps)
            o.Sum_of_Global_Child_Opp_Selling_Price__c = o.Amount;
    }
    
    public static void calculateGlobalSellingPrice(list<Opportunity> globalOpps)
    {
        CurrencyUtility cu = new CurrencyUtility();
        map<Id, Opportunity> oppMap = new map<Id, Opportunity>();
        for(Opportunity opp : globalOpps)
            oppMap.put(opp.Id, opp);
        
        list<Opportunity> oList = [Select Id, convertCurrency(Amount), Sum_of_Global_Child_Opp_Selling_Price__c, closeDate, CurrencyIsoCode, (Select Id, convertCurrency(Amount), closeDate From Opportunities__r) from Opportunity where Id IN :globalOpps];
        for(Opportunity o : oList)
        {
            if (oppMap.get(o.Id).CurrencyIsoCode != UserInfo.getDefaultCurrency() && oppMap.get(o.Id).Amount != null)
                o.Sum_of_Global_Child_Opp_Selling_Price__c = cu.convertToCurrency(oppMap.get(o.Id).Amount, oppMap.get(o.Id).CurrencyIsoCode, UserInfo.getDefaultCurrency(), oppMap.get(o.Id).closeDate);
            else
                o.Sum_of_Global_Child_Opp_Selling_Price__c = oppMap.get(o.Id).Amount;
            
            if (o.Sum_of_Global_Child_Opp_Selling_Price__c == null)
                o.Sum_of_Global_Child_Opp_Selling_Price__c = 0;
                
            for (Opportunity oChild : o.Opportunities__r)
                if (oChild.Amount != null)
                    o.Sum_of_Global_Child_Opp_Selling_Price__c = o.Sum_of_Global_Child_Opp_Selling_Price__c + oChild.Amount;

            if (oppMap.get(o.Id).CurrencyIsoCode != UserInfo.getDefaultCurrency() && o.Sum_of_Global_Child_Opp_Selling_Price__c != null)
                o.Sum_of_Global_Child_Opp_Selling_Price__c = cu.convertToCurrency(o.Sum_of_Global_Child_Opp_Selling_Price__c, UserInfo.getDefaultCurrency(), oppMap.get(o.Id).CurrencyIsoCode, oppMap.get(o.Id).closeDate);
            
            oppMap.get(o.Id).Sum_of_Global_Child_Opp_Selling_Price__c = o.Sum_of_Global_Child_Opp_Selling_Price__c;
        }
    }
    
    public static void calculateGlobalSellingPrice(Set<Id> globalOppsId)
    {
        list<Opportunity> oppIds = new list<Opportunity>();
        for (Id oppId : globalOppsId)
            oppIds.add(new Opportunity(Id = oppId));
        
        // Sum update will be done in Global Opportunity update trigger
        update oppIds;
    }
    
    public static void emptySellingPrice(list<Opportunity> opps)
    {
        // Setting value to null because we want to see an empty field, not 0
        for(Opportunity o : opps)
            o.Sum_of_Global_Child_Opp_Selling_Price__c = null;
    }
}