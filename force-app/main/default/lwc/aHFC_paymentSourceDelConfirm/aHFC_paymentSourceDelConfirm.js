/* Name               :    AHFC_paymentSourceDelConfirm
 * Description        :    This Component is used to display delete modal screen for payment sources.
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ---------------------------------------------------------------------------
 * 
 * Satish                     14/06/2021              created
 * 
 *********************************************************************************/
import {
    LightningElement,
    api,
    track
} from "lwc";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import {
    loadStyle
} from "lightning/platformResourceLoader";


export default class AHFC_paymentSourceDelConfirm extends LightningElement {

    @api nickname;

    @track isDeleteModalOpen = false;
    onSave() {
        const selectedEvent = new CustomEvent("modalsave", {
            detail: this.isDeleteModalOpen
        });
        this.dispatchEvent(selectedEvent);
    }

    onCancel() {
        const selectedEvent = new CustomEvent("modalclose", {
            detail: this.isDeleteModalOpen
        });
        this.dispatchEvent(selectedEvent);
    }

    handleDialogClose() {
        const selectedEvent = new CustomEvent("modalclose", {
            detail: this.isDeleteModalOpen
        });
        this.dispatchEvent(selectedEvent);
    }

}