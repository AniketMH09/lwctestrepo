import { LightningElement, api, track } from 'lwc';

export default class AHFC_carousel extends LightningElement {
    // The list of accounts provided by the parent component
    @api selectedAccountsList = [];
    // Has the currently showing image in the carousel changed
    @track isImageChanged = false;
    @track myValue = 50;

    userAccountMax(event) {
        myValue = event.detail.value;
        console.log(myValue);
        console.log(JSON.stringify(selectedAccountsList));
    }
}