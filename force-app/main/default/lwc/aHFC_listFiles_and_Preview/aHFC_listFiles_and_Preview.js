import { LightningElement, api, wire, track } from 'lwc';
import getAllFilesByRecordId from '@salesforce/apex/AHFC_ListFileAndPreviewController.getAllFilesByRecordId'
import { NavigationMixin } from 'lightning/navigation'

export default class AHFC_listFiles_and_Preview extends NavigationMixin(LightningElement) {
    @api recordId;
    @track recordCount;
    @track baseUrl;
    @track data;
    @track records;

    @track isRecordsAvaialable = false;
    filesList = []
    @wire(getAllFilesByRecordId, { recordId: '$recordId' })
    wiredResult({ data, error }) {
        if (data) {
            this.filesList = data;
            console.log('AHFC_listFiles_and_Preview data :' + JSON.stringify(data));
            this.recordCount = this.filesList.length;
            if (this.recordCount > 0) {
                this.baseUrl = this.filesList[0].baseUrl;
                this.isRecordsAvaialable = true;
            }       
        }
        if (error) {
            console.log(error)
        }
    }
  
    previewHandler_old(event) {
        let filePath = event.target.dataset.value;
        console.log('previewHandler, value: ', filePath);
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: filePath//"https://ahfc--webproj1.my.salesforce.com/sfc/servlet.shepherd/document/download/0690U000001xdkkQAA?operationContext=S1" //"https://poc.acura.americanhondafinance.com/sfc/servlet.shepherd/version/renditionDownload?rendition=PDF&versionId="+event.target.dataset.id
            }
        }, false);
    }

    
    previewHandler(event) {
        let filePath = this.baseUrl+"/sfc/servlet.shepherd/document/download/"+ event.target.dataset.id+"?operationContext=S1"
        
        console.log('previewHandler, value: ', filePath);
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: filePath//"https://ahfc--webproj1.my.salesforce.com/sfc/servlet.shepherd/document/download/0690U000001xdkkQAA?operationContext=S1" //"https://poc.acura.americanhondafinance.com/sfc/servlet.shepherd/version/renditionDownload?rendition=PDF&versionId="+event.target.dataset.id
            }
        }, false);
    }
   
}