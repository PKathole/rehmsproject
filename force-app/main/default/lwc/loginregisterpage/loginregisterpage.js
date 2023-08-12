import { LightningElement,track ,wire} from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import getPatientRegister from '@salesforce/apex/rePatientC.registerpatient';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Loginregisterpage extends LightningElement {
    @track isDoctorLogin = true ;
    @track isPatientLogin = true;
    @track isRegister = false ;

    /* ***** Doctor Login ***** */

    /* ***** Patient Login ***** */

    /* ***** Patient Register ***** */

    @track firstName = '';
    @track lastName = '';
    @track phone = '';
    @track email = '';
    @track bloodGroup = '';
    @track dob = '' ;

   

    isRegistered(){
        this.isRegister = !this.isRegister ;
        this.isDoctorLogin = !this.isDoctorLogin ;
        this.isPatientLogin = !this.isPatientLogin;
    }

    isPatientLogin(){
        this.isRegister = false ;
        this.isDoctorLogin = true ;
        this.isPatientLogin = true ;
    }

    get options() {
        return [
            { label: 'A+', value: 'A+' },
            { label: 'A-', value: 'A-' },
            { label: 'Ab+', value: 'Ab+' },
            { label: 'Ab-', value: 'Ab-' },
            { label: 'O+', value: 'O+' },
            { label: 'O-', value: 'O-' }
        ];
    }

    handleBloodGroupChange(event){
        this.bloodGroup = event.target.value ;
        console.log("blood Group :: "+this.bloodGroup);
    }

    handleRegisterSubmit(){
        
        this.firstName = this.template.querySelector(".fname").value ;
        this.lastName = this.template.querySelector(".lname").value ;
        this.phone = this.template.querySelector(".mobile").value ;
        this.dob = this.template.querySelector(".dob").value ;
        this.email = this.template.querySelector(".email").value ;
        console.log("Inside the handleRegisterSubmit");
        console.log("First Name  :: "+this.firstname+"  Last Name :: "+ this.lastname+ "   Mobile :: "+this.phone 
                    + " DOB  :: "+this.dob) ;

        getPatientRegister({ fname : this.firstName , lname : this.lastName , phone : this.phone ,email : this.email ,bloodGroup : this.bloodGroup  })
        .then(response=>{
            console.log("Inside success");
            console.log(response);
        })
        .catch(error=>{
            console.log("Inside error");
            console.log(error)
        })  


    }
}