/*
 AP63ProjectProduct apex class
   ~ Author          : Christophe AVERSENG
   ~ Date Created    : 05/05/2014
   ~ Description     : Apex Class 
              - automatically update the related Project: 'TECH_Platforms1' and 'TECH_Platforms2' summary fields  
*/
public with sharing class AP63ProjectProduct 
{
  public static void updateProjectPlatformSummary(List<ProjectProduct__c> lProducts)
  {
    list<Id> idProjects = new list<Id>();
    for (ProjectProduct__c p : lProducts)
      idProjects.add(p.Project__c);
    
    list<Project__c> lProjects = [Select Id, TECH_Platforms1__c, TECH_Platforms2__c, (Select Id, Platform__c from Project_Products__r order by Platform__c asc) from Project__c where Id in :idProjects];
    for (Project__c prj : lProjects)
    {
      // Summary must start and finish with ';' for sharing rules
      String platformSummary1 = ';';
      String platformSummary2 = ';';
      Set<String> platforms = new Set<String>();
      for (ProjectProduct__c prod : prj.Project_Products__r)
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
      
      prj.TECH_Platforms1__c = platformSummary1;
      if (platformSummary2.length() > 1)
        prj.TECH_Platforms2__c = platformSummary2;
    }
    
    update lProjects;
  }
}