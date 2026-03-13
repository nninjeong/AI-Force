import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getInquiryList from '@salesforce/apex/InquiryController.getInquiryList';
import updateInquiries from '@salesforce/apex/InquiryController.updateInquiries';

// Row Actions 정의
const ACTIONS = [
    { label: '상세 보기', name: 'view_details' }
];

// 데이터 테이블 컬럼 정의
const COLUMNS = [
    { label: '문의 번호', fieldName: 'Name', type: 'text', initialWidth: 120 },
    { label: '고객명', fieldName: 'CustomerName__c', type: 'text', initialWidth: 120 },
    { label: '유형', fieldName: 'Category__c', type: 'text', initialWidth: 120 },
    { 
        label: '상태', 
        fieldName: 'Status__c', 
        type: 'text', 
        editable: true, // 인라인 편집 활성화
        initialWidth: 120,
        cellAttributes: { 
            class: { fieldName: 'statusClass' }
        }
    },
    { 
        label: '접수일시', 
        fieldName: 'CreatedDate', 
        type: 'date', 
        initialWidth: 180,
        typeAttributes: {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        }
    },
    {
        type: 'action',
        typeAttributes: { rowActions: ACTIONS }
    }
];

export default class InquiryList extends NavigationMixin(LightningElement) {
    @track inquiries = [];
    @track draftValues = []; // 초안 값 저장
    @track isLoading = true;
    @track columns = COLUMNS;
    
    wiredInquiryResult;

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
        }
    }

    get isDataEmpty() {
        return !this.isLoading && (!this.inquiries || this.inquiries.length === 0);
    }

    async handleRefresh() {
        this.isLoading = true;
        try {
            await refreshApex(this.wiredInquiryResult);
        } catch (error) {
            this.showToast('에러', '새로고침 중 오류가 발생했습니다.', 'error');
        } finally {
            this.isLoading = false;
        }
    }

    // 인라인 편집 저장 핸들러
    async handleSave(event) {
        const updatedFields = event.detail.draftValues;
        
        try {
            this.isLoading = true;
            await updateInquiries({ data: updatedFields });
            
            this.showToast('성공', '상태가 수정되었습니다.', 'success');
            
            // 초안 초기화 및 데이터 갱신
            this.draftValues = [];
            await refreshApex(this.wiredInquiryResult);
            
        } catch (error) {
            let message = '저장 중 오류가 발생했습니다.';
            if (error.body && error.body.message) {
                message = error.body.message;
            }
            this.showToast('오류', message, 'error');
        } finally {
            this.isLoading = false;
        }
    }

    // Row Action 핸들러
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        
        if (actionName === 'view_details') {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: row.Id,
                    objectApiName: 'Inquiry__c',
                    actionName: 'view'
                }
            });
        }
    }

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