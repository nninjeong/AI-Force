public with sharing class ManagerController {
    
    /**
     * 미배정된 수리 주문 목록 조회 (Status = 'Received')
     */
    @AuraEnabled(cacheable=true)
    public static List<RepairOrder__c> getPendingOrders() {
        return [
            SELECT Id, Name, CustomerName__c, Description__c, CreatedDate
            FROM RepairOrder__c
            WHERE Status__c = 'Received'
            ORDER BY CreatedDate ASC
        ];
    }

    /**
     * 활동 중인 기술자 목록 조회
     */
    @AuraEnabled(cacheable=true)
    public static List<Technician__c> getAvailableTechnicians() {
        return [
            SELECT Id, Name, Specialty__c, Region__c
            FROM Technician__c
            WHERE Status__c = 'Active'
        ];
    }

    /**
     * 기술자 배정 처리
     */
    @AuraEnabled
    public static void assignTechnician(Id orderId, Id techId) {
        try {
            RepairOrder__c ro = new RepairOrder__c(Id = orderId);
            ro.Technician__c = techId;
            ro.Status__c = 'Assigned';
            update ro;
        } catch (Exception e) {
            throw new AuraHandledException('배정 처리 중 오류가 발생했습니다: ' + e.getMessage());
        }
    }

    /**
     * 상태별 수리 통계 조회 (대시보드용)
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getRepairStats() {
        Map<String, Integer> stats = new Map<String, Integer>();
        for (AggregateResult ar : [SELECT Status__c, COUNT(Id) cnt FROM RepairOrder__c GROUP BY Status__c]) {
            stats.put((String)ar.get('Status__c'), (Integer)ar.get('cnt'));
        }
        return stats;
    }
}
