import { LightningElement, wire } from 'lwc';
import GETCONFIRMEDAPPOINTMENTS from '@salesforce/apex/BookAppointmentList.getAppointmentsInfo';
import GETCANCELAPPOINTMENTS from '@salesforce/apex/BookAppointmentList.cancelAppointment';
import GETTRANSFERAPPOINTMENT from '@salesforce/apex/BookAppointmentList.transferAppointment';
import Id from '@salesforce/user/Id';
import { getRecord,getFieldValue} from 'lightning/uiRecordApi';
import USER_EMAIL from '@salesforce/schema/User.Email';
import GETDOCTOR from '@salesforce/apex/Doctor.getDoctorId';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';



export default class ListOfAppointments extends NavigationMixin(LightningElement) {

userId=Id;
DoctorId;

@wire(getRecord,{recordId:'$userId',fields:USER_EMAIL})
useremail;

get mailId(){
    return getFieldValue(this.useremail.data,USER_EMAIL);
}

@wire(GETDOCTOR,{email:'$mailId'})
Doctor({data,error}){
if(data){
    this.DoctorId=data;
    }
    else if(error){
        console.log(error)
    }
}

columns=[
    {
        label:'Name of the patient', 
        fieldName:'patient_name__c'
    },
    {
        label:'Patient Age', 
        fieldName:'Patient_Age__c'
    },
    {
        label:'Mobile Number', 
        fieldName:'Patient_Number__c'
    },
    
    {
        label:'Time Slot',
        fieldName:'Booked_Slot__c'
    },
    {
        label:'Date', 
        fieldName:'Appointment_Date__c'
    },
    {
        label: 'Cancel',
        type: 'button',
        typeAttributes: {
            label: 'Cancel',
            name: 'CancelAppointment',
            value: 'Cancel',
            variant:'destructive'
        }
    },
    {
        label: 'Transfer',
        type: 'button',
        typeAttributes: {
            label: 'Transfer',
            name: 'TransferAppointment',
            value: 'Transfer',
            variant:'success'
        }
    }
]


records;


@wire( GETCONFIRMEDAPPOINTMENTS,{doctorId:'$DoctorId'})
reatedData({error,data}){
    if(data){
        this.records=data;
        console.log(this.records.length);
        if(this.records.length===0){
            this.records=false;
        }
            
    } else if(error){
        console.log(error);
    }
}

showCancelModel=false;
action;
row;
idValue;
showTransferModel = false ;


handleclick(event){

    console.log('inside handle');
    this.action = event.detail.action.value;
    this.row = event.detail.row;
    this.idValue = this.row.Id;
    console.log(this.idValue);
    console.log(this.action);
    if(this.action==='Cancel'){
        console.log('cancelled clicked');
        this.showCancelModel=true;
    }
    else if(this.action==='Transfer'){
        console.log('Inside Transfer Click');
        this.showTransferModel = true ;
    }
    
}


    handleCancelled(){

            GETCANCELAPPOINTMENTS({appointmentId:this.idValue})
            .then(() => {
                console.log('success');
                refreshApex(this.records);
                window.location.reload();
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                    attributes: {
                        url: 'upcomingappointments'
                    }
                },true);
                
            })
            .catch((error) => {
                console.log('error');
                console.log(error);
                
            })
            .finally(()=>{
                this.showCancelModel=false;
            })
            
    }

    handleCancel(){
        this.showCancelModel=false;

    }

    handleTransferCancelled(){

        GETTRANSFERAPPOINTMENT({appointmentId:this.idValue})
            .then(() => {
                console.log('Transfer success');
                refreshApex(this.records);
                window.location.reload();
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                    attributes: {
                        url: 'upcomingappointments'
                    }
                },true);
                
            })
            .catch((error) => {
                console.log('error');
                console.log(error);
                
            })
            .finally(()=>{
                this.showTransferModel=false;
            })
    }

    handleTransferCancel(){
        this.showTransferModel =false;
    }


    }