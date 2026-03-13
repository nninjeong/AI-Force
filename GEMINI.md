# Salesforce Project Instructions

## 환경
- Salesforce DX 프로젝트 구조 준수

## 목적
이 문서의 목적은 다음과 같다.
- AI가 코드를 생성할 때 아키텍처 규칙을 위반하지 않도록 강제
- 유지보수성과 확장성을 고려한 일관된 코드 구조 유지
이 문서에 정의된 규칙은 항상 준수되어야 한다.


## Naming Conventions
- 기능 목적을 나타내는 명사 + 클래스 특징을 나타내는 접미사 사용하여 명명
- 예시: AccountListComponent, ContactController
- Trigger 는 object명 + Trigger/ TriggerHandler 형식으로 명명 (예: AccountTrigger)
- 변수명은 줄임말 대신 전체 단어 사용하여 직관적
- 커스텀 필드 및 오브젝트는 포물라는 fm_, 롤업 ru_, 체크박스 Is 로 시작하여 명명

## 🏗️ 기술 스택
- Platform : Salesforce (API Version 59.0)
- Backend  : Apex (with sharing 필수)
- Frontend : LWC (Lightning Web Components)
- IDE      : IntelliJ IDEA
- AI 도구  : Gemini (설계 + 구현 전담)
- 배포 도구: Salesforce CLI (sf 명령어)

## 📁 프로젝트 폴더 구조force-app/main/default/
├── objects/       ← Custom Object & 필드 XML
├── classes/       ← Apex 클래스 & 테스트 클래스
├── lwc/           ← LWC 컴포넌트
├── email/         ← 이메일 템플릿
└── permissionsets/← 권한 설정


## ✅ 코딩 공통 규칙 (모든 코드에 항상 적용)

### Apex
- `with sharing` 항상 선언
- DML은 반드시 try-catch로 감싸기
- `AuraHandledException`으로 에러 반환
- SOQL은 for 루프 안에 절대 작성 금지
- 한 번에 여러 건 처리되도록 bulkify 패턴 적용
- 모든 메서드에 주석 작성

### LWC
- 데이터 조회는 `@wire` 서비스 우선 사용
- 에러/성공 메시지는 `ShowToastEvent` 사용
- 로딩 중에는 반드시 `lightning-spinner` 표시
- 모든 사용자 메시지는 한국어로 작성
- 파일은 html / js / css / js-meta.xml 분리

### 공통
- 변수명: camelCase
- 상수명: UPPER_SNAKE_CASE
- 주석: 한국어로 작성
- 하드코딩 문자열 금지 → Custom Label 사용

---

## 🚨 응답 형식 규칙 (항상 아래 형식으로 답변)

1. **파일 목록 먼저 제시** → 어떤 파일을 만들지 목록 표시
2. **파일별로 코드 제공** → 파일명 + 저장 경로 + 전체 코드
3. **배포 명령어 제시** → 복붙 가능한 sf CLI 명령어
4. **다음 단계 안내** → 지금 작업 후 무엇을 해야 하는지

---

## 📋 프로젝트 관리 방식
- Agile 스프린트 단위로 개발
- 매 작업은 User Story 기반으로 수행
- User Story 형식: "~로서, ~할 수 있다 (Because ~)"