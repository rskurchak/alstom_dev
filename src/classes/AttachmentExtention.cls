public without sharing class AttachmentExtention {
	private static final Integer SPLITE_SIZE_MAIN_TABLE = 5;
	private static final Integer SPLITE_SIZE_DETAIL_TABLE = 5;
	private static final String SPLITE_TAG = '<wbr>';

    public RMA__c rma {get;set;}
    private List<Item__c> itemDetailList {get;set;}
    public List<ItemWrapper> items {get;set;}
    public String headerValue {get;set;}

    public String emailValue {get;set;}
    public String emailcValue {get;set;}
    public String additionalComments {get;set;}

    public AttachmentExtention(ApexPages.StandardController controller) {
        this.rma = (RMA__c)controller.getRecord();

        this.rma = RMAServices.getRMAById(this.rma.Id);

        //prepare long output values. Splitting long words by <wbr> tags
        this.emailValue = splitStringByTag(this.rma.Email__c, SPLITE_SIZE_MAIN_TABLE);
        this.emailcValue = splitStringByTag(this.rma.Emailc__c, SPLITE_SIZE_MAIN_TABLE);
        this.additionalComments = splitStringByTag(this.rma.Additional_Comments__c, SPLITE_SIZE_MAIN_TABLE);

        this.itemDetailList = RMAServices.getItemsByRMAId(this.rma.Id);

        this.items = new List<ItemWrapper>();
        this.headerValue = RMAServices.RMA_ITEM_OPTION_STANDARD;
        for (Item__c item : this.itemDetailList){
            if (item.Processing_Option__c == RMAServices.RMA_ITEM_OPTION_UX){
                this.headerValue = RMAServices.RMA_ITEM_OPTION_UX;
            } else if (this.headerValue != RMAServices.RMA_ITEM_OPTION_UX && item.Processing_Option__c == RMAServices.RMA_ITEM_OPTION_EXPEDITE){
                this.headerValue = RMAServices.RMA_ITEM_OPTION_EXPEDITE;
            }
            this.items.add(new ItemWrapper(item));
        }
    }

    private static String splitStringByTag(String item, Integer maxStringLength){
    	if (String.isEmpty(item)){
    		return item;
    	}

    	List<String> words = item.split(' ');

    	List<String> result = new List<String>();

    	for (String word : words){
			String[] chars = word.split('');
			String res = '';

			Integer j = 0;
			for (Integer i = 1; i <= word.length(); i++){
			    if ( j <= SPLITE_SIZE_MAIN_TABLE ){
			        res += chars[i];
			        j++;
			    } else {
			        res += chars[i] + SPLITE_TAG;
			        j = 0;
			    }
			}
			result.add(res);
		}

		return String.join(result, ' ');
	}

	public class ItemWrapper{
		public String action {get;set;}
		public String description {get;set;}
		public String serialNumber {get;set;}
		public String reasonForReturn {get;set;}
		public String gePartNumber {get;set;}
		public String processingOption {get;set;}

		public ItemWrapper(Item__c item){
			action = splitStringByTag(item.Action__c, SPLITE_SIZE_DETAIL_TABLE);
			description = splitStringByTag(item.Name, SPLITE_SIZE_DETAIL_TABLE);
			serialNumber = splitStringByTag(item.Serial_Number__c, SPLITE_SIZE_DETAIL_TABLE);
			reasonForReturn = splitStringByTag(item.Reason_for_Return__c, SPLITE_SIZE_DETAIL_TABLE);
			gePartNumber = splitStringByTag(item.GE_Part_Number__c, SPLITE_SIZE_DETAIL_TABLE);
			processingOption = splitStringByTag(item.Processing_Option__c, SPLITE_SIZE_DETAIL_TABLE);
		}
	}
}