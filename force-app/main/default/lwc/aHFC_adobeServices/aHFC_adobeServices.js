import Environment from "@salesforce/label/c.Environment";

const name = 'aniket';
 
const fireAdobeEvent = (data, eventname) => {
    //Bug number 22918
    if(sessionStorage.getItem('tagging') == 'true' && data['Page.page_name'] == 'Finance Account Details' && eventname == 'PageLoadReady'){
        return;
    }
    if(data['Page.page_name'] == 'Finance Account Details' && eventname == 'PageLoadReady'){
        sessionStorage.setItem('tagging', 'true')
    }else {
        sessionStorage.setItem('tagging', 'false')
    }
    let digitalData = {
        "Metadata.version_dl": '2021.12',
        "Metadata.property_name": "American Honda Finance",
        "Event_Metadata.action_type": "",
        "Event_Metadata.action_label": "",
        "Event_Metadata.action_category": "",
        "Model.model_brand": "",
        "Page.content_publish_date": "12/15/2021",
        "Page.page_friendly_url": '',
        "Page.full_url": window.location.href,
        "Page.page_name": "",
        "Page.site_section": "",
        "Page.sub_section": "",
        "Page.sub_section2": "",
        "Page.sub_section3": "",
        "Page.brand_name": "",
        "Page.referrer_type": "",
        "Page.referrer_url": '',
        "Page.environment": Environment,
        "user.first_name": '',
        "user.last_name": '',
        "user.email": ''
    };

    for (let key in data) {
        digitalData[key] = data[key]
    }
    console.log('xyz++', data);
    
    if (digitalData["Page.referrer_url"] == digitalData["Page.full_url"]) {
        digitalData["Page.referrer_url"] = '';
    }
    digitalData['Page.page_friendly_url'] = window.location.href.split('?')[0];
    window.dataLayer = digitalData;
    console.log('xyz', eventname);
    _satellite.track(eventname);
}

export { fireAdobeEvent };