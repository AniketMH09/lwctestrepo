import { api, LightningElement, track, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import isguest from '@salesforce/user/isGuest';
export default class AHFC_CCPA_Header extends NavigationMixin(LightningElement) {

    @track guestUser = isguest;

    connectedCallback() {
        console.log('<<<<<<<guestUser>>>>>>> '+this.guestUser);
        sessionStorage.setItem('guestUser',this.guestUser)
    }

}