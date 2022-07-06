/* Component Name        :    AHFC_communicationPrefernce
    * Description        :    This is LWC for Communication ref Page. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aniket                     07/06/2021              Created 
*/

import { LightningElement, api, wire, track } from 'lwc';
import commRefeSearch from '@salesforce/apex/AHFC_CorrespondenceHandler.commRefeSearch';
import AHFC_Communication_Ref_Receive_Notification from "@salesforce/label/c.AHFC_Communication_Ref_Receive_Notification";
import AHFC_Communication_Edit_Refer from "@salesforce/label/c.AHFC_Communication_Edit_Refer";
import AHFC_Communication_Enroll_Comm from "@salesforce/label/c.AHFC_Communication_Enroll_Comm";
import AHFC_Communication_Sign_Up from "@salesforce/label/c.AHFC_Communication_Sign_Up";
import {
    NavigationMixin
} from "lightning/navigation";

export default class AHFC_communicationPrefernce extends NavigationMixin(LightningElement) {

    @track isEnrolled = false;
    @track email = '';

    labels = {
        AHFC_Communication_Ref_Receive_Notification: AHFC_Communication_Ref_Receive_Notification,
        AHFC_Communication_Edit_Refer: AHFC_Communication_Edit_Refer,
        AHFC_Communication_Enroll_Comm: AHFC_Communication_Enroll_Comm,
        AHFC_Communication_Sign_Up: AHFC_Communication_Sign_Up
    }


    //To check user enrolled or not.
    // @wire(commRefeSearch, { finid: '$finid' })
    // wiredData(result) {
    //     this.isEnrolled = false;
    //     if (result.data) {
    //         if (result.data[0] != undefined) {
    //             if (result.data[0].Email_Address__c != undefined) {
    //                 this.email = result.data[0].Email_Address__c;
    //                 this.isEnrolled = true;
    //                 console.log('CommPreffResult-->',result);
    //             }

    //         }
    //     } else {
    //         console.log('result.error', result.error);
    //     }
    // }

    @api get finid() {
         
    }
    set finid(data) {
        
        commRefeSearch({finid: data})
        .then(result => {
        this.isEnrolled = false;
      
        if (result) {
            if (result[0] != undefined) {
                if (result[0].Email_Address__c != undefined) {
                    this.email = result[0].Email_Address__c;
                    this.isEnrolled = true;
                  
                }

            }
        } else {
            console.log('result.error', result.error);
        }
        })
        .catch(error => {
           console.log(error);
        })
    }



    //To edit Communication pre.
    onEditNot() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'communicationpreference'
            }
        });
    }
}