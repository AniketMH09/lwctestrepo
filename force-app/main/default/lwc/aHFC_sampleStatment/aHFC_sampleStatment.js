/* Component Name     :    aHFC_sampleStatment
 * Description        :    This is LWC for Sample Statement model pop up  (US 7638)
 * Modification Log   :  
 * ---------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ---------------------------------------------------------------------------------
    
 * Sagar                     14/09/2021              Created 
 */

import { LightningElement,track,api} from 'lwc';
import toolTipImg from "@salesforce/resourceUrl/tooltip_image";
import afsLeaseStatementSampleImg from "@salesforce/resourceUrl/AFS_Lease_Statment_Sample";
import hfsLeaseStatementSampleImg from "@salesforce/resourceUrl/HFS_Lease_Statment_Sample";
import afsRetailStatementSampleImg from "@salesforce/resourceUrl/AFS_Retail_Statment_Sample";
import hfsRetailStatementSampleImg from "@salesforce/resourceUrl/HFS_Retail_Statment_Sample";
import powerSportsStatementSampleImg from "@salesforce/resourceUrl/powersport_sample_statement";
import blankImage from "@salesforce/resourceUrl/one_pixel_transparent_image";


export default class AHFC_sampleStatment extends LightningElement {

    @api accountDetails;
    @api showSampleStatmentModel;
    @track showSampleStatement=true;

    @track hfsLeaseSample=false;
    @track hfsRetailSample=false;
    @track afsLeaseSample=false;
    @track afsRetailSample=false;
    @track powerSportsSample=false;

    get tooltipImg() {
        return toolTipImg;
    }
    
    get transparentImg()
    {
        return blankImage;
    }

    get afsLeaseStatementSample()
    {
        return afsLeaseStatementSampleImg;
    }

    get hfsLeaseStatementSample()
    {
        return hfsLeaseStatementSampleImg;
    }

    get afsRetailStatementSample()
    {
        return afsRetailStatementSampleImg;
    }

    get hfsRetailStatementSample()
    {
        return hfsRetailStatementSampleImg;
    }

    get powerSportsStatementSample()
    {
        return powerSportsStatementSampleImg;
    }

    showtooltip()
    {

        this.template.querySelector('[data-id="tooltip"]').classList.remove('ahfc_tooltip');   
        this.template.querySelector('[data-id="tooltip"]').classList.add('toggle');
       

    }

    hidetooltip()
    { 

        this.template.querySelector('[data-id="tooltip"]').classList.add('ahfc_tooltip');   
        this.template.querySelector('[data-id="tooltip"]').classList.remove('toggle');
    }

    showActivitytooltip()
    {

        this.template.querySelector('[data-id="activity_tooltip"]').classList.remove('ahfc_tooltip');   
        this.template.querySelector('[data-id="activity_tooltip"]').classList.add('toggle');
       

    }

    hideActivitytooltip()
    { 

        this.template.querySelector('[data-id="activity_tooltip"]').classList.add('ahfc_tooltip');   
        this.template.querySelector('[data-id="activity_tooltip"]').classList.remove('toggle');
    }

    showACustServicetooltip()
    {

        this.template.querySelector('[data-id="custservice_tooltip"]').classList.remove('ahfc_tooltip');   
        this.template.querySelector('[data-id="custservice_tooltip"]').classList.add('toggle');
    }

    hideCustServicetooltip()
    {

        this.template.querySelector('[data-id="custservice_tooltip"]').classList.add('ahfc_tooltip');   
        this.template.querySelector('[data-id="custservice_tooltip"]').classList.remove('toggle');

    }

    showoffertooltip()
    {

        this.template.querySelector('[data-id="offer_tooltip"]').classList.remove('ahfc_tooltip');   
        this.template.querySelector('[data-id="offer_tooltip"]').classList.add('toggle');
    }

    hideOffertooltip()
    {

        this.template.querySelector('[data-id="offer_tooltip"]').classList.add('ahfc_tooltip');   
        this.template.querySelector('[data-id="offer_tooltip"]').classList.remove('toggle');

    }

    closePopup()
    {
        this.showSampleStatement=false;
        const selectedEvent = new CustomEvent("modalclose", {
            detail: false
          });
        this.dispatchEvent(selectedEvent);
    }

    connectedCallback() {


        if(this.accountDetails.productType=='Marine' || this.accountDetails.productType=='Powersports'
        || this.accountDetails.productType=='Power Equipment')
       {
            this.powerSportsSample=true;
       }else{
           this.powerSportsSample=false;
       }

        if(this.powerSportsSample==false)
        {
            if(this.accountDetails.isHonda && this.accountDetails.isRetailAccount )
            {
                this.hfsRetailSample=true;
            }else if(this.accountDetails.isHonda && this.accountDetails.isLeaseAccount)
            {
                this.hfsLeaseSample=true;
            }else if(this.accountDetails.isAcura && this.accountDetails.isRetailAccount)
            {
                this.afsRetailSample=true;
            }else if(this.accountDetails.isAcura && this.accountDetails.isLeaseAccount)
            {
                this.afsLeaseSample=true;
            }else{
                this.hfsRetailSample=true;
                this.hfsLeaseSample=false;
                this.afsRetailSample=false;
                this.afsLeaseSample=false;
            }
        }

        

       



    }


}