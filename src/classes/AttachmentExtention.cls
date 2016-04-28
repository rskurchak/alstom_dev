public without sharing class AttachmentExtention {
    public RMA__c rma {get;set;}
    public List<Item__c> itemDetailList {get;set;}
    public String headerValue {get;set;}
    public String pdf{get;set;}
    public String testString {get;set;}

    public AttachmentExtention(ApexPages.StandardController controller) {
        this.rma = (RMA__c)controller.getRecord();

        pdf = !String.isEmpty(System.currentPageReference().getParameters().get('pdf')) ? '' : 'PDF';

        this.rma = RMAServices.getRMAById(this.rma.Id);

//        testString = '<span style="display: inline-block">khalid.ed</span><span style="display: inline-block">daikhane@bl</span><span style="display: inline-block">uewolf</span><span style="display: inline-block">group.com</span>';
		testString = 'kh<wbr>ali<wbr>d.ed<wbr>daik<wbr>han<wbr>e@blue<wbr>wolf<wbr>gro<wbr>up.co<wbr>m';

        this.itemDetailList = RMAServices.getItemsByRMAId(this.rma.Id);

        this.headerValue = RMAServices.RMA_ITEM_OPTION_STANDARD;
        for (Item__c item : this.itemDetailList){
            if (item.Processing_Option__c == RMAServices.RMA_ITEM_OPTION_UX){
                this.headerValue = RMAServices.RMA_ITEM_OPTION_UX;
                break;
            } else if (item.Processing_Option__c == RMAServices.RMA_ITEM_OPTION_EXPEDITE){
                this.headerValue = RMAServices.RMA_ITEM_OPTION_EXPEDITE;
            }
        }
    }
}