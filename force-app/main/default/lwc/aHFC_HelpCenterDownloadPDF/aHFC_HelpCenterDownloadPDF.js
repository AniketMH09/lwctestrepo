/* Component Name     :    aHFC_HelpCenterDownloadPDF
    * Description        :    This is LWC for download pdf option in help center article page 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aswin                     25/05/2021              Created 
    */
import { LightningElement } from 'lwc';

export default class AHFC_HelpCenterDownloadPDF extends LightningElement {

    downloadData(){
        window.print();
    }
}