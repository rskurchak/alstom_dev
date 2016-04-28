/*
 AP07Product apex class
   ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
    ~ Date Created    : 09/07/2012 
    ~ Description     : Apex Class 
                        - automatically update the related Opportunity Product Line and Platform fields when the Leading product is changed it values
*/
public class AP07Product 
{
    //automatically update the related Opportunity Product Line and Platform fields when the Leading product is changed it values
    // context : Product__c After Insert and after Update
    public static void updateOpportunityProductInfo(List<Product__c> products)
    {
        System.debug('## >>> Starting AP07Product.updateOpportunityProductInfo <<<');
        
        List<Opportunity> opportunities2Update = new List<Opportunity>();
        Set<Id> oppIds = new Set<Id>();
        list<Id> oppToUncheckOtherLeading = new list<Id>();
        
        for(Product__c prd : products)
        {
            if (!oppIds.contains(prd.Opportunity__c))
            {
                opportunities2Update.add(new Opportunity(Id=prd.Opportunity__c, Platform__c=prd.Platform__c,LeadingProductLine__c=prd.ProductLine__c, Leading_Product__c=prd.Product__c));
                oppIds.add(prd.Opportunity__c);
            }
            
            if(prd.TECH_ProdCount__c > 0)
                oppToUncheckOtherLeading.add(prd.Opportunity__c);
        }
        
        if(oppToUncheckOtherLeading.size() > 0)
        {
            list<Product__c> listeProduct = [Select Id, Leading__c from Product__c where Leading__c = true and Opportunity__c IN :oppToUncheckOtherLeading and Id NOT IN :products];
            
            for (Product__c p : listeProduct)
                p.Leading__c = false;
                
            update listeProduct;
        }
            
        if(opportunities2Update.size() > 0)
            update opportunities2Update;
        
        System.debug('## >>> END AP07Product.updateOpportunityProductInfo <<<');
    }
}