/*
 CCC09_BCP
    ~ Author            :   Damian Hercun ~ damian.hercun@axoa.fr
    ~ Date Created      :   21/12/2011
    ~ Description       :   Apex controller for visualforce component CCP09_BCP 
*/
public class CCC09_BPS 
{
    /*============================================================================
        V.A.R.I.A.B.L.E.S
    =============================================================================*/ 
    // get icons for the CCP08_IconPicklist component
    public List<IconPicklistValue> getWCSIcons() {
        return new List<IconPicklistValue> {
            new IconPicklistValue('Asset', 'Asset', 'img/asset_16.png'),
            new IconPicklistValue('To be seen', 'To_be_seen', 'img/to_be_seen_16.png'),
            new IconPicklistValue('Watch out', 'Watch_out', 'img/watch_out_16.png')
        };
    }

    // define action type (createBCP or createEXC)
    public String actionType {get; set;}
    
    // id of current bps
    public String bpsId                     {get; set;}

    // id of current opp
    public String oppId                     {get; set;}
    
    // generic BCP used to display input fields
    public BuyingProcessStakeholder__c bps  {get; set;} {bps = new BuyingProcessStakeholder__c();}
    
    public String contactTitle 				{
    	get {
    		if(bps.ContactName__c != null) {
				Contact contact = [SELECT Title FROM Contact WHERE Id =:bps.ContactName__c LIMIT 1].get(0);
    			contactTitle = contact.Title;
    		}
    		return contactTitle;
   		} 
   		set;
   	} 
        
    // external contact name
    public String extContactName            {get; set;}
    
    // javascript callback
    public String jsCallBack                {get; set;}

    /*============================================================================
        M.E.T.H.O.D.S
    =============================================================================*/ 
    // create or update a single bps
    public PageReference saveBPS()
    {
        try {
            if(actionType != 'createEXC') { // diffrent from anonymous
                if(bps.ContactName__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You must select the contact'));
                    return null;
                }
                BuyingProcessStakeholder__c bps2Upsert = new BuyingProcessStakeholder__c(Opportunity__c=oppId);//bps.clone(false, true); // opt_preserve_id, opt_IsDeepClone
                
                if(bpsId != null && bpsId != '') { // update => set id
                    bps2Upsert = new BuyingProcessStakeholder__c(Id=bpsId, Opportunity__c=oppId);
                }
                
                bps2Upsert.ContactName__c = bps.ContactName__c;
                
                bps2Upsert.AlstomUser__c = bps.AlstomUser__c;
                
                bps2Upsert.PromotorType__c = bps.PromotorType__c;
                bps2Upsert.Attitude__c = bps.Attitude__c;
                bps2Upsert.Influence__c = bps.Influence__c;
                bps2Upsert.Typology__c = bps.Typology__c;
                
                bps2Upsert.User__c = bps.User__c;
                bps2Upsert.DecisionMaker__c = bps.DecisionMaker__c;
                bps2Upsert.Consultant__c = bps.Consultant__c;
                
                bps2Upsert.Comments__c = bps.Comments__c;
                
                upsert bps2Upsert;
                bpsId = bps2Upsert.Id;
                bps = bps2Upsert;               
            }
            // else anonymous
            jsCallback += 'saveAndCloseEdit();';
            if(Test.isRunningTest())
            	throw new UtilityTestMethod.myException();
        } catch(Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    // reset bps and cancel
    public PageReference cancel() {
        bps = new BuyingProcessStakeholder__c();
        jsCallback = 'closeEdit();';
        return null;
    }
}