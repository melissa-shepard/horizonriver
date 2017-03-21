public class QuoteDetailPageController {
    
    public Boolean DetailPage{get;set;}
    public Boolean EditPage{get;set;}
    public Boolean flg{get;set;}
    public quote qobj{get;set;}
    private List<QuoteLineItem> oppz;
    public id SelectedID{get;set;}
    
    public QuoteDetailPageController(ApexPages.StandardController controller) {
        EditPage = false;
        DetailPage = true;
        flg = false;
        qobj = [select id,Opportunity.Account.BillingPostalCode,Accountid,Account.name,ExpirationDate,name,IsSyncing,Status,opportunityid,opportunity.name,Contactid,PaymentTerms__c,DocusignStatus__c,DS_Envelope_del__c,Subtotal,Tax,Discount,ShippingHandling,TotalPrice,GrandTotal,QuoteFrom__c,Zip_Code__c from quote where id =: ApexPages.currentPage().getParameters().get('id')];
    }
    
    public List<QuoteLineItem> getOppz()
    {
        oppz = [SELECT Id, CreatedDate, Quantity, UnitPrice, QuoteId, Discount, Description, Product2Id,Product2.name, ListPrice, Subtotal, TotalPrice, Sales_Taxs__c, Sub_Total__c FROM QuoteLineItem where quoteid =: qobj.id ];
        return oppz;
    }

    public void DocuSign(){
        
        //return new PageReference('/apex/docusign_editenvelope?DSEID=a0pV00000016P68IAE&nw=0&SourceID=' + ApexPages.currentPage().getParameters().get('id'));
        
        //return new PageReference('https://dsfs.cs12.visual.force.com/apex/docusign_editenvelope?DSEID=a0pV00000016P68IAE&nw=0&SourceID=' + ApexPages.currentPage().getParameters().get('id'));
       // return null;
    }
    
    public pagereference Edit(){
        EditPage = true;
        DetailPage = false;
        return null;
    }
    
    public pagereference SaveBt(){
        EditPage = false;
        DetailPage = true;
        update qobj;
        return null;
    }
    
    public pagereference CancelBt(){
        EditPage = false;
        DetailPage = true;
        return null;
    }
    
    public pagereference CalTax(){
        Apexpages.standardcontroller sc = new Apexpages.standardcontroller(qobj);
        SureTaxController stc = new SureTaxController(sc);
        stc.login();
    return null;
    }    
    
    public pagereference Del(){
        system.debug('SelectedID==>'+ApexPages.currentPage().getParameters().get('accountId'));
        system.debug('SelectedID==>'+SelectedID);
        if(SelectedID != null){
            QuoteLineItem q = new QuoteLineItem();
            q.id = SelectedID;
            delete q;
        }
    return null;
    } 
    
    public pagereference Edits(){
    flg = true;
    return null;
    }
    
    public pagereference Saves(){
    flg = false;
    update oppz;
    return null;
    }
    
    
           
}