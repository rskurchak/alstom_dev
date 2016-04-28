public with sharing class ClusterInfoContExt {

	private final Program__c program;
	private final ProgramSynthesisServices services;
	private Cluster__c cluster;

    public ClusterInfoContExt(ApexPages.StandardController controller) {
    	this(getProgram(controller), new ProgramSynthesisServicesImpl());
    }

	// Test constructor
    public ClusterInfoContExt(Program__c program, ProgramSynthesisServices services) {
    	this.program = program;
    	this.services = services;
    }
    
    public Cluster__c getCluster() {
    	if (cluster == null) {
			cluster = services.getCluster(program.cluster__c);
    	}
    	
    	return cluster;
    }
    
    private static Program__c getProgram(ApexPages.StandardController controller) {
      	if (!Test.isRunningTest()) {
    		controller.addFields(new String[] { 'Cluster__c'});	
    	}

    	return (Program__c) controller.getRecord();
	}
}