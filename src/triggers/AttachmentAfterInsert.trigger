/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Loop through attachments is done in 2 places : trigger and class => do everything in class
 Remove this box once modification done.
*********************************************************************/
trigger AttachmentAfterInsert on Attachment (after insert) 
{
    System.debug('## >>> Attachment after insert <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP42Attachment
        - Add a Chatter Feed on the Parent Object 
    **************************************************************************************************************/
    if(PAD.canTrigger('AP42'))
    {
        List<Attachment> ap42 = new List<Attachment>();
        
        for (Attachment att : Trigger.new)
        {
            // Private attachments are not tracked
            if (att.ParentId != null && !att.IsPrivate)
            { 
                // For Object: Milestone
                // But not for auto generated PDF (FEAT#0426 / FEAT#0371)
                If (String.valueOf(att.ParentId).substring(0, 3) == System.label.LBL0078
                        && !(att.Name.length() > 7
                             && (att.Name.substring(0, 4) == System.label.LBL0079
                                 || att.Name.substring(0, 7) == System.label.LBL0080)
                             && att.Name.substring(att.Name.length() - 4, att.Name.length()) == '.pdf'))
                {
                    
                    ap42.add(att);
                }
                else 
                // for Object : Tender Submission
                if (String.valueOf(att.ParentId).substring(0, 3) == System.label.LBL0124)
                {
                    ap42.add(att);
                }
            }
        }
    
        if (ap42.size() > 0)
            AP42Attachment.newAttachmentChatterFeed(ap42);
    }
    
    System.debug('## >>> Attachment after insert : END <<<');
}