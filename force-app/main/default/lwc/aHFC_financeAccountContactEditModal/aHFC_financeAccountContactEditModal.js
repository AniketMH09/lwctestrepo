import { LightningElement,track, api } from 'lwc';

export default class AHFC_financeAccountContactEditModal extends LightningElement {
@api cellphone;
@api cellphone2;
@api homephone;
@api worklphone;
@api employername;
    onSave(){
        console.log('Inside ON save!!!');
    
    }


    onCancel() {
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA);
    }

    connectedCallback(){
        console.log('resultData1----->'+this.cellphone);
        console.log('resultData1----->'+this.cellphone2);
        console.log('resultData1----->'+this.homephone);
        console.log('resultData1----->'+this.worklphone);
        console.log('resultData1----->'+this.employername);
    }
    
    handleCell1InputChange(event){
        console.log('Input Cell1 Change------> '+event.target.value);
    }
    handleCell2InputChange(event){
        console.log('Input Cell2 Change------> '+event.target.value);
    }
    handleHomePhoneInputChange(event){
        console.log('Input home phone Change------> '+event.target.value);
    }
    handleWorkPhoneInputChange(event){
        console.log('Input work phone Change------> '+event.target.value);
    }
    handleEmpNameInputChange(event){
        console.log('Input emp name Change------> '+event.target.value);
    }

}