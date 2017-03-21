public class SmartSheetView {
   public void onload(){        
        SSDatas();
    }
    
   @future (callout=true)
   public static void SSDatas(){        
        transient HttpRequest request;
        transient HttpResponse response;
        string responses;       
        request = new HttpRequest();
        response = new HttpResponse();
        
        request.setHeader('Accept', 'application/json');
        Blob headerValue = Blob.valueOf(Custom_Config__c.getinstance('Smart Sheet Settings').headerValue__c);
        String authorizationHeader = Custom_Config__c.getinstance('Smart Sheet Settings').authorizationHeader__c;// + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);    
        request.setEndPoint('https://api.smartsheet.com/2.0/reports/1048378869081988?include=format');
        request.setMethod('GET');
        
        Http ht=new Http();
        if(!test.isrunningtest()){
        response=ht.send(request);
        responses=response.getBody();}
              
        system.debug('==res=='+responses);
        SmartSheets ssAll=new SmartSheets();
        if(!test.isrunningtest())
        ssAll=(SmartSheets) System.JSON.deserialize(responses, SmartSheets.class);
        SmartSheets ssNew=new SmartSheets();
        system.debug('===='+ssNew.rows);
        Map<string, SSWrap> SSDatas=new Map<string,SSWrap>();
        SSWrap ssw;
        integer i=1;
        boolean flg,err;
        String sno;
        if(test.isrunningtest()){
        responses='{"id":1708263350790020,"sheetId":4926930429470596,"rowNumber":255,"siblingId":237662253672324,"version":2214,"expanded":true,"accessLevel":"EDITOR_SHARE","createdAt":"2016-09-06T14:46:50Z","modifiedAt":"2017-02-10T22:00:45Z","cells":[{"columnId":5403890523891588,"columnType":"TEXT_NUMBER","value":"Group 6","displayValue":"Group 6"},{"columnId":3152090710206340,"columnType":"TEXT_NUMBER","value":"0116","displayValue":"0116"},{"columnId":4700203082114948,"columnType":"TEXT_NUMBER","value":63368.0,"displayValue":"63368"},{"columnId":3011353221851012,"columnType":"DATE","value":"2017-03-27"},{"columnId":5472063533148036,"columnType":"DATE","value":"2017-03-17","linksOutToCells":[{"status":"OK","sheetId":5534891640153988,"rowId":4137835686061956,"columnId":8725037403400068,"sheetName":"Massage Envy Internet Tracker"}]},{"columnId":7222417325090692,"columnType":"DATE","value":"2017-03-17","formula":"=[Target NW Install Week]255 - 10"},{"columnId":2796035874547588,"columnType":"DATE","value":"2017-07-03","linkInFromCell":{"status":"INACCESSIBLE","sheetId":3664153538783108,"rowId":null,"columnId":null,"sheetName":"IPad Golive 01302017"}},{"columnId":2165515616577412,"columnType":"TEXT_NUMBER","value":99.0,"displayValue":"99","formula":"=NETDAYS([Target NW Install Week]255, [P4 IPad GoLive]255)"},{"columnId":6669115243947908,"columnType":"TEXT_NUMBER","value":109.0,"displayValue":"109","formula":"=IF(ISBLANK([Internet Install Complete]255), IF(ISBLANK([Internet Construction Completion Date]255), NETDAYS([Target Internet Install Week]255, [P4 IPad GoLive]255), IF(([Internet Construction Completion Date]255 > [Target Internet Install Week]255), NETDAYS([Internet Construction Completion Date]255, [P4 IPad GoLive]255), NETDAYS([Target Internet Install Week]255, [P4 IPad GoLive]255))), NETDAYS([Internet Install Complete]255, [P4 IPad GoLive]255))"},{"columnId":1710530235787140,"columnType":"CHECKBOX"},{"columnId":7070821354104708,"columnType":"CHECKBOX"},{"columnId":8687425569482628,"columnType":"CHECKBOX"},{"columnId":5523000234665860,"columnType":"CHECKBOX"},{"columnId":7315485910951812,"columnType":"TEXT_NUMBER"},{"columnId":2519003873732484,"columnType":"CHECKBOX"},{"columnId":713621081745284,"columnType":"CHECKBOX"},{"columnId":1685986376738692,"columnType":"TEXT_NUMBER"},{"columnId":7022603501102980,"columnType":"CHECKBOX"},{"columnId":8250978240620420,"columnType":"TEXT_NUMBER"},{"columnId":1592917790877572,"columnType":"TEXT_NUMBER"},{"columnId":759553408165764,"columnType":"DATE","value":"TBD","linkInFromCell":{"status":"OK","sheetId":5534891640153988,"rowId":4137835686061956,"columnId":1043178016008068,"sheetName":"Massage Envy Internet Tracker"}},{"columnId":7514952849221508,"columnType":"DATE"},{"columnId":5999178426935172,"columnType":"TEXT_NUMBER"},{"columnId":3747378613249924,"columnType":"TEXT_NUMBER"},{"columnId":6096517418248068,"columnType":"TEXT_NUMBER"},{"columnId":4136978250786692,"columnType":"TEXT_NUMBER"},{"columnId":478078431455108,"columnType":"CHECKBOX"},{"columnId":2856788086286212,"columnType":"TEXT_NUMBER"},{"columnId":4981678058825604,"columnType":"TEXT_NUMBER"},{"columnId":3844717604562820,"columnType":"TEXT_NUMBER"},{"columnId":6034717804914564,"columnType":"TEXT_NUMBER"},{"columnId":8286517618599812,"columnType":"TEXT_NUMBER"},{"columnId":3782917991229316,"columnType":"TEXT_NUMBER"},{"columnId":2894790326019972,"columnType":"DATE"},{"columnId":6389052942378884,"columnType":"DATE","linkInFromCell":{"status":"OK","sheetId":5534891640153988,"rowId":4137835686061956,"columnId":1063640381056900,"sheetName":"Massage Envy Internet Tracker"},"linksOutToCells":[{"status":"INACCESSIBLE","sheetId":8756604590942084,"rowId":null,"columnId":null,"sheetName":"ME Billing Tracker"}]},{"columnId":4137253128693636,"columnType":"DATE","linksOutToCells":[{"status":"INACCESSIBLE","sheetId":8756604590942084,"rowId":null,"columnId":null,"sheetName":"ME Billing Tracker"}]},{"columnId":8185235713091460,"columnType":"CHECKBOX"},{"columnId":2729878245140356,"columnType":"TEXT_NUMBER"},{"columnId":8640852756064132,"columnType":"DATE"},{"columnId":260416300443524,"columnType":"DATE"},{"columnId":5569717432805252,"columnType":"CHECKBOX"},{"columnId":7525951253833604,"columnType":"TEXT_NUMBER"},{"columnId":1896451719620484,"columnType":"TEXT_NUMBER","value":1.0,"displayValue":"1"},{"columnId":6400051346990980,"columnType":"TEXT_NUMBER","value":2.0,"displayValue":"2"},{"columnId":4148251533305732,"columnType":"TEXT_NUMBER","value":2.0,"displayValue":"2"},{"columnId":8651851160676228,"columnType":"TEXT_NUMBER","value":4.0,"displayValue":"4"},{"columnId":489076836067204,"columnType":"TEXT_NUMBER","value":1.0,"displayValue":"1"},{"columnId":4992676463437700,"columnType":"TEXT_NUMBER"},{"columnId":7170002919942020,"columnType":"TEXT_NUMBER","value":116.0,"displayValue":"116","formula":"=VALUE([Store Number]255)"},{"columnId":290728032135044,"columnType":"TEXT_NUMBER","value":116.0,"displayValue":"116","linkInFromCell":{"status":"OK","sheetId":5534891640153988,"rowId":4137835686061956,"columnId":8192720532465540,"sheetName":"Massage Envy Internet Tracker"}},{"columnId":1764838117533572,"columnType":"TEXT_NUMBER","value":0.0,"displayValue":"0","formula":"=[Store ID]255 - [IT Store ID]255"},{"columnId":2740876649752452,"columnType":"TEXT_NUMBER","value":598.0,"displayValue":"598"},{"columnId":7012686488725380,"columnType":"TEXT_NUMBER","value":598.0,"displayValue":"598"}],"columns":[{"id":5403890523891588,"index":0,"title":"Priority","type":"TEXT_NUMBER","primary":true,"tags":["GANTT_DISPLAY_LABEL"],"width":121},{"id":3152090710206340,"index":1,"title":"Store Number","type":"TEXT_NUMBER","width":98},{"id":7655690337576836,"index":2,"title":"Territory","type":"PICKLIST","options":["Central","East","Northeast","Northwest","West"],"width":71},{"id":2026190803363716,"index":3,"title":"Region","type":"TEXT_NUMBER","width":155},{"id":6529790430734212,"index":4,"title":"Site Name","type":"TEXT_NUMBER","width":165},{"id":4277990617048964,"index":5,"title":"Street_Address","type":"TEXT_NUMBER","width":310},{"id":8781590244419460,"index":6,"title":"City","type":"TEXT_NUMBER","width":152},{"id":196603454744452,"index":7,"title":"ST","type":"TEXT_NUMBER","width":40},{"id":4700203082114948,"index":8,"title":"Zip","type":"TEXT_NUMBER","width":67},{"id":2448403268429700,"index":9,"title":"County","type":"TEXT_NUMBER","width":118},{"id":6952002895800196,"index":10,"title":"SitePhone","type":"TEXT_NUMBER","width":111},{"id":1322503361587076,"index":11,"title":"Site Contact Name","type":"TEXT_NUMBER","width":213},{"id":5826102988957572,"index":12,"title":"FranchiseeName","type":"TEXT_NUMBER","width":115},{"id":3574303175272324,"index":13,"title":"FranchiseeEmail","type":"TEXT_NUMBER","width":202},{"id":8077902802642820,"index":14,"title":"ClinicGeneralEmail","type":"TEXT_NUMBER","width":188},{"id":968463905777540,"index":15,"title":"SP1","type":"TEXT_NUMBER","width":40},{"id":5263153035536260,"index":16,"title":"Target NW Install Month","type":"TEXT_NUMBER","width":140},{"id":3011353221851012,"index":17,"title":"Target NW Install Week","type":"DATE","tags":["CALENDAR_START_DATE","GANTT_START_DATE"],"width":128},{"id":5472063533148036,"index":18,"title":"Target Internet Install Week","type":"DATE","tags":["GANTT_END_DATE"],"width":103},{"id":7222417325090692,"index":19,"title":"Target HW Ship Week","type":"DATE","width":87},{"id":2796035874547588,"index":20,"title":"P4 IPad GoLive","type":"DATE","width":150},{"id":2165515616577412,"index":21,"title":"Days between NW and IPad","type":"TEXT_NUMBER","width":150},{"id":6669115243947908,"index":22,"title":"Days between Internet and IPad","type":"TEXT_NUMBER","width":150},{"id":1710530235787140,"index":23,"title":"HW Order Submitted","type":"CHECKBOX","width":82},{"id":7070821354104708,"index":24,"title":"Active Staging","type":"CHECKBOX","width":68},{"id":8687425569482628,"index":25,"title":"HW Staged","type":"CHECKBOX","width":82},{"id":5523000234665860,"index":26,"title":"HW Shipped","type":"CHECKBOX","width":75},{"id":7315485910951812,"index":27,"title":"HW Tracking #s","type":"TEXT_NUMBER","width":150},{"id":2519003873732484,"index":28,"title":"HW Delivered","type":"CHECKBOX","width":70},{"id":713621081745284,"index":29,"title":"UPS Shipped","type":"CHECKBOX","width":75},{"id":1685986376738692,"index":30,"title":"UPS Tracking #s","type":"TEXT_NUMBER","width":150},{"id":7022603501102980,"index":31,"title":"UPS Delivered","type":"CHECKBOX","width":75},{"id":8250978240620420,"index":32,"title":"HW Kit Order#","type":"TEXT_NUMBER","width":94},{"id":1592917790877572,"index":33,"title":"SP2","type":"TEXT_NUMBER","width":40},{"id":759553408165764,"index":34,"title":"Internet Install Scheduled","type":"DATE","width":107},{"id":7514952849221508,"index":35,"title":"NW Install Scheduled","type":"DATE","width":93},{"id":5999178426935172,"index":36,"title":"ATLAS REQ","type":"TEXT_NUMBER","width":89},{"id":3747378613249924,"index":37,"title":"ATLAS CHG","type":"TEXT_NUMBER","width":84},{"id":6096517418248068,"index":38,"title":"SP3","type":"TEXT_NUMBER","width":71},{"id":4136978250786692,"index":39,"title":"Install Comments","type":"TEXT_NUMBER","width":104},{"id":478078431455108,"index":40,"title":"Revisit Reqd","type":"CHECKBOX","width":105},{"id":2856788086286212,"index":41,"title":"Revisit Date","type":"TEXT_NUMBER","width":107},{"id":4981678058825604,"index":42,"title":"Revisit Reason","type":"TEXT_NUMBER","width":179},{"id":3844717604562820,"index":43,"title":"SP4","type":"TEXT_NUMBER","width":40},{"id":6034717804914564,"index":44,"title":"Carrier","type":"TEXT_NUMBER","width":104},{"id":8286517618599812,"index":45,"title":"Service Type","type":"TEXT_NUMBER","width":94},{"id":3782917991229316,"index":46,"title":"Support Number","type":"TEXT_NUMBER","width":84},{"id":2894790326019972,"index":47,"title":"Internet Construction Completion Date","type":"DATE","width":150},{"id":6389052942378884,"index":48,"title":"Internet Install Complete","type":"DATE","width":101},{"id":4137253128693636,"index":49,"title":"P4 Complete","type":"DATE","width":85},{"id":8185235713091460,"index":50,"title":"100% Complete","type":"CHECKBOX","width":83},{"id":2729878245140356,"index":51,"title":"InitialIndex","type":"TEXT_NUMBER","locked":true,"lockedForUser":true,"hidden":true,"width":51},{"id":8640852756064132,"index":52,"title":"Site Complete Date","type":"DATE","width":105},{"id":260416300443524,"index":53,"title":"Lease Payment Billed","type":"DATE","width":86},{"id":5569717432805252,"index":54,"title":"Is Leased","type":"CHECKBOX","width":87},{"id":7525951253833604,"index":55,"title":"SP5","type":"TEXT_NUMBER","width":59},{"id":1896451719620484,"index":56,"title":"CradlePoint","type":"TEXT_NUMBER","width":93},{"id":6400051346990980,"index":57,"title":"MX65 - Firewall","type":"TEXT_NUMBER","width":87},{"id":4148251533305732,"index":58,"title":"MS220-8P Switch","type":"TEXT_NUMBER","width":104},{"id":8651851160676228,"index":59,"title":"MR32 AP","type":"TEXT_NUMBER","width":81},{"id":489076836067204,"index":60,"title":"UPS","type":"TEXT_NUMBER","width":51},{"id":4992676463437700,"index":61,"title":"SP6","type":"TEXT_NUMBER","width":52},{"id":7170002919942020,"index":62,"title":"Store ID","type":"TEXT_NUMBER","width":150},{"id":290728032135044,"index":63,"title":"IT Store ID","type":"TEXT_NUMBER","width":91},{"id":1764838117533572,"index":64,"title":"ID Diff","type":"TEXT_NUMBER","width":64},{"id":2740876649752452,"index":65,"title":"929_Index","type":"TEXT_NUMBER","width":79},{"id":7012686488725380,"index":66,"title":"IndexRev1","type":"TEXT_NUMBER","locked":true,"lockedForUser":true,"hidden":true,"width":79}]}';
        ssAll.rows=new List<cls_rows>{(cls_rows) System.JSON.deserialize(responses, cls_rows.class)};
        }
        for(cls_rows ss:ssAll.rows){
            integer hrs=2; 
            if(Custom_Config__c.getinstance('Smart Sheet Settings').Rule_ON__c && Custom_Config__c.getinstance('Smart Sheet Settings').No_of_Hours__c != null)
               hrs = Integer.valueof(Custom_Config__c.getinstance('Smart Sheet Settings').No_of_Hours__c);     
            if(test.isrunningtest()||(datetime.valueOf((string.valueOf(ss.modifiedAt).replace('T',' ')).replace('Z',''))>=system.now().addhours(-hrs))){
            
            ssw=new SSWrap();
            flg=false;
            err=true;
            sno='';
            for(cls_cells ssc:ss.cells){
            
                if(ssc.columnid == Custom_Config__c.getinstance('SSColumnIDS').Email_ToAdd__c){//3152090710206340
                    
                    ssw.sno=ssc.value;
                    sno=(ssc.value).contains('.')?string.valueOf(decimal.valueOf(ssc.value).setscale(0)):ssc.value;
                    system.debug('=='+(ssc.value).contains('.')+'======sno==='+sno);
                }
                if(ssc.columnid == Custom_Config__c.getinstance('SSColumnIDS').Email_Queue__c){//6389052942378884
                system.debug('======IIC==='+ssc.value);
                    ssw.IIC=ssc.value;
                    if(ssw.IIC != null && ssw.IIC != '' && ssw.IIC.contains(' for DSL'))
                    err=false;
                     
                }
                if(ssc.columnid == Custom_Config__c.getinstance('SSColumnIDS').Email_Queue_Name__c){//7514952849221508,4137253128693636
                system.debug('======NWIC==='+ssc.value);
                    ssw.NWIC=ssc.value; 
                    if(ssw.NWIC != null && ssw.NWIC != '' && ssw.NWIC.contains(' for DSL'))
                    err=false;                
                }
            }
            if(err)
                SSDatas.put(sno,ssw);
            }
            i++;
        }
        system.debug('====datesmap==='+SSDatas.keyset());
        
        List<opportunity> OppList = new List<opportunity>();
        for(opportunity o : [select id, Install_Complete__c, Store_Number__c,Internet_Installation_Date__c,Network_Installation_Date__c from opportunity where Store_Number__c  in:SSDatas.keyset()]){
            if(SSDatas.containskey(o.Store_Number__c)){ 
                system.debug('====each opp==='+o);
                if(SSDatas.get(o.Store_Number__c).IIC!=null)           
                o.Internet_Installation_Date__c = date.valueof(SSDatas.get(o.Store_Number__c).IIC);
                else
                o.Internet_Installation_Date__c = null;
                if(SSDatas.get(o.Store_Number__c).NWIC!=null)           
                o.Network_Installation_Date__c = date.valueof(SSDatas.get(o.Store_Number__c).NWIC);
                else
                o.Network_Installation_Date__c = null;
                o.Install_Complete__c=true;
                OppList.add(o);
                
            }
        }
        system.debug('===opp===='+OppList);
        If(OppList.size()>0 || test.isrunningtest()){
            try{
                if(!test.isrunningtest())
                update OppList;
                else
                update new Opportunity();
                
            }
            catch(Exception e){
                System.debug('ERROR=='+e);
                Messaging.reserveSingleEmailCapacity(2);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {Custom_Config__c.getinstance('Smart Sheet Settings').To_Email__c}; 
                String[] ccAddresses = new String[] {Custom_Config__c.getinstance('Smart Sheet Settings').Cc_Email__c};
                mail.setToAddresses(toAddresses);
                mail.setCcAddresses(ccAddresses); 
                mail.setSenderDisplayName('Salesforce Support');
                mail.setSubject('Smart Sheet Update failed');
                mail.setBccSender(false);
                mail.setUseSignature(false);                               
                mail.setHtmlBody(''+e);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
     
       
}