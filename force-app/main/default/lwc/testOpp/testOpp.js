import { LightningElement, wire, track } from 'lwc';
import getTodayData from "@salesforce/apex/TestApexForPoc.getTodayData";
import getYesterdayData from "@salesforce/apex/TestApexForPoc.getYesterdayData";
import getData from "@salesforce/apex/TestApexForPoc.getData";
import { refreshApex } from '@salesforce/apex';
import Count from "@salesforce/label/c.Opportunity_Report_Refresh_Interval";

export default class TestOpp extends LightningElement {

    count = Count;
    @track todayCount = 0;
    @track yesCounbt = 0;

    @track refrestodayCount;
    @track refresyesCounbt;
    @track gotData = {
        closedToday: 0,
        closedYesterday: 0,
        openToday: 0,
        openYesterday: 0,
        closedPercentage: 0
    };




    @wire(getData)
    resultGetData(result) {
        this.refresyesCounbt = result;
        
        if (result.data) {
            this.gotData = JSON.parse(JSON.stringify(result.data));
            //console.log('xyz', this.gotData)
        }
    }



    connectedCallback() {

        setInterval(() => {
            refreshApex(this.refresyesCounbt);
            // refreshApex(this.refrestodayCount);
        }, this.count);

    }
}