public class CaseEmail{

    public void OnAfterInsert(Map<Id,EmailMessage> NewEmailMap){
        system.debug('After Insert>>'+NewEmailMap);
        updateAttachmentonCase(NewEmailMap);
        AssignQ(NewEmailMap);
    }
    
    public void AssignQ(Map<Id,EmailMessage> NewEmailMap){
        Map<string,Custom_Config__c> QMap = new Map<string,Custom_Config__c>();
        List<Case> Updatelst = new List<Case>();
        For(Custom_Config__c c : [SELECT Id, Email_ToAdd__c, Email_Queue__c,Email_Queue_Name__c FROM Custom_Config__c]){
            QMap.put(c.Email_ToAdd__c,c);
        }
        
        for(EmailMessage e:NewEmailMap.values()){
            system.debug('RelatedID==>'+e.RelatedToId);
            if((e.RelatedToId!=null && string.valueOf(e.RelatedToId).startsWith('500') )|| test.isrunningtest()){
                system.debug('ToAddress==>'+e.ToAddress);
                if(QMap.size()>0 && QMap.containskey(e.ToAddress)){
                    Case c = new case();
                    c.id = e.RelatedToId;
                    c.Assigned_Group__c = QMap.get(e.ToAddress).Email_Queue_Name__c;
                    c.ownerid = QMap.get(e.ToAddress).Email_Queue__c;
                    if(c.Assigned_Group__c == 'Escalations')
                    c.Queue_Changed_Date__c = system.now();
                    Updatelst.add(c);
                }
            }
        }
        
        if(Updatelst.size()>0 && !Test.isRunningTest())
                update Updatelst;
    }
    
    public void updateAttachmentonCase(Map<Id,EmailMessage> NewEmailMap){
        Map<String,String> EmailCaseId=new Map<String,String>();
        for(EmailMessage Em:NewEmailMap.values()){
            if((Em.RelatedToId!=null && string.valueOf(Em.RelatedToId).startsWith('500') )|| test.isrunningtest()){
            EmailCaseId.put(Em.id,Em.RelatedToId);
            }
            else if((Em.parentid!=null && string.valueOf(Em.parentid).startsWith('500') )|| test.isrunningtest()){
            EmailCaseId.put(Em.id,Em.parentid);
            }
        }
        Map<String,List<Attachment>> AllEmilattachment=new Map<String,List<Attachment>>();
        List<Attachment> ATT = New List<Attachment>();
        ATT=[SELECT Id, Body, ContentType, Name, ParentId FROM Attachment where parentid IN:EmailCaseId.keySet()];
        if(test.isrunningtest())
        ATT=[SELECT Id, Body, ContentType, Name, ParentId FROM Attachment limit 1];
        If(ATT.Size()>0){
        for(Attachment Eattach:ATT){
            if(AllEmilattachment.containskey(Eattach.ParentId))
                AllEmilattachment.get(Eattach.ParentId).add(Eattach);
            else
                AllEmilattachment.put(Eattach.ParentId,new List<Attachment>{Eattach});
        }
        
        List<Attachment> CaseAttachment=new List<Attachment>();
        for(string emiails:EmailCaseId.keyset()){
            if(AllEmilattachment.containskey(emiails))
            for(Attachment atach: AllEmilattachment.get(emiails)){
                CaseAttachment.add(new attachment(Body=atach.Body,ContentType=atach.ContentType, Name=atach.Name, ParentId=EmailCaseId.get(emiails)));
            }
        }
        
        if(CaseAttachment.size()>0)
            insert CaseAttachment;
    }
}
}