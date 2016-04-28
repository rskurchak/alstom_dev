public interface ProgramSynthesisServices {

    Cluster__c getCluster(Id clusterId);

    Map<FiscalYear, List<ProgramAllocation__c>> getProgramAllocations(Id ProgramId);
    
    void saveProgramAllocations(List<ProgramAllocation__c> allocations);

}