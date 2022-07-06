import { LightningElement, wire } from 'lwc';
import FinName from '@salesforce/schema/Finance_Account__c.Name';
import getAccounts from '@salesforce/apex/LWC_Test_Finacclist.getAccounts';
import { NavigationMixin } from "lightning/navigation";
const COLUMNS = [
    { label: 'FInance Name', fieldName: FinName.fieldApiName, type: Text }
];
export default class lWC_Test_page extends NavigationMixin(LightningElement){
    columns = COLUMNS;
    @wire(getAccounts)
    accounts;
pageRef = {
        type: "comm__namedPage",
  attributes: {
    pageName: "dashboard",
        },
    };
    navigateToMadePayment() {        console.log('here 2ia m');
        this[NavigationMixin.Navigate]({
          type: "comm__namedPage",
          attributes: {
            pageName: "dashboard"
          },
          state: {
            sacRecordId: this.id
          }
        });
      }

      navigateToDashboard() {
        console.log('here ia m');
  this[NavigationMixin.Navigate](this.pageRef);
      }
}