import { LightningElement, wire, api, track } from 'lwc';
import fetchNotes from '@salesforce/apex/AHFC_NotesController.fetchNotes';
import getRelatedFilesByRecordId from '@salesforce/apex/AHFC_ListFileAndPreviewController.getRelatedFilesByRecordId'

export default class checkCustomerAccess extends LightningElement {

    @api recordId = '5000U00000C81JDQAZ';
   // @track strRecordId = '5000U00000C81JDQAZ';
    @track records;
    @track isFilesAvailable = false;
    @track isNotesAvailable = false;
    @track filesCount = 0;
    @track notesCount = 0;

    connectedCallback() {
        this.getFiles();
        this.getNotes();
    }


    getNotes() {
        console.log('Inside Notes method>>>>>>>>');
        fetchNotes({
            strRecordId: this.recordId
        })
            .then((data) => {
                if (data) {                 
                    console.log('Notes data :' + JSON.stringify(data));
                    this.records = data.mapIdTitle;         
                   // console.log(' this.records>>>>>>>:' +  this.records);         
                    this.notesCount = Object.keys(data).length;
                    console.log('Notes Count>>>>>>>:' + this.notesCount);
                    if (this.notesCount > 0) {
                        this.isNotesAvailable = true;
                    }
                }
            })
            .catch((error) => {
                this.error = error;
                console.log('Notes error', error);
            });

    }

    getFiles() {
        console.log('Inside Files method>>>>>>>>');
        getRelatedFilesByRecordId({
            recordId: this.recordId
        })
            .then((data) => {
                if (data) {
                    console.log('AHFC_listFiles_and_Preview data :' + JSON.stringify(data));
                    this.records = data.mapIdTitle;
                    this.filesCount = Object.keys( this.records).length;
                    console.log('filesCount>>>>>>>:'+this.filesCount);
                    if (this.filesCount > 0) {
                        this.isFilesAvailable = true;
                    }
                }
            })
            .catch((error) => {
                this.error = error;
                console.log('Files error', error);
            });

    }
    /*
        getNotes() {
            fetchNotes(strRecordId: this.sacRecordId).then((data) => {
                console.log('Inside Notes method>>>>>>>>');
                if (data) {
                    console.log('AHFC_ListNotes, data: ' + JSON.stringify(data));
                    this.notesCount = Object.keys(data).length;
                    this.isNotesAvailable = true;
                    console.log('notesCount>>>>>>>:'+this.notesCount);
                }
    
            }).catch((error) => { console.log('Notes, error: ' + JSON.stringify(error));});
        }
    
        getFiles() {
            getRelatedFilesByRecordId(this.strRecordId).then((data) => {
                console.log('Inside Files method>>>>>>>>');
                if (data) {
                    this.records = data.mapIdTitle;
                    console.log('AHFC_listFiles_and_Preview data :' + JSON.stringify(data));
                    this.filesCount = Object.keys(this.records).length;
                    console.log('filesCount>>>>>>>:'+this.filesCount);
                    if (this.recordCount > 0) {
                        this.isFilesAvailable = true;
                    }
        
                }
    
            }).catch((error) => { console.log('Files, error: ' + JSON.stringify(error));});
        }*/

}