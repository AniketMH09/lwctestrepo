import { LightningElement, track } from 'lwc';
// importing cnx library from static resource
import cnx from '@salesforce/resourceUrl/cnx';
//import cnxTst from '@salesforce/resourceUrl/cnxTst';

// importing resource loader
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
// imported for to show toast messages
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AHFC_customerSurvey extends LightningElement {
    //  @track error;


    connectedCallback() { // invoke the method when component rendered or loaded


        console.log('qqqqq', sessionStorage.getItem('surveystarted'));
        Promise.all([
            loadScript(this, cnx), // cnx js file
            //  loadScript(this, cnxTst + '/cnxTst.js'), // cnx js file
            // loadScript(this, cnxTst + '/cnxTst2.js'), // cnx js file
            loadScript(this, cnx + '/cnx/allPages.js'), // cnx js file
            loadScript(this, cnx + '/cnx/cnx_bundle.js'), // cnx js file
            loadScript(this, cnx + '/cnx/SPA.js'), // cnx js file
            
            loadScript(this, cnx + '/cnx/readme.txt'), // readme js file
            
            loadScript(this, cnx + '/cnx/.DS_Store'), // readme js file

            loadScript(this, cnx + '/cnx/data/settings.json'), // json File 
            loadStyle(this, cnx + '/cnx/data/PoweredByConcentrixCX.png'), // png File 

            loadStyle(this, cnx + '/cnx/cnx_style.css'), // CSS File
            loadStyle(this, cnx + '/cnx/fonts/DINPro-CondBold.otf'), // CSS File
            loadStyle(this, cnx + '/cnx/fonts/Inter-Regular.otf'), // CSS File
            loadStyle(this, cnx + '/cnx/fonts/Inter-Bold.otf'), // CSS File

        ])
            .then(() => {

                // Call back function if scripts loaded successfully
                console.log('Here iam ');

            })
            .catch(error => {

                console.log('error uiam ', error);

            });


    }



}