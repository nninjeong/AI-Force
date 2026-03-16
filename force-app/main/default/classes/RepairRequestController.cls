public with sharing class RepairRequestController {
    // 수리 요청 정보
    public RepairOrder__c repairOrder { get; set; }
    
    // 파일 업로드 관련
    public transient Blob fileBody { get; set; }
    public String fileName { get; set; }
    
    // 조회 기능 관련
    public String searchPhone { get; set; }
    public String searchOrderNumber { get; set; }
    public List<RepairOrder__c> searchResults { get; set; }

    public RepairRequestController() {
        repairOrder = new RepairOrder__c();
        searchResults = new List<RepairOrder__c>();
    }

    // 수리 접수 저장
    public PageReference save() {
        try {
            // 기본 상태 설정
            repairOrder.Status__c = 'Received';
            insert repairOrder;
            
            // 파일 업로드 처리 (ContentVersion 사용)
            if (fileBody != null && String.isNotBlank(fileName)) {
                ContentVersion cv = new ContentVersion();
                cv.Title = fileName;
                cv.PathOnClient = fileName;
                cv.VersionData = fileBody;
                cv.FirstPublishLocationId = repairOrder.Id; // 레코드와 연결
                insert cv;
                
                // AI 분석 호출 (제안된 기능 - 추후 구현)
                analyzeImage(cv.Id);
            }
            
            // 접수 번호 조회 및 성공 메시지
            RepairOrder__c insertedOrder = [SELECT Name FROM RepairOrder__c WHERE Id = :repairOrder.Id];
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, '수리 접수가 완료되었습니다. 접수번호: ' + insertedOrder.Name));
            
            // 폼 초기화
            repairOrder = new RepairOrder__c();
            fileBody = null;
            fileName = null;
            
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '오류가 발생했습니다: ' + e.getMessage()));
        }
        return null;
    }

    // 접수 현황 조회
    public void search() {
        if (String.isBlank(searchOrderNumber) || String.isBlank(searchPhone)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, '접수번호와 전화번호를 모두 입력해주세요.'));
            return;
        }

        searchResults = [SELECT Name, Status__c, CustomerName__c, Description__c, IsApproved__c
                         FROM RepairOrder__c 
                         WHERE Name = :searchOrderNumber 
                         AND ContactPhone__c = :searchPhone
                         ORDER BY CreatedDate DESC];
                         
        if (searchResults.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '일치하는 접수 내역이 없습니다.'));
        }
    }
    
    // AI 이미지 분석 (Placeholder)
    private void analyzeImage(Id contentVersionId) {
        // TODO: Call Einstein Vision or External AI API
        // System.debug('AI Analysis Triggered for Image: ' + contentVersionId);
    }
}
