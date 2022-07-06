import { LightningElement,track } from 'lwc';
import ahfc_odometerPdf from "@salesforce/resourceUrl/ahfc_odometerPdf";
import AHFC_CommunityNamedDashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";
import { NavigationMixin } from "lightning/navigation";
import loadUpdatedPrintableForm from "@salesforce/resourceUrl/AHFC_updated_printable_forms";



export default class AHFC_nextStepPrint extends NavigationMixin (LightningElement) {
    @track odometerPdf =  ahfc_odometerPdf;
    @track ohiopdf = '';
    @track ohioPAPdf = '';
    connectedCallback() {
      this.ohiopdf = loadUpdatedPrintableForm+ '/Ohio_Odometer_Disclosure_Title_Release.pdf';
      this.ohioPAPdf = loadUpdatedPrintableForm + '/OH_PowerofAttorney-HFS.pdf';
    }

    @track labels={
        CommunityNamedDashboard:AHFC_CommunityNamedDashboard,
    }
    printCurrentPage() {
        window.print();
    }


    renderedCallback(){
        window.print();
    }
    printDoc(){
    //   let ele = this.template.querySelectorAll('.printContent');
    //   console.log('20',ele.innerHTML);
      // var pc = component.find("printContent");
       // var pt = pc.getElement().innerHTML;
        //var newWin= window.open("");
           // newWin.document.write(pt);
            //newWin.print();
            //newWin.close();
            window.print();
    }
    navigateBackToDashboard(){
        this[NavigationMixin.Navigate]({
          type: "comm__namedPage",
          attributes: {
            pageName: this.labels.CommunityNamedDashboard
          }
        });
      }
  
}