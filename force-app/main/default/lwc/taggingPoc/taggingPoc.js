import { LightningElement } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled }  from 'lightning/empApi';

export default class TaggingPoc extends LightningElement {

   connectedCallback(){
       this.handleSubscribe();
   }

    //platform event dont deploy this****************
    channelName = '/event/platform_test__e';
    subscription = {};

    handleSubscribe() {
        //this.registerErrorListener();
        console.log('1264');
        subscribe(this.channelName, -1, this.messageCallback).then(response => {
            // Response contains the subscription information on subscribe call
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
        
        })
    }

    messageCallback(response){
      console.log('1274', response);
      var obj = JSON.parse(JSON.stringify(response));
     console.log('New message received 4: ', obj.data.payload);
    }
    registerErrorListener() {
        // Invoke onError empApi method
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }
}