public class CaseSurveyContExt {

    private ApexPages.StandardController controller;
    private Case c;

    public CaseSurveyContExt(ApexPages.StandardController controller) {
        this.controller = controller;
        if (!Test.isRunningTest()) {
            System.debug('Adding Survey_Taken_Date__c as a field to be retrieved');
            controller.addFields(new List<String> {'Survey_Taken_Date__c', 'Survey_is_submitted__c'});
        }
        c = (Case) controller.getRecord();
    }

    public PageReference checkSurvey() {
        System.debug('Checking survey whether it has been submitted already');
        if ( !c.Survey_is_submitted__c ) {
            System.debug('Survey not submitted yet');
            return null;
        } else {
            System.debug('Survey submitted already, redirecting to Survey Complete page');
            return getCaseDetailPage();
        }
    }

    public PageReference save() {
        System.debug('Saving case...');
        c.Survey_Taken_Date__c = System.today();
        c.Survey_is_submitted__c = true;
        c.SatisfactionQuestionnaire__c = false;      
        System.debug('Updated case survey info: ' + c);
        controller.save();
        return getCaseDetailPage();
    }

    public PageReference reopenRequest() {
    	// Save survey fields first
    	save();
        System.debug('Reopening the case (redirect)');
        return new PageReference('/apex/VFP73_PortalCaseNew?id=' + c.Id);
    }

    private PageReference getCaseDetailPage() {
        PageReference pageReference = new PageReference('/CaseWithDetail?id=' + c.Id);
        pageReference.setRedirect(true);
        return pageReference;
    }
}