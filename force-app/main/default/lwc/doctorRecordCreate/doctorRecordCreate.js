import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import DOCTOR_OBJECT from '@salesforce/schema/Doctor__c';
import NAME_FIELD from '@salesforce/schema/Doctor__c.Name';
import LAST_NAME_FIELD from '@salesforce/schema/Doctor__c.Last_Name__c';
import EMAIL_FIELD from '@salesforce/schema/Doctor__c.Email__c';
import MOBILE_FIELD from '@salesforce/schema/Doctor__c.Mobile_Number__c';
import SPECIALITY_FIELD from '@salesforce/schema/Doctor__c.Specialization__c';
import ADDRESS_FIELD from '@salesforce/schema/Doctor__c.Address__c';
import ACHIEVEMENT_FIELD from '@salesforce/schema/Doctor__c.Achievements__c';
import EXPERIENCE_FIELD from '@salesforce/schema/Doctor__c.Experience__c';
import CONSULTANT_FEE_FIELD from '@salesforce/schema/Doctor__c.Consultant_Fee__c';
import QUALIFICATION_FIELD from '@salesforce/schema/Doctor__c.Qualification__c';

export default class DoctorRecordCreate extends LightningElement {
    
    objectApiName = DOCTOR_OBJECT;
    fields = [NAME_FIELD,LAST_NAME_FIELD,MOBILE_FIELD,EMAIL_FIELD,SPECIALITY_FIELD,QUALIFICATION_FIELD,EXPERIENCE_FIELD,ACHIEVEMENT_FIELD,CONSULTANT_FEE_FIELD,ADDRESS_FIELD] ;

    handleSuccess(event){
        console.log("event.detail.id :: "+event.detail.id) 
        const toastEvent = new ShowToastEvent({
            title: 'Doctor Created Successfully',
            message: 'Doctor Created Successfully : ',
            varient : "success"
        });
        this.dispatchEvent(toastEvent);
        setTimeout(() => {
            location.reload();
        }, 3000);
    }
}