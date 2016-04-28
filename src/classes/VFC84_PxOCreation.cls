public without sharing class VFC84_PxOCreation 
{
	public PxO__c newPxO {get;set;}
	public List<PxOStandard__c> listPxOStandards {get;set;}
	public Id selectedPxOId {get;set;}
	public Opportunity relatedOpp {get;set;}
	private map<Id, PxOStandard__c> mapPxOStandards;
	private map<Id, RecordType> mapPxoRt;
	
	public VFC84_PxOCreation(ApexPages.StandardController stdCtrl)
	{
		String oppId = ApexPages.currentPage().getParameters().get('oppId');
		String recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
		
		// Creating a map of Record Type Names to do matching later
		mapPxoRt = new map<Id, RecordType>([SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'PxO__c']);
		
		newPxO = new PxO__c();
		relatedOpp = new Opportunity();
		mapPxOStandards = new map<Id, PxOStandard__c>();
		
		listPxOStandards = new List<PxOStandard__c>();
		if (oppId != null && oppId != '')
			newPxO.Opportunity__c = oppId;
		
		if (recordTypeId != null && recordTypeId != '')
			newPxO.RecordTypeId = recordTypeId;
	}
	
	public PageReference getPxOStandards()
	{
		listPxOStandards.clear();
		
		if (newPxO.Opportunity__c != null)
		{
            if (newPxO.RecordTypeId == null)
            {
            	ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Missing Record Type');
            	ApexPages.addMessage(msg);
				return null;
            }
            
			relatedOpp = [Select Id, Name, ATRegion__c, RecordTypeId, BOid__c, (Select Id, Platform__c, Product__c From Other_Products__r), (Select Id from PxO__r where RecordTypeId = :newPxO.RecordTypeId) from Opportunity where Id = :newPxO.Opportunity__c];
			
			// Check that Opportunity doesn't already have this kind of PxO
			if (relatedOpp.PxO__r.size() > 0)
            {
                // Redirect to the existing PxO
                return new PageReference('/' + relatedOpp.PxO__r.get(0).Id + '/e?retURL=' + newPxO.Opportunity__c);
            }
            
			Set<String> authorizedPlatforms = new Set<String>();
			Set<String> authorizedProductFound = new Set<String>();
			authorizedPlatforms.addAll(System.Label.LBL0305.split(';'));

			for (Product__c product : relatedOpp.Other_Products__r)
			{
				if (authorizedPlatforms.contains(product.Platform__c))
				{
					authorizedProductFound.add(product.Product__c);
				}
			}
			
			if (authorizedProductFound.size() > 0)
			{
				// Get the Record Type Names to do the matching
				// No try catch because names should be set up accordingly, and if not we will be warned at the first crash instead of never knowing the issue
				Id pxoStdRtId = [SELECT Id FROM RecordType WHERE SObjectType = 'PxOStandard__c' and DeveloperName = :mapPxoRt.get(newPxO.RecordTypeId).DeveloperName].Id;
				
				listPxOStandards = [Select Id, Name, RecordTypeId, RecordType.Name, Platform__c, Product__c, 
									ATRegion__c, SubRegion__c, Approver__c, Comments__c from PxOStandard__c 
									where ATRegion__c = :relatedOpp.ATRegion__c
									AND Product__c IN :authorizedProductFound
									AND RecordTypeId = :pxoStdRtId];
									
				// If no PxO Standard is found, then all existing PxO Standard records of the same Record Type are proposed to selection
				if (listPxOStandards.size() == 0)
				{
					listPxOStandards = [Select Id, Name, RecordTypeId, RecordType.Name, Platform__c, Product__c, 
										ATRegion__c, SubRegion__c, Approver__c, Comments__c from PxOStandard__c 
										where RecordTypeId = :pxoStdRtId];
										
					// If no PxO Standard exists with the appropriate record type, a message is displayed
					if (listPxOStandards.size() == 0)
					{
						ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Warning, System.Label.LBL0311 + ' ' + mapPxoRt.get(newPxO.RecordTypeId).Name);
		            	ApexPages.addMessage(msg);
						return null;
					}
				}
				
				for (PxOStandard__c pxos : listPxOStandards)
					mapPxOStandards.put(pxos.Id, pxos);
				
				// If only one PxO Standard found, skip selection page
				if (mapPxOStandards.size() == 1)
				{
					selectedPxOId = listPxOStandards.get(0).Id;
					return selectPxOStandard();
				}
			}
			else
			{
				// Products not eligible for PxO
				ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Warning, System.Label.LBL0304);
            	ApexPages.addMessage(msg);
				return null;
			}
		}

		return null;
	}
	
	public PageReference selectPxOStandard()
	{
		newPxO.Name = mapPxoRt.get(newPxO.RecordTypeId).Name + '-' + relatedOpp.BOid__c;
		
		// retrieve PxOStandard Id and values from VF Page
		PxOStandard__c selectedPxOStd = mapPxOStandards.get(selectedPxOId);
		newPxO.Platform__c = selectedPxOStd.Platform__c;
		newPxO.Product__c = selectedPxOStd.Product__c;
		newPxO.ATRegion__c = selectedPxOStd.ATRegion__c;
		newPxO.SubRegion__c = selectedPxOStd.SubRegion__c;
		newPxO.Approver__c = selectedPxOStd.Approver__c;
		newPxO.Comments__c = selectedPxOStd.Comments__c;
		
		try
		{
			insert newPxO;
			
			// Creating PxO Line from PxO Standard Line
			List<PxOLine__c> pxoLines = new List<PxOLine__c>();
			
			Id pxoLineRtId = [SELECT Id FROM RecordType WHERE SObjectType = 'PxOLine__c' and DeveloperName = :mapPxoRt.get(newPxO.RecordTypeId).DeveloperName].Id;
			for (PxOStandardLine__c pxoStdLine : [Select Id, MoBStrategy__c, Site__c, Type__c from PxOStandardLine__c where PxOStandard__c = :selectedPxOId])
			{
				PxOLine__c pxoL = new PxOLine__c();
				pxoL.RecordTypeId = pxoLineRtId;
				pxoL.PxO__c = newPxO.Id;
				pxoL.MoBStrategy__c = pxoStdLine.MoBStrategy__c;
				pxoL.StandardMoBStrategy__c = pxoStdLine.MoBStrategy__c;
				pxoL.Site__c = pxoStdLine.Site__c;
				pxoL.StandardSite__c = pxoStdLine.Site__c;
				pxoL.Type__c = pxoStdLine.Type__c;				
				pxoLines.add(pxoL);
			}
		
			if (pxoLines.size() > 0)
				insert pxoLines;
				
			return new PageReference('/' + newPxO.Id + '?retURL=' + relatedOpp.Id);
		}
		catch (Exception e)
		{
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
            ApexPages.addMessage(msg);
			return null;
		}
	}
}