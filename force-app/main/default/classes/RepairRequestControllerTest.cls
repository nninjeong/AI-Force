@isTest
private class RepairRequestControllerTest {
    
    @isTest
    static void testSaveAndSearch() {
        RepairRequestController controller = new RepairRequestController();
        
        // 1. 수리 접수 테스트
        controller.repairOrder.CustomerName__c = '테스트 고객';
        controller.repairOrder.ContactPhone__c = '010-1234-5678';
        controller.repairOrder.Description__c = '화면이 안 나옵니다.';
        
        // 파일 업로드 시뮬레이션
        controller.fileName = 'broken_screen.jpg';
        controller.fileBody = Blob.valueOf('Test Image Content');
        
        PageReference ref = controller.save();
        
        // 검증: 데이터 생성 확인
        List<RepairOrder__c> orders = [SELECT Id, Name, Status__c FROM RepairOrder__c];
        System.assertEquals(1, orders.size(), '수리 접수 레코드가 생성되어야 합니다.');
        System.assertEquals('Received', orders[0].Status__c, '초기 상태는 Received여야 합니다.');
        
        // 검증: 파일 생성 확인
        List<ContentVersion> cvs = [SELECT Id FROM ContentVersion WHERE FirstPublishLocationId = :orders[0].Id];
        System.assertEquals(1, cvs.size(), '파일이 첨부되어야 합니다.');
        
        // 2. 조회 기능 테스트
        controller.searchOrderNumber = orders[0].Name;
        controller.searchPhone = '010-1234-5678';
        
        controller.search();
        
        System.assertNotEquals(null, controller.searchResults, '검색 결과가 null이 아니어야 합니다.');
        System.assertEquals(1, controller.searchResults.size(), '검색 결과가 1건이어야 합니다.');
        System.assertEquals('테스트 고객', controller.searchResults[0].CustomerName__c);
    }
    
    @isTest
    static void testSaveError() {
        RepairRequestController controller = new RepairRequestController();
        // 필수 필드 누락 상태로 저장 시도
        controller.save();
        
        // 에러 메시지 확인 (ApexPages.Messages)
        List<ApexPages.Message> msgs = ApexPages.getMessages();
        System.assert(msgs.size() > 0, '에러 메시지가 발생해야 합니다.');
    }
}
