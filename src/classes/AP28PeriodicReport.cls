/*
 AP28PeriodicReport Apex Class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 03/07/2013
    ~ Description     : Apex Class 
                        - Set the IsLast Field on the most recent Periodic Report, based on ReportDate__c. Only one record
                          can be IsLast for a given Opportunity. Setting IsLast on the most recent record will also unset it
                          on all other Periodic Reports related to the same Opportunity.
*/
public with sharing class AP28PeriodicReport 
{
    public static void updateIsLast(List<PeriodicReport__c> listPeriodicReports)
    {
        List<Id> oppIds = new List<Id>();
        for (PeriodicReport__c pr : listPeriodicReports)
            oppIds.add(pr.Opportunity__c);
        
        Set<PeriodicReport__c> prToUpdate = new Set<PeriodicReport__c>();
        for (Opportunity opp : [Select Id, (Select Id, ReportDate__c, IsLast__c From Last_Reports__r) from Opportunity where Id IN :oppIds])
        {
            if (opp.Last_Reports__r.size() > 0)
            {
                PeriodicReport__c mostRecent = opp.Last_Reports__r.get(0);
                PeriodicReport__c isLast = new PeriodicReport__c();
                for (PeriodicReport__c pr : opp.Last_Reports__r)
                {
                    if (pr.ReportDate__c > mostRecent.ReportDate__c)
                        mostRecent = pr;
                        
                    if (pr.IsLast__c)
                        isLast = pr;
                }
                
                // If there is at least one Periodic Report flagged as Last
                if (isLast.Id != null)
                {
                    // The Periodic Report flagged as Last isn't the last anymore
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
            List<PeriodicReport__c> listPrToUpdate = new List<PeriodicReport__c>();
            listPrToUpdate.addAll(prToUpdate);
            update listPrToUpdate;
        }
    }
}