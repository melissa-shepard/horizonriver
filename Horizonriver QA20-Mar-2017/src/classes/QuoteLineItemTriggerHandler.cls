Public class QuoteLineItemTriggerHandler{
    
    public void Isinsert(List<QuoteLineItem> Newlist){
        RemoveSTprd(Newlist);        
    }
    
    public void RemoveSTprd(List<QuoteLineItem> Newlist){
        
        String products;
        products = test.isrunningtest()?'test':SureTax__c.getInstance('Sales Tax').Product_Id__c;
        for ( Integer i = Newlist.size() - 1; i > -1; --i )
        {
            system.debug('=='+Newlist[i].product2id);
            if(Newlist[i].product2id !=null && string.valueof(Newlist[i].product2id).startswith(products))
            Newlist[i].product2id = '';
            //Newlist.remove(i+1);
        }
    }
}