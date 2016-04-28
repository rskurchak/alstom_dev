@IsTest
public class ProgramSystenthesisServicesImplTest {
    
    @TestSetup
    public static void init() {
        TestUtils.cluster('A');
        TestUtils.cluster('B');
        TestUtils.cluster('C');
        
        Program__c program = TestUtils.program('XYZ');
        TestUtils.programAllocation('X', program, '15-16');
        TestUtils.programAllocation('Y', program, '15-16');
        TestUtils.programAllocation('Z', program, '16-17');
    }
    
    @IsTest
    public static void testGetCluster_Success() {
        Cluster__c expected = TestUtils.cluster('TEST');
        ProgramSynthesisServicesImpl services = new ProgramSynthesisServicesImpl();
		Cluster__c cluster = services.getCluster(expected.Id);
        System.assertEquals(expected.Id, cluster.Id);
    }

    @IsTest
    public static void testGetCluster_NotFound() {
        ProgramSynthesisServicesImpl services = new ProgramSynthesisServicesImpl();
        Cluster__c cluster = services.getCluster(Id.valueOf('a0b3E0000008QjH')); // non-existent
        System.assertEquals(null, cluster);
    }

	@IsTest
    public static void testGetProgramAllocations() {
        Program__c program = TestUtils.program('Test');
        TestUtils.programAllocation('A', program, '15-16');
        TestUtils.programAllocation('B', program, '15-16');
        TestUtils.programAllocation('C', program, '16-17');
        
        ProgramSynthesisServicesImpl services = new ProgramSynthesisServicesImpl();
        Map<FiscalYear, List<ProgramAllocation__c>> allocations = services.getProgramAllocations(program.Id);
        
        System.assertEquals(2, allocations.size());
        Set<FiscalYear> fiscalYears = allocations.keySet();
        
        FiscalYear fy1516 = new FiscalYear('15-16', false);
        FiscalYear fy1617 = new FiscalYear('16-17', false);
        
        System.assert(fiscalYears.contains(fy1516));
        System.assert(fiscalYears.contains(fy1617));
                      
        System.assertEquals(2, allocations.get(fy1516).size());
        System.assertEquals(1, allocations.get(fy1617).size());
    }

}