global  class SendEmailSchedular implements Schedulable {
    global void execute(SchedulableContext sc) {
  	SendEmailBatch se = new SendEmailBatch(); // your batch class
  	database.executebatch(se);
  }

}