/*
    VisualForce Controller for VFP13_OpportunityAssessment_Edit
    ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
    ~ Date Created    : 12/07/2012
*/   
public class VFC13_OpportunityAssessment_Edit 
{
    /* Variables */
    public List<OpportunityAssessment__c> assessments {get; set;}
    private String oppId = Apexpages.currentPage().getParameters().get('id');
    
    /* Constructor */
    public VFC13_OpportunityAssessment_Edit(ApexPages.StandardSetController controller) 
    {
        //get the OpportunityAssessment__c with status = Open related to the Opportunity
        assessments = [SELECT Id, Opportunity__c FROM OpportunityAssessment__c WHERE Status__c='Open' AND Opportunity__c = :oppId];
    }
    
    /* Methods */
    // method excuted after the confirmation of the user when he click on new Opportunity Assessment
    public PageReference init()
    {
        PageReference vfp12 = Page.VFP12_OpportunityAssessment;
        if(assessments.size() == 0)
        {
            try 
            { 
                // try to insert a new Opportunity Assessment 
                //String oppNum = [SELECT OppNumber__c FROM Opportunity WHERE Id = :oppId LIMIT 1].OppNumber__c;
                OpportunityAssessment__c oppAssessment= new OpportunityAssessment__c(Status__c='Open', Opportunity__c=oppId, AssessmentVersion__c='01');
                insert oppAssessment;
    
                // insert the default compititor for the Opportunity Assessment (ALSTOM Record) 
                insert  new OpportunityActor__c(Competitor__c=System.Label.LBL0008, Opportunity__c=oppId, Role__c='Competitor', RecordTypeId=UtilityTestMethod.oppActorRecTypes.get('OpportunityActorCompetitors'), Ranking__c = 1); 
                
                // set the Opportunity Assessment Id to VFP12 and redirect to it
                
                vfp12.getParameters().put('Id',oppAssessment.Id);
                
            } 
            catch(Exception ex) 
            {
                ApexPages.addMessages(ex);
                System.debug('>>> FOR TEST METHOD <<< Insert oppAssessment and/or Competition :'+ex);
                return null;
            }
        }
        else
            vfp12.getParameters().put('Id',assessments.get(0).Id);
        
        vfp12.setRedirect(true);
        return vfp12;
    }
}//action="{!IF(assessments.size = 0, init(), URLFOR('/apex/VFP12_OpportunityAssessment', null, [id=assessments[0].Id, retURL=assessments[0].Opportunity__c], true))}">