import { LightningElement, wire, track, api } from 'lwc';
import findCases from '@salesforce/apex/AHFC_Case_List_View.getBranchData';

const columns = [
    { label: 'Case Number', fieldName: 'hrefid', initialWidth: 149, type: 'url', typeAttributes: { label: { fieldName: 'CaseNumber' } } },
    { label: 'Date/Time Opened', fieldName: 'CreatedDate', type: 'date', initialWidth: 175 },
    { label: 'Type', fieldName: 'Type', initialWidth: 100 },
    { label: 'Case Status', fieldName: 'Status', initialWidth: 130 },
    { label: 'Case Disposition', fieldName: 'Case_Reason__c', initialWidth: 170 },
    { label: 'Date/Time Closed', fieldName: 'ClosedDate', type: 'date', initialWidth: 175 },
    { label: 'Owner name', fieldName: 'hrefownerid', initialWidth: 200, type: 'url', typeAttributes: { label: { fieldName: 'ownerName' } } }
];

export default class AHFC_cases_list_view extends LightningElement {

    @track data = [];
    columns = columns;
    @api recordId;
    @track title = '';
    @track count = '';
    @track isZero = false;

    @wire(findCases, { finid: '$recordId' })
    contacts({ error, data }) {
        if (data) {

            this.data = JSON.parse(JSON.stringify(data));
            console.log('xxx>>', this.data);
            this.title = `CCPA Cases (${this.data.length})`;
            this.count = `${this.data.length} items`;
           
            if(this.data.length == 0) {
                console.log('YYY')
                this.isZero = false;
            }else {
                this.isZero = true;
            }
           
            for (let i = 0; i < this.data.length; i++) {
                this.data[i].ownerName = this.data[i].Owner.Name;
                this.data[i].hrefid = '/' + this.data[i].Id;
                this.data[i].hrefownerid = '/' + this.data[i].OwnerId;

            }
            console.log('xxx>', this.data);
        } else {
            console.log('yyy>', error);
        }
    }

    refreshTable() {

    }

}