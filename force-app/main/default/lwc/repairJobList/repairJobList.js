import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAssignedJobs from '@salesforce/apex/TechnicianController.getAssignedJobs';
import saveDiagnosis from '@salesforce/apex/TechnicianController.saveDiagnosis';
import completeJob from '@salesforce/apex/TechnicianController.completeJob';

export default class RepairJobList extends LightningElement {
    @track isModalOpen = false;
    @track isLoading = false;
    @track selectedOrderId;
    @track diagnosisResult = '';
    @track estimatedCost = 0;

    @wire(getAssignedJobs)
    jobs;

    handleDiagnose(event) {
        this.selectedOrderId = event.target.dataset.id;
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.diagnosisResult = '';
        this.estimatedCost = 0;
    }

    handleResultChange(event) {
        this.diagnosisResult = event.target.value;
    }

    handleCostChange(event) {
        this.estimatedCost = event.target.value;
    }

    async saveDiagnosis() {
        if (!this.diagnosisResult || !this.estimatedCost) {
            this.showToast('경고', '모든 필드를 입력해주세요.', 'warning');
            return;
        }

        this.isLoading = true;
        try {
            await saveDiagnosis({ 
                orderId: this.selectedOrderId, 
                diagnosisResult: this.diagnosisResult, 
                estimatedCost: this.estimatedCost 
            });
            this.showToast('성공', '진단 결과가 저장되었습니다.', 'success');
            this.closeModal();
            await refreshApex(this.jobs);
        } catch (error) {
            this.showToast('오류', error.body.message, 'error');
        } finally {
            this.isLoading = false;
        }
    }

    async handleComplete(event) {
        const orderId = event.target.dataset.id;
        this.isLoading = true;
        try {
            await completeJob({ orderId: orderId });
            this.showToast('성공', '수리가 완료 처리되었습니다.', 'success');
            await refreshApex(this.jobs);
        } catch (error) {
            this.showToast('오류', error.body.message, 'error');
        } finally {
            this.isLoading = false;
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
