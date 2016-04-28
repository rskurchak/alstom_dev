/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Unused queries : use directly fields from VFP51 page.
   => Is this Apex class really needed ?
 Remove this box once modification done.
*********************************************************************/

/*
 VFC51_FI15_ApprovalStatus 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 10/10/2013
    ~ Description       : Controller of VFP51_BudgetLine_New
                          Overide standard button New for Budget Line
    ~ Feature Id      : FEAT#0441 
*/
public with sharing class VFC51_FI15_ApprovalStatus {

    // Contains related FI15
    public FI15__c fi15 {get;set;}
    
    public Boolean isNew {get;set;}
    public String sApprovalStatus {get;set;}
    public String fi15CreatedById {get;set;}
    public String fi15Name {get;set;}
    public String fi15Id {get;set;}
    public String fi15NumberFieldID {get;set;}
    public String fi15NumberFieldLKID {get;set;}
    String sRetURL {get;set;}
    
    public VFC51_FI15_ApprovalStatus(ApexPages.StandardController controller) {
        
        // Getting retURL parameter
        sRetURL = ApexPages.currentPage().getParameters().get('retURL');
        
        // Set FI15 Number Field ID for object 'Budget Line'
        fi15NumberFieldID = System.label.LBL0120;
        // Set FI15 Number Field LKID for object 'Budget Line'
        fi15NumberFieldLKID = System.label.LBL0120 + '_lkid';
        
        // Getting value of FI15 Number Field LKID parameter
        String fi15LKID = ApexPages.currentPage().getParameters().get(fi15NumberFieldLKID);

        if(fi15LKID != '' && fi15LKID != null){
            // Getting related FI15
            fi15 = [Select Id, Name, ApprovalStatus__c, CreatedById from FI15__c where Id =: fi15LKID];
            sApprovalStatus = fi15.ApprovalStatus__c;
            fi15CreatedById = fi15.CreatedById;
            fi15Name = fi15.Name;
            fi15Id = fi15.Id;
            isNew = false;
        }
        else {
            isNew = true;
            sApprovalStatus = '';
            fi15CreatedById = '';
            fi15Name = '';
            fi15Id = '';
        }
    }
    
    // sURL method return URL of create Budget Line page
    // Populate FI15 Number field for Budget Line
    public PageReference sUrl() 
    {
        // if Approval status is not Pending
        if (sApprovalStatus != System.label.LBL0106){
            PageReference p = new PageReference('/' + System.label.LBL0121 + '/e');
            p.getParameters().put('nooverride', '1');
            p.getParameters().put('retURL', sRetURL);
            if (fi15 != null) {
                p.getParameters().put(fi15NumberFieldID, fi15.Name);
                p.getParameters().put(fi15NumberFieldLKID, fi15.id);
            }
        
            //String redirectUrl = 'retURL='+sRetURL+','+System.label.LBL0120+'='+fi15.Name+','+System.label.LBL0120+'_lkid='+fi15.id;
            return p;
        }
        else return null;
    }
}