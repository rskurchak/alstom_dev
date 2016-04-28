trigger NoteAfterInsert on Note (after insert) 
{
    System.debug('## >>> Note after insert <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP21Note
        - Add a Chatter Feed on the Parent Opportunity 
    **************************************************************************************************************/
    if(PAD.canTrigger('AP21'))
    {
        List<Note> ap21 = new List<Note>();
        
        for (Note n : Trigger.new)
        {
            // Opportunity, Account, Competitor, Contact, Tender
            if ((n.ParentId != null && !n.IsPrivate && String.valueOf(n.ParentId).substring(0, 3) == '006')
                || (n.ParentId != null && !n.IsPrivate && String.valueOf(n.ParentId).substring(0, 3) == '001')
                || (n.ParentId != null && !n.IsPrivate && String.valueOf(n.ParentId).substring(0, 3) == 'a05')
                || (n.ParentId != null && !n.IsPrivate && String.valueOf(n.ParentId).substring(0, 3) == '003'))
                ap21.add(n);
        }
            
        if (ap21.size() > 0)
            AP21Note.newNoteChatterFeed(ap21);
    }
    
    System.debug('## >>> Note after insert : END <<<');
}