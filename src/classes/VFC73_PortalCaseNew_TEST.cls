/*
  Class Test Controller for VFC73_PortalCaseNew
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
   ~ Date Created    : 27/06/2014 
*/
@isTest
private class VFC73_PortalCaseNew_TEST {
    static testMethod void testVFC73() {
        System.debug('## >>>>> testing class VFC73_PortalCaseNew START <<<<<');
        
        Case testcase = new Case(Subject='case test', Type = 'Technical question', Description = 'test text');
        insert testcase;
        
        Test.startTest();
        
        PageReference VFP73 = Page.VFP73_PortalCaseNew; 
        Test.setCurrentPage(VFP73);
        ApexPages.currentPage().getParameters().put('Id', testcase.Id);
        ApexPages.currentPage().getParameters().put('retURL', 'VFP64_PortalHome');
        ApexPages.currentPage().getParameters().put('cas5', System.Label.LBL0204);
        testcase.Subject='';
        VFC73_PortalCaseNew VFC73 = new VFC73_PortalCaseNew(new ApexPages.StandardController(testcase));
        PageReference ret = VFC73.doSave();
        testcase.Type = '';
        VFC73 = new VFC73_PortalCaseNew(new ApexPages.StandardController(testcase));
        ret = VFC73.doSave();
        testcase.Description = null;
        VFC73 = new VFC73_PortalCaseNew(new ApexPages.StandardController(testcase));
        ret = VFC73.doSave();
        testcase.Subject='case test';
        testcase.Type = 'Technical question';
        testcase.Description = 'test text';
        VFC73 = new VFC73_PortalCaseNew(new ApexPages.StandardController(testcase));
        ret = VFC73.doSave();
        VFC73.redirect();
            
        Test.stopTest();       
                                                    
        System.debug('## >>>>> testing class VFC73_PortalCaseNew END <<<<<');
    }
    
    @IsTest
    public static void testReopenRequest_NullSomeFields() {
    	Case testcase = new Case(Subject='case test', Type = 'Technical question', Description = 'test text', Survey_Taken_Date__c = System.today());
        insert testcase;
        
        Test.startTest();
        
        PageReference VFP73 = Page.VFP73_PortalCaseNew; 
        Test.setCurrentPage(VFP73);
        ApexPages.currentPage().getParameters().put('Id', testcase.Id);

        testcase.Subject='';
        VFC73_PortalCaseNew VFC73 = new VFC73_PortalCaseNew(new ApexPages.StandardController(testcase));
        
        Test.stopTest();       
        
        System.assertEquals(null, VFC73.PortalCase.Id);
        System.assertEquals(null, VFC73.PortalCase.Survey_Taken_Date__c);
    }
    
}