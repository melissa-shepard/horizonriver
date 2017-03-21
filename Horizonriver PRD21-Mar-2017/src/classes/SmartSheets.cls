public class SmartSheets{
    public string id;  //4926930429470596
    public String name; //ME Master Rollout Schedule
    public Integer version; //1319
    public Integer totalRowCount;   //1148
    public String accessLevel;  //EDITOR_SHARE
    public boolean ganttEnabled;
    public boolean dependenciesEnabled;
    public boolean resourceManagementEnabled;
    public boolean cellImageUploadEnabled;
    public cls_userSettings userSettings;
    public String permalink;    //https://app.smartsheet.com/b/home?lx=8aA4CGAXXgHLRdipO4hNjQ
    public String createdAt;    //2016-09-06T13:29:56Z
    public String modifiedAt;   //2017-01-12T15:57:14Z
    public cls_columns[] columns;
    public cls_rows[] rows;
    
    public class cls_userSettings {
        public boolean criticalPathEnabled;
        public boolean displaySummaryTasks;
    }
    public class cls_columns {
        public string id;  //5403890523891588
        public Integer index;   //0
        public String title;    //Priority
        public String type; //TEXT_NUMBER
        public boolean primary;
        public Integer width;   //121
    }
    public SmartSheets(){}
}