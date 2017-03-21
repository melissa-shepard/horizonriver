@isTest (SeeAllData = TRUE)
Public class SureTaxController_Test{
    Static Testmethod void SureTaxController(){
        Quote qobj = [select id from quote where Quote_Date__c != null order by LastModifiedDate desc limit 1];
        Apexpages.standardcontroller sc = new Apexpages.standardcontroller(qobj);
        SureTaxController stc = new SureTaxController(sc);
        stc.login();
    }
    
    static testmethod void SureTaxWarning(){
    
        Quote qobj = [select id,Opportunityid from quote where Quote_Date__c != null order by createddate desc limit 1];
        AcctSeed__Billing_Line__c ab = [select id,AcctSeed__Product__c,AcctSeed__Billing__c from AcctSeed__Billing_Line__c where AcctSeed__Product__c != null and Sales_Taxs__c = false limit 1];
        AcctSeed__Billing__c abill =[select id from AcctSeed__Billing__c where id =: ab.AcctSeed__Billing__c limit 1];
        Apexpages.standardcontroller sc = new Apexpages.standardcontroller(abill);
        SureTaxWarning stc = new SureTaxWarning(sc);
        stc.recid = abill.id;
        stc.login();
    }
}