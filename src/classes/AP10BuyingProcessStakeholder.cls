/*
 AP10BuyingProcessStakeholder apex class
    ~ Author          : Damian HERCUN ~ damian.hercun@axoa.fr 
    ~ Date Created    : 17/07/2012 
    ~ Description     : Apex Class 
                        - to update Alstom Contact with Contact Owner for all BuyingProcessStakeholder where this field is null
*/

public with sharing class AP10BuyingProcessStakeholder {
    
    // to update Alstom Contact with Contact Owner for all BuyingProcessStakeholder where this field is null
    // contaxt : BuyingProcessStakeholder Before Insert
    public static void fillContact(List<BuyingProcessStakeholder__c> BPSs) 
    {
   		for(BuyingProcessStakeholder__c bps : BPSs)
       	{
	        // get the BuyingProcessStackholder with empty AlstomUser and fill it
            if(bps.AlstomUser__c == null && bps.TECH_OwnerId__c != null) {
    	        bps.AlstomUser__c = bps.TECH_OwnerId__c;
            }
            System.debug('#### BPS Contact before insert : ' + bps.AlstomUser__c);
        }
    }
}