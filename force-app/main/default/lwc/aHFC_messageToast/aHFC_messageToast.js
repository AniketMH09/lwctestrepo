import { LightningElement, api, track } from "lwc";

export default class AHFC_messageToast extends LightningElement {

    @api type;
    @api notifylink;
    @api notifyMessage;
    @api label = '';
    @api text; //added by Prabu
    @api message;
    @api toastType;
    @api isNotification;
    @api showIcon = 'false';
    @api link;
    @api singlemsg;
    @api singlelink;
    @api date; //added by Prabu
    @api isReviewPayment = false; //by edwin
    @api isotpcompletion = false; //by Akash
    @api messageData='';
    // @track labels = label;
    timeout;

    get messageClass() {
        return `message-container ${this.type} ${this.toastType}`;
    }

    get messageContent() {
        if (this.isReviewPayment) { // by edwin 
            return "message-content-forReviewEasyPay";
        } else if (this.isotpcompletion) {
            return "message-content-forOTP";
        } else {
            return (this.isIconShow) ? "message-content message-content-with-cross" : "message-content";
        }
    }


    get messageNotification() {
        return (this.isIconShow) ? "message-content message-content-with-cross message-content-forOTP" : "message-content";
    }




    get iconName() {
        const type = this.type;
        switch (type) {
            case "error":
                return `utility:error`;
            case "warning":
                return `utility:warning`;
            case "success":
                return `utility:success`;
            case "info":
                return `utility:info`;
            case "alert":
                return `utility:warning`;
        }
    }

    get iconTitle() {
        const type = this.type;
        switch (type) {
            case "error":
                return `Error`;
            case "warning":
                return `Warning`;
            case "success":
                return `Success`;
            case "info":
                return `info`;
            case "alert":
                return `alert`;
        }
    }

    get isIconShow() {
        return (this.showIcon == 'true') ? true : false;
    }

    connectedCallback() {
        if (this.toastType === 'snack-bar') {
            //   this.timeout = setTimeout(()=>{
            //     const selectedEvent = new CustomEvent("closetoast", {});
            //     // Dispatches the event.
            //     this.dispatchEvent(selectedEvent);
            //     clearTimeout(this.timeout);
            //   },5000); 
        }
    }

    //Dispatch Event on click of a link inside toasttoastLinkClicked
    toastLinkClicked() {
        const selectedEvent = new CustomEvent("linkclicked", {});
        this.dispatchEvent(selectedEvent);
    }

    //Dispatch Event on click of a link inside toasttoastLinkClicked
    hyperLinkClicked() {
        const selectedEvent = new CustomEvent("hyperclicked", {});
        this.dispatchEvent(selectedEvent);
    }

    //Dispatch Event on click of a single line toast link
    singleToastLinkClicked() {
        const selectedEvent = new CustomEvent("singlelinkclicked", {});
        this.dispatchEvent(selectedEvent);
    }

    //Dispatch Event on closing toast
    closeToast() {
        if (this.timeout) {
            clearTimeout(this.timeout);
        }
        const selectedEvent = new CustomEvent("closetoast");
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

    }

}