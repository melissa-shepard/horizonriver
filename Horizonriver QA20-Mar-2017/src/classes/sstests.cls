public class sstests {
    public transient HttpRequest request;
    public transient HttpResponse response;
    public string responses{get;set;}
    public List<string> reslist{get;set;}
    public SmartSheets ssAll;
    public List<SSWrap> SSDatas{get;set;}
    public map<string,opportunity> OppMap;
    //public boolean SuccessFlag{get;set;}
    //public boolean FailFlag{get;set;}
    public void onload(){        
        OppMap = new map<string,opportunity>();
        //SuccessFlag = false;
        //FailFlag = false;
        for(opportunity o : [select id, Store_Number__c from opportunity where Store_Number__c  in ('0011','0014','0015','0033', '0092','0095','0227')]){
            OppMap.put(o.Store_Number__c  ,o);
        }
        
        SSDatas();
    }
    public void SSDatas(){
        
        
        
        request = new HttpRequest();
        response = new HttpResponse();
        reslist = new List<string>();
        request.setHeader('Accept', 'application/json');
        Blob headerValue = Blob.valueOf('development@lizztech.com:Salesforce2016!');
        String authorizationHeader = 'Bearer 3ywhhmd4nxags7eatgyxkf7ay0';// + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);    
        request.setEndPoint('https://api.smartsheet.com/2.0/sheets/4926930429470596?include=format');
        request.setMethod('GET');
        Http ht=new Http();
        response=ht.send(request);
        responses=response.getBody();
        ssAll=new SmartSheets();
        ssAll=(SmartSheets) System.JSON.deserialize(responses, SmartSheets.class);
        SmartSheets ssNew=new SmartSheets();
        system.debug('===='+ssNew.rows);
        SSDatas=new List<SSWrap>();
        SSWrap ssw;
        integer i=1;
        boolean flg;
        for(cls_rows ss:ssAll.rows){
            
            if(date.valueOf((ss.modifiedAt).split('T')[0])>=system.today().adddays(-7)){
            ssw=new SSWrap();
            flg=true;
            for(cls_cells ssc:ss.cells){
                if(ssc.columnid=='3152090710206340'){
                    ssw.sno=ssc.value;
                }
                if(ssc.columnid=='6389052942378884'){
                    ssw.IIC=ssc.value;
                }
                if(ssc.columnid=='4137253128693636'){
                    ssw.NWIC=ssc.value;                    
                }
                if(ssc.columnid=='8185235713091460' && ssc.value!='true'){
                    //ssw.clear();
                    flg=false;
                    break;
                }
            }
            if(flg)
            SSDatas.add(ssw);
            }
            i++;
        }
        
        
        if(SSDatas.size()>0){
            List<opportunity> OppList = new List<opportunity>();
            for(SSWrap s:SSDatas ){
                /*
                if(s.sno == '0011' || s.sno == '0014' || s.sno == '0015' || s.sno == '0033' || s.sno == '0092' || s.sno == '0095'  || s.sno == '0227' ){
                    system.debug('<<<<SUCCESS>>>'+s.sno);
                } 
                */
                if(s.sno != null && s.sno != '' && OppMap.containskey(s.sno)){
                    opportunity o = new opportunity();
                    o.id = OppMap.get(s.sno).id;
                    if(s.IIC != null && s.IIC != '')
                    o.Internet_Installation_Date__c = date.valueof(s.IIC);
                    if(s.NWIC != null && s.NWIC != '')
                    o.Network_Installation_Date__c = date.valueof(s.NWIC);
                    OppList.add(o);
                }
            }
            
            If(OppList.size()>0){
                try{
                    update OppList;
                    //SuccessFlag = true;
                }
                catch(Exception e){
                    System.debug('ERROR=='+e);
                    //FailFlag = true;
                }
            }
        }
    }
    public class SSWrap{
        public string sno{get;set;}
        public string IIC{get;set;}
        public string NWIC{get;set;}        
    } 
       
}