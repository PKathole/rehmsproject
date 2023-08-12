import { LightningElement } from 'lwc';
import Carousel from '@salesforce/resourceUrl/Carousel'
export default class CustomCarouselWrapper extends LightningElement {

    slides=[
       
        {
            image:`${Carousel}/1.gif`
        },
        {
            image:`${Carousel}/2.gif`
        },
        {
            image:`${Carousel}/3.png`
        }
        
    ]
}