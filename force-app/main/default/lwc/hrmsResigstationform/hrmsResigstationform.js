import { LightningElement,track } from 'lwc';
import registerUser from '@salesforce/apex/MoekaLoginRegistrationController.registerUser';
//import emailExitsCheck from '@salesforce/apex/emailExitsCheck.emailExits';
import { NavigationMixin } from 'lightning/navigation';
import icon from '@salesforce/resourceUrl/addPatient';



export default class HrmsResigstationform extends NavigationMixin(LightningElement) {
    addPatientimg=icon;
    selectedBloodgroupValue= '--None--' ;
    selectedGenderValue= '--None--';
    firstNameValue;
    lastNameValue;
    emailValue;
    dateValue;
    phoneValue;
    addressValue ;
    error='';
    errorMessage='';
    today = new Date().toISOString().split("T")[0];
    

   

    @track genderOptions = [
        { label: '--None--', value: '--None--' },
        { label: 'Male', value: 'Male' },
        { label: 'Female', value: 'Female' },
        { label: 'Others', value: 'Others' },
    ];
    @track bloodgroupOptions=[
        { label:'--None--', value:'--None--'},
        { label:'A+',value:'A+'},
        { label:'A-',value:'A-'},
        { label:'B+',value:'B+'},
        { label:'B-',value:'B-'},
        { label:'AB+',value:'AB+'},
        { label:'AB-',value:'AB-'},
        { label:'O+',value:'O+'},
        { label:'O-+',value:'O-'},
    ];
    // Validate date (allow user to access dates upto today)
    
    
    handleFirstNameChange(event) {
        this.firstNameValue = event.target.value;
    }
    handleLastNameChange(event) {
        this.lastNameValue = event.target.value;
    }
    handleGenderChange(event) {
        this.selectedGenderValue = event.target.value;
    }
    handleEmailChange(event) {
        this.emailValue = event.target.value;
    }
    handleDateChange(event) {
        this.dateValue = event.target.value;
    }
    handlePhoneChange(event) {
        this.phoneValue = event.target.value;
    }
    handleBloodgroupChange(event) {
        this.selectedBloodgroupValue = event.target.value;
    }
    handleAddressChange(event) {
        this.addressValue = event.target.value;
    }
    handleRegistration(){
        this.errorMessage = '';
        

        // Validate first name
        if (!this.firstNameValue){
            this.errorMessage = 'Please enter a valid first name.';
            return;
        } else if (!/^[a-zA-Z]+$/.test(this.firstNameValue)) {
            this.errorMessage = 'Please enter only alphabets for the first name.';
            return;
        } else if (this.firstNameValue.length > 25) {
            this.errorMessage = 'Please enter a first name less than or equal to 25 characters.';
            return;
        }

        // Validate last name
        if (!this.lastNameValue) {
            this.errorMessage = 'Please enter a valid last name.';
            return;
        } else if (!/^[a-zA-Z]+$/.test(this.lastNameValue)) {
            this.errorMessage = 'Please enter only alphabets for the last name.';
            return;
        } else if (this.lastNameValue.length > 18) {
            this.errorMessage = 'Please enter a last name less than or equal to 18 characters.';
            return;
        }

        // Validate gender
        if (this.selectedGenderValue=== '--None--') {
            this.errorMessage = 'Please select a gender.';
            return;
        }

        // Validate email
        const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!this.emailValue) {
            this.errorMessage = 'Please enter your email address.';
            return;
        } else if (!emailPattern.test(this.emailValue)) {
            this.errorMessage = 'Please enter a valid email address.';
            return;
        }

        // Validate date for empty
        if (!this.dateValue) {
            this.errorMessage = 'Please enter a valid date.';
            return;
        }

        // Validate phone number
        if (!this.phoneValue){
            this.errorMessage = 'Please enter a 10-digit phone number.';
            return;
        } else if(this.phoneValue.length!=10){
            this.errorMessage = 'Please enter a valid 10-digit phone number.';
            return;
        }  else if(!/^\d+$/.test(this.phoneValue)){
            this.errorMessage = 'Please enter a valid phone number.';
            return;
        }

        // Validate blood group
        if (!this.selectedBloodgroupValue=== '--None--') {
            this.errorMessage = 'Please select a blood group.';
            return;
        }
        
        // Validate address
        if (!this.addressValue) {
            this.errorMessage = 'Please enter your address.';
            return;
        } else if(this.addressValue.length>70){
            this.errorMessage = 'your address is to long';
            return;
        }


        // Call Apex method to register user
                registerUser({ 
                    firstName: this.firstNameValue, 
                    lastName: this.lastNameValue, 
                    email: this.emailValue,
                    gender: this.selectedGenderValue,
                    dateofBirth: this.dateValue,
                    phone: this.phoneValue,
                    bloodGroup: this.selectedBloodgroupValue,
                    address: this.addressValue
                })
                .then((result) => {
                    if (result === this.emailValue) {
                        
                       
                        this[NavigationMixin.Navigate]({
                            type: 'standard__webPage',
                            attributes: {
                                url: 'CheckPasswordResetEmail'
                            }
                        },true);
        
                     } else {
                        console.log('No Email Detected');
                    }
                })

        
        
        .catch((error) => {
            console.log(error); // Log the complete error object for debugging
            this.error=error;
            if (error.body.message === 'Script-thrown exception') {
                this.errorMessage = 'Email already exists. Please use a different email.';
            } else {
                this.errorMessage = error.body.message;
            }
            console.log(this.errorMessage);
        });
    }

}