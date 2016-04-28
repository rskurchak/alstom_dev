/*
 AP64ProjectProduct apex class
   ~ Author          : Christophe AVERSENG 
    ~ Date Created    : 05/05/2014
    ~ Description     : Apex Class 
                        - automatically update the related Project Leading Product Line and Leading Platform fields when the Leading product is changed
*/
public class AP64ProjectProduct 
{
    // automatically update the related Project Leading Product Line and Leading Platform fields when the Leading product is changed
    // context : ProjectProduct__c After Insert and After Update
    public static void updateProjectProductInfo(List<ProjectProduct__c> products)
    {
        System.debug('## >>> Starting AP64ProjectProduct.updateProjectProductInfo <<<');
        
        List<Project__c> projects2Update = new List<Project__c>();
        Set<Id> prjIds = new Set<Id>();
        list<Id> prjToUncheckOtherLeading = new list<Id>();
        
        for(ProjectProduct__c prd : products)
        {
            if (!prjIds.contains(prd.Project__c))
            {
                projects2Update.add(new Project__c(Id=prd.Project__c, Platform__c=prd.Platform__c,ProductLine__c=prd.ProductLine__c,Product__c=prd.Product__c));
                prjIds.add(prd.Project__c);
            }
            
            if(prd.TECH_ProdCount__c > 0)
                prjToUncheckOtherLeading.add(prd.Project__c);
        }
        
        if(prjToUncheckOtherLeading.size() > 0)
        {
            list<ProjectProduct__c> listeProduct = [Select Id, Leading__c from ProjectProduct__c where Leading__c = true and Project__c IN :prjToUncheckOtherLeading and Id NOT IN :products];
            
            for (ProjectProduct__c p : listeProduct)
                p.Leading__c = false;
                
            update listeProduct;
        }
            
        if(projects2Update.size() > 0)
            update projects2Update;
        
        System.debug('## >>> END AP64ProjectProduct.updateProjectProductInfo <<<');
    }
    
    // Blank the Leading Product Line and Leading Platform fields in Project when the leading Project Product is deleted
    // Context : ProjectProductAfterDelete
    public static void blankProjectProductInfo(List<ProjectProduct__c> products)
    {
        System.debug('## >>> Starting AP64ProjectProduct.blankProjectProductInfo <<<');
        
        List<Project__c> prjToUpdate = new List<Project__c>();
        
        for (ProjectProduct__c prd : products)
            if (prd.Leading__c == true)
                prjToUpdate.add(new Project__c(Id=prd.Project__c, Platform__c='',ProductLine__c='',Product__c=''));
  
        if (prjToUpdate.size() > 0)
            update prjToUpdate;
                          
        System.debug('## >>> END AP64ProjectProduct.blankProjectProductInfo <<<');
    }
}