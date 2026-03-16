import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPendingOrders from '@salesforce/apex/ManagerController.getPendingOrders';
import getAvailableTechnicians from '@salesforce/apex/ManagerController.getAvailableTechnicians';
import assignTechnician from '@salesforce/apex/ManagerController.assignTechnician';

export default class RepairAssignment extends LightningElement {
    @track isLoading = false;
    @track selectedTechs = {}; // orderId: techId mapping

    @wire(getPendingOrders)
    pendingOrders;

    @wire(getAvailableTechnicians)
    availableTechs;

    get techOptions() {
        if (this.availableTechs.data) {
            return this.availableTechs.data.map(tech => ({
                label: tech.Name + ' (' + (tech.Specialty__c || '일반') + ')',
                value: tech.Id
            }));
        }
        return [];
    }

    handleTechChange(event) {
        const orderId = event.target.dataset.orderid;
        this.selectedTechs[orderId] = event.detail.value;
    }

    async handleAssign(event) {
        const orderId = event.target.dataset.orderid;
        const techId = this.selectedTechs[orderId];

        if (!techId) {
            this.showToast('경고', '기술자를 선택해주세요.', 'warning');
            return;
        }

        this.isLoading = true;
        try {
            await assignTechnician({ orderId: orderId, techId: techId });
            this.showToast('성공', '기술자가 배정되었습니다.', 'success');
            await refreshApex(this.pendingOrders);
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
