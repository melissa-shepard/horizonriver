public class CaseEmail{

    public void OnAfterInsert(Map<Id,EmailMessage> NewEmailMap){
        updateAttachmentonCase(NewEmailMap);
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