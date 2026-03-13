public with sharing class InquiryTriggerHandler {
    /**
     * @description 고객 문의(Inquiry__c) 생성 시 자동으로 Case를 생성하는 메서드
     * @param newList 새로운 Inquiry__c 레코드 목록
     */
    public void onAfterInsert(List<Inquiry__c> newList) {
        createRelatedCases(newList);
    }

    /**
     * @description Inquiry 레코드를 기반으로 Case를 생성하고 연결합니다.
     * @param newList 새로운 Inquiry__c 레코드 목록
     */
    private void createRelatedCases(List<Inquiry__c> newList) {
        List<Case> casesToInsert = new List<Case>();
        
        for (Inquiry__c inq : newList) {
            Case newCase = new Case(
                Subject = inq.Name,
                Description = inq.Content__c,
                Origin = 'Web',
                Status = 'New',
                Type = mapCategoryToType(inq.Category__c)
            );
            casesToInsert.add(newCase);
        }

        if (!casesToInsert.isEmpty()) {
            try {
                insert casesToInsert;
                
                // 생성된 Case ID를 Inquiry 레코드에 업데이트 (Self-Update avoiding recursion)
                List<Inquiry__c> inquiriesToUpdate = new List<Inquiry__c>();
                for (Integer i = 0; i < casesToInsert.size(); i++) {
                    inquiriesToUpdate.add(new Inquiry__c(
                        Id = newList[i].Id,
                        RelatedCase__c = casesToInsert[i].Id
                    ));
                }
                
                if (!inquiriesToUpdate.isEmpty()) {
                    update inquiriesToUpdate;
                }
            } catch (Exception e) {
                System.debug('Error creating related cases: ' + e.getMessage());
                // 실제 운영 환경에서는 Custom Log 오브젝트나 이메일 알림 등으로 처리 권장
            }
        }
    }

    /**
     * @description Inquiry 카테고리를 Case Type으로 매핑합니다.
     * @param category Inquiry__c.Category__c 값
     * @return 매핑된 Case.Type 값
     */
    private String mapCategoryToType(String category) {
        if (category == '일반문의') return 'Question';
        if (category == '불만') return 'Problem';
        if (category == '환불') return 'Other';
        return 'Other';
    }
}