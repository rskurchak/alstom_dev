public with sharing class CaseServices {

    static public List<Case> getAvailableCases( ){
        String caseQueryStr =  ' Select Id, Subject, CaseNumber, toLabel(Type), toLabel(Status), CreatedById, CreatedDate ';
        caseQueryStr        += ' FROM Case ';
        caseQueryStr        += ' WHERE Status != \'' + System.label.LBL0170 + '\' and ';
        caseQueryStr        += ' Status != \'' + System.label.LBL0171 + '\' and ';
        caseQueryStr        += ' CreatedById = \'' + UserInfo.getUserID() + '\' ';
        caseQueryStr        += ' ORDER BY CreatedDate Desc LIMIT 100 ';

        return Database.query( caseQueryStr );
    }
    
}