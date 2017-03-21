<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CaseClosedEmail</fullName>
        <description>CaseClosedEmail</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>customerservice@horizonriver.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/SupportCaseClosed</template>
    </alerts>
    <alerts>
        <fullName>CaseCommentAddedEmail</fullName>
        <description>CaseCommentAddedEmail</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>customerservice@horizonriver.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/SupportCaseCommentAdded</template>
    </alerts>
    <fieldUpdates>
        <fullName>CaseAssignedGroup</fullName>
        <field>Assigned_Group__c</field>
        <formula>Owner:Queue.QueueName</formula>
        <name>CaseAssignedGroup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CaseAssignedGroup2</fullName>
        <field>Assigned_Group__c</field>
        <formula>Owner:Queue.QueueName</formula>
        <name>CaseAssignedGroup2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CheckBox_Update</fullName>
        <field>Is_Email_Send__c</field>
        <literalValue>1</literalValue>
        <name>CheckBox Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CheckBox_Updates</fullName>
        <field>Is_Email_Send__c</field>
        <literalValue>1</literalValue>
        <name>CheckBox Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QueueChangeDate</fullName>
        <field>Queue_Changed_Date__c</field>
        <formula>NOW()</formula>
        <name>QueueChangeDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Update</fullName>
        <field>HRT_Case_Stage__c</field>
        <literalValue>1 - Telecom Team</literalValue>
        <name>Stage_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Case - Stage Update</fullName>
        <actions>
            <name>Stage_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Closed Email</fullName>
        <actions>
            <name>CaseClosedEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CaseAssignedGroup</fullName>
        <actions>
            <name>CaseAssignedGroup</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Escalations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>HRSupport</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CaseAssignedGroup2</fullName>
        <actions>
            <name>CaseAssignedGroup2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Accounting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Implementation_Support</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CaseCommentEmail</fullName>
        <actions>
            <name>CaseCommentAddedEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CaseComment__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case_QueueChangedUpdates</fullName>
        <active>true</active>
        <booleanFilter>(1 OR 3 ) AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.Assigned_Groups__c</field>
            <operation>equals</operation>
            <value>Escalations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Assigned_Group__c</field>
            <operation>equals</operation>
            <value>Escalations</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CheckBox_Updates</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Queue_Changed_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
