@isTest(SeeAllData=true)
private class CaseEmailTest{
  public static testmethod void myTriggerTestMeth(){
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {'help_test@horizonriver.com','help_test@21kutysy5qzos7uomb9m8f1mfp7j4ctt655ifqtg42wdihm5qs.v-6tikmmam.cs12.case.sandbox.salesforce.com'};
        String[] toAddresses = new String[] {'help_test@horizonriver.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Testing email through apex');
        mail.setPlainTextBody('This is test email body. This mail is being sent');
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        for (Attachment a : [select Name, Body, BodyLength from Attachment limit 1]){
        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
        efa.setFileName(a.Name);
        efa.setBody(a.Body);
        fileAttachments.add(efa);
        //mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        }
        mail.setFileAttachments(fileAttachments);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       
    }
}