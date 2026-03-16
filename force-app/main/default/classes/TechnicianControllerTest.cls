@isTest
private class TechnicianControllerTest {
    
    @testSetup
    static void setup() {
        // 기술자 데이터 생성
        Technician__c tech = new Technician__c(
            Name = 'Test Tech',
            User__c = UserInfo.getUserId(),
            Status__c = 'Active'
        );
        insert tech;

        // 수리 주문 데이터 생성
        RepairOrder__c ro = new RepairOrder__c(
            CustomerName__c = 'Test Customer',
            ContactPhone__c = '010-0000-0000',
            Status__c = 'Assigned',
            Technician__c = tech.Id
        );
        insert ro;
    }

    @isTest
    static void testGetAssignedJobs() {
        Test.startTest();
        List<RepairOrder__c> jobs = TechnicianController.getAssignedJobs();
        Test.stopTest();

        System.assertEquals(1, jobs.size(), '배정된 작업이 1건 조회되어야 합니다.');
    }

    @isTest
    static void testSaveDiagnosis() {
        RepairOrder__c ro = [SELECT Id FROM RepairOrder__c LIMIT 1];
        
        Test.startTest();
        TechnicianController.saveDiagnosis(ro.Id, '액정 파손 확인', 150000);
        Test.stopTest();

        RepairOrder__c updatedRo = [SELECT Status__c FROM RepairOrder__c WHERE Id = :ro.Id];
        List<RepairDiagnosis__c> diags = [SELECT Id FROM RepairDiagnosis__c WHERE RepairOrder__c = :ro.Id];
        
        System.assertEquals('Diagnosed', updatedRo.Status__c, '상태가 Diagnosed로 업데이트되어야 합니다.');
        System.assertEquals(1, diags.size(), '진단 레코드가 생성되어야 합니다.');
    }

    @isTest
    static void testCompleteJob() {
        RepairOrder__c ro = [SELECT Id FROM RepairOrder__c LIMIT 1];
        
        Test.startTest();
        TechnicianController.completeJob(ro.Id);
        Test.stopTest();

        RepairOrder__c updatedRo = [SELECT Status__c FROM RepairOrder__c WHERE Id = :ro.Id];
        System.assertEquals('Completed', updatedRo.Status__c, '상태가 Completed로 업데이트되어야 합니다.');
    }
}
