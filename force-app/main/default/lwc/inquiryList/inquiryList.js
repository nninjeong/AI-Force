import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getInquiryList from '@salesforce/apex/InquiryController.getInquiryList';

// 데이터 테이블 컬럼 정의
const COLUMNS = [
    { label: '문의 번호', fieldName: 'Name', type: 'text', initialWidth: 120 },
    { label: '고객명', fieldName: 'CustomerName__c', type: 'text', initialWidth: 120 },
    { label: '유형', fieldName: 'Category__c', type: 'text', initialWidth: 120 },
    { 
        label: '상태', 
        fieldName: 'Status__c', 
        type: 'text', 
        initialWidth: 100,
        cellAttributes: { 
            class: { fieldName: 'statusClass' } // 상태별 색상 적용을 위한 클래스 (선택 사항)
        }
    },
    { 
        label: '접수일시', 
        fieldName: 'CreatedDate', 
        type: 'date', 
        typeAttributes: {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        }
    }
];

export default class InquiryList extends LightningElement {
    @track inquiries = [];
    @track isLoading = true;
    @track columns = COLUMNS;
    
    wiredInquiryResult; // refreshApex를 위한 와이어 결과 저장

    // Apex 메서드 호출
    @wire(getInquiryList)
    wiredInquiries(result) {
        this.wiredInquiryResult = result;
        const { data, error } = result;

        if (data) {
            this.inquiries = data;
            this.isLoading = false;
        } else if (error) {
            this.showToast('에러', '데이터를 불러오는 중 오류가 발생했습니다.', 'error');
            this.isLoading = false;
            console.error('Error fetching inquiries:', error);
        }
    }

    // 데이터 존재 여부 확인
    get isDataEmpty() {
        return !this.isLoading && (!this.inquiries || this.inquiries.length === 0);
    }

    // 새로고침 버튼 핸들러
    async handleRefresh() {
        this.isLoading = true;
        try {
            await refreshApex(this.wiredInquiryResult);
            // this.showToast('성공', '목록이 갱신되었습니다.', 'success'); // 너무 잦은 토스트는 사용자 경험 저하 가능성 있음
        } catch (error) {
            this.showToast('에러', '새로고침 중 오류가 발생했습니다.', 'error');
        } finally {
            this.isLoading = false;
        }
    }

    // 공통 토스트 메시지
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