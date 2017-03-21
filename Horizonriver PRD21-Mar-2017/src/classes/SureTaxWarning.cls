public with sharing class SureTaxWarning {
    public string recid;
    public AcctSeed__Billing__c abill;
    Public transient HttpRequest request;
    Public transient HttpResponse response;
    Public string responses{get;set;}
    public string JsonResult;
    public Boolean CheckTax{get;set;}
    public Boolean CheckTaxonQuote{get;set;}

    public pagereference login(){
   
    SureTaxWarning.calculateTax(recid);
    return new Pagereference('/'+recid);    
    }

    public static void calculateTax(string recids){
    transient HttpRequest request;
    transient HttpResponse response;
    string responses;
    AcctSeed__Billing__c abill;
    abill =[select id,Opp_PricebookId__c, ClinicNumber__c ,createddate,  AcctSeed__Billing_PostalCode__c,AcctSeed__Opportunity__c from AcctSeed__Billing__c where id=:recids];       
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
            String products;
            Product2 prdobj = [SELECT Id, ProductCode FROM Product2 limit 1];
            products = SureTax__c.getInstance('Sales Tax').Product_Id__c;
            for(AcctSeed__Billing_Line__c qt:[select id,createddate,AcctSeed__Total__c,AcctSeed__Product__r.TransCode__c, AcctSeed__Hours_Units__c from AcctSeed__Billing_Line__c where AcctSeed__Billing__c=:recids and AcctSeed__Product__c!=:products and Sales_Taxs__c = false]){
            i++;
            gen.writeStartObject();
                   gen.writeStringField('LineNumber',String.valueof(i));
                   gen.writeStringField('InvoiceNumber','12');
                   gen.writeStringField('CustomerNumber',aBill.ClinicNumber__c==null?'':aBill.ClinicNumber__c);
                   gen.writeStringField('OrigNumber','');
                   gen.writeStringField('TermNumber','');
                   gen.writeStringField('BillToNumber','');
                   gen.writeStringField('Zipcode',aBill.AcctSeed__Billing_PostalCode__c==null?'':aBill.AcctSeed__Billing_PostalCode__c);
                   gen.writeStringField('Plus4','');
                   gen.writeStringField('P2PZipcode','');
                   gen.writeStringField('P2PPlus4','');
                   gen.writeStringField('TransDate',String.valueof(date.valueof(aBill.createddate)));
                   gen.writeStringField('Revenue',String.valueof(qt.AcctSeed__Total__c));
                   gen.writeStringField('Units',String.valueof(qt.AcctSeed__Hours_Units__c));
                   gen.writeStringField('UnitType','00');
                   gen.writeStringField('Seconds','00');
                   gen.writeStringField('TaxIncludedCode','0');
                   gen.writeStringField('TaxSitusRule','04');
                   gen.writeStringField('TransTypeCode',qt.AcctSeed__Product__r.TransCode__c==null?'':qt.AcctSeed__Product__r.TransCode__c);
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
         try{
             Taxrate=Decimal.valueof(TaxRes);
         }
         catch(Exception e){
             Taxrate= 0;
         }    
         }
      }
    List<AcctSeed__Billing_Line__c> tBill=new List<AcctSeed__Billing_Line__c>();
        
        tBill=[select id,AcctSeed__Hours_Units__c,AcctSeed__Rate__c,Sales_Taxs__c from AcctSeed__Billing_Line__c where AcctSeed__Billing__c=:recids and AcctSeed__Product__c=:products];
    List<OpportunityLineItem> oppli=new List<OpportunityLineItem>();
    
    
    
    for(OpportunityLineItem o:[select id,PricebookEntry.product2id,product2id,OpportunityId from OpportunityLineItem where OpportunityId=:aBill.AcctSeed__Opportunity__c]){        
        if(string.valueOf(o.product2id).substring(0,15)==products.substring(0,15))
        oppli.add(o);
        
    }
    for(PricebookEntry pbe:[select id from PricebookEntry where pricebook2id=:abill.Opp_PricebookId__c and product2id=:products]){        
        if(oppli.size()==0){
        OpportunityLineItem SalOppli=new OpportunityLineItem();
        SalOppli.PricebookEntryId=pbe.id;
        SalOppli.OpportunityId=aBill.AcctSeed__Opportunity__c;
        SalOppli.quantity=1;
        SalOppli.unitprice=Taxrate;
        SalOppli.Sales_Taxs__c=true;
        if(!test.isrunningtest())
        insert SalOppli;
        }
        else{
        for(OpportunityLineItem o:oppli){
           o.unitprice=Taxrate;
           o.Sales_Taxs__c=true;
        }
        if(!test.isrunningtest())
        update oppli;
        }
        }
    if(tBill.size()==0){
        AcctSeed__Billing_Line__c bli;
        Id SlaesTaxGL;
        List<AcctSeed__GL_Account__c> GlAcc=new List<AcctSeed__GL_Account__c>([select id,name from AcctSeed__GL_Account__c where name like '%Sales Tax%' limit 1]);
        SlaesTaxGL=GlAcc.size()!=0?GlAcc[0].id:null;
        if(SlaesTaxGL!=null)
        for(AcctSeed__Billing__c bill:[select id from AcctSeed__Billing__c where id=:recids]){
            bli=new AcctSeed__Billing_Line__c();
            bli.AcctSeed__Billing__c=bill.id;
            bli.AcctSeed__Hours_Units__c=1;
            bli.AcctSeed__Rate__c=Taxrate;
            bli.AcctSeed__Revenue_GL_Account__c =SlaesTaxGL;
            bli.AcctSeed__Product__c=products;
            bli.Sales_Taxs__c=true;
            if(!test.isrunningtest())
            insert bli;
        }
    }
    else{
        for(AcctSeed__Billing_Line__c bli: tbill){
            bli.AcctSeed__Hours_Units__c=1;
            bli.AcctSeed__Rate__c=Taxrate;
            bli.Sales_Taxs__c=true;
            if(!test.isrunningtest())
            update bli;            
        }
    }
    }
    public SureTaxWarning(ApexPages.StandardController controller) {
        CheckTax=false;
        CheckTaxonQuote=false;
        recid=controller.getRecord().id;
        abill=new AcctSeed__Billing__c();
        if(recid==null)
        return;
        else
        abill =[select id, ClinicNumber__c ,createddate,  AcctSeed__Billing_PostalCode__c,AcctSeed__Opportunity__c from AcctSeed__Billing__c where id=:recid];       

    }
}