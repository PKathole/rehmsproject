import { LightningElement , api} from 'lwc';

const CARD_VISIBLE_CLASSES='slds-show'
const CARD_HIDDEN_CLASSES='slds-hide'
const DOT_VISIBLE_CLASSES='dot active'
const DOT_HIDDEN_CLASSES='dot'
const DEFULT_SLIDER_TIMER= 3000 
export default class CustomCarousel extends LightningElement {
    slides=[]
    slideindex=1
    @api slidetimer=DEFULT_SLIDER_TIMER
    timer
    @api 
    get slidesData(){
        return this.slides
    }

    set slidesData(data){
        this.slides=data.map((item,index)=>{
            return index === 0 ?{
                ...item,
                slideindex: index+1,
                cardclasses:CARD_VISIBLE_CLASSES,
                dotclasses:DOT_VISIBLE_CLASSES
            }:{
                ...item,
                slideindex: index+1,
                cardclasses:CARD_HIDDEN_CLASSES,
                dotclasses:DOT_HIDDEN_CLASSES
            }
        })
    }
    connectedCallback(){
        this.timer=window.setInterval(() => {
            this.slideSelectionHandler(this.slideindex+1)
        }, Number(this.slidetimer));
    }
    /*disconnectedCallback(){
        window.clearInterval(this.timer)
    }*/
    currentSlide(event){
        let slideindex=Number(event.target.dataset.id)
        this.slideSelectionHandler(slideindex)
    }
    backsilde(){
        let slideindex=this.slideindex-1
        this.slideSelectionHandler(slideindex)
    }
    nextsilde(){
        let slideindex=this.slideindex+1
        this.slideSelectionHandler(slideindex)
    }
    slideSelectionHandler(id){
        if(id > this.slides.length){
            this.slideindex=1
        }else if(id < 1){
             this.slideindex
        }else{
            this.slideindex=id
        }
        this.slides=this.slides.map(item=>{
            return this.slideindex === item.slideindex ?{
                ...item,
                cardclasses:CARD_VISIBLE_CLASSES,
                dotclasses:DOT_VISIBLE_CLASSES
            }:{
                ...item,
                cardclasses:CARD_HIDDEN_CLASSES,
                dotclasses:DOT_HIDDEN_CLASSES
            }
        })

    }


}