import { LightningElement, track } from 'lwc';
import ahfc_odometerPdf from "@salesforce/resourceUrl/ahfc_odometerPdf";
import AHFC_CommunityNamedDashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";
import { NavigationMixin } from "lightning/navigation";
import loadUpdatedPrintableForm from "@salesforce/resourceUrl/AHFC_updated_printable_forms";



export default class Ahfc_nextSteps extends NavigationMixin(LightningElement) {


  @track odometerPdf = ahfc_odometerPdf;
  @track ohiopdf = '';
    @track ohioPAPdf = '';
    connectedCallback() {
      this.ohiopdf = loadUpdatedPrintableForm+ '/Ohio_Odometer_Disclosure_Title_Release.pdf';
      this.ohioPAPdf = loadUpdatedPrintableForm + '/OH_PowerofAttorney-HFS.pdf';
    }

  @track labels = {
    CommunityNamedDashboard: AHFC_CommunityNamedDashboard,
  }
  printCurrentPage() {
    window.print();
  }
  printDoc() {

    this[NavigationMixin.GenerateUrl]({
      type: 'comm__namedPage',
      attributes: {
        pageName: "nextstepprint"
      },
    }).then(url => {
      console.log('url', url);
      
      window.open(url, '_blank');
    });

    // this[NavigationMixin.Navigate]({
    //   type: "comm__namedPage",
    //   attributes: {
    //     pageName: "nextstepprint"
    //   }
    // });

  }
  navigateBackToDashboard() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: this.labels.CommunityNamedDashboard
      }
    });
  }

  onCancel() {
    const closeqa = new CustomEvent('close');
    // Dispatches the event.
    this.dispatchEvent(closeqa);
  }


}