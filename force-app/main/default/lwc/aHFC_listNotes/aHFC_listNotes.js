import { LightningElement, api, wire, track } from 'lwc';
import fetchNotes from '@salesforce/apex/AHFC_NotesController.fetchNotes';
import TrackingJS from '@salesforce/resourceUrl/TrackingJS';
import {
    getConstants
} from "c/ahfcConstantUtil";
const CONSTANTS = getConstants();
export default class AHFC_ListNotes extends LightningElement {
    @api recordId;
    @track records;
    @track recordCount;
    @track isRecordsAvaialable = false;
    @wire(fetchNotes, { strRecordId: '$recordId' })
    wiredResult({ data, error }) {
        if (data) {
            console.log('AHFC_ListNotes, data: ' + JSON.stringify(data));
            this.records= JSON.parse(JSON.stringify(data));
            for (let i = 0; i < this.records.length; i++) {
                this.records[i].strCreatedDate = this.formatDate(this.records[i].strCreatedDate);
            }
            this.recordCount = Object.keys(data).length;
            if (this.recordCount > 0) {
                this.isRecordsAvaialable = true;
            }
        }
        if (error) {
            console.log('AHFC_ListNotes, error: ' + error)
        }
    }

    /*
 @description: format date field
 @ author edwin
 */
    formatDate(dt) {
        var formatdate = new Date(dt);
        formatdate = new Date(formatdate.getTime() + formatdate.getTimezoneOffset() * 60 * 1000);
        if (formatdate !== CONSTANTS.INVALID_DATE) {
            const options = {
                year: "numeric",
                month: "short",
                day: "numeric"
            };
            return formatdate.toLocaleDateString("en-US", options);
        } else {
            return "";
        }
    }
}