/*
 AP44TenderReport Apex Class
    ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
    ~ Date Created    : 25/09/2013
    ~ Description     : Method updateIsLast : 
    					- Scan all records for the related Tender. The Tender Report having the most recent value 
    					  for Report Date field must be flagged (Set the IsLast Field). The other records must be unflagged. 
    					  Records must not be updated if the flag doesn't change => if multiple records, 
    					  only one is unflagged and only one is flagged, the other ones are not updated. 
    					  If only one record existing, it must be flagged
    					Method setOppFields : 
    					- Set LastTenderReport__c and LastTenderReportDate__c fields for Opportunity from Abstract__c and ReportDate__c fields of the last Tender Report
						- Set LastTenderReportManagementAttention__c field for Opportunity from ManagementAttention__c field of the related Tender
    					Method setAbstractFieldForOpp :
    					- Set LastTenderReport__c field for Opportunity from Abstract__c field of the last Tender Report
    ~ Triggers 		  : TenderReportAfterInsert, TenderReportAfterUpdate, TenderReportAfterDelete, TenderReportAfterUndelete
    ~ Feature Id      : FEAT#0475 
    ~ Feature Id      : FEAT#0541 
    ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 03/03/2014
    ~ Description     : fields  : Abstract__, ReportDate__c and LastTenderReportManagementAttention__c are deleted from Opportunity.
                      : as well as the functionality to sync them.
    ~ Feature Id      : FEAT#0546 
    ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 07/03/2014
    ~ Description     : Bug: Flag IsLastTender should not be calculated based on TenderReports with empty date
*/
public with sharing class AP44TenderReport 
{
	// Set the IsLast Field for the last Tender Report
    public static void updateIsLast(List<TenderReport__c> listTenderReports)
    {
    	// Contains the Tenders Ids
        List<Id> tenderIds = new List<Id>();
        for (TenderReport__c tr : listTenderReports)
            tenderIds.add(tr.Tender__c);
        
        // Contains the Report Tender to update
        Set<TenderReport__c> trToUpdate = new Set<TenderReport__c>();
        
        // Contains the related Opportunity to the last Tender Tender to update
        List<Opportunity> listOpp = new List<Opportunity>();
        for (Tender__c tend : [Select Id, ManagementAttention__c, (Select Id, ReportDate__c, IsLast__c, Opportunity__c, Tender__c, Abstract__c From Tender_Reports__r order by ReportDate__c desc) from Tender__c where Id IN :tenderIds])
        {
            if (tend.Tender_Reports__r.size() > 0)
            {
                TenderReport__c mostRecent = tend.Tender_Reports__r.get(0);
                TenderReport__c isLast = new TenderReport__c();
                for (TenderReport__c tr : tend.Tender_Reports__r)
                {
                    if (tr.ReportDate__c > mostRecent.ReportDate__c || (tr.Id != mostRecent.Id && mostRecent.ReportDate__c == null)) {
		                if (mostRecent.IsLast__c)
		                {
		                	mostRecent.IsLast__c = false;
		                	trToUpdate.add(mostRecent);
		                }
                        mostRecent = tr; 
                    }
                    else {
	                    if (tr.IsLast__c && tr.Id != mostRecent.Id) {
	                        //isLast = tr;
	                        tr.IsLast__c = false;
	                        trToUpdate.add(tr);
	                    }
                    }
                }
                if (!mostRecent.IsLast__c)
                {
                	mostRecent.IsLast__c = true;
                	trToUpdate.add(mostRecent);
                }
            }
        }
        if (trToUpdate.size() > 0)
        {
        	// Contains the last Tender Report and the most recent Tender Report to update
            List<TenderReport__c> listTrToUpdate = new List<TenderReport__c>();
            
            // Contains the related Opportunity to the last Tender Tender to update
            List<Opportunity> listOppToUpdate = new List<Opportunity>();
            
            listTrToUpdate.addAll(trToUpdate);
            listOppToUpdate.addAll(listOpp);
            
            update listTrToUpdate;
            update listOppToUpdate;
        }
    }
    
}