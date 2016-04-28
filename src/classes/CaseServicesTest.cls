@isTest
private class CaseServicesTest {
	private final static Integer COUNT_CASE = 4;

	private static void setupData(){
		insert UtilityTestMethod.getCaseList(COUNT_CASE, 'TestStatus');
	}

	@isTest static void testBulletinServices() {
		setupData();

		Test.startTest();
			List<Case> casesSelected = CaseServices.getAvailableCases();
		Test.stopTest();

        System.assertEquals(COUNT_CASE, casesSelected.size(), 'Count cases should be equlas created.');
	}
	
}