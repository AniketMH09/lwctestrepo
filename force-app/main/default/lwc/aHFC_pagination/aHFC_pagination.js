/* Component Name     :    AHFC_pagination
    * Description        :    This is LWC for pagination on transaction detail. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aniket                     20/05/2021              Created 
    */
import { api, LightningElement, track } from 'lwc';

export default class AHFC_pagination extends LightningElement {
    @api items;
    @api itemsperpage;
    @track pageNoArray = [];
    currentPage;
    isPrevAllowed;
    isNextAllowed;

    // Find Page Count
    get noOfPages() {
        return Math.ceil((JSON.parse(this.items)).length / this.itemsperpage);
    }

    // Find Items Count
    get totalItems() {
        return (JSON.parse(this.items)).length;
    }

    // Get Items
    get arrayItems() {
        return JSON.parse(this.items);
    }

    // Previous Button Whether Disabled or Active
    get prevClass() {
        return (this.isPrevAllowed) ? "nextprev active" : "nextprev disable";
    }

    // Starting Item No showing
    get startPageItem() {
        return ((this.currentPage - 1) * this.itemsperpage) + 1;
    }

    // Ending Item No showing
    get endPageItem() {
        return ((this.currentPage * this.itemsperpage) > this.totalItems) ? this.totalItems : (this.currentPage * this.itemsperpage);
    }

    // Showing Text
    get showingText() {
        return `Showing ${this.startPageItem} - ${this.endPageItem} of ${this.totalItems}`;
    }

    // Next Button Whether Disabled or Active
    get nextClass() {
        return (this.isNextAllowed) ? "nextprev next active" : "nextprev next disable";
    }

    @api handleValueChange(items) {
        this.items = items;
        this.currentPage = 1;
        this.setPageArray();
    }

    // Cut the items need to display for this page and send to Parent
    excerptItemsToParent() {
        const selectedEvent = new CustomEvent("pagechanges", {
            detail: JSON.stringify(this.arrayItems.slice(this.startPageItem - 1, this.endPageItem))
        });
        this.dispatchEvent(selectedEvent);
    }

    // Setting up the Page Nos Displayed and whether dots will display
    setPageArray() {
        this.pageNoArray.length = 0;
        if (this.noOfPages <= 4) {
            let pageNo = 1
            while (pageNo <= this.noOfPages) {
                if (this.currentPage == pageNo) {
                    this.pageNoArray.push({ pageNo: pageNo, disable: true, className: 'page active disable', pagename:'Page '+pageNo });
                } else {
                    this.pageNoArray.push({ pageNo: pageNo, disable: false, className: 'page', pagename:'Page '+pageNo });
                }
                pageNo++;
            }
        } else {

            if (this.currentPage != 1) {
                this.pageNoArray.push({ pageNo: 1, disable: false, className: 'page', pagename:'Page 1' });
            }

            if (this.currentPage > 2) {
                this.pageNoArray.push({ pageNo: '...', disable: true, className: 'page disable dot', pagename:'Page ...' });
            }

            if (this.currentPage == this.noOfPages) {
                this.pageNoArray.push({ pageNo: this.currentPage - 1, disable: false, className: 'page', pagename:'Page '+this.currentPage - 1});
            }

            this.pageNoArray.push({ pageNo: this.currentPage, disable: true, className: 'page active disable', pagename:'Page '+ this.currentPage });

            if (this.currentPage == 1) {
                this.pageNoArray.push({ pageNo: this.currentPage + 1, disable: false, className: 'page', pagename:'Page '+ this.currentPage+1 });
            }

            if (this.currentPage < this.noOfPages - 1) {
                this.pageNoArray.push({ pageNo: '...', disable: true, className: 'page disable dot', pagename:'Page ...'});
            }

            if (this.currentPage != this.noOfPages) {
                this.pageNoArray.push({ pageNo: this.noOfPages, disable: false, className: 'page', pagename:'Page '+ this.noOfPages});
            }

        }

        this.isPrevAllowed = (this.currentPage == 1) ? false : true;
        this.isNextAllowed = (this.currentPage == this.noOfPages) ? false : true;
        this.excerptItemsToParent();

    }

    connectedCallback() {
        this.currentPage = 1;
        this.setPageArray();

    }

    // Setting Page on click of Page No
    setPage(event) {
        this.currentPage = parseInt(event.target.dataset.page);
        this.setPageArray();
    }

    // Setting Page on click of Previous
    setPrevPage() {
        this.currentPage -= 1;
        this.setPageArray();
    }

    // Setting Page on click of Next
    setNextPage() {
        this.currentPage += 1;
        this.setPageArray();
    }

}