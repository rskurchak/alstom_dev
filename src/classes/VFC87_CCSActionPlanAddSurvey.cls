public without sharing class VFC87_CCSActionPlanAddSurvey 
{
	public CSSActionPlan__c curActionPlan {get;set;}
	public Project__c curProject {get;set;}
	public List<ProjectSurvey__c> ListSurveyProject {get;set;}
	public List<ProjectSurvey__c> ListSurveyActionPlan {get;set;}
	public Set<Id> SetSurveyActionPlanId {get;set;}
	//public Id CSSActionPlanId {get;set;}
	
	public map<Id, Boolean> mapSurveyCheck {get;set;}
	
	
	public VFC87_CCSActionPlanAddSurvey(ApexPages.StandardController stdCtrl)
	{
		curActionPlan = (CSSActionPlan__c)stdCtrl.getrecord();
		//String ActionPlanId = ApexPages.currentPage().getParameters().get('id');
		
		//curActionPlan = [Select Id, Name, Project__c from CSSActionPlan__c where Id = :ActionPlanId];
		//curProject = [Select Id, Name from Project__c where Id = :curActionPlan.Project__c];
		ListSurveyProject = new List<ProjectSurvey__c>();
		ListSurveyActionPlan = new List<ProjectSurvey__c>();
		ListSurveyProject = [Select Id, Name, Status__c, Survey__c, SurveyURL__c, ResponseDate__c,CSSActionPlan__c from ProjectSurvey__c where Project__c = :curActionPlan.Project__c and (CSSActionPlan__c = :curActionPlan.Id OR CSSActionPlan__c = null)];
		ListSurveyActionPlan = [Select Id, Name, Status__c, Survey__c, SurveyURL__c, ResponseDate__c from ProjectSurvey__c where CSSActionPlan__c = :curActionPlan.Id];
		
		SetSurveyActionPlanId = new  Set<Id>();
		mapSurveyCheck = new map<Id, Boolean>();
		for(ProjectSurvey__c p :ListSurveyActionPlan)
		{
			SetSurveyActionPlanId.add(p.Id);
		}
		
		for(ProjectSurvey__c p :ListSurveyProject)
		{
			if(SetSurveyActionPlanId.contains(p.Id))
			{
				mapSurveyCheck.put(p.Id,true);
			}
			else
			{
				mapSurveyCheck.put(p.Id,false);
			}
		}
	}
	

	
	
	public PageReference AddRemoveSurvey()
	{
		for(ProjectSurvey__c p :ListSurveyProject)
		{
			if(p.CSSActionPlan__c == curActionPlan.Id && (mapSurveyCheck.get(p.Id) == false))
			{
				p.CSSActionPlan__c = null;
			}
			
			if(mapSurveyCheck.get(p.Id) == true)
			{
				p.CSSActionPlan__c = curActionPlan.Id;
			}
		}
		
		
		Update ListSurveyProject;
		
		
		return new PageReference('/' + curActionPlan.Id);
		
	}
	
	
}