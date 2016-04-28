public class InstalledBaseRSEditorController {
    private InstalledBaseRS__c baseRS;

    public final    String  labelEdit = Label.LBL0389;
    public final    String  labelSave = Label.LBL0390;
    public          Boolean isEdit          {get; set;}
    public          String  labelSaveEdit   {get; set;}
    public          ApexPages.StandardController con;

    public Boolean globalAccount {
        get {
            if( globalAccount == null ){
                User u = [ Select Id, Contact.AccountId From User Where Id = :UserInfo.getUserId() ];

                Set<Id> accountIds = new Set<Id>{ baseRS.Account__c, baseRS.OperatorName__c, baseRS.FleetMaintainer__c };

                globalAccount = !accountIds.contains( u.Contact.AccountId );
            }
            return globalAccount;
        }
        set;
    }

    public InstalledBaseRSEditorController(ApexPages.StandardController controller) {
        isEdit = false;
        labelSaveEdit = labelEdit;
        con = controller;

        baseRS = (InstalledBaseRS__c)con.getRecord();
    }

    public PageReference actionSaveEdit(){
        isEdit = !isEdit;
        labelSaveEdit = isEdit? labelSave: labelEdit;
        if(!isEdit){
            try{
                upsert baseRS;
            }catch(Exception e){
                ApexPages.addMessages(e);
            }
        }
        return null;
    }

    public void actionCancel(){
        isEdit = false;
    }
}