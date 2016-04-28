/*
 AP65ProjectPeriodicReport Apex Class
    ~ Author          : Christophe AVERSENG
    ~ Date Created    : 15/05/2014 - copied from AP28PeriodicReport
    ~ Description     : Apex Class 
              - Set the IsLast Field
*/
public with sharing class AP65ProjectPeriodicReport 
{
  public static void updateIsLast(List<ProjectPeriodicReport__c> listProjectPeriodicReports)
  {
    List<Id> prjIds = new List<Id>();
    for (ProjectPeriodicReport__c pr : listProjectPeriodicReports)
      prjIds.add(pr.Project__c);
    
    Set<ProjectPeriodicReport__c> prToUpdate = new Set<ProjectPeriodicReport__c>();
    for (Project__c prj : [Select Id, (Select Id, ReportDate__c, IsLast__c From Project_Periodic_Reports__r) from Project__c where Id IN :prjIds])
    {
      if (prj.Project_Periodic_Reports__r.size() > 0)
      {
        ProjectPeriodicReport__c mostRecent = prj.Project_Periodic_Reports__r.get(0);
        ProjectPeriodicReport__c isLast = new ProjectPeriodicReport__c();
        for (ProjectPeriodicReport__c pr : prj.Project_Periodic_Reports__r)
        {
          if (pr.ReportDate__c > mostRecent.ReportDate__c)
            mostRecent = pr;
            
          if (pr.IsLast__c)
            isLast = pr;
        }
        
        // If there is at least one Project Periodic Report flagged as Last
        if (isLast.Id != null)
        {
          // The Project Periodic Report flagged as Last isn't the last anymore
          if (isLast.Id != mostRecent.Id)
          {
            isLast.IsLast__c = false;
            mostRecent.IsLast__c = true;
            prToUpdate.add(isLast);
            prToUpdate.add(mostRecent);
          }
          // Otherwise the isLast flag is already OK
        }
        else
        {
          mostRecent.IsLast__c = true;
          prToUpdate.add(mostRecent);
        }
      }
    }
    
    if (prToUpdate.size() > 0)
    {
      List<ProjectPeriodicReport__c> listPrToUpdate = new List<ProjectPeriodicReport__c>();
      listPrToUpdate.addAll(prToUpdate);
      update listPrToUpdate;
    }
  }
}