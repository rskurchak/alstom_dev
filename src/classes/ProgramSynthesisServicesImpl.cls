public with sharing class ProgramSynthesisServicesImpl implements ProgramSynthesisServices {
	
    public Cluster__c getCluster(Id clusterId) {
		Cluster__c[] clusters = [select Id, Name, Owner.Name, Cluster_Coordinator__r.Name from Cluster__c where Id = :clusterId limit 1];
		if (clusters.size() > 0) {
			return clusters[0];
		}
    	
    	return null;
    }
   
    public Map<FiscalYear, List<ProgramAllocation__c>> getProgramAllocations(Id ProgramId) {
        List<ProgramAllocation__c> allocations = [select Id, Name, SiteName__c, ActualsCurrentFY__c, Budget__c, Authorization__c, Forecast__c, FiscalYear__c, TECH_CurrentFY__c from ProgramAllocation__c where Program__c = :programId];

        System.debug('Program allocations fetched:' + allocations);

        Map<FiscalYear, List<ProgramAllocation__c>> fiscalYearsMap = new Map<FiscalYear, List<ProgramAllocation__c>>();
        
        for (ProgramAllocation__c a : allocations) {
            FiscalYear fiscalYear = new FiscalYear(a.FiscalYear__c, a.TECH_CurrentFY__c);

            List<ProgramAllocation__c> all = fiscalYearsMap.get(fiscalYear);
            if (all == null) {
                all = new List<ProgramAllocation__c>();
            }

            all.add(a);
            fiscalYearsMap.put(fiscalYear, all);
        }
        
        System.debug('Fiscal Years Map created:' + fiscalYearsMap);        
        return fiscalYearsMap;
    }
    
    public void saveProgramAllocations(List<ProgramAllocation__c> allocations) {
        if (allocations == null || allocations.size() == 0) {
            return;
        }
        update allocations;
    }

}