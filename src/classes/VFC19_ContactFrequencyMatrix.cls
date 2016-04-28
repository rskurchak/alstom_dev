/*
	VisualForce Controller for VFP19_ContactFrequencyMatrix
    ~ Author          : Mohamed EL MOUSSAOUI @axoa.fr 
    ~ Date Created    : 14/11/2012
*/  
public class VFC19_ContactFrequencyMatrix 
{
	/* V.A.R.I.A.B.L.E.S. */
	// current opportunity Id
    public String oppId
    {
        get
        {
        	return ApexPages.currentPage().getParameters().get('oppId');
        } 
         set;
    }
    
    // current opportunity object
    public Opportunity opp 
    {
    	get 
    	{
    		if(opp == null && oppId != null) 
    		{
    			opp = [SELECT Id, Name FROM Opportunity WHERE Id =:oppId];
    		}
    		return opp;
    	}
    	set;
    }
    
    // contains the StakeHolders Names
	public Set<String> stakeHolders {get; set;}
	public Map<String, String> stakeHoldersIdName {get; set;}
	
	// contains the AlstomContacts Names
	public Set<String> alstomContacts {get; set;}
	public Map<String, String> alstomContactsIdName {get; set;}
	
	// the map of the relation StakeHolde & Alstom Contact with the Frequency of contac
	public Map<String, String> stackHolderWithValue {get; set;} 
	
	// variable used for rerendreing the Matrix or an Information msg to the user if there no information to show
	public Boolean showTabel {get; set;}
	
	/* C.O.N.S.T.R.U.C.T.O.R. */
	public VFC19_ContactFrequencyMatrix() 
	{
		initMatrix(oppId);
	}
	
	/* METHOD */
	public void initMatrix(Id oppId)
	{
		stakeHolders = new Set<String>();
		alstomContacts = new Set<String>();
		stackHolderWithValue = new Map<String, String>();
		stakeHoldersIdName = new Map<String, String>();
		alstomContactsIdName = new Map<String, String>();
		
		for(AlstomRelationship__c relation : [Select Stakeholder__c, Stakeholder__r.ContactName__r.Name, AlstomEmployee__r.FullName__c, AlstomEmployee__c, FrequencyOfContacts__c From AlstomRelationship__c WHERE Stakeholder__r.Opportunity__c = :oppId])
		{
			showTabel = true;
			stakeHolders.add(relation.Stakeholder__c);
			alstomContacts.add(relation.AlstomEmployee__c);
			
			stakeHoldersIdName.put(relation.Stakeholder__c, relation.Stakeholder__r.ContactName__r.Name);
			alstomContactsIdName.put(relation.AlstomEmployee__c, relation.AlstomEmployee__r.FullName__c);
			
			String frequency = relation.FrequencyOfContacts__c;
			if(frequency == 'Frequent')
				frequency = '<b>Frequent</b>';
			stackHolderWithValue.put(''+relation.Stakeholder__c+relation.AlstomEmployee__c, frequency);
		}
		
		for(String sh : stakeHolders) 
			for(String ac : alstomContacts) 
				if(!stackHolderWithValue.containsKey(''+sh+ac))
					stackHolderWithValue.put(sh+ac, '');
	}
}