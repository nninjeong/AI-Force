public with sharing class TechnicianController {
    
    /**
     * 현재 로그인한 기술자에게 배정된 수리 목록 조회
     */
    @AuraEnabled(cacheable=true)
    public static List<RepairOrder__c> getAssignedJobs() {
        return [
            SELECT Id, Name, CustomerName__c, ContactPhone__c, Description__c, Status__c, CreatedDate
            FROM RepairOrder__c
            WHERE Technician__r.User__c = :UserInfo.getUserId()
            AND Status__c IN ('Assigned', 'In Repair')
            ORDER BY CreatedDate DESC
        ];
    }

    /**
     * 수리 진단 결과 저장 및 주문 상태 업데이트
     */
    @AuraEnabled
    public static void saveDiagnosis(Id orderId, String diagnosisResult, Decimal estimatedCost) {
        try {
            // 1. 진단 레코드 생성
            RepairDiagnosis__c diag = new RepairDiagnosis__c();
            diag.RepairOrder__c = orderId;
            diag.DiagnosisResult__c = diagnosisResult;
            diag.EstimatedCost__c = estimatedCost;
            insert diag;

            // 2. 수리 주문 상태 업데이트 (진단완료로 변경)
            RepairOrder__c ro = new RepairOrder__c(Id = orderId);
            ro.Status__c = 'Diagnosed';
            update ro;
            
        } catch (Exception e) {
            throw new AuraHandledException('진단 저장 중 오류가 발생했습니다: ' + e.getMessage());
        }
    }

    /**
     * 수리 완료 처리
     */
    @AuraEnabled
    public static void completeJob(Id orderId) {
        try {
            RepairOrder__c ro = new RepairOrder__c(Id = orderId);
            ro.Status__c = 'Completed';
            update ro;
        } catch (Exception e) {
            throw new AuraHandledException('완료 처리 중 오류가 발생했습니다: ' + e.getMessage());
        }
    }
}
