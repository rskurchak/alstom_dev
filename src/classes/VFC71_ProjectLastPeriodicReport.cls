/*
 VFC71_ProjectLastPeriodicReport 
    ~ Author            : Christophe Averseng
    ~ Modification Date : 19/05/2014 - copied from VFC30
    ~ Description       : Controller of VFP71_ProjectLastPeriodicReport Page
*/
public with sharing class VFC71_ProjectLastPeriodicReport 
{
  private Project__c prj;
  public ProjectPeriodicReport__c periodicReport {get;set;}
  
  public VFC71_ProjectLastPeriodicReport(ApexPages.StandardController controller)
  {
    this.prj= (Project__c)controller.getRecord();
    
    if (prj != null)
    {
      List<ProjectPeriodicReport__c> listPr = [Select Id, ReportDate__c, LastInformation__c from ProjectPeriodicReport__c where Project__c = :this.prj.Id and IsLast__c = true Limit 1];
        
      if (listPr.size() > 0)
        periodicReport = listPr.get(0);
      else
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, System.label.LBL0137));
    }
  }
}