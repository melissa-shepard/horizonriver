@isTest(seeAllData = true)
Public class CreateOpportunityController_Test{
    
    static testmethod void Method1(){
    CreateOpportunityController cobj = new CreateOpportunityController();
    cobj.CreateInvoice();
    
    account aid = [select id from account limit 1];
    
    cobj.OppObj.name = 'test';
    cobj.OppObj.Accountid = aid.id;
    cobj.OppObj.CloseDate = system.today();
    cobj.OppObj.StageName = 'Qualification';
    cobj.OppObj.Probability = 1;
    cobj.Next();
    
    Pricebook2 probj = [SELECT Id, Name FROM Pricebook2 limit 1];
    PricebookEntry  pbeObj = [SELECT Id, Name, Pricebook2Id, Product2.Name FROM PricebookEntry where Pricebook2Id  =: probj.id limit 1];
    
    
    
    cobj.toSelect = string.valueof(pbeObj.ID);
    cobj.searchString = string.valueof(pbeObj.Product2.Name);
    cobj.PBvalue = string.valueof(probj.id);
    cobj.OppObj.Pricebook2id = probj.id;
    cobj.toUnselect = 'test';
    cobj.QuoteObj.name = 'Test';
    cobj.opportunities = new List<Opportunity>();
    cobj.PBSave();
    
    cobj.addToShoppingCart();
    
    
    OpportunityLineItem qitem = new OpportunityLineItem();
    qitem.PricebookEntryId = pbeObj.id;
    qitem.Quantity = 1;
    qitem.UnitPrice = 1;
    qitem.Opportunityid = cobj.OppObj.id;
    insert qitem;
    cobj.shoppingCart.add(qitem);
    
    cobj.removeFromShoppingCart();
    cobj.CreateQuote();
    cobj.onSave();
    }
    
    static testmethod void Method2(){
    CreateOpportunityController cobj = new CreateOpportunityController();
    cobj.CreateInvoice();
    account aid = [select id from account limit 1];
    cobj.OppObj.name = 'test';
    cobj.OppObj.Accountid = aid.id;
    cobj.OppObj.CloseDate = system.today();
    cobj.OppObj.StageName = 'Qualification';
    cobj.OppObj.Probability = 1;
    cobj.Next();
    cobj.PBvalue = null;
    cobj.OppObj.Pricebook2Id = null;
    cobj.PBSave();
    }
}