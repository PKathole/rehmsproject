import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import PATIENT_OBJECT from '@salesforce/schema/Patient__c';
import FIRST_NAME_FIELD from '@salesforce/schema/Patient__c.First_Name__c';
import LAST_NAME_FIELD from '@salesforce/schema/Patient__c.Last_Name__c';
import EMAIL_FIELD from '@salesforce/schema/Patient__c.Email__c';
import PHONE_FIELD from '@salesforce/schema/Patient__c.Phone_Number__c';

export default class PatientRecordDetail extends LightningElement {
    @api recordId;
    conId;
    isEditing = false;

    objectApiName = PATIENT_OBJECT;
    fields = [FIRST_NAME_FIELD, LAST_NAME_FIELD, EMAIL_FIELD, PHONE_FIELD];

    @wire(getRecord, { recordId: '$recordId', fields: '$fields' })
    patientRecord;

    get firstName() {
        return getFieldValue(this.patientRecord.data, FIRST_NAME_FIELD);
    }

    get lastName() {
        return getFieldValue(this.patientRecord.data, LAST_NAME_FIELD);
    }

    get email() {
        return getFieldValue(this.patientRecord.data, EMAIL_FIELD);
    }

    get phone() {
        return getFieldValue(this.patientRecord.data, PHONE_FIELD);
    }

    handleEditClick() {
        this.isEditing = true;
    }

    handleCancelClick() {
        this.isEditing = false;
    }

    handleSubmitSuccess(event) {
        this.isEditing = false;
        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);
    }

    handleSaveClick() {
        const fields = {};
        fields['Id'] = this.conId;
        fields['First_Name__c'] = this.template.querySelector("[data-field='First_Name__c']").value;
        fields['Last_Name__c'] = this.template.querySelector("[data-field='Last_Name__c']").value;
        fields['Email__c'] = this.template.querySelector("[data-field='Email__c']").value;
        fields['Phone_Number__c'] = this.template.querySelector("[data-field='Phone_Number__c']").value;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.isEditing = false;
            })
            .catch(error => {
                console.log(error);
            });
    }

    connectedCallback() {
        this.conId = this.recordId;
    }

    handleRecordUpdated(event) {
        const { id } = event.detail;
        this.conId = id;
    }
}