/*
 VFC77_PortalCaseScoreScript
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 27/06/2014 
    ~ Description     : Apex Class to display Satisfaction Questionnaire.
*/
public without sharing class VFC77_PortalCaseScoreScript {
	
    public Case PortalCase {get;set;}
    public Case actualcase {get;set;}
 	public boolean showBtnSatisfaction {get; set;}   
 	public Decimal SatisfactionScore {get; set;} 
 	public string usercomments {get; set;}     
    
    public VFC77_PortalCaseScoreScript(ApexPages.StandardController controller) {
        this.PortalCase= (Case) controller.getRecord();
        actualcase = [Select Id, Status, SatisfactionQuestionnaire__c, Satisfaction__c, UserComments__c from Case where id = : this.PortalCase.Id];
        SatisfactionScore = actualcase.Satisfaction__c;
        usercomments = actualcase.UserComments__c;
        boolean isCaseClosed = false;
		if([Select Id, MasterLabel From CaseStatus Where IsClosed = true and MasterLabel = :actualcase.Status].size()>0){
			isCaseClosed = true;
		}
        if (isCaseClosed && actualcase.SatisfactionQuestionnaire__c){
	        showBtnSatisfaction = true; 
        }else {
	        showBtnSatisfaction = false;         	
        }
    }

	public List<SelectOption> getSatisfactions(){
        List<selectOption> options = new List<selectOption>();
       	for (integer i=1;i<=10;i++) {
        	options.add(new selectOption(''+ i, ''+ i));
      	}
  		return options;
	}   

    public void doSave() {
        try {
        	system.debug ('in save usercomments: ' + SatisfactionScore);
        	system.debug ('in save satisfaction: ' + usercomments);
        	actualcase.Satisfaction__c = SatisfactionScore;
        	actualcase.UserComments__c = usercomments;
            update actualcase;
            if(Test.isRunningTest()){
                throw new UtilityTestMethod.myException();
            }
        } catch (Exception e){// roll everything back in case of error
            ApexPages.addMessages(e);
         }
    }    
}