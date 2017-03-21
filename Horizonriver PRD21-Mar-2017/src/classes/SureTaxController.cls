public class SureTaxController{
    public String QuoteId;
    Public transient HttpRequest request;
    Public transient HttpResponse response;
    Public string responses{get;set;}
    public string JsonResult;
    public string Errms{get;set;}
    Quote qut;
    
    public SureTaxController(ApexPages.StandardController controller) {
        QuoteId=controller.getRecord().id;
        qut=[select id,name,Tax,ClinicNumber__c,Zip_Code__c,createddate,GrandTotal,Pricebook2id,Opportunityid,IsSyncing  from Quote where id=:QuoteId];
    }

    
    public pagereference login(){
   
        Integer i=0;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        gen.writeStringField('ClientNumber','4001526763');
        gen.writeStringField('BusinessUnit','');
        gen.writeStringField('ValidationKey','09ca649c-3ca0-4d84-a2f9-c40bb1077a57');
        gen.writeStringField('LineNumber',String.valueof(i));
        gen.writeStringField('DataYear','2016');
        gen.writeStringField('DataMonth','05');
        gen.writeStringField('TotalRevenue','400.00');
        gen.writeStringField('ReturnFileCode','0');
        gen.writeStringField('ClientTracking','track');
        gen.writeStringField('IndustryExemption','');
        gen.writeStringField('ResponseType','D');
        gen.writeStringField('ResponseGroup','03');
        gen.writeFieldName('ItemList');
        gen.writeStartArray();
            
            for(QuoteLineItem qt:[select id,TotalPrice,product2.TransCode__c,Quote.GrandTotal,Quote.createddate,Quote.Name,Quote.Zip_Code__c,Quote.ClinicNumber__c,Product2.Name,UnitPrice,Quantity,Description from QuoteLineItem where QuoteId=:QuoteId and Sales_Taxs__c = false]){
            i++;
            gen.writeStartObject();
                   gen.writeStringField('LineNumber',String.valueof(i));
                   gen.writeStringField('InvoiceNumber','12');
                   gen.writeStringField('CustomerNumber',Qut.ClinicNumber__c==null?'':Qut.ClinicNumber__c);
                   gen.writeStringField('OrigNumber','');
                   gen.writeStringField('TermNumber','');
                   gen.writeStringField('BillToNumber','');
                   gen.writeStringField('Zipcode',Qut.Zip_Code__c==null?'':Qut.Zip_Code__c);
                   gen.writeStringField('Plus4','');
                   gen.writeStringField('P2PZipcode','');
                   gen.writeStringField('P2PPlus4','');
                   gen.writeStringField('TransDate',String.valueof(date.valueof(Qut.createddate)));
                   gen.writeStringField('Revenue',String.valueof(qt.TotalPrice));
                   gen.writeStringField('Units',String.valueof(qt.Quantity));
                   gen.writeStringField('UnitType','00');
                   gen.writeStringField('Seconds','00');
                   gen.writeStringField('TaxIncludedCode','0');
                   gen.writeStringField('TaxSitusRule','04');
                   gen.writeStringField('TransTypeCode',qt.product2.TransCode__c==null?'':qt.product2.TransCode__c);
                   gen.writeStringField('SalesTypeCode','B');
                   gen.writeStringField('RegulatoryCode','99');
                   gen.writeFieldName('TaxExemptionCodeList');
                   gen.writeStartArray();
                   gen.writeString('00');
                   gen.writeString('00');
                   gen.writeEndArray();
                   gen.writeEndObject();
             }
        gen.writeEndArray();
        
        String jsonString = gen.getAsString();
        jsonString='request='+jsonString;
        System.debug(jsonString);
        
        request = new HttpRequest();
        response = new HttpResponse();
        request.setCompressed(false);
        request.setHeader('Content-type', 'application/x-www-form-urlencoded');
        request.setEndpoint('https://testapi.taxrating.net/Services/V01/SureTax.asmx/PostRequest'); 
        request.setBody(jsonString);
        system.debug('body>>>>>>>>'+request.getbody());
        request.setMethod('POST');
        Http http = new Http();
         
        try {
        if(!test.isrunningtest())
      response = http.send(request);
      system.debug('response >>>>'+response.getBody());
      Dom.Document testdoc = new Dom.Document();
      if(test.isrunningtest())     
      testdoc.load('<?xml version="1.0" encoding="utf-8"?><string xmlns="http://tempuri.org/">{"Successful":"Y","ResponseCode":"9999","HeaderMessage":"Success","ItemMessages":[],"ClientTracking":"track","TotalTax":"789.07","TransId":318852327,"GroupList":[{"StateCode":"CA","InvoiceNumber":"12","CustomerNumber":"0488","TaxList":[{"TaxTypeCode":"101","TaxTypeDesc":"STATE SALES TAX","TaxAmount":"547.97"},{"TaxTypeCode":"202","TaxTypeDesc":"COUNTY SALES TAX","TaxAmount":"109.59"},{"TaxTypeCode":"203","TaxTypeDesc":"DISTRICT TAX (LACT) (LATC ) (LAMT)","TaxAmount":"131.51"}]}]}</string>');      
      
      Dom.Document doc = (!test.isrunningtest())?response.getBodyDocument():testdoc;
      Dom.XMLNode root = doc.getRootElement();
      List<String> Ele=new List<String>();
      Decimal Taxrate;
      String TaxRes;
      
      for(Dom.XMLNode childField :root.getChildren()){
          Ele=childField.getText().split(',',0);
          system.debug('root>>>'+Ele);
      }
      
      List<String> Res=new List<String>();
      for(integer Count=0;Count<Ele.size();Count++){
         Res=Ele[Count].split(':',0);
         if(Res[0]=='"TotalTax"'){
         TaxRes=Res[1].substring(1, Res[1].length()-1);
         Taxrate=Decimal.valueof(TaxRes);
         }
      }
    List<QuoteLineItem> oli=new List<QuoteLineItem>();
    List<OpportunityLineItem> oppli=new List<OpportunityLineItem>();
    String products;
    products = SureTax__c.getInstance('Sales Tax').Product_Id__c;
    system.debug('opp==='+qut.id);
    for(QuoteLineItem o:[select id,PricebookEntry.product2id,product2id,QuoteId from QuoteLineItem where QuoteId=:qut.id]){
        system.debug(string.valueOf(o.product2id).substring(0,15)+'==p=='+products+'==='+string.valueOf(o.product2id).substring(0,15)==products);
        if(string.valueOf(o.product2id).substring(0,15)==products)
        oli.add(o);
    }
    for(OpportunityLineItem o:[select id,PricebookEntry.product2id,product2id,OpportunityId from OpportunityLineItem where OpportunityId=:qut.OpportunityId ]){        
        if(string.valueOf(o.product2id).substring(0,15)==products)
        oppli.add(o);
    }
    system.debug(oli+'==pbook==='+Qut.Pricebook2id);
    
        for(PricebookEntry pbe:[select id from PricebookEntry where pricebook2id=:Qut.Pricebook2id and product2id=:products]){
         system.debug('pbe===='+pbe);
        if(oli.size()==0){
        QuoteLineItem SalOli=new QuoteLineItem();
        SalOli.PricebookEntryId=pbe.id;
        SalOli.QuoteId=qut.id;
        SalOli.quantity=1;
        SalOli.unitprice=Taxrate;
        SalOli.Sales_Taxs__c=true;
        insert SalOli;
        }
        if(oppli.size()==0 && qut.IsSyncing == false){
        OpportunityLineItem SalOppli=new OpportunityLineItem();
        SalOppli.PricebookEntryId=pbe.id;
        SalOppli.OpportunityId=qut.OpportunityId;
        SalOppli.quantity=1;
        SalOppli.unitprice=Taxrate;
        SalOppli.Sales_Taxs__c=true;
        insert SalOppli;}
        else{
        for(OpportunityLineItem o:oppli){
           o.unitprice=Taxrate;
           o.Sales_Taxs__c=true;
        }
        update oppli;
        }
        }
        
    
    if(oli.size()>0){
        for(QuoteLineItem o:oli){
           o.unitprice=Taxrate;
           o.Sales_Taxs__c=true;
        }        
        update oli;
    }
    
    }catch(System.CalloutException e) {
    
    }
    PageReference pg = new PageReference('/'+qut.id);
        pg.setredirect(true);
        return pg;    
    }       
}