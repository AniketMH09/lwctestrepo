import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

export default class UrlDemo extends LightningElement {

    enca;

    @wire(CurrentPageReference)
    currentPageReference;

    connectedCallback() {
       
        if ( this.currentPageReference.state.enca ) {

            console.log( 'Encrypted Param value is ' + this.currentPageReference.state.enca );
            this.enca = this.currentPageReference.state.enca;

        }

    }

}