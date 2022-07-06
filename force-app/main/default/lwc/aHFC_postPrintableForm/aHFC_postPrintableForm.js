import { LightningElement } from 'lwc';
import hondaHeadLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import hondaVehImg from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";

export default class AHFC_postPrintableForm extends LightningElement {
    get hondaheadLogoUrl() {
        return hondaHeadLogo;
    }
    get hondaVehImgUrl() {
    return hondaVehImg;
    }
}