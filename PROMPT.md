# Q1
## 작업 유형: Custom Object 설계

## 목적
고객 문의 접수 데이터를 저장하는 Custom Object를 설계해줘.

## 구현할 User Story
- US-01: 고객으로서 문의 유형을 선택할 수 있다
- US-02: 시스템이 문의 접수 시 자동으로 Case를 생성한다
- US-03: 관리자가 문의 상태를 추적할 수 있다

## 필요한 필드 목록
| 필드명 | 타입 | 필수 여부 | 설명 |
|--------|------|-----------|------|
| Name | Text(80) | 필수 | 문의 제목 |
| CustomerName__c | Text(80) | 필수 | 고객 이름 |
| Email__c | Email | 필수 | 고객 이메일 |
| Phone__c | Phone | 선택 | 고객 연락처 |
| Category__c | Picklist | 필수 | 일반문의/불만/환불 |
| Content__c | LongTextArea | 필수 | 문의 내용 |
| Status__c | Picklist | 필수 | 접수/처리중/완료 |
| RelatedCase__c | Lookup(Case) | 선택 | 연결된 Case |

## 요청 사항
1. Inquiry__c.object-meta.xml 전체 코드
2. 위 필드 각각의 field-meta.xml 전체 코드
3. 각 파일의 저장 경로 명시
4. 완료 후 배포 명령어
```

# Answer 
   ```
✦ 제시해주신 User Story와 필드 요구사항을 바탕으로 Inquiry__c Custom Object 및 관련 필드 설계를 진행하겠습니다.


📄 파일 목록
1. force-app/main/default/objects/Inquiry__c/Inquiry__c.object-meta.xml
2. force-app/main/default/objects/Inquiry__c/fields/CustomerName__c.field-meta.xml
3. force-app/main/default/objects/Inquiry__c/fields/Email__c.field-meta.xml
4. force-app/main/default/objects/Inquiry__c/fields/Phone__c.field-meta.xml
5. force-app/main/default/objects/Inquiry__c/fields/Category__c.field-meta.xml
6. force-app/main/default/objects/Inquiry__c/fields/Content__c.field-meta.xml
7. force-app/main/default/objects/Inquiry__c/fields/Status__c.field-meta.xml
8. force-app/main/default/objects/Inquiry__c/fields/RelatedCase__c.field-meta.xml

  ---

💻 파일별 코드


1. Inquiry__c.object-meta.xml
   force-app/main/default/objects/Inquiry__c/Inquiry__c.object-meta.xml


    1 <?xml version="1.0" encoding="UTF-8"?>
    2 <CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    3     <deploymentStatus>Deployed</deploymentStatus>
    4     <description>고객 문의 접수 데이터를 저장하는 오브젝트</description>
    5     <enableActivities>true</enableActivities>
    6     <enableBulkApi>true</enableBulkApi>
    7     <enableFeeds>false</enableFeeds>
    8     <enableHistory>true</enableHistory>
    9     <enableLicensing>false</enableLicensing>
10     <enableReports>true</enableReports>
11     <enableSearch>true</enableSearch>
12     <enableSharing>true</enableSharing>
13     <enableStreamingApi>true</enableStreamingApi>
14     <externalSharingModel>Private</externalSharingModel>
15     <label>고객 문의</label>
16     <nameField>
17         <label>문의 제목</label>
18         <type>Text</type>
19     </nameField>
20     <pluralLabel>고객 문의</pluralLabel>
21     <searchLayouts/>
22     <sharingModel>ReadWrite</sharingModel>
23     <visibility>Public</visibility>
24 </CustomObject>


2. CustomerName__c.field-meta.xml
   force-app/main/default/objects/Inquiry__c/fields/CustomerName__c.field-meta.xml


    1 <?xml version="1.0" encoding="UTF-8"?>
    2 <CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    3     <fullName>CustomerName__c</fullName>
    4     <description>고객 이름</description>
    5     <externalId>false</externalId>
    6     <label>고객 이름</label>
    7     <length>80</length>
    8     <required>true</required>
    9     <trackHistory>false</trackHistory>
10     <trackTrending>false</trackTrending>
11     <type>Text</type>
12     <unique>false</unique>
13 </CustomField>


3. Email__c.field-meta.xml
   force-app/main/default/objects/Inquiry__c/fields/Email__c.field-meta.xml


    1 <?xml version="1.0" encoding="UTF-8"?>
    2 <CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    3     <fullName>Email__c</fullName>
    4     <description>고객 이메일</description>
    5     <externalId>false</externalId>
    6     <label>고객 이메일</label>
    7     <required>true</required>
    8     <trackHistory>false</trackHistory>
    9     <trackTrending>false</trackTrending>
10     <type>Email</type>
11     <unique>false</unique>
12 </CustomField>


4. Phone__c.field-meta.xml
   force-app/main/default/objects/Inquiry__c/fields/Phone__c.field-meta.xml


    1 <?xml version="1.0" encoding="UTF-8"?>
    2 <CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    3     <fullName>Phone__c</fullName>
    4     <description>고객 연락처</description>
    5     <externalId>false</externalId>
    6     <label>고객 연락처</label>
    7     <required>false</required>
    8     <trackHistory>false</trackHistory>
    9     <trackTrending>false</trackTrending>
10     <type>Phone</type>
11 </CustomField>


5. Category__c.field-meta.xml
   force-app/main/default/objects/Inquiry__c/fields/Category__c.field-meta.xml


    1 <?xml version="1.0" encoding="UTF-8"?>
    2 <CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    3     <fullName>Category__c</fullName>
    4     <description>문의 유형</description>
    5     <externalId>false</externalId>
    6     <label>문의 유형</label>
    7     <required>true</required>
    8     <trackHistory>false</trackHistory>
    9     <trackTrending>false</trackTrending>
10     <type>Picklist</type>
11     <valueSet>
12         <restricted>true</restricted>
13         <valueSetDefinition>
14             <sorted>false</sorted>
15             <value>
16                 <fullName>일반문의</fullName>
17                 <default>true</default>
18                 <label>일반문의</label>
19             </value>
20             <value>
21                 <fullName>불만</fullName>
22                 <default>false</default>
23                 <label>불만</label>
24             </value>
25             <value>
26                 <fullName>환불</fullName>
27                 <default>false</default>
28                 <label>환불</label>
29             </value>
30         </valueSetDefinition>
31     </valueSet>
32 </CustomField>


6. Content__c.field-meta.xml
   force-app/main/default/objects/Inquiry__c/fields/Content__c.field-meta.xml


    1 <?xml version="1.0" encoding="UTF-8"?>
    2 <CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    3     <fullName>Content__c</fullName>
    4     <description>문의 내용</description>
    5     <externalId>false</externalId>
    6     <label>문의 내용</label>
    7     <length>32768</length>
    8     <required>true</required>
    9     <trackHistory>false</trackHistory>
10     <trackTrending>false</trackTrending>
11     <type>LongTextArea</type>
12     <visibleLines>3</visibleLines>
13 </CustomField>


7. Status__c.field-meta.xml
   force-app/main/default/objects/Inquiry__c/fields/Status__c.field-meta.xml


    1 <?xml version="1.0" encoding="UTF-8"?>
    2 <CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    3     <fullName>Status__c</fullName>
    4     <description>접수 상태</description>
    5     <externalId>false</externalId>
    6     <label>상태</label>
    7     <required>true</required>
    8     <trackHistory>false</trackHistory>
    9     <trackTrending>false</trackTrending>
10     <type>Picklist</type>
11     <valueSet>
12         <restricted>true</restricted>
13         <valueSetDefinition>
14             <sorted>false</sorted>
15             <value>
16                 <fullName>접수</fullName>
17                 <default>true</default>
18                 <label>접수</label>
19             </value>
20             <value>
21                 <fullName>처리중</fullName>
22                 <default>false</default>
23                 <label>처리중</label>
24             </value>
25             <value>
26                 <fullName>완료</fullName>
27                 <default>false</default>
28                 <label>완료</label>
29             </value>
30         </valueSetDefinition>
31     </valueSet>
32 </CustomField>

8. RelatedCase__c.field-meta.xml
   force-app/main/default/objects/Inquiry__c/fields/RelatedCase__c.field-meta.xml


    1 <?xml version="1.0" encoding="UTF-8"?>
    2 <CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    3     <fullName>RelatedCase__c</fullName>
    4     <deleteConstraint>SetNull</deleteConstraint>
    5     <description>연결된 Case</description>
    6     <externalId>false</externalId>
    7     <label>연결된 Case</label>
    8     <referenceTo>Case</referenceTo>
    9     <relationshipLabel>고객 문의</relationshipLabel>
10     <relationshipName>Inquiries</relationshipName>
11     <required>false</required>
12     <trackHistory>false</trackHistory>
13     <trackTrending>false</trackTrending>
14     <type>Lookup</type>
15 </CustomField>

  ---

1 sf project deploy start -m CustomObject:Inquiry__c

  ---


⏭️ 다음 단계 안내
1. 위 명령어를 사용하여 Inquiry__c 오브젝트를 Salesforce 환경에 배포합니다.
2. US-02 구현을 위해 Inquiry__c 레코드 생성 시 자동으로 Case를 생성하는 Apex Trigger 작성이 필요합니다.
3. 관리자가 레코드를 확인할 수 있도록 Custom Tab 생성 및 Permission Set 설정이 권장됩니다.


추가적인 Trigger 구현이나 LWC 화면 개발이 필요하시면 말씀해 주세요!


ℹ Gemini CLI update available! 0.33.0 → 0.33.1
Installed via Homebrew. Please update with "brew upgrade gemini-cli".