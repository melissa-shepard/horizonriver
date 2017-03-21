@isTest(seeAllData = true)
Public class QuoteDetailPageController_Test{
    
    static testmethod void Method1(){
        Test.StartTest();
        quote qobj = [select id,Quote_Date__c from quote where Quote_Date__c != null limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(qobj);
        ApexPages.currentPage().getParameters().put('Id',qobj.id);
        QuoteDetailPageController Obj = new QuoteDetailPageController(sc);
        Obj.getOppz();
        Obj.CalTax();
        Obj.Edit();
        Obj.SaveBt();
        Obj.Edit();
        Obj.Del();
        Obj.Edits();
        Obj.CancelBt();
        Obj.Saves();
        Test.StopTest();
    }
}