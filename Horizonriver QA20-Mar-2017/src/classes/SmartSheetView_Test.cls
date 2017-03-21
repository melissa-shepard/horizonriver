@isTest (SeeAllData = TRUE)
public class SmartSheetView_Test{
    static testmethod void SmartSheetViewTests(){
        Test.StartTest();
        SmartSheetView.SSDatas();
        
    
        Test.StopTest();
        
    }
    static testmethod void ss1(){
    SmartSheets ssobj= new SmartSheets();
        ssobj.id='4926930429470596';
    ssobj.name='ME Master Rollout Schedule';
    ssobj.version=1319;
    ssobj.totalRowCount=1148;
    ssobj.accessLevel='EDITOR_SHARE';
    ssobj.ganttEnabled=true;
    ssobj.dependenciesEnabled=true;
    ssobj.resourceManagementEnabled=true;
    ssobj.cellImageUploadEnabled=true;
    //ssobj.userSettings=new List<ssobj.cls_userSettings>();
    ssobj.permalink='https://app.smartsheet.com/b/home?lx=8aA4CGAXXgHLRdipO4hNjQ';
    ssobj.createdAt='2016-09-06T13:29:56Z';
    ssobj.modifiedAt='2017-01-12T15:57:14Z';
    cls_cells cells=new cls_cells();
    cells.columnId='5403890523891588';
    cells.value='Group6';
    cells.displayValue='Group6';
    cls_rows crows=new cls_rows();
    crows.id='1708263350790020';
    crows.rowNumber=1;
    crows.createdAt='2016-09-06T14:46:50Z';
    crows.modifiedAt='2016-12-28T19:39:06Z';
    }
}