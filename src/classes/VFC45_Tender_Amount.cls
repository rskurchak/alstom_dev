/*
 VFC45_Tender_Amount apex controller
	~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
    ~ Date Created    : 05/09/2013 
    ~ Description     : Generate a PDF
    ~ Feature Id      : FEAT#0382 
*/
public with sharing class VFC45_Tender_Amount {
	/* Variables */
	//Contains related amount
	public Amounts__c amount {get; set;}
	public Tender__c tender {get; set;}
	// Contains Opportunity name
    public String oppName{get;set;}
    // Contains creator of amount
    public String amountCreatedBy{get;set;}
    // Contains last modifier of amount
    public String amountLastModifiedBy{get;set;}
    
    // This list contain all amounts of tender except the last one. This list is printed on the N-1 PDF pages
    public List<Amounts__c> lstAmountsWitnoutLastOne{get;set;}
    // This list will contain the last amount. We will print it in the last page of the PDF
    public List<Amounts__c> lastAmount{get;set;}

	
	/* Constructor */
	public VFC45_Tender_Amount(ApexPages.StandardController stdCtrl)
	{
		// Getting current record of Tender
		this.tender = (Tender__c)stdCtrl.getRecord();
		tender = [Select Id, Opportunity__c from Tender__c where Id =: this.tender.Id];
		
		// Getting needed informations on related Opportunity
		Opportunity Opp = [Select Id, Name from Opportunity where Id =: tender.Opportunity__c];
		oppName = Opp.Name;
	}
	
    public List<Amounts__c> lstAmounts
    {
        get
        {
        	lstAmountsWitnoutLastOne = new List<Amounts__c>();
        	lastAmount = new List<Amounts__c>();
        	/* CR-0734 - Removed GrossMargin__c */
        	lstAmounts = [Select Id, Name, Tender__c, CreatedById, LastModifiedById, LastModifiedDate, Option__c, TECH_Amount_Created_By__c, TECH_Amount_Last_Modified_By__c, CurrencyIsoCode, MinimumSellingPrice__c, ExchangeRate__c, MinimumSellingPriceMEUR__c, NetMargin__c, GrossMarginAdjusted__c, Contingencies__c, DownPayment__c, OnwardPayment__c, Ambition__c, Comments__c from Amounts__c where Tender__c =: tender.Id];

			// Getting all related amounts except the last one
        	for(Integer  i=0; i<lstAmounts.size()-1; i++) {
        		lstAmountsWitnoutLastOne.add(lstAmounts[i]);
        	}
        	
        	// Getting The last related amount
        	lastAmount.add(lstAmounts[lstAmounts.size()-1]);
            return lstAmountsWitnoutLastOne;
        }
        set;
    }
	
	// Getting the current DataTime formatted in "d MMM yyyy h:mm a"
    public String currentDateTime//Formated 
    {
    	get
    	{
    		return Datetime.now().format('d MMM yyyy h:mm a');
    	}
    	private set;
    }
}