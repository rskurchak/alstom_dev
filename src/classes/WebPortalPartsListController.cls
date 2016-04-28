global with sharing class WebPortalPartsListController 
{
    private final String PIC_FOLDER_NAME = 'Graphics'; 
    private final String PIC_NAME_SUFFIX = '_Pictogram';
    private final String PIC_MISSING_NAME = 'Missing';
    private final String PIC_URL = '/servlet/servlet.FileDownload?file=';
    
	private map<String, String> mapCategoryTranslation;

	public String categoryFilter {get;set;}
	public String categoryLabel {get;set;}
	public String searchText {get;set;}
	public String partId {get;set;}
	public String parentURL {get;set;}
	public List<SelectOption> categoryList {get;set;}
    public Map<String, Id> images {get;set;}
    
    public String currentURL {
        get{
        	currentURL = ApexPages.currentPage().getHeaders().get('Host');
            return currentURL;
        }
            set;
    }
    
	public ApexPages.StandardSetController setCtrl
	{
		get 
		{
			if (setCtrl == null)
			{
				if (searchText != null && searchText!= '')
				{
					// Search with keyword
					List<SObject> partsFound = [FIND :searchText IN ALL FIELDS RETURNING PartAndRepair__c (Id, Name, DesignationEN__c, Category__c, PartRepairNumber__c, OtherReference__c, DisplayContactLink__c, Type__c)][0];                       
					setCtrl = new ApexPages.StandardSetController(partsFound);
				}
				else
				{
					// Filtering with Categories
					String query = 'Select Id, Name, DesignationEN__c, PartRepairNumber__c, Category__c, OtherReference__c, DisplayContactLink__c, Type__c from PartAndRepair__c';                    
					if  (categoryFilter != null && categoryFilter != '')
						query += ' where Category__c = \'' + categoryFilter + '\'';
	
					setCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(query));
				}
				
				setCtrl.setPageSize(10);
			}
			
			return setCtrl;
		}
		set;
	}
	public List<FoundPart> listPR
	{
		get
		{
            List<FoundPart> partList = new List<FoundPart>();
            List<String> partTypesSplit = new List<String>();
            // append pictogram links based on type to records 
/*            Map<String,PartType_Pictograms__c> cS = 
                PartType_Pictograms__c.getAll();
            	Set<String> csKeySet = cs.keySet();*/
            for (SObject part : setCtrl.getRecords()) {
                List<String> partTypes = new List<String>();
                String newString = (String) part.get('Type__c');
                
                if (newString != NULL) partTypesSplit = newString.split(';');
                // vyhodit
                for(integer i =0; i< partTypesSplit.Size(); i++){
                    partTypes.add(partTypesSplit[i]);
                }
                
                FoundPart foundPart = new FoundPart(); 
                foundPart.partAndRepair = (PartAndRepair__c) part;
                
                for ( String pType : partTypes) {
		            foundPart.typeIconLinks.put( pType, getImageUrl(pType) );
                }

                partList.add(foundPart);
            }  
			return partList;
		}
		set;
	}

	public WebPortalPartsListController()
	{
		categoryLabel = '';
		categoryFilter = ApexPages.currentPage().getParameters().get('category');
		searchText = ApexPages.currentPage().getParameters().get('searchText');
		parentURL = ApexPages.currentPage().getParameters().get('parentURL');
        retrieveImageUrls();

		// Checking that partId is a real Id, we don't want public site to crash
		partId = ApexPages.currentPage().getParameters().get('partId');
		if (partId != null && partId != '')
		{
			List<PartAndRepair__c> partWithId = [Select Id from PartAndRepair__c where Id = :partId];
			if (partWithId.size() == 0)
				partId = '';
		}

		categoryList = new List<SelectOption>();
		mapCategoryTranslation = new map<String, String>();

		// Getting Categories
		Set<String> categoriesWithData = new Set<String>();
		for(AggregateResult aggregateCategory : [SELECT COUNT(Id) nbRecordPerCat, Category__c FROM PartAndRepair__c GROUP BY Category__c])
		{
			if ((Integer)aggregateCategory.get('nbRecordPerCat') > 0)
				categoriesWithData.add((String)aggregateCategory.get('Category__c'));
		}

        List<Schema.PicklistEntry> ple = PartAndRepair__c.Category__c.getDescribe().getPicklistValues();
        for (Schema.PicklistEntry f : ple)
        {
        	if (categoriesWithData.contains(f.getValue()))
        	{
            	categoryList.add(new SelectOption(f.getValue(), f.getLabel()));
            	mapCategoryTranslation.put(f.getValue(), f.getLabel());
        	}
    	}
    	categoryLabel = mapCategoryTranslation.get(categoryFilter);

        listPR = new List<FoundPart>();
	}

	public void filter()
	{
		categoryLabel = mapCategoryTranslation.get(categoryFilter);
		partId = '';
		searchText = '';

		setCtrl = null;
	}

	// Nothing is done, just need an action in apex:commandLink
	public PageReference showPartDetailContact()
	{
		categoryFilter = '';
		searchText = '';

		return null;
	}
    
    private String getImageUrl(String partType)
    {
    	String partTypeWithoutSpaces = ( partType != null ? partType.replace(' ', '_') : null );
        if ( images.containsKey( partTypeWithoutSpaces + PIC_NAME_SUFFIX ) ) {
            return PIC_URL + images.get( partTypeWithoutSpaces + PIC_NAME_SUFFIX );
        } else {
            return PIC_URL + images.get(PIC_MISSING_NAME + PIC_NAME_SUFFIX);
        }
    }
    
    private void retrieveImageUrls()
    {
		images = new Map<String, Id>();
        
        List<Folder> folders = [SELECT Id FROM Folder Where DeveloperName = :PIC_FOLDER_NAME];
        
        if (folders.isEmpty()) {
            return;
        }
        
        Id folderId = folders.get(0).Id;
        
        List<Document> documents = [SELECT Id, DeveloperName FROM Document WHERE FolderId = :folderId AND IsPublic = true];
        
        for (Document document : documents) {
            images.put(document.DeveloperName, document.Id);
        }
    }
}