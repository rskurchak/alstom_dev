public without sharing class VFC87_MultiRegionalAccount 
{
    public List<Account> accounts {get; set;}
    public List<Item> items {get; set;}
    
    public Id accountId;
    
    public VFC87_MultiRegionalAccount()
    {
        items = new List<Item>();
        
        accountId = ApexPages.currentPage().getParameters().get('id');
        
        accounts = [SELECT Id, Name, (SELECT Id, Name,BOid__c, Platform__c, SubmittalDate__c, RFP__c, StageName, OwnerId, Owner.Name, Country__c FROM Opportunities) FROM Account WHERE Id =: accountId OR ParentId =: accountId];
        
        for(Account anAccount : accounts)
        {   
            items.add(new Item(anAccount.Id, anAccount.Name));
            for(Opportunity anOpp : anAccount.Opportunities)
            {
                items.add(new Item(anOpp.Id, anOpp.Name, anOpp.Platform__c, anOpp.SubmittalDate__c, anOpp.RFP__c, anOpp.StageName, anOpp.OwnerId, anOpp.Owner.Name, anOpp.Country__c,anOpp.BOid__c));
            }
        }
    }
    
    public PageReference exportPDF()
    {
        return Page.VFP87_MultiRegionalAccountsExport;
    }
    
    public class Item
    {
        public Id AccountId {get; set;}
        public String AccountName {get; set;}
        public String OpportunityName {get; set;}
        public String boidInfo {get; set;}
        public Id OpportunityId {get; set;}
        public String Platform {get; set;}
        public Date SubmittalDate {get; set;}
        public Date RFP {get; set;}
        public String Status {get; set;}
        public String Owner {get; set;}
        public Id OwnerId {get; set;}
        public String Country {get; set;}
        public boolean isAccount {get; set;}
        
        public Item(Id accountId, String accountName)
        {
            this.AccountId = accountId;
            this.AccountName = accountName;
            this.isAccount = true;      
        }
        
        public Item(Id opportunityId,String OpportunityName, String Platform, Date SubmittalDate, Date RFP, String Status, Id OwnerId, String Owner, String Country,string boidInfo)        
        {
            this.OpportunityId = opportunityId;
            this.OpportunityName = OpportunityName;
            this.Platform = Platform;
            this.SubmittalDate = SubmittalDate;
            this.RFP = RFP;
            this.Status = Status;
            this.Owner = Owner;
            this.OwnerId = OwnerId;
            this.Country = Country;
            this.isAccount = false;
            this.boidInfo=boidInfo;
        }
    }
}