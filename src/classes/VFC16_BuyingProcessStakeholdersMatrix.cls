/*
    VisualForce Controller for VFP16_BuyingProcessStakeholdersMatrix
    ~ Author          : Damian HERCUN ~ damian.hercun@axoa.fr 
    ~ Date Created    : 24/07/2012
        - VFP16 is displayed from the Opportunity page layout, button labeled "View Influence vs Attitude Matrix".
          It shows each Buying Center Stakeholder positioned on a 2-axis graph, based on Attitude and Influence fields.
*/   
public with sharing class VFC16_BuyingProcessStakeholdersMatrix {
    /* Variables */
    // current opportunity Id
    public String oppId {
        get { return ApexPages.currentPage().getParameters().get('oppId'); }
        private set;
    }
    
    // current opportunity object
    public Opportunity opp {
        get {
            if(opp == null) {
                opp = [SELECT Id, Name FROM Opportunity WHERE Id =:oppId];
            }
            return opp;
        }
        set;
    }
    
    // list of opportunities related to the current opportunity
    public List<BuyingProcessStakeholder__c> allBps {
        get {
            if(allBps == null) {
                allBps = [SELECT Id, ContactName__r.Name, Attitude__c, Influence__c FROM BuyingProcessStakeholder__c 
                            WHERE Opportunity__c = :oppId
                            ORDER BY ContactName__c DESC];
            }
            return allBps;
        }
        private set;
    }
    /* Constructor */
    public VFC16_BuyingProcessStakeholdersMatrix() {    }
}