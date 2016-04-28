trigger ConfidentialInformationAfterInsert on ConfidentialInformation__c (after insert) 
{
	  System.debug('## >>> Opportunity after insert <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP06ConfidentialInformation
        - Uautomatically add the owner of the parent object (Account, Contact, Opportunityn, Competitor, Competitors Contact) 
    	  in the sharing table for the Confidentia lInformation
    **************************************************************************************************************/
    if(PAD.canTrigger('AP06'))//bypass
		AP06ConfidentialInformation.createParentSharing(Trigger.new);
       
    System.debug('## >>> Opportunity after insert : END <<<');

}