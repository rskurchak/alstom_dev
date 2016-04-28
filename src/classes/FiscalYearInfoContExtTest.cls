@IsTest
public class FiscalYearInfoContExtTest {

    @TestSetup
    public static void setup() {
        
    }
    
    @IsTest
    public static void testAllocations() {
        Program__c program = TestUtils.program('Test');
        Map<FiscalYear, List<ProgramAllocation__c>> expectedAllocations = allocations(program);
        
        FiscalYearInfoContExt ext = controller(program, expectedAllocations);
        
        Map<FiscalYear, List<ProgramAllocation__c>>  allocations = ext.getAllocations();
        System.debug('Returned allocations: ' + allocations);
        assertEquals(expectedAllocations, allocations);
    }
    
    @IsTest
    public static void testGetExpandedMap() {
        Program__c program = TestUtils.program('Test');
        Map<FiscalYear, List<ProgramAllocation__c>> expectedAllocations = allocations(program);
        
        FiscalYearInfoContExt ext = controller(program, expectedAllocations);

        Map<String, Boolean> expandedMap = ext.getExpandedMap();
        System.assertEquals(2, expandedMap.size());
        System.assertEquals(true, expandedMap.get('15-16'));
        System.assertEquals(false, expandedMap.get('16-17'));
    }
    
    @IsTest
    public static void testExpand() {
        Program__c program = TestUtils.program('Test');
        Map<FiscalYear, List<ProgramAllocation__c>> expectedAllocations = allocations(program);
        
        FiscalYearInfoContExt ext = controller(program, expectedAllocations);

        ext.sectionToExpand = '16-17';
        ext.expand();
        Map<String, Boolean> expandedMap = ext.getExpandedMap();
        System.assertEquals(2, expandedMap.size());
        System.assertEquals(true, expandedMap.get('15-16'));
        System.assertEquals(true, expandedMap.get('16-17'));        
    }
    
    @IsTest
    public static void testSave() {
        Program__c program = TestUtils.program('Test');
        Map<FiscalYear, List<ProgramAllocation__c>> expectedAllocations = allocations(program);
        
                MockProgramSynthesisServices mockServices = new MockProgramSynthesisServices().setProgramAllocations(expectedAllocations);
        ApexPages.StandardController controller = new ApexPages.StandardController(program);
        FiscalYearInfoContExt ext = new FiscalYearInfoContExt(controller, mockServices);
       
        ext.save();
        
		System.assertEquals(3, mockServices.getSavedProgramAllocations().size());        
    }
    
    private static FiscalYearInfoContExt controller(Program__c program, Map<FiscalYear, List<ProgramAllocation__c>> expectedAllocations) {
        MockProgramSynthesisServices mockServices = new MockProgramSynthesisServices().setProgramAllocations(expectedAllocations);
        ApexPages.StandardController controller = new ApexPages.StandardController(program);
        FiscalYearInfoContExt ext = new FiscalYearInfoContExt(controller, mockServices);
        return ext;
    }
    
    private static Map<FiscalYear, List<ProgramAllocation__c>> allocations(Program__c program) {
        FiscalYear fy1516 = new FiscalYear('15-16', true);
        FiscalYear fy1617 = new FiscalYear('16-17', false);

        Map<FiscalYear, List<ProgramAllocation__c>> allocations = new Map<FiscalYear, List<ProgramAllocation__c>>();
        allocations.put(fy1617, new List<ProgramAllocation__c> { TestUtils.programAllocation('C', program, '16-17') });
        allocations.put(fy1516, new List<ProgramAllocation__c> { TestUtils.programAllocation('B', program, '15-16'),
            TestUtils.programAllocation('A', program, '15-16') });
        return allocations;
    }
    
    private static void assertEquals(Map<FiscalYear, List<ProgramAllocation__c>> m1, Map<FiscalYear, List<ProgramAllocation__c>> m2) {
        System.assertEquals(m1.size(), m2.size());
        for (FiscalYear key: m1.keySet()) {
        	System.assertEquals(m1.get(key), m2.get(key));
        }
    }

}