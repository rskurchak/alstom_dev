public with sharing class MockProgramSynthesisServices implements ProgramSynthesisServices {
    
    private Cluster__c cluster;
    private Map<FiscalYear, List<ProgramAllocation__c>> allocations;
    private List<ProgramAllocation__c> savedAllocations;
    
    public MockProgramSynthesisServices() {
    }

    public Cluster__c getCluster(Id programId) {
        return cluster;
    }
    
    public Map<FiscalYear, List<ProgramAllocation__c>> getProgramAllocations(Id programId) {
        System.debug('Returning mock allocations:' + allocations);
        return allocations;
    }
    
    public void saveProgramAllocations(List<ProgramAllocation__c> allocations) {
        this.savedAllocations = allocations;
    }
    
    // Test data setter
    public MockProgramSynthesisServices setCluster(Cluster__c cluster){
        this.cluster = cluster;
        return this;
    }

	// Test data setter    
    public MockProgramSynthesisServices setProgramAllocations(Map<FiscalYear, List<ProgramAllocation__c>> allocations) {
        this.allocations = allocations;
        return this;
    }

    // Verification method
    public List<ProgramAllocation__c> getSavedProgramAllocations() {
        return savedAllocations;
    }

}