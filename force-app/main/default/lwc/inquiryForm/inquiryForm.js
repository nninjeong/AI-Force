import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import INQUIRY_OBJECT from '@salesforce/schema/Inquiry__c';
import CATEGORY_FIELD from '@salesforce/schema/Inquiry__c.Category__c';
import createInquiry from '@salesforce/apex/InquiryController.createInquiry';

export default class InquiryForm extends LightningElement {
    @track isLoading = false;
    @track categoryOptions = [];
    
    // 초기화된 데이터 구조
    @track inquiryData = {
        CustomerName__c: '',
        Email__c: '',
        Phone__c: '',
        Category__c: '',
        Content__c: ''
    };

    // 1. Inquiry__c 오브젝트 정보 가져오기 (기본 레코드 타입 ID 획득용)
    @wire(getObjectInfo, { objectApiName: INQUIRY_OBJECT })
    inquiryObjectInfo;

    // 2. Category__c 픽리스트 값 동적 로드
    @wire(getPicklistValues, { 
        recordTypeId: '$inquiryObjectInfo.data.defaultRecordTypeId', 
        fieldApiName: CATEGORY_FIELD 
    })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.categoryOptions = data.values;
        } else if (error) {
            console.error('Error loading picklist values:', error);
        }
    }

    // 입력값 변경 핸들러
    handleInputChange(event) {
        const field = event.target.name;
        this.inquiryData[field] = event.target.value;
    }

    // 폼 제출 핸들러
    async handleSubmit() {
        this.isLoading = true;

        try {
            // Apex 호출
            const resultId = await createInquiry({ inq: this.inquiryData });
            
            // 성공 알림 (US-06)
            this.showToast('성공', '문의가 정상적으로 접수되었습니다. (ID: ' + resultId + ')', 'success');
            
            // 폼 초기화
            this.resetForm();
            
        } catch (error) {
            // 에러 알림 (US-05)
            let message = '알 수 없는 에러가 발생했습니다.';
            if (error.body && error.body.message) {
                message = error.body.message;
            }
            this.showToast('오류', message, 'error');
        } finally {
            this.isLoading = false;
        }
    }

    // 폼 데이터 초기화
    resetForm() {
        this.inquiryData = {
            CustomerName__c: '',
            Email__c: '',
            Phone__c: '',
            Category__c: '',
            Content__c: ''
        };
    }

    // 공통 토스트 메시지 함수
    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}