public with sharing class VFC80_AGSubmitMultipleApprovals 
{
	public Id tenderSubmissionId;
	public boolean checkboxHeader {get;set;}
	public List<ApproverGroupWrapper> listApproverGroup {get;set;}
	public List<String> listNumberOfApprovers
	{
		get
		{
			// Return the max number of Approvers to dynamically reference fields Approver1__c, Approver2__c... in Visualforce
			if (listNumberOfApprovers == null)
				listNumberOfApprovers= new List<String>{'1','2','3','4','5','6','7','8','9','10'};
			
			return listNumberOfApprovers;
		}
		set;
	}

	public VFC80_AGSubmitMultipleApprovals(ApexPages.StandardController controller) 
	{
		tenderSubmissionId = System.currentPageReference().getParameters().get('id');
		checkboxHeader = true;
		listApproverGroup = new List<ApproverGroupWrapper>();

		for (ApproverGroup__c aGroup : [Select Id, Name, ApproverGroupName__c,
										Approver1__r.Name, Approver1__r.IsActive, Approver1Title__c,
										Approver2__r.Name, Approver2__r.IsActive, Approver2Title__c,
										Approver3__r.Name, Approver3__r.IsActive, Approver3Title__c,
										Approver4__r.Name, Approver4__r.IsActive, Approver4Title__c,
										Approver5__r.Name, Approver5__r.IsActive, Approver5Title__c,
										Approver6__r.Name, Approver6__r.IsActive, Approver6Title__c,
										Approver7__r.Name, Approver7__r.IsActive, Approver7Title__c,
										Approver8__r.Name, Approver8__r.IsActive, Approver8Title__c,
										Approver9__r.Name, Approver9__r.IsActive, Approver9Title__c,
										Approver10__r.Name, Approver10__r.IsActive, Approver10Title__c
										from ApproverGroup__c where Submission__c = :tenderSubmissionId 
										and ApprovalStatus__c = :System.label.LBL0247 
										order by ApproverGroupName__c ASC])
		{
			listApproverGroup.add(new ApproverGroupWrapper(aGroup));
		}

		if (listApproverGroup.size() > 0)
		{
			if (hasInactiveUsers(false))
			{
				ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Warning, System.Label.LBL0252);
	            ApexPages.addMessage(msg);
			}
		}
		else
		{
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Warning, System.Label.LBL0250);
            ApexPages.addMessage(msg);
		}
	}

	public PageReference submitForMultipleApprovals()
	{
		PageReference pageRef = null;

		// Check inactive users in selected Approver Groups
		if (hasInactiveUsers(true))
		{
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, System.Label.LBL0252);
            ApexPages.addMessage(msg);
            return null;
		}

		// Submit selected Approver Groups
		map<Integer, ApproverGroupWrapper> approverGroupToSubmit = new map<Integer, ApproverGroupWrapper>();
		List<Approval.ProcessSubmitRequest> approvalProcessToSubmit = new List<Approval.ProcessSubmitRequest>();
		Integer submitIndex = 0;
		for (ApproverGroupWrapper agw : listApproverGroup)
		{
			// Removing potential previous errors
			agw.inError = false;

			if (agw.isSelected)
			{
				approverGroupToSubmit.put(submitIndex, agw);
				Approval.ProcessSubmitRequest apRequest = new Approval.ProcessSubmitRequest();
				apRequest.setObjectId(agw.approverGroup.Id);
				approvalProcessToSubmit.add(apRequest);

				submitIndex++;
			}
		}

		if (approvalProcessToSubmit.size() > 0)
		{
			try
			{
				List<Approval.ProcessResult> apRequestResults = Approval.process(approvalProcessToSubmit);
				pageRef = new PageReference('/' + tenderSubmissionId);
			}
			catch(DmlException e)
			{
				for (Integer i = 0; i < e.getNumDml(); i++)
                {
                    // Adding error on the correct line
                    if (approverGroupToSubmit.get(e.getDmlIndex(i)) != null)
                    {
                    	approverGroupToSubmit.get(e.getDmlIndex(i)).inError = true;
                    }

                    // Displaying message to the user
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getDmlMessage(i)));
                }
                pageRef = null;
			}
		}
		else
		{
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info, System.Label.LBL0251);
            ApexPages.addMessage(msg);
            pageRef = null;
		}

		return pageRef;
	}

	public boolean hasInactiveUsers(boolean onlyInSelectedAG)
	{
		for (ApproverGroupWrapper agw : listApproverGroup)
		{
			if (!onlyInSelectedAG || agw.isSelected)
			{
				for (String approverNum : listNumberOfApprovers)
				{
					if (agw.approverGroup.getSObject('Approver'+approverNum+'__r') != null
						&& !(boolean)agw.approverGroup.getSObject('Approver'+approverNum+'__r').get('IsActive'))
					{
						return true;
					}
				}
			}
		}
		
		return false;
	}

	public class ApproverGroupWrapper
    {
    	public boolean isSelected {get;set;}
    	public boolean inError {get;set;}
        public ApproverGroup__c approverGroup {get;set;}
        
        public ApproverGroupWrapper(ApproverGroup__c ag)
        {
        	isSelected = true;
            inError = false;
            approverGroup = ag;
        }
    }
}