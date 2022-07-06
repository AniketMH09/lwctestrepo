import { LightningElement, api, wire, track } from 'lwc';
import fetchNotes from '@salesforce/apex/AHFC_NotesController.fetchNotes';
import getRelatedFilesByRecordId from '@salesforce/apex/AHFC_ListFileAndPreviewController.getRelatedFilesByRecordId'
import {
    getConstants
} from "c/ahfcConstantUtil";
const CONSTANTS = getConstants();
export default class CheckAccessForCommunityUser extends LightningElement {
    @api recordId ='5000U00000C81JDQAZ';
    @track records;
    @track recordCount;
    @track isFilesAvailable = false;
    @track isNotesAvailable = false;
    @wire(fetchNotes, { strRecordId: '$recordId' })
    wiredResult({ data, error }) {
        if (data) {
            console.log('AHFC_ListNotes, data: ' + JSON.stringify(data));
            this.notesCount = Object.keys(data).length;
            this.isNotesAvailable = true;
        }
        if (error) {
            console.log('AHFC_ListNotes, error: ' + error)
        }
    }

    @wire(getRelatedFilesByRecordId, { recordId: '$recordId' })
    wiredResult({ data, error }) {
        if (data) {
            this.records = data.mapIdTitle;
            console.log('AHFC_listFiles_and_Preview data :' + JSON.stringify(data));            
            this.filesCount = Object.keys(this.records).length;
            if (this.recordCount > 0) {
                this.isFilesAvailable = true;
            }
        
        }
        if (error) {
            console.log(error)
        }
    }
   
}