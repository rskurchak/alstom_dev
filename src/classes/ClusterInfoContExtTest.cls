@IsTest
public class ClusterInfoContExtTest {

    @TestSetup
    public static void setup() {
        TestUtils.cluster('X');
        TestUtils.cluster('Y');
        TestUtils.cluster('Z');
    }

    @IsTest
    public static void testGetCluster() {
        Program__c program = TestUtils.program('Test');
        ApexPages.StandardController controller = new ApexPages.StandardController(program);
        ClusterInfoContExt ext = new ClusterInfoContExt(controller);
        System.assertEquals(program.Cluster__c, ext.getCluster().Id);
    }

}