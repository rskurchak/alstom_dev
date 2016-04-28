/*
 AP62ProjectProduct apex class
   ~ Author          : Christophe Averseng
   ~ Date Created    : 05/05/2014 (copied from AP15Product)
   ~ Description     : Apex Class 
              - automatically update the related Project : ProductLines__c summary field 
*/
public with sharing class AP62ProjectProduct
{
  public static void updateProjectProductLineSummary(List<ProjectProduct__c> lProducts)
  {
    list<Id> idProjects = new list<Id>();
    for (ProjectProduct__c pp : lProducts)
      idProjects.add(pp.Project__c);
      
    list<Project__c> lProjects = [Select Id, (Select Id, ProductLine__c , Leading__c from Project_Products__r order by ProductLine__c, Leading__c desc), ProductLines__c from Project__c where Id in :idProjects];
    for (Project__c prj : lProjects)
    {
      String prodLineSummary = '';
      Set<String> prodLines = new Set<String>();
      for (ProjectProduct__c prod : prj.Project_Products__r)
      {
        if (!prodLines.contains(prod.ProductLine__c))
        {
          prodLines.add(prod.ProductLine__c);
          if (prod.Leading__c)
            prodLineSummary = prodLineSummary + prod.ProductLine__c + ' (Leading); ';
          else
            prodLineSummary = prodLineSummary + prod.ProductLine__c + '; ';
        }
      }
      
      if (prodLineSummary.length() >= 2)
        prodLineSummary = prodLineSummary.substring(0, prodLineSummary.length()-2);
        
      prj.ProductLines__c = prodLineSummary;
    }
    
    update lProjects;
  }
}