/**
 * @description 고객 문의(Inquiry__c) 처리를 위한 Apex Controller
 * @author Gemini CLI
 * @version 1.0
 */
public with sharing class InquiryController {
    
    /**
     * @description 신규 문의 레코드를 생성합니다.
     * US-04: Inquiry__c 레코드 생성 (트리거를 통해 Case와 연결됨)
     * US-05: 이메일 형식 및 필수값 유효성 검사 및 한국어 에러 반환
     * @param inq 저장할 Inquiry__c 데이터
     * @return 생성된 Inquiry__c 레코드의 ID
     */
    @AuraEnabled
    public static String createInquiry(Inquiry__c inq) {
        try {
            // 1. 필수값 유효성 검사 (서버 사이드 검증)
            validateInquiry(inq);
            
            // 2. 레코드 삽입 (Bulkify 패턴 적용 가능하도록 리스트 처리)
            List<Inquiry__c> inquiriesToInsert = new List<Inquiry__c>{ inq };
            insert inquiriesToInsert;
            
            return inquiriesToInsert[0].Id;
            
        } catch (DmlException e) {
            // DML 에러 발생 시 한국어 메시지로 변환하여 반환
            throw new AuraHandledException('데이터 저장 중 오류가 발생했습니다: ' + e.getDmlMessage(0));
        } catch (Exception e) {
            // 기타 예외 발생 시 한국어 메시지 반환
            // AuraHandledException은 getMessage()를 통해 전달된 메시지를 클라이언트에 노출함
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description 문의 데이터의 유효성을 검사합니다. (US-05)
     * @param inq 검사할 Inquiry__c 데이터
     */
    private static void validateInquiry(Inquiry__c inq) {
        if (inq == null) {
            throw new AuraHandledException('입력 데이터가 없습니다.');
        }

        // 필수값 체크
        if (String.isBlank(inq.CustomerName__c)) {
            throw new AuraHandledException('고객명은 필수 입력 항목입니다.');
        }
        if (String.isBlank(inq.Email__c)) {
            throw new AuraHandledException('이메일은 필수 입력 항목입니다.');
        }
        if (String.isBlank(inq.Category__c)) {
            throw new AuraHandledException('문의 유형은 필수 선택 항목입니다.');
        }
        if (String.isBlank(inq.Content__c)) {
            throw new AuraHandledException('문의 내용은 필수 입력 항목입니다.');
        }

        // 이메일 형식 체크 (정규식 활용)
        String emailRegex = '^[a-zA-Z0-9._|\\\\%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern emailPattern = Pattern.compile(emailRegex);
        Matcher emailMatcher = emailPattern.matcher(inq.Email__c);
        
        if (!emailMatcher.matches()) {
            throw new AuraHandledException('올바른 이메일 형식이 아닙니다. (예: example@mail.com)');
        }
    }

    /**
     * @description 문의 목록을 조회합니다. (Sprint 3)
     * @return 최근 생성된 순서로 정렬된 Inquiry__c 목록
     */
    @AuraEnabled(cacheable=true)
    public static List<Inquiry__c> getInquiryList() {
        try {
            return [
                SELECT Id, Name, CustomerName__c, Category__c, Status__c, CreatedDate 
                FROM Inquiry__c 
                ORDER BY CreatedDate DESC 
                LIMIT 100
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}