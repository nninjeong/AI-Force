@isTest
private class InquiryTriggerHandlerTest {
    /**
     * @description Inquiry 생성 시 Case가 정상적으로 생성되고 연결되는지 테스트
     */
    @isTest
    static void testCaseCreation() {
        // Given
        List<Inquiry__c> inquiries = new List<Inquiry__c>();
        inquiries.add(new Inquiry__c(
            Name = '환불 요청합니다',
            CustomerName__c = '테스트 사용자',
            Email__c = 'test@example.com',
            Category__c = '환불',
            Content__c = '제품이 파손되어 환불을 요청합니다.',
            Status__c = '접수'
        ));
        inquiries.add(new Inquiry__c(
            Name = '일반 문의입니다',
            CustomerName__c = '김철수',
            Email__c = 'chulsoo@example.com',
            Category__c = '일반문의',
            Content__c = '영업 시간이 어떻게 되나요?',
            Status__c = '접수'
        ));

        // When
        Test.startTest();
        insert inquiries;
        Test.stopTest();

        // Then
        List<Case> cases = [SELECT Id, Subject, Description, Type FROM Case];
        System.assertEquals(2, cases.size(), 'Case가 2건 생성되어야 합니다.');

        List<Inquiry__c> updatedInquiries = [SELECT Id, RelatedCase__c FROM Inquiry__c];
        for (Inquiry__c inq : updatedInquiries) {
            System.assertNotEquals(null, inq.RelatedCase__c, 'Inquiry에 Case가 연결되어야 합니다.');
        }

        // 특정 매핑 확인
        Inquiry__c refundInq = [SELECT Name, RelatedCase__r.Subject, RelatedCase__r.Type FROM Inquiry__c WHERE Category__c = '환불' LIMIT 1];
        System.assertEquals('환불 요청합니다', refundInq.RelatedCase__r.Subject);
        System.assertEquals('Other', refundInq.RelatedCase__r.Type, '환불 카테고리는 Other로 매핑되어야 합니다.');
    }
}