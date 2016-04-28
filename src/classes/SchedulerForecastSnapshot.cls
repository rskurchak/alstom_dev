global class SchedulerForecastSnapshot implements Schedulable {
 
   global void execute(SchedulableContext SC) {
    
      String query = System.Label.LBL0316;
      String email = System.Label.LBL0317; // Batch Apex Email Alert

      ForecastSnapshot FS = new ForecastSnapshot(query,email);
      ID batchComplStatus = Database.executeBatch(FS, 200);
   }
}