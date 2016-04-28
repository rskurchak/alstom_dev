public with sharing class FiscalYearInfoContExt {
	
	private final ApexPages.StandardController controller;
	private final ProgramSynthesisServices services;
	private final Program__c program;
    
    // Sorted list of Fiscal years, current as the first one
	private final List<FiscalYear> fiscalYears = new List<FiscalYear>();
    
    // State of each fiscal year section -- expanded/collapsed
    // The current fiscal year to be expanded by default
    private final Map<String, Boolean> expandedMap = new Map<String, Boolean>();
    
    // Fiscal Year -> List of program allocations for each year
	private Map<FiscalYear, List<ProgramAllocation__c>> allocationsMap;
    
    public Map<FiscalYear, Total> totalsMap = new Map<FiscalYear, Total>();
    
    // Section currently changed to be expanded/collapsed
	public String sectionToExpand {get; set;}

    public FiscalYearInfoContExt(ApexPages.StandardController controller) {
    	this(controller, new ProgramSynthesisServicesImpl());
    }

    public FiscalYearInfoContExt(ApexPages.StandardController controller, ProgramSynthesisServices services) {
    	this.controller = controller;
    	this.program = (Program__c) controller.getRecord();
    	this.services = services;
        
        initializeData();
    }

    private void initializeData() {
        System.debug('Initializing Data');
        allocationsMap = services.getProgramAllocations(program.Id);
        
        for (FiscalYear fy : allocationsMap.keySet()) {
            if (fy.Current && fiscalYears.size() > 0) {
                fiscalYears.add(0, fy);
            } else {
            	fiscalYears.add(fy);
            }

            expandedMap.put(fy.Name, fy.Current);
            
            List<ProgramAllocation__c> allocations = allocationsMap.get(fy);
            
            if (allocations == null) {
                System.debug('No Allocations found for ' + fy);
            } else {
        	    System.debug('Calculating total FY:' + fy + ', Allocations size: ' + allocations.size());
    	        Total total = getTotal(allocations);
	            totalsMap.put(fy, total);
            }
        }
        
        System.debug('Totals: ' + totalsMap);
    }

    private static Total getTotal(List<ProgramAllocation__c> allocations) {
        Total total = new Total();
        for (ProgramAllocation__c a : allocations) {
            if (a.ActualsCurrentFY__c != null) {
            	total.actuals += a.ActualsCurrentFY__c;
            }
            if (a.Budget__c != null) {
            	total.budget += a.Budget__c;
            }
            if (a.Authorization__c != null) {
            	total.authorization += a.Authorization__c;
            }
            if (a.Forecast__c != null) {
            	total.forecast += a.Forecast__c;
            }
        }
        return total;
    }
    
    public Map<FiscalYear, Total> getTotalsMap() {
        return totalsMap;
    }
    
    public List<FiscalYear> getFiscalYears() {
    	return fiscalYears;
    }

	public Map<String, Boolean> getExpandedMap() {
		return expandedMap;
	}

	public Map<FiscalYear, List<ProgramAllocation__c>> getAllocations() {
		return allocationsMap;
	}

	public void expand() {
		System.debug('Expanding section ' + sectionToExpand);
		if (sectionToExpand == null) {
			return;
		}
		
		Boolean expanded = expandedMap.get(sectionToExpand);
		FiscalYear fiscalYear = new FiscalYear(sectionToExpand, false);

		if (allocationsMap.get(fiscalYear).size() > 0) {
			expandedMap.put(sectionToExpand, !expanded);
		}
	}

	public PageReference save() {
        try {
            List<ProgramAllocation__c> allocationsToUpdate = new List<ProgramAllocation__c>();

			for (List<ProgramAllocation__c> all : allocationsMap.values()) {
				allocationsToUpdate.addAll(all);
			}

			System.debug('Saving Program');
            controller.save();
            
            System.debug('Saving Program Allocations: ' + allocationsToUpdate);
			services.saveProgramAllocations(allocationsToUpdate);
            
            return controller.view();
        } catch(System.Exception ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
}