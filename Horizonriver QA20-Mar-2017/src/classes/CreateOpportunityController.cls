public class CreateOpportunityController {
 
        //Declaration
        Public opportunity OppObj {get;set;}
        Public Quote QuoteObj {get;set;}
        Public List<opportunity> opportunities {get;set;}
        Public boolean OppLayout {get;set;}
        Public boolean QuoteLayout {get;set;}
        Public boolean FirstPage{get;set;}
        Public boolean ChoosePBookPg{get;set;}
        
        Public List<selectOption> PriceBookSelect {get;set;}
        Public String PBvalue {get;set;}
        public String toSelect {get; set;}
        public priceBookEntry[] AvailableProducts {get;set;}
        public Pricebook2 theBook {get;set;} 
        public Boolean multipleCurrencies {get; set;}
        public String searchString {get;set;}
        public opportunityLineItem[] shoppingCart {get;set;}
        public Boolean overLimit {get;set;}
        public Boolean ProductPage{get;set;}
        public Boolean DetailPage{get;set;}
        private Boolean forcePricebookSelection = false;
        
        private opportunityLineItem[] forDeletion = new opportunityLineItem[]{};
        
    public String toUnselect {get; set;}
        
        //Constructor Call
        public CreateOpportunityController() {
            OppObj = new opportunity();
            QuoteObj = new Quote();
            
            QuoteLayout = false;
            OppLayout = false;
            FirstPage = true;
            ChoosePBookPg = false;
            ProductPage = false;
            DetailPage = false;
            /*          
            QuoteLayout = true;
            OppLayout = true;
            FirstPage = true;
            ChoosePBookPg = true;
            ProductPage = true;
            */

            
            shoppingCart = new List<opportunityLineItem>();
            PriceBookSelect = new List<selectoption>();
            for(Pricebook2 p : [SELECT Id, Name FROM Pricebook2]){
                PriceBookSelect.add(new selectoption(p.id,p.name));
                if(PBvalue == null)
                    PBvalue = p.name;
            }
            
            multipleCurrencies = UserInfo.isMultiCurrencyOrganization();
        }
        
        //CreateInvoice Method()
        public void CreateInvoice(){
            OppLayout = true;
            FirstPage = false;
        }
        
        //PBSave Method()
        public void PBSave(){
            QuoteLayout = false;
            ProductPage = true;
            ChoosePBookPg = false;
            try{
                OppObj.Pricebook2id = PBvalue;
                insert OppObj;
                
                
                shoppingCart = [select Id, Quantity, TotalPrice, UnitPrice, Description, PriceBookEntryId, PriceBookEntry.Name, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.PriceBook2Id from opportunityLineItem where OpportunityId=:OppObj.Id];
                if(OppObj.Pricebook2Id == null){
                    Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
                    if(activepbs.size() == 2){
                        forcePricebookSelection = true;
                        theBook = new Pricebook2();
                    }
                    else{
                        theBook = activepbs[0];
                    }
                }
                else{
                    theBook = OppObj.Pricebook2;
                }
                
                //if(!forcePricebookSelection)
                    updateAvailableList();
           
            }
            catch(exception e){
            system.debug('ERROR:'+e);
            }
           
        }
        
        
        //Next Method()
        public void Next(){
            QuoteLayout = false;
            OppLayout = false;
            ChoosePBookPg = true;

        }
        
        //CreateQuoteMethod()
        public PageReference CreateQuote(){
            QuoteLayout = false;
            OppLayout = false;
            ChoosePBookPg = false;
            DetailPage = true;
            List<quotelineitem> QItemList = new List<quotelineitem>();
            try{
                //insert OppObj;
                QuoteObj.opportunityid = OppObj.id;
                QuoteObj.pricebook2id = PBvalue; 
                insert QuoteObj;
                For(OpportunityLineItem q : [SELECT Id, OpportunityId, SortOrder, PricebookEntryId, Product2Id, ProductCode, Name, Quantity, TotalPrice, UnitPrice, ListPrice FROM OpportunityLineItem where opportunityid =: OppObj.id]){
                    quotelineitem ql = new quotelineitem();
                    ql.quoteid = QuoteObj.id;
                    ql.pricebookentryid = q.PricebookEntryId;
                    ql.quantity = q.Quantity;
                    ql.unitprice = q.UnitPrice;
                    QItemList.add(ql);
                }
                //PageReference pageRef = new PageReference('/apex/opportunityProductEntry?Id='+OppObj.id+'&QuoteId='+QuoteObj.id);
                //PageReference pageRef = new PageReference('/'+QuoteObj.id);
                if(QItemList.size()>0)
                insert QItemList;
                
                //PageReference pageRef = new PageReference('/apex/SureTax?id='+QuoteObj.id);
                
                //return null;
                PageReference pageRef = new PageReference('/apex/QuoteDetailPage?id='+QuoteObj.id);
                return pageRef;
    
            }
            catch(exception e){
                PageReference pageRef = new PageReference('/apex/SureTax?id='+QuoteObj.id);
                return null;
            }
            return null;
            
        }
        
        public void addToShoppingCart(){
    
        // This function runs when a user hits "select" button next to a product
    
        for(PricebookEntry d : AvailableProducts){
            if((String)d.Id==toSelect){
                shoppingCart.add(new opportunityLineItem(OpportunityId=OppObj.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice));
                break;
            }
        }
        
        updateAvailableList();  
        }
        
        public void updateAvailableList() {
    
            // We dynamically build a query string and exclude items already in the shopping cart
            String qString = 'select Id, Pricebook2Id, IsActive, Product2.Name, Product2.Family, Product2.IsActive, Product2.Description, UnitPrice from PricebookEntry where IsActive=true and Pricebook2Id = \'' + PBvalue + '\'';
            if(multipleCurrencies)
                qstring += ' and CurrencyIsoCode = \'' + OppObj.get('currencyIsoCode') + '\'';
            
            // note that we are looking for the search string entered by the user in the name OR description
            // modify this to search other fields if desired
            if(searchString!=null){
                qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\')';
            }
            
            Set<Id> selectedEntries = new Set<Id>();
            for(opportunityLineItem d:shoppingCart){
                selectedEntries.add(d.PricebookEntryId);
            }
            
            if(selectedEntries.size()>0){
                String tempFilter = ' and Id not in (';
                for(Id i : selectedEntries){
                    tempFilter+= '\'' + (String)i + '\',';
                }
                String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
                extraFilter+= ')';
                
                qString+= extraFilter;
            }
            
            qString+= ' order by Product2.Name';
            qString+= ' limit 101';
            
            system.debug('qString:' +qString);        
            AvailableProducts = database.query(qString);
            
            // We only display up to 100 results... if there are more than we let the user know (see vf page)
            if(AvailableProducts.size()==101){
                AvailableProducts.remove(100);
                overLimit = true;
            }
            else{
                overLimit=false;
            }
        }
        
        public PageReference removeFromShoppingCart(){
    
            // This function runs when a user hits "remove" on an item in the "Selected Products" section
        
            Integer count = 0;
        
            for(opportunityLineItem d : shoppingCart){
                if((String)d.PriceBookEntryId==toUnselect){
                
                    if(d.Id!=null)
                        forDeletion.add(d);
                
                    shoppingCart.remove(count);
                    break;
                }
                count++;
            }
            
            updateAvailableList();
            
            return null;
        }
        
        public void onSave(){
        
                QuoteLayout = true;
                    ProductPage = false;
            
                // If previously selected products are now removed, we need to delete them
                if(forDeletion.size()>0)
                    delete(forDeletion);
            
                // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
                try{
                    if(shoppingCart.size()>0)
                        upsert(shoppingCart);
                        //return new PageReference('/apex/SureTax?id=' + ApexPages.currentPage().getParameters().get('QuoteId'));
                }
                catch(Exception e){
                    ApexPages.addMessages(e);
                    
                }  
                
         }
}