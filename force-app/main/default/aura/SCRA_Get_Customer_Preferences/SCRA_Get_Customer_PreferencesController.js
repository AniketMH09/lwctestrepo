({
    doInit: function (component, event, helper) {

        window.scroll(0, 0);

        var url = window.location.href;
        //console.log('url---- '+url);

        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");

        //console.log('honda domain :' + hondaDomain);

        var vfOrigin = '';
        var vflink = '';
        if (url.includes(hondaDomain)) {
            component.set("v.communityName", 'hondahelp');
            vfOrigin = $A.get('$Label.c.SCRA_VF_Community_URL_honda');
            //vfOrigin = 'https://scrawebpro-hondafinance.cs15.force.com/hondahelp';
            vflink = vfOrigin + '/apex/GoogleReCaptcha'; 
            component.set("v.strvflink", vflink);
            console.log('Captcha link :' + vflink);

        }
        else if (url.includes(acuraDomain)) {
            component.set("v.communityName", 'acurahelp');
            vfOrigin = $A.get('$Label.c.SCRA_VF_Community_URL_acura');
            //vfOrigin = 'https://scrawebpro-hondafinance.cs15.force.com';
            vflink = vfOrigin + '/apex/GoogleReCaptcha';
            //console.log(vflink);
            component.set("v.strvflink", vflink);
        }

        /*Captcha Code */
        //let vfOrigin = $A.get('$Label.c.CCPA_VF_COMMUNITY_URL');

        var pathArray = vfOrigin.split('/');
        var protocol = pathArray[0];
        var host = pathArray[2];
        var vfdomain = protocol + '//' + host;
        //console.log('vfdomain : ' + vfdomain);
        window.addEventListener('message', function (event) {
            //console.log('event.origin--- ' + event.origin);
          /*  if (event.origin !== vfdomain) {
               // return;
            }*/
            if (event.data.captchaVisible) {
                let captchEl = document.getElementById('vfFrame');
                //console.log('captchEl--- ' + captchEl);
                //console.log('event.data.captchaVisible---- ' + event.data.captchaVisible);
                if (event.data.captchaVisible === 'visible') {
                    captchEl.classList.add('reCaptchaBig');
                    captchEl.classList.remove('reCaptchaSmall');
                } else {
                    captchEl.classList.remove('reCaptchaBig');
                    captchEl.classList.add('reCaptchaSmall');
                }
            }
            if (event.data.action === 'unlock') {
                // passing captcha is handled here. event.data.response - is a key of captcha
                component.set("v.captchaokay", true);
            }
        }, false);
        // End Captcha Code 

        //update message based on request type
        // component.set("v.strRequestType",$A.get('$Label.c.CCPA_WHAT_INFO'));
        /*
        if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DO_NOT_SELL')){
            component.set("v.strMessage1",$A.get('$Label.c.CCPA_DNS_MSG_1'));
        }
        else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_WHAT_INFO')){
            component.set("v.strMessage1",$A.get('$Label.c.CCPA_WHAT_INFO_MSG_1'));
            component.set("v.inforequest", true);
        }
            else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DELETE_INFO')){
                component.set("v.strMessage1",$A.get('$Label.c.CCPA_DELETE_INFO_MSG_1'));
            }*/
        //end update message
        //
        //info category options
        /*var infocategory =  [
            {'label': $A.get('$Label.c.CCPA_INFO_CATEGORY_MSG1'), 'value':$A.get('$Label.c.CCPA_INFO_CATEGORY_MSG1') },
            {'label': $A.get('$Label.c.CCPA_INFO_CATEGORY_MSG2'), 'value': $A.get('$Label.c.CCPA_INFO_CATEGORY_MSG2')}
        ];
        component.set("v.infocategory", infocategory);
        *///end info category
    },

    onChange: function (component, event, helper) {

        //console.log("On Change function");
        //console.log(component.get("v.captchaokay"));


        if (component.get("v.captchaokay")) {
            component.set("v.disabled", false);
        }
        else {
            component.set("v.disabled", true);
        }

        //var regex = /[A-Za-z, ]+$/; 

        var inputCmp2 = component.find("serviceid");
        var strrequestoption = component.get("v.strrequestoption");


        if (strrequestoption != null && strrequestoption != '' && strrequestoption != undefined) {
            inputCmp2.setCustomValidity("");
            component.set("v.validservice", true);
        }

        


    }, //end of on change

    onPrefChange: function (component, event, helper) {

        component.set('v.truthy', false);
        component.set('v.truthy', true);
        var inputCmp = component.find("comid");
        var strCommunicationPref = component.get("v.strCommunicationPref");
        var inputCmp1 = component.find("emailfield");
        var emailselected = component.get('v.strEmail');
        var inputCmp2 = component.find("phonefield");
        var phoneselected = component.get('v.strPhoneNumber');
        var pref = component.get("v.strCommunicationPref");
       console.log('pref : ' + pref);
        if (pref === 'Email') {
            component.set("v.emailrequired", true);
            component.set("v.phonerequired", false);
            inputCmp2.setCustomValidity("");
            component.set("v.validPhone", true);
            inputCmp2.reportValidity();
        }
        else if (pref === 'Phone') {
            component.set("v.phonerequired", true);
            component.set("v.emailrequired", false);
            inputCmp1.setCustomValidity("");
            component.set("v.validEmail", true);
            inputCmp1.reportValidity();
        }


        //console.log('phone validity : ' + inputCmp1.get)
        //console.log('strCommunicationPref --- ' + strCommunicationPref);
        /*
            if(strCommunicationPref!=null && strCommunicationPref!='' && strCommunicationPref!=undefined)
            {
                inputCmp.setCustomValidity(""); 
                component.set("v.validCommPref",true);
                //inputCmp1.setCustomValidity("");
                //component.set("v.validEmail",true); 
                //inputCmp2.setCustomValidity("");
                //component.set("v.validPhone",true); 
                //console.log('inputCmp1.setCustomValidity---'+ inputCmp1.setCustomValidity());
                //alret("validEmail + validPhone" + v.validEmail +" "+ v.validPhone);
                
            }*/
        //onChange();
        /*
        inputCmp1.setCustomValidity("");
        component.set("v.validEmail",true);
        inputCmp2.setCustomValidity("");
        component.set("v.validPhone",true);  */
        var trackpref = component.get("v.trackpref");
        if (trackpref) component.set("v.trackpref", false)
        else component.set("v.trackpref", true);



    }, //end of on pref change

    afterRender: function (component, helper) {
        this.superAfterRender();
        // interact with the DOM here


    },

    

    onChangeFirstname: function (component, event, helper) {
        
        var strFirstName = component.get('v.strFirstName');
        var firstname = event.getSource().get("v.value");
        var inputCmp = component.find("inputCmp1");
        var regex = /[A-Za-z, ]+$/;
        //console.log('strFirstName : '+strFirstName);
        console.log('FirstName : '+firstname);
        if (strFirstName === null || strFirstName === '' || strFirstName === undefined) {
            var value = inputCmp.get("v.value");
            inputCmp.setCustomValidity("Error: Enter First Name.");
            inputCmp.reportValidity();
            component.set("v.validFirstName", false);
            component.set("v.allInValid",true);
        } else {

            try{
            //console.log('match: '+strFirstName.match(regex));
            if (!strFirstName.match(regex)) {
                inputCmp.setCustomValidity("Error:Enter valid value");
                inputCmp.reportValidity();
                component.set("v.validFirstName", false);
                component.set("v.allInValid",true);
            } else {
                inputCmp.setCustomValidity("");
                inputCmp.reportValidity();
                component.set("v.validFirstName", true);
                component.set("v.allInValid",false);
            }
        }catch(err){
            console.log(err);
        }
        }

    },   
    
    onChangeLastname: function (component, event, helper) {
        
        var strLastName = component.get('v.strLastName');
        var inputCmp = component.find("inputCmp2");
            
        var regex = /[A-Za-z, ]+$/;

        if (strLastName === null || strLastName === '' || strLastName === undefined) {

            var value = inputCmp.get("v.value");
            inputCmp.setCustomValidity("Error: Enter Last Name.");
            inputCmp.reportValidity();
            component.set("v.validLastName", false);
            component.set("v.allInValid",true);
        } else {

            if (!strLastName.match(regex)) {
                inputCmp.setCustomValidity("Error:Enter valid value");
                inputCmp.reportValidity();
                component.set("v.validLastName", false);
                component.set("v.allInValid",true);
            } else {
                inputCmp.setCustomValidity("");
                inputCmp.reportValidity();
                component.set("v.validLastName", true);
                component.set("v.allInValid",false);
            }

        }

    }, 

    onChangeEmail: function (component, event, helper) {

        try{
            var inputCmp = component.find("emailfield");
            var strEmail = component.get("v.strEmail");
            var pref = component.get("v.strCommunicationPref");
            var inputCmp1 = component.find("phonefield");
            var strPhoneNumber = component.get("v.strPhoneNumber");
            
            
            
            var controlAuraIds = ["emailfield"];
        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
            let validEmail = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            //fetches the component details from the auraId
                var inputEmailCmp = component.find(controlAuraId);
            //displays the error messages associated with field if any
                inputEmailCmp.reportValidity();
            //form will be invalid if any of the field's valid property provides false value.
                return isValidSoFar && inputEmailCmp.checkValidity();
            },true);

            //console.log('validEmail :',validEmail);


            if (pref === 'Phone') {
                inputCmp1.setCustomValidity("");
                component.set("v.validPhone", true);
            }

            if (strEmail != null && strEmail != '' && strEmail != undefined) {
                inputCmp.setCustomValidity("");
                inputCmp.reportValidity();
                component.set("v.validEmail", true);
                component.set("v.allInValid",false);
                
            }
            /*
            if(pref === 'Email' && !validEmail){
                inputCmp.setCustomValidity("Error: Enter a valid Email Address");
                inputCmp.reportValidity();
                component.set("v.allInValid",true);
                component.set("v.validEmail", false);
            }*/

        }catch(err){
            console.log('error on change email :'+err);
        }
    },

    onChangePhone: function (component, event, helper) {


        var inputCmp = component.find("emailfield");
        var strEmail = component.get("v.strEmail");
        var pref = component.get("v.strCommunicationPref");
        var inputCmp1 = component.find("phonefield");
        var strPhoneNumber = component.get("v.strPhoneNumber");
        var controlAuraIds = ["phonefield"];
        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
            let validPhone = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            //fetches the component details from the auraId
                var inputCmp = component.find(controlAuraId);
            //displays the error messages associated with field if any
                inputCmp.reportValidity();
            //form will be invalid if any of the field's valid property provides false value.
                return isValidSoFar && inputCmp.checkValidity();
            },true);

            
         console.log('validPhone :'+validPhone);

        if (strPhoneNumber != null && strPhoneNumber != '' && strPhoneNumber != undefined) {
            inputCmp1.setCustomValidity("");
            component.set("v.validPhone", true);
            component.set("v.allInValid",false);
            
        }else if(pref === 'Phone' && !validPhone){
            inputCmp.setCustomValidity("Error: Enter a 10 digit Phone Number");
            inputCmp.reportValidity();
            component.set("v.allInValid",true);
            component.set("v.validPhone", false);
        }

        if (pref === 'Email') {
            inputCmp.setCustomValidity("");
            component.set("v.validEmail", true);
        }
    },

    redirectToHome: function (component, event, helper) {
        //@KP Nov/08 - T-747962 Cancellation return to MyAccount Page
        var url = window.location.href;
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        if (url.includes(hondaDomain)) {
            url = $A.get("$Label.c.SCRA_F_A_Q_Knowledge_Article_URL");
        } else {
            url = $A.get("$Label.c.SCRA_F_A_Q_Knowledge_Article_URL");
        } 
        window.open(url, '_top');
    },
    changeinfocategory: function (component, event, helper) {
        var infocategory = component.get("v.strinfocategory");
        if (infocategory === $A.get('$Label.c.CCPA_INFO_CATEGORY_MSG2')) {
            component.set("v.perjuryackreqd", true);
        }
    },

    closeModel: function (component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },

    openModel: function (component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },

    handleContinue: function (component, event, helper) {
        // When an option is selected, navigate to the next screen
        var pref = component.get("v.strCommunicationPref");
        var emailselected = component.get('v.strEmail');
        var phoneselected = component.get('v.strPhoneNumber');
        var serviceval = component.get('v.strrequestoption');
        var strFirstName = component.get('v.strFirstName');
        var strLastName = component.get('v.strLastName');
        var regex = /[A-Za-z, ]+$/;

        if (strFirstName === null || strFirstName === '' || strFirstName === undefined) {

            var inputCmp = component.find("inputCmp1");
            var value = inputCmp.get("v.value");
            inputCmp.setCustomValidity("Error: Enter First Name.");
            inputCmp.reportValidity();
            component.set("v.validFirstName", false);
            component.set("v.allInValid",true);
        } else {

            if (!strFirstName.match(regex)) {
                inputCmp.setCustomValidity("Enter valid value");
                component.set("v.validFirstName", false);
                component.set("v.allInValid",true);
            } else {
                component.set("v.validFirstName", true);
                component.set("v.allInValid",false);
            }
        }

        if (strLastName === null || strLastName === '' || strLastName === undefined) {

            var inputCmp = component.find("inputCmp2");
            var value = inputCmp.get("v.value");
            inputCmp.setCustomValidity("Error: Enter Last Name.");
            inputCmp.reportValidity();
            component.set("v.validLastName", false);
            component.set("v.allInValid",true);
        } else {

            if (!strLastName.match(regex)) {
                inputCmp.setCustomValidity("Enter valid value");
                component.set("v.validLastName", false);
                component.set("v.allInValid",true);
            } else {
                component.set("v.validLastName", true);
                component.set("v.allInValid",false);
            }

        }

        console.log('pref : '+pref);
        
        if (pref === null || pref === '' || pref === undefined) {

            var inputCmp = component.find("comid");
            var value = inputCmp.get("v.value");
            //console.log('inputCmp' + inputCmp);
            //console.log('value' + value);
            inputCmp.setCustomValidity("Error: Please make a selection");
            inputCmp.reportValidity();
            component.set("v.validCommPref", false);
            component.set("v.allInValid",true);
        } else {
            component.set("v.validCommPref", true);
            component.set("v.allInValid",false);
        }

        
        if (pref === 'Email') {
            
            var controlAuraIds = ["emailfield"];
        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
            let validemail = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            //fetches the component details from the auraId
                var inputCmp = component.find(controlAuraId);
            //displays the error messages associated with field if any
                inputCmp.reportValidity();
            //form will be invalid if any of the field's valid property provides false value.
                return isValidSoFar && inputCmp.checkValidity();
            },true);

            //console.log('email : '+emailselected);
            //console.log('email : '+validemail);

            if (emailselected === null || emailselected === '' || emailselected === undefined || !validemail) {

                var inputCmp = component.find("emailfield");
                var value = inputCmp.get("v.value");
                inputCmp.setCustomValidity("Error: Enter an Email Address.");
                inputCmp.reportValidity();
                component.set("v.validEmail",false);
                component.set("v.allInValid",true);
            }else{
                //console.log('inside valid email********');
                component.set("v.validEmail",true);
                component.set("v.allInValid",false);
            }
        } else {
            //console.log('inside********');
            component.set("v.validEmail",true);
            component.set("v.allInValid",false);
        }

        

        if (pref === 'Phone') {

            var controlAuraIds = ["phonefield"];
        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
            let validPhone = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            //fetches the component details from the auraId
                var inputCmp = component.find(controlAuraId);
            //displays the error messages associated with field if any
                inputCmp.reportValidity();
            //form will be invalid if any of the field's valid property provides false value.
                return isValidSoFar && inputCmp.checkValidity();
            },true);
            
            if (phoneselected === null || phoneselected === '' || phoneselected === undefined || !validPhone) {

                var inputCmp = component.find("phonefield");
                var value = inputCmp.get("v.value");
                inputCmp.setCustomValidity("Error: Enter a 10 digit Phone Number.");
                inputCmp.reportValidity();
                component.set("v.validPhone", false);
                component.set("v.allInValid",true);
            }else{
                component.set("v.validPhone", true);
                component.set("v.allInValid",false);
            }
        } else {
            component.set("v.validPhone", true);
            component.set("v.allInValid",false);
        }

        if (serviceval === null || serviceval === '' || serviceval === undefined) {
            var inputCmp = component.find("serviceid");
            var value = inputCmp.get("v.value");
            inputCmp.setCustomValidity("Error: Please make a selection");
            inputCmp.reportValidity();
            component.set("v.validservice", false);
            component.set("v.allInValid",true);
        } else {
            component.set("v.validservice", true);
            component.set("v.allInValid",false);
        }
        var compref_valid = component.get("v.validCommPref");
        var email_valid = component.get("v.validEmail");
        var phone_valid = component.get("v.validPhone");
        var service_valid = component.get("v.validservice");
        var fName_valid = component.get("v.validFirstName");
        var LName_valid = component.get("v.validLastName");

        //console.log('compref_valid : '+compref_valid);
        //console.log('email_valid : '+email_valid);
        //console.log('phone_valid : '+phone_valid);
        //console.log('service_valid : '+service_valid);
        //console.log('fName_valid : '+fName_valid);
        //console.log('LName_valid : '+LName_valid);
        

        if (pref === 'Email') {
            if (compref_valid && email_valid && service_valid && fName_valid && LName_valid) {
                // When an option is selected, navigate to the next screen
                var response = event.getSource().getLocalId();
                component.set("v.value", response);
                var navigate = component.get("v.navigateFlow");
                component.set("v.allInValid",false);
                navigate("NEXT");
                
            }else{
                component.set("v.allInValid",true);
            }
        }else if (pref === 'Phone') {
            if (compref_valid && phone_valid && service_valid && fName_valid && LName_valid) {
                // When an option is selected, navigate to the next screen
                var response = event.getSource().getLocalId();
                component.set("v.value", response);
                var navigate = component.get("v.navigateFlow");
                component.set("v.allInValid",false);
                navigate("NEXT");

            }else{
                component.set("v.allInValid",true);
            }
        }else{
            component.set("v.allInValid",true);
        }
        
        /*
        var response = event.getSource().getLocalId();
            component.set("v.value", response);
            var navigate = component.get("v.navigateFlow");
            navigate("NEXT");*/

            //console.log('allInValid : '+component.get("v.allInValid"));
            
    },

    contactUs: function (component, event, helper) {
        var href = $A.get("$Label.c.AHFC_Contact_Us_URL");
        window.open(href, '_top');
    },

    handleNavigateEvent: function (component, event, helper) {
        
        //console.log('**************Called Previous event*****************');
        component.set("v.comingFromPrevious",true);
    }


})