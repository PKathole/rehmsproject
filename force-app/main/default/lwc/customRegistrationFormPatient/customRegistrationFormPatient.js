import { LightningElement, track } from 'lwc';
import registerUser from '@salesforce/apex/MoekaLoginRegistrationController.registerUser';

export default class CustomRegistrationFormPatient extends LightningElement {
    
    @track fisrtname= '';
    @track lastname='';
    @track gender='';
    @track dob='';
    @track phone='';
    @track bloodgroup='';
    @track email='';
    @track username='';
    @track address='';
    

   

    onEmailInvalid(event){

        if (!event.target.validity.valid) {
            event.target.setCustomValidity('Enter a valid email address')
        }
        
    }

    onEmailInput(event){

        event.target.setCustomValidity('')
    }

    onEmailClick(event){

        let parent = event.target.parentElement.parentElement.parentElement;
        console.log('parent-', parent);
        parent.classList.remove('tooltipEmail');
    }

    onEmailBlur(event){

        let parent = event.target.parentElement.parentElement.parentElement;
        console.log('parent-', parent);
        parent.classList.add('tooltipEmail');
    }

    handleEmailChange(event) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const email = event.target.value.trim();
      
        if (emailRegex.test(email)) {
          const [username, domain] = email.split('@');
          this.email = email;
          this.username = `${username}@${domain}`;
        } else {
          this.email = '';
          this.username = '';
        }
    }
      
    
    handleRegistration(event){
        registerUser({ firstName:this.fisrtname,lastName:this.lastname,email:this.email})
        .then((result) => {
            if(result===this.email){
                this.checkEmail='/CheckPasswordResetEmail';
                console.log(result);
                console.log(this.checkEmail);
                window.location.href = this.checkEmail;
                } else{
                console.log('No Email Deteced');
                }
            })
            .catch((error) => {
                this.error = error;
                this.errorMessage = error.body.message;
                console.log(this.errorMessage);
                console.log('expection');
             });
                    
    }

    handleFirstNameChange(event){
        this.fisrtname=event.target.value;    
    }
    handleLastNameChange(event){
        this.lastname=event.target.value;
    }
    handleGenderChange(event){
        this.gender=event.target.value;
    }
    handledobChange(event){
        this.dob=event.target.value;
    }
    handleNumberChange(event){
        this.phone=event.target.value;
    }
    handlebloodgroupChange(event){
        this.bloodgroup=event.target.value;
    }
    handleaddresschange(event){
        this.address=event.target.value;
    }
}