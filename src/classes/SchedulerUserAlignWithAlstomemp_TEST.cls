@isTest
private class SchedulerUserAlignWithAlstomemp_TEST {
  static testMethod void testSchedulerUserAlignWithAlstomemp() {
    System.Debug('## >>>>> testing class SchedulerUserAlignWithAlstomemployees <<<<<');
    Test.startTest();
    System.schedule('testSchedulerUserAlignWithAlstomemployees', '0 0 20 * * ? 2020', new SchedulerUserAlignWithAlstomemployees());
    Test.stopTest();
    System.Debug('## >>>>> testing class SchedulerUserAlignWithAlstomemployees END <<<<<');
  }
}