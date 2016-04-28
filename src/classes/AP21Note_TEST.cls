/**
 * This class contains unit tests for validating the behavior of AP21Note Apex Class
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com
     ~ Date Created    : 21/03/2013
 */
@isTest
private class AP21Note_TEST 
{
    static testMethod void AP21Note_TEST() 
    {
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.LeadingProductLine__c = 'Rolling Stock & Components';
        opp.Platform__c = 'Mainlines';
        insert opp;
        
        Account acc = UtilityTestMethod.getAccount();
        insert acc;
        
        Competitor__c com = UtilityTestMethod.getCompetitor();
        insert com;
        
        Contact con = UtilityTestMethod.getContact();
        insert con;
        
        List<Note> listNote = new List<Note>();
        Note noteOpp = new Note(ParentId = opp.Id, Title = 'My note Opp');
        listNote.add(noteOpp);
        
        Note noteAcc = new Note(ParentId = acc.Id, Title = 'My note Acc');
        listNote.add(noteAcc);
        
        Note noteCom = new Note(ParentId = com.Id, Title = 'My note Com');
        listNote.add(noteCom);
        
        Note noteCon = new Note(ParentId = con.Id, Title = 'My note Con');
        listNote.add(noteCon);
        
        test.startTest();
        
        insert listNote;
        for (Note n : listNote)
            n.Title = 'My updated note';
        update listNote;
        
        test.stopTest();
    }
}