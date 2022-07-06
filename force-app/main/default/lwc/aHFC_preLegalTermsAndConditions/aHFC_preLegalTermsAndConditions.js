/* Component Name   :    aHFC_preLegalTermsAndConditions
* @Description      :    LWC for sub menu legal terms and conditions for pre login page
* Modification Log  :
* --------------------------------------------------------------------------------------------------------------------------- 
* Developer                          Date                    Description
* ---------------------------------------------------------------------------------------------------------------------------
* Sagar Ghadigaonkar                 Aug 23 2021             LWC for sub menu legal terms and conditions for pre login page
 
* Sagar Ghadigaonkar                 Nov 17 2021             bug fix 21917

*****************************************************************************************************************************/

import { LightningElement, track, wire } from 'lwc';

import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { labels } from "c/aHFC_paymentConstantsUtil";
import { NavigationMixin } from "lightning/navigation";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import AHFC_CutOffTime from "@salesforce/label/c.AHFC_CutOffTime";
import AHFC_Privacy_Policy_PDF from "@salesforce/resourceUrl/AHFC_Privacy_Policy"; //added by sagar bug fix 21917
import basePath from "@salesforce/community/basePath"; //added by sagar bug fix 21917
import {
    CurrentPageReference
} from "lightning/navigation";
import {
    fireEvent
} from 'c/pubsub';


export default class AHFC_postLegalTermsAndConditions extends NavigationMixin(LightningElement) {

    @wire(CurrentPageReference) pageRef;

    @track cutOffTime = AHFC_CutOffTime;
    @track privacyPolicyPdfUrl = AHFC_Privacy_Policy_PDF;
    @track labels = labels;
    @track firstBar = false;
    @track lockedmobile = [];

    /* change in accordian data for differenr header section bug fix for 21917  */
    @track mobileSections = [{
        id: "0",
        // parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest ahfc_parentOpen",
        // class: "slds-is-open slds-accordion__section",
        // contentClass: "slds-accordion__content ahfc_accordionContent",
        // isOpened: true,
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Applicability',
        /*accordionData: [{ id: 0, item: 'The following terms and conditions apply to all American Honda Web Sites that are owned, operated, and maintained by or for American Honda Motor Co., Inc. and its United States subsidiaries and affiliates (“America Honda”) including (1) www.honda.com, www.acura.com and other American Honda websites on which these terms and conditions are linked; (2) American Honda mobile applications; and (3) the social media accounts and/or pages that we control. American Honda websites, applications and social media accounts are collectively referred to in these terms and conditions as the “Site.” ', customClass: 'ahfc_CustomPadding' },
            { id: 1, item: 'These terms and conditions do not apply to: (1) a limited number of American Honda websites that are governed by separate terms and conditions or (2) your interaction with or use of the website of any Honda or Acura dealer. Please also note that this Site contains hyperlinks to a separate www.world.honda.com website that is owned and operated by our parent company, Honda Motor Co., Ltd. to which these terms and conditions do not apply.', customClass: 'ahfc_CustomPadding' }
        ]*/
        accordionData:[{id:0,item:"The following terms and conditions apply to all websites that are owned, operated, and maintained by or for American Honda Finance Corporation and its United States subsidiaries (“we,” “us,” “our”) including (1) honda.americanhondafinance.com, acura.americanhondafinance.com, and other websites on which these terms and conditions are linked; (2) our mobile applications; and (3) the social media accounts and/or pages that we control. Our websites, applications and social media accounts are collectively referred to in these terms and conditions as the “Site.”", customClass: 'ahfc_CustomPadding',containsLink:false},
        { id: 1, item: 'These terms and conditions do not apply to: (1) a limited number of our websites that are governed by separate terms and conditions, (2) websites that are owned and operated by American Honda Motor Co., Inc. (“American Honda”) or its other subsidiaries and affiliates on which separate terms and conditions are linked, or (3) your interaction with or use of the website of any Honda or Acura dealer. Please also note that the Site may contain hyperlinks to a separate world.honda.com website that is owned and operated by Honda Motor Co., Ltd. to which these terms and conditions do not apply.', customClass: 'ahfc_CustomPadding',containsLink:false }]

    },
    {
        id: "1",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'General Provisions',
        accordionData: [
            { id: 0, item: 'THESE TERMS AND CONDITIONS TOGETHER WITH OUR <a href="pricayPolicyUrl" Style="margin-left: 0.4rem;text-decoration: underline;color:#cc0000;">PRIVACY POLICY</a> AND ANY SUPPLEMENTAL TERMS, CONDITIONS, OR RULES POSTED TO A SPECIFIC AREA OF THIS SITE (COLLECTIVELY, “TERMS”) SET FORTH THE LEGALLY BINDING TERMS GOVERNING YOUR USE OF THIS SITE.', customClass: 'ahfc_CustomPadding',containsLink: true},
            { id: 1, item: 'By entering the Site, you acknowledge and agree to all terms, conditions, and rules stated in these Terms. You are not permitted to use the Site if you do not agree to be legally bound by these Terms. Please read these Terms carefully.', customClass: 'ahfc_CustomPadding',containsLink: false},
            { id: 2, item: 'We may, in our sole discretion, modify these Terms from time to time and reserve the right to make changes at any time, without notice or obligation, to any of the content and information contained on the Site, including, but not limited to, automobile financing or leasing products or other product or service features. By entering the Site or continuing your relationship with us after such revisions, you acknowledge and agree that you shall be bound by any such revisions. If we believe, in our sole discretion, that changes to these Terms are material, we will provide notice of the material changes at least 30 days before they become effective by posting a notice on our websites honda.americanhondafinance.com and acura.americanhondafinance.com, sending a notice to recent known users whose email addresses we have on file, and/or through other means. Your failure to send us written notice terminating your relationship with us prior to the effective date of the material changes constitutes your acceptance of the changed Terms.  You should periodically visit this page of the Site to review these Terms.', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 3, item: 'You may only use the Site in compliance with all federal, state, and local laws and regulations.', customClass: 'ahfc_CustomPadding',containsLink: false }
        ]
    },
    {
        id: "2",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Jurisdiction and Governing Law',
        accordionData: [
            { id: 0, item: 'We make no representations that the information and materials contained within the Site are appropriate for locations outside the United States. By entering the Site, you acknowledge and agree that, unless otherwise expressly stated, the Site is intended for use within the United States only by users 16 years of age or older and will only be governed according to the laws of the State of California, without regard to its conflicts of laws principles. If you are not a member of the intended audience, you are not authorized to use the Site. If you use the Site from other locations, you are responsible for compliance with any and all applicable local laws.', customClass: 'ahfc_CustomPadding',containsLink: false }
        ]
    },
    {
        id: "3",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Disclaimer of Warranties',
        accordionData: [
            { id: 0, item: 'The Site, and all information and materials contained herein, is provided to you on an "AS IS" and “AS AVAILABLE” basis, and AT YOUR OWN RISK TO THE FULLEST EXTENT PERMITTED UNDER APPLICABLE LAW. Although we and all parties involved in creating, producing, or delivering the Site make reasonable efforts to ensure that material on the Site is correct, accuracy cannot be guaranteed. WE DISCLAIM, TO THE FULLEST EXTENT PERMITTED BY LAW, ALL WARRANTIES, WHETHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION, ANY IMPLIED WARRANTIES OF TITLE, MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR PURPOSE AND ALL WARRANTIES REGARDING SECURITY, CURRENCY, CORRECTNESS, QUALITY, ACCURACY, COMPLETENESS, RELIABILITY, PERFORMANCE, TIMELINESS, OR CONTINUED AVAILABILITY WITH RESPECT TO THE SITE. We expressly disclaim, to the fullest extent permitted by applicable law, any warranties with respect to any downtime, delays, or errors in the transmission or delivery of any information, materials, or services through the Site. To the extent any jurisdiction does not allow the exclusion of certain warranties, some of the above exclusions do not apply.', customClass: 'ahfc_CustomPadding',containsLink: false }
        ]
    },
    {
        id: "4",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'General Product, Services, and Financing Information',
        accordionData: [{ id: 0, item: 'The Site provides information, including, but not limited to, specific product pricing, product specifications, used car values, service contracts, budget calculators, financial calculators, current financing offers, and basic company information for informational purposes only and nothing contained herein constitutes financial advice or an offer to sell, finance, or lease a specific product or service to you unless otherwise expressly acknowledged and apparent from the particular content.', customClass: 'ahfc_CustomPadding',containsLink: false },
                        { id: 1, item: 'Our financial calculators’ estimated payments exclude applicable taxes, title, registration, license, and documentary fees. The current finance or lease options are offered only on approved credit through us, may not be available in all areas of the United States, and not all Honda and Acura dealers may participate in these programs. Current offers do not constitute an offer of direct financing or of any lease or purchase transaction. Rates and requirements vary based on geographic location and credit worthiness. For example, lease rates and payments may be higher for customers and dealers in New York State compared to the national average. Financial calculators linked from the Site but provided by third parties, including American Honda, may have different assumptions and you should carefully review the information provided by such third parties prior to using their calculators.', customClass: 'ahfc_CustomPadding',containsLink: false },
                        { id: 2, item: 'The Site shall not be used or relied upon by you as a substitute for information that is available to you from a third-party advisor or from an authorized Honda or Acura dealer.', customClass: 'ahfc_CustomPadding',containsLink: false }
                        
            
           /* { id: 1, item: `The MSRPs (manufacturer's suggested retail price) listed on this Site exclude tax, title, license, registration, destination charge, options and any dealer documentary fees. Dealers set actual prices. All trade-in values obtained from Kelley Blue Book are estimates and the actual value of the vehicle may be higher or lower depending upon the condition of your vehicle, equipment and local market conditions. For some newer models, Kelley Blue Book may not have enough data to provide a trade-in value. `, customClass: 'ahfc_CustomPadding' },
            { id: 2, item: 'Our financial calculators’ estimated payments exclude applicable taxes, title, registration, license, and documentary fees. The current finance or lease options are offered only on approved credit through us, may not be available in all areas of the United States, and not all Honda and Acura dealers may participate in these programs. Current offers do not constitute an offer of direct financing or of any lease or purchase transaction. Rates and requirements vary based on geographic location and credit worthiness. For example, lease rates and payments may be higher for customers and dealers in New York State compared to the national average. Financial calculators linked from the Site but provided by third parties, including American Honda, may have different assumptions and you should carefully review the information provided by such third parties prior to using their calculators.', customClass: 'ahfc_CustomPadding' },
            { id: 3, item: 'This Site also posts certified used car inventories provided from individual authorized Honda and Acura certified used car dealers. You acknowledge that American Honda is neither responsible nor guarantees the accuracy of any information provided and that all vehicles are subject to prior sale. You understand that dealers set their own prices, all prices and specifications are subject to change without notice, and prices may not include additional fees such as government fees and taxes, title and registration fees, finance charges, dealer document preparation fees, processing fees, and emission testing and compliance charges.', customClass: 'ahfc_CustomPadding' },
            { id: 4, item: 'As a result, this Site shall not be used or relied upon by you as a substitute for information that is available to you from a third party advisor or from an authorized Honda or Acura dealer.', customClass: 'ahfc_CustomPadding' }*/
        ]
    },
    {
        id: "5",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Our Intellectual Property', //American Honda’s Intellectual Property
        accordionData: [{ id: 0, item: 'We will aggressively enforce our intellectual property rights to the fullest extent of the law. All images, text, sound, photos, custom graphics, button icons, the collection and compilation and assembly thereof, and the overall “look and feel” and distinctiveness of the Site constitute trade dress and are either our property or used on the Site with permission. The absence on the Site of our name or logo does not constitute a waiver of our trademark or other intellectual property rights relating to such name or logo. All other product names, company names, marks, logos, and symbols appearing on the Site may be the trademarks and the property of their respective owners.', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 1, item: 'You acknowledge and agree that information, and services available on the Site are protected by copyrights, trademarks, service marks, patents, trade secrets, or other proprietary rights and laws and are owned or licensed by us. Except as expressly authorized by us, either in these Terms or elsewhere, you agree not to sell, license, rent, modify, distribute, copy, reproduce, transmit, publicly display, publicly perform, publish, adapt, edit, or create derivative works from the Site, information, or services. Without waiving any of the foregoing rights, you may print or download information or products from the Site for your own personal, non-commercial home use, provided that you keep intact all copyright and other proprietary notices. Systematic retrieval of information or services from the Site to create or compile, directly or indirectly, a collection, compilation, database, or directory without written permission from us is prohibited.', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 2, item: 'Honda Financial Services and Acura Financial Services are DBAs of American Honda Finance Corporation. Acura Financial Services, Acura Care, Acura Care Maintenance, Acura Luxury Lease, Acura Loyalty Advantage, Leadership Leasing, Honda Financial Services, Honda Care, Hondacare Protection Plan, Honda Care Maintenance, Honda Care Sentinel, Leadership Purchase Plan, iDeal, EasyPay, VIPS, Maintenance Minder, Momentum Miles, Mileage Forgiveness, Acura, Honda, the H-mark symbol, and the stylized “A” logo are trademarks of Honda Motor Co., Ltd. All rights reserved. American Honda Motor Co., Inc. is the copyright owner of the “Applying Online” content.', customClass: 'ahfc_CustomPadding',containsLink: false }

        ]
    },
    {
        id: "6",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'General Submissions',
        accordionData: [{ id: 0, item: 'You agree that you will not post on the Site, or transmit to the Site, any pornographic, obscene, profane, defamatory, libelous, threatening, unlawful, objectionable, discriminatory, or other material that could constitute or encourage conduct that would be considered a criminal offense, give rise to civil liability, or otherwise violate any law or regulation. Notwithstanding the fact that we or other parties involved in creating, producing, or delivering the Site, may monitor or review transmissions, postings, discussions, or chats, we and all parties involved in creating, producing, or delivering the Site, assume no responsibility or liability that may arise from the content thereof, including, but not limited to, claims for defamation, libel, slander, obscenity, pornography, profanity, or misrepresentation. By entering the Site you acknowledge and agree that any communication or material you transmit to this Site or to us in any manner and for any reason is subject to review and removal, and will not be treated as confidential and/or proprietary to you, unless otherwise expressly stated in a particular area of the Site or in our Privacy Policy (such as information submitted for access to your Honda Financial Services or Acura Financial Services account). Furthermore, you acknowledge and agree that any ideas, questions, concepts, techniques, procedures, methods, systems, designs, plans, charts, or other materials you transmit to us may be distributed, published, modified, edited, or otherwise used by us anywhere, anytime, and for any reason whatsoever, commercial or otherwise, without any acknowledgement of or compensation to you.', customClass: 'ahfc_CustomPadding' ,containsLink: false},
            { id: 1, item: 'Some areas on the Site may allow you to submit personal photos. The general purpose of such submissions is to provide a visual and textual representation of your American Honda product. We suggest you attach a high-quality photo of your product and provide an accurate, textual description that is both clear and relevant. You understand that not all types of photos are appropriate for use and all photos submitted are subject to review and removal. The following is a list of general photo restrictions:', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 2, item: '• Photos cannot be sexually explicit or suggestive, unnecessarily violent, or derogatory of any ethnic, racial, gender, religious, professional or age group, profane or pornographic, or contain nudity;', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 3, item: '• Photos cannot promote alcohol, illegal drugs, tobacco, firearms/weapons (or the use of any of the foregoing), any activities that may appear unsafe or dangerous, or any political agenda or message;', customClass: 'ahfc_CustomPadding' ,containsLink: false},
            { id: 4, item: '• Photos cannot be obscene, offensive, or endorse any form of hate or hate group;', customClass: 'ahfc_CustomPadding' },
            { id: 5, item: '• Photos cannot defame, misrepresent, or contain disparaging remarks about American Honda or its products, or other people, products, or companies;', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 6, item: '• Photos cannot contain trademarks, logos or trade dress owned by others, or advertise or promote any brand or product of any kind other than Honda or Acura, without permission, or contain any personal identification, such as license plate numbers, personal names, e-mail addresses or street addresses;', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 7, item: '• Photos cannot contain copyrighted materials owned by others (including photographs, sculptures, paintings and other works of art or images published on or in websites, television, movies, or other media) without permission;', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 8, item: '• Photos cannot contain materials embodying the names, likenesses, photographs, or other indicia identifying any person, living or dead, without permission;', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 9, item: '• Photos cannot communicate messages or images inconsistent with the positive images and/or goodwill to which we or American Honda wishes to associate; and', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 10, item:'• Photos cannot depict a violation, and cannot themselves, be in violation of any law.',customClass: 'ahfc_CustomPadding' },
            { id: 11, item: 'By submitting a photo, you acknowledge that your photo may be posted on the Site, at our discretion. We reserve the right to, and may or may not, monitor/screen photos prior to posting them to the Site.', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 12, item: 'By submitting a photo, you acknowledge that we have no obligation to use or post any photo you submit.', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 13, item: 'By submitting a photo you warrant and represent that: (a) it is your original work and accurately reflects your experience with your product and that depictions are known to be true and are based upon your use of your product; (b) it has not been previously published; (c) it has not received previous awards; (d) it does not infringe upon the copyrights, trademarks, rights of privacy, publicity, or other intellectual property or other rights of any person or entity; (e) you have obtained permission from a person whose name, likeness, or voice is used in the photo (if any); (f) publication of the photo via various media, including Web posting, will not infringe on any third party rights; and (g) you will indemnify and hold harmless both us and any parties involved in creating, producing, or delivering the photo submission from any claims to the contrary.', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 14, item: 'By submitting a photo, you agree that your submission is gratuitous, made without restriction, will not place us under any obligation, and that we are free to disclose or otherwise disclose the ideas contained in the photo on a non-confidential basis to anyone or otherwise use the ideas without any additional compensation to you.', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 15, item: 'You understand that submitting a photo grants us and our agents an unlimited worldwide perpetual license and right to publish and use the photo in any way, in any and all media, without limitation, and without consideration to you. You acknowledge that, by acceptance of your submission, we do not waive any rights to use similar or related ideas previously known to us, or developed by our employees, or obtained from sources other than you.', customClass: 'ahfc_CustomPadding',containsLink: false }
        ]
    },
    {
        id: "7",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Digital Millennium Copyright Act Notice',
        accordionData: [{ id: 0, item: 'Copyright Infringement Notification', customClass:'ahfc_bold', divOrSpan: true,containsLink: true },
            { id: 1, item: 'We are committed to complying with U.S. copyright law and to respond to claims of copyright infringement. We will promptly process and investigate notices of alleged infringement and will take appropriate actions under the Digital Millennium Copyright Act, Title 17, United States Code, Section 512(c) (“DMCA”).', customClass: 'ahfc_CustomPadding ahfc_TopPadding',containsLink: false},
            {
                id: 2,
                item: 'If you are an intellectual property rights holder and believe your rights have been infringed, please read the following. Pursuant to the DMCA, notifications of claimed copyright infringement should be sent to our Designated Agent. Notification must be submitted to the following Designated Agent for this site in the matter described below:',
                customClass: ' ahfc_CustomPadding',
                containsLink: false
            },
            { id: 3, item: 'By Mail: DMCA Agent, 700 Van Ness Ave, Torrance, CA 90501',containsLink: false },
            { id: 4, item: 'By Email: dmca@hpt.honda.com',containsLink: false},
            { id: 5, item: 'Phone: (310) 781-4900', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 6, item: 'For your complaint to be valid under the DMCA, you must provide all of the following information when providing notice of the claimed copyright infringement:', customClass: 'ahfc_CustomPadding' ,containsLink: false},
            { id: 7, item: '1.	A physical or electronic signature of a person authorized to act on behalf of the copyright owner;',containsLink: false },
            { id: 8, item: '2.	Identification of the copyrighted work claimed to have been infringed;',containsLink: false },
            { id: 9, item: '3.	Identification of the material that is claimed to be infringing or to be the subject of the infringing activity, and that is to be removed or access to which is to be disabled, as well as information reasonably sufficient to permit us to locate the material;',containsLink: false },
            { id: 10, item: '4.	Information reasonably sufficient to permit us to contact the copyright owner, such as an address, telephone number, and, if available, an electronic mail address;',containsLink: false },
            { id: 11, item: '5.	A statement that you have a good faith belief that use of the material in the manner complained of is not authorized by the copyright owner, its agent, or law; and' ,containsLink: false},
            { id: 12, item: '6.	A statement that the information in the notification is accurate, and under penalty of perjury, that you are authorized to act on behalf of the copyright owner.',customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 13, item: 'For more details on the information required for valid notification, see 17 U.S.C. § 512(c)(3).', customClass: 'ahfc_CustomPadding',containsLink: false },
            { id: 14, item: 'You should be aware that, under the DMCA, claimants who make misrepresentations concerning copyright infringement may be liable for damages incurred as a result of the removal or blocking of the material, court costs, and attorney fees.', customClass: 'ahfc_CustomPadding',containsLink: false }
        ]
    },
    {
        id: "8",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Limitation of Liability',
        accordionData: [
            { id: 0, item: 'IN NO EVENT WILL WE OR OUR AFFILIATES, SUBSIDIARIES, OFFICERS, DIRECTORS, OWNERS, EMPLOYEES, OR AGENTS BE LIABLE FOR ANY DIRECT, INDIRECT, CONSEQUENTIAL, EXEMPLARY, SPECIAL, INCIDENTAL, OR PUNITIVE DAMAGES OR LOST REVENUE, LOST PROFITS, LOST DATA, LOSS OF GOODWILL/REPUTATION, OR LOST ANTICIPATED BUSINESS (EVEN IF WE HAVE BEEN ADVISED OF OR COULD HAVE ANTICIPATED THE POSSIBILITY OF SUCH DAMAGES) ARISING FROM OR RELATING TO THESE TERMS OR THIS SITE, REGARDLESS OF THE FORM OF ACTION OR THEORY OF LIABILITY. OUR AGGREGATE LIABILITY FOR ANY LIABILITIES, LOSSES, COSTS, DAMAGES, AND EXPENSES ASSOCIATED WITH ANY CLAIM OR ACTION RELATED TO, IN CONNECTION WITH, OR ARISING UNDER THESE TERMS OR THE SITE, REGARDLESS OF THE FORM OF ACTION OR THEORY OF LIABILITY, WILL NOT EXCEED FIFTY DOLLARS ($50). TO THE EXTENT A JURISDICTION DOES NOT ALLOW THE LIMITATION OF SOME LIABILITIES, SOME OF THE ABOVE EXCLUSIONS MAY NOT APPLY TO YOU.', customClass: 'ahfc_CustomPadding',containsLink: false }
        ]
    },
    {
        id: "9",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Dispute Resolution',
        accordionDataStr1:'',
        accordionDataStr2:'',
        accordionData: [
            { id: 0, item:'Any controversy, claim or dispute arising out of or related to these Terms or the Site, including, but not limited to, alleged violations of state or federal statutory or common law rights or duties (a “Dispute”) shall be solely and exclusively resolved according to the procedures set forth in this paragraph. If the parties are unable to resolve any Dispute through informal means, either party may initiate binding arbitration of such Dispute by sending notice demanding arbitration to the other party. The demand for arbitration shall be made within a reasonable time after the Dispute has arisen, but in no event shall it be made more than one year from when the aggrieved party knew or should have known of the controversy, claim, or facts forming the basis of the Dispute. The arbitration shall be initiated and conducted according to American Arbitration Association rules and procedures for consumer arbitration (the “Arbitration Rules”), including its provisions permitting Disputes falling within the jurisdiction of small claims court to be filed in small claims court. The arbitration shall be conducted in Los Angeles County, California before a single neutral arbitrator appointed in accordance with the Arbitration Rules with the option to appeal the arbitrator’s decision to an Optional Appellate Arbitration in accordance with the Arbitration Rules. Disputes with an amount in controversy under $10,000 will be decided by the arbitrator solely upon written submissions without a hearing. To the fullest extent permitted by law, the arbitrator shall not have the power to award punitive, special, exemplary, consequential, incidental, or indirect damages against any party. Arbitration costs and fees shall be determined in accordance with the Arbitration Rules. Attorneys’ fees shall be borne by each party independently and no party shall be liable for the attorneys’ fees of the other party. No disputes may be arbitrated on a class or representative basis and the arbitrator may not consolidate or join the claims of other persons or parties who may be similarly situated. BY AGREEING TO THESE TERMS, EACH PARTY IRREVOCABLY WAIVES ANY RIGHT IT MAY HAVE TO JOIN CLAIMS OR DISPUTES WITH THOSE OF OTHERS IN THE FORM OF A CLASS ACTION, CLASS ARBITRATION OR SIMILAR PROCEDURAL DEVICE; AND WAIVES ANY RIGHT IT MAY HAVE TO PRESENT ITS CLAIM OR DISPUTE IN A COURT OF LAW. Judgment on the award rendered by the arbitrator(s), if any, may be entered for enforcement purposes in any court having jurisdiction thereof. Subject to the dispute resolution process described above, all claims, disputes, and suits (including Disputes filed in small claims court pursuant to the Arbitration Rules) must be brought solely in the state or federal courts located in Los Angeles County, California, and you agree to the jurisdiction thereof.', customClass: 'ahfc_CustomPadding' ,containsLink: false},
        ]
    },
    {
        id: "10",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Indemnity',
        accordionData: [
            { id: 0, item: `You agree to defend, indemnify, and hold us, our affiliates, subsidiaries, joint ventures, third-party service providers, employees, contractors, agents, owners, officers, and directors harmless from any and all liability, claims, and expenses (including reasonable attorneys' fees) that arise out of or are related to your violation of these Terms or use of the Site.`, customClass: 'ahfc_CustomPadding',containsLink: false }
        ]
    },
    {
        id: "11",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Force Majeure',
        accordionData: [
            { id: 0, item: 'We will be excused from failures or delays in delivery or performance of the Site if such failure or delay is attributable to causes beyond our reasonable control such as weather, acts of God, natural disaster, war, terrorist attack, disease, epidemic/pandemic, criminal activity, riot, civil unrest, strike, or utility failure.', customClass: 'ahfc_CustomPadding' ,containsLink: false}
        ]
    },
    {
        id: "12",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Sweepstakes',
        accordionData: [
            { id: 0, item: 'The Site offers sweepstakes from time to time. While no purchase is necessary to enter any such sweepstakes, you agree to comply with the official rules of the relevant sweepstakes advertised on the Site. Please do not enter if you are not a permanent resident of the eligible geographic area, or if you are otherwise ineligible as set forth in the sweepstakes’ official rules. Entries received from persons residing outside of the eligible geographic areas, from other persons otherwise ineligible, or where restricted or prohibited by law will be disqualified.', customClass: 'ahfc_CustomPadding' ,containsLink: false}
        ]
    },
    {
        id: "13",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Careers',
        accordionData: [
            { id: 0, item: 'The Site contains a link to job opening information on a website maintained by American Honda Motor Co., Inc., which includes a means for you to apply and submit your resume. You understand that nothing contained on that site constitutes an offer of employment by any American Honda entity.', customClass: 'ahfc_CustomPadding' ,containsLink: false}
        ]
    },
    {
        id: "14",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Privacy & Security',
        accordionData: [
            { id: 0, item: 'Our Privacy Policy is incorporated into these Terms. You acknowledge and agree that your use of the Site constitutes consent to the data collection, use, and disclosure practices described in our Privacy Policy. To access portions of the Site, you are required to obtain a username and/or password. You agree that you will not register under the name of another person, choose a username that is vulgar, profane, or otherwise offensive, choose a username that impersonates or suggests representation of another person or entity, or choose a username that includes a solicitation. You are responsible for maintaining the confidentiality of any such username or password and are fully responsible for all activities that occur under such username and password. You understand that you can help protect your username, password, and personal information by logging out of password protected webpages before you close your browser. You agree to notify us immediately of any unauthorized use of your username or password. We will never ask for your password. We maintain exclusive control of access and right of access to the Site. You understand and agree that we reserve the right to revoke your registration to or use of the Site at any time without notice or cause of action for any reason whatsoever.', customClass: 'ahfc_CustomPadding',containsLink: false}
        ]
    },
    {
        id: "15",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'User Data',
        accordionData: [
            { id: 0, item: 'We may retain certain data that you transmit in connection with the Site for purposes of managing the Site and providing the Site to you, to manage our business and the products and services we provide, or for any other purposes outlined in our Privacy Policy. We do not warrant that we will retain your data for any period of time or at all. You should retain copies and backups of all data you provide to us.', customClass: 'ahfc_CustomPadding',containsLink: false }
        ]
    },
    {
        id: "16",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Account Profile & Payments',
        accordionData: [
            { id: 0, item: 'Any changes to your Honda Financial Services or Acura Financial Services account profile will be reflected on your account within one (1) business day. For lease accounts, an address change may affect the type and amount of tax you pay and your monthly payment. Our online payment features, including EasyPay for recurring payments, allow you to electronically pay bills including but not limited to your scheduled monthly payment, NSF fees, and property taxes. If you choose to set up this feature, the EasyPay Enrollment Process Terms and Conditions will apply in addition to these Terms.', customClass: 'ahfc_CustomPadding',containsLink:false },
            { id: 1, item: 'You acknowledge that any payment transacted electronically after 2:00 p.m. PT (Pacific Time) or on a non-business day will be processed the following business day. Business Day as used means any day other than a Saturday or Sunday, that is not a legal holiday or a day on which commercial banks are authorized, or required by law, regulation, or executive order to close. Payments will be posted to your account within 1-2 business days.', customClass: 'ahfc_CustomPadding',containsLink:false },
        ]
    },
    {
        id: "17",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Links',
        accordionData: [
            { id: 0, item: 'The Site may contain links to or be accessed through links that are owned and operated by independent third parties, such as authorized Honda and Acura dealers and American Honda, to which these Terms do not apply. We provide links as a convenience and the inclusion of the link does not imply that we endorse or accept any responsibility for the content on those sites. We are not responsible for content including but not limited to advertising claims, special offers, illustrations, names or endorsement, or the availability, operation, or performance of authorized Honda and Acura dealers or any other sites to which our Site may be linked to or from which our Site may be accessed. Further, we are not, directly or indirectly, implying any approval, association, sponsorship, endorsement, or affiliation with the linked site, unless specifically stated therein. Your linking to any other off-site pages or other sites is at your own risk. We recommend that you review any terms of use statement and privacy policy before using any other linked site.', customClass: 'ahfc_CustomPadding',containsLink:false }
        ]
    },
    {
        id: "18",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Miscellaneous',
        accordionData: [
            { id: 0, item: 'The Terms constitute the entire agreement and understanding between you and us as to the subject matter hereof. Our failure to exercise or enforce any right or provision of the Terms will not operate as a waiver of such right or provision. If any provision of the Terms is determined to be unlawful, void, or unenforceable, the parties intend that the offending provision be modified to the minimum extent necessary to be lawful and enforceable. Portions of the Terms which by their nature would survive termination of your use of the Site (e.g., disclaimer of warranties, limitation of liability, indemnification) will be deemed to survive. Headings are provided as a convenience and should not be used as interpretive aids. The Terms do not create any joint venture, partnership, employment, or agency relationship between the parties. You agree that ambiguities in the Terms will not be construed against us by attribution of drafting. We may assign any of our rights or obligations to others at any time without notice to you. You may not assign any of your rights or obligations to others without our prior written consent.', customClass: 'ahfc_CustomPadding',containsLink:false }
        ]
    },
    {
        id: "19",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'License',
        accordionData: [
            { id: 0, item: 'Loans will be arranged or made pursuant to a Department of Corporations California Finance Lenders License. CFL License Nos. 6031969, 6031970, 6051562.', customClass: 'ahfc_CustomPadding',containsLink:false },
        ]
    },
    {
        id: "20",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        header: 'Contact Information',
        accordionData: [
           /* { id: 0, item: '(800) 999-1009', customClass: 'ahfc_CustomPadding' },
            { id: 1, item: 'LAST UPDATED: February 17, 2017', customClass: 'ahfc_CustomPadding' },*/
            { id: 0, item: 'American Honda Finance Corporation, 1919 Torrance Blvd., Torrance, CA 90501.', customClass: 'ahfc_CustomPadding',containsLink:false },
            { id: 1, item: "If you have any questions, please <a href='contactUsPageUrl' target='_self' Style='margin-left: 0.4rem;text-decoration: underline;color:#cc0000;'>Contact Us</a>", customClass: 'ahfc_CustomPadding',containsLink: true }
        ]
    }
    /*,{
        id: "17",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        containsLink:false,
        header: 'Specific Website Provisions',
        accordionData: [
            { id: 0, item: 'This section addresses this Site’s unique functionality and offerings specific to particular areas of this Site and serves as a supplement to the General Provisions above.', customClass: 'ahfc_CustomPadding' },
            { id: 1, item: 'powersports.honda.com', customClass: ''},
            { id: 2, item: 'powerequipment.honda.com', customClass: ''},
            { id: 3, item: 'owners.honda.com and owners.acura.com',customClass: ''},
            { id: 4, item: 'hondafinancialservices.com', customClass: ''},
            { id: 5, item: 'hondafinancialservices.com/ir', customClass: ''},
            { id: 6, item: 'acurafinancialservices.com', customClass: ''},
            { id: 7, item: 'greendealer.honda.com', customClass: 'ahfc_CustomPadding'},
        ]
    },
    {
        id: "18",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        containsLink:false,
        header: 'powersports.honda.com',
        accordionData: [
            { id: 0, item: 'Honda Card', customClass: 'ahfc_CustomPadding ahfc_bold' },
            { id: 1, item: 'The Honda Card program sponsored by Honda Card and GE Capital Consumer Card Company and the revolving charge card is only valid for the purchase of Honda motorcycle-, ATV-, scooter- or personal watercraft-related items at participating Dealers.  See the Honda Card Online Credit Pre-approval Web pages and the cardholder application/agreement for more details at www.powersports.honda.com.', customClass: 'ahfc_CustomPadding' },
            { id: 2, item: 'offroad.honda.com', customClass: 'ahfc_CustomPadding ahfc_bold' },
            { id: 3, item: 'Photo disclaimer.  All riders shown on established trails in approved riding areas.', customClass: 'ahfc_CustomPadding' },
            { id: 4, item: 'Where to Ride Trail Locator', customClass: 'ahfc_CustomPadding ahfc_bold' }, 
            { id: 5, item: 'Offroad.honda.com provides trail information for reference purposes only.  American Honda does not endorse the safety or conditions of any trails identified on this Site and you acknowledge that there are inherent risks, dangers, and hazards associated with riding mechanical equipment and that you are responsible for your own safety.  American Honda is not responsible for any property damage, personal injury, death or loss that may occur to any property, you or others while making use of referenced trails.  American Honda is not responsible for any inaccuracies or errors in the referenced trail locations.  All trail locations are approximate locations.  All trail difficulty and/or riding skill ratings are listed as suggested guidelines only and will vary based on conditions and rider ability.  Contact the local trail administrator, governing body, or local authorities for updated trail information before you go. ', customClass: 'ahfc_CustomPadding' },
            { id: 6, item: 'Honda Riding Education Centers', customClass: 'ahfc_CustomPadding ahfc_bold'},
            { id: 7, item: 'Offroad.honda.com allows you to request a Motorcycle Safety Foundation Dirtbike  School class and submit your preferred date for participation.  You acknowledge that this submission does not guarantee your preferred date at the particular location and you must schedule dates with a representative of the selected location.', customClass: 'ahfc_CustomPadding' },
        ]
    },
    {
        id: "19",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        containsLink:false,
        header: 'powerequipment.honda.com',
        accordionData: [
            { id: 0, item: 'Honda Power Equipment Credit Card', customClass: 'ahfc_CustomPadding ahfc_bold' },
            { id: 1, item: 'The Honda Power Equipment Credit Card program sponsored by Honda Power Equipment and Wells Fargo Financial National Bank. Wells Fargo issues the card.  See the Honda Power Equipment Credit Card Online Credit Web pages and the cardholder application/agreement for more details.', customClass: 'ahfc_CustomPadding' },
        ]
    },
    {
        id: "20",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        containsLink:false,
        header: 'owners.honda.com and owners.acura.com',
        accordionData: [
            { id: 0, item: 'Honda Owners and Acura Owners sites generally', customClass: 'ahfc_CustomPadding ahfc_bold' },
            { id: 1, item: 'The Honda Owners/Acura Owners sites allow users to create a Honda ID/Acura ID and Password to gain access to your account and vehicle information, although it is not required for access to the site itself.  You are responsible for maintaining the confidentiality of your Honda ID/Acura ID and Password, and you are fully responsible for all activities that occur under your Honda ID/Acura ID and Password.  We reserve the right to terminate your Honda ID/Acura ID and/or Password for use on this site for any reason, with or without prior notice.  More details are available within site "Help”.', customClass: 'ahfc_CustomPadding' },
            { id: 2, item: 'Vehicle Information', customClass: 'ahfc_CustomPadding ahfc_bold' },
            { id: 3, item: 'Service records may include manually entered information and data derived from authorized Honda and Acura dealers. American Honda has not independently verified such information and does not guarantee its accuracy.', customClass: 'ahfc_CustomPadding' },
            { id: 4, item: 'Financial Account Profile', customClass: 'ahfc_CustomPadding ahfc_bold' },
            { id: 5, item: 'Any changes to your Honda Financial Services or Acura Financial Services account profile will be reflected on your account within one (1) business day.  For lease accounts, an address change may affect the type and amount of tax you pay and your monthly payment.  The Easy Pay online feature allows you to electronically pay bills including but not limited to your scheduled monthly payment, NSF fees, and property taxes. If you choose to set up this feature, the AHFC Easy Pay Enrollment Process Terms and Conditions will apply in addition to these Terms.  You acknowledge that any payment transacted after 5:00 p.m. PT (Pacific Time) or on a non-business day will be posted the following business day.  Business Day as used means any day other than a Saturday or Sunday, that is not a legal holiday or a day on which commercial banks are authorized, or required by law, regulation or executive order to close.', customClass: 'ahfc_CustomPadding' },
            { id: 6, item: 'eStore', customClass: 'ahfc_CustomPadding ahfc_bold' },
            { id: 7, item: 'eStore is developed and supported by American Honda to assist consumers in purchasing Genuine Honda & Acura Parts and Accessories directly from their local participating Honda & Acura dealer, using the convenience of the internet.  You understand that when you purchase an item on eStore, you are purchasing from one of hundreds of participating Honda or Acura Dealers and not from American Honda. Each participating Honda or Acura Dealer determines their own pricing and from time to time may offer discounts on select items.', customClass: 'ahfc_CustomPadding' },
        ]
    },
    {
        id: "21",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        containsLink:false,
        header: 'hondafinancialservices.com',
        accordionData: [
            { id: 0, item: 'Honda Financial Services is a DBA of American Honda Finance Corporation. Honda Financial Services, Honda Care, Hondacare Protection Plan, Honda Care Maintenance, Honda Care Sentinel, Leadership Leasing, Leadership Purchase Plan, iDeal, EasyPay, VIPS, Maintenance Minder, Honda, and the H-mark symbol are trademarks of Honda Motor Co., Ltd. All rights reserved.', customClass: 'ahfc_CustomPadding' },
            { id: 1, item: 'All other trademarks are the property of their respective owners.', customClass: 'ahfc_CustomPadding' },
            { id: 2, item: 'American Honda Finance Corporation is the copyright owner of hondafinancialservices.com. American Honda Motor Co., Inc. is the copyright owner of the “Applying Online” content, a feature of hondafinancialservices.com. No portion of this site, including but not limited to the text, images, audio or video, may be used in any manner, for any purpose without the express written permission, except as provided herein. Without waiving any of the above rights, you may download a copy of the material on this site for your personal, non-commercial home use only, provided you do not delete or change any copyright, trademark or other proprietary notice.', customClass: 'ahfc_CustomPadding' },
            { id: 3, item: 'This site allows you to choose a Honda ID and Password to gain access to your account and vehicle information. You are responsible for maintaining the confidentiality of your Honda ID and Password, and you are fully responsible for all activities that occur under your Honda ID and Password. We reserve the right to terminate your Honda ID and/or Password for use on this site for any reason, with or without prior notice.', customClass: 'ahfc_CustomPadding' },
            { id: 4, item: 'Any changes to your Honda Financial Services account profile will be reflected on your account within one (1) business day. For lease accounts, an address change may affect the type and amount of tax you pay and your monthly payment. The Easy Pay online feature allows you to electronically pay bills including but not limited to your scheduled monthly payment, NSF fees, and property taxes. If you choose to set up this feature, the AHFC Easy Pay Enrollment Process Terms and Conditions will apply in addition to these Terms.', customClass: 'ahfc_CustomPadding' },
            { id: 5, item: 'You acknowledge that any payment transacted after ' + this.cutOffTime + ' (Pacific Time) or on a non-business day will be posted the following business day. Business Day as used means any day other than a Saturday or Sunday, that is not a legal holiday or a day on which commercial banks are authorized, or required by law, regulation or executive order to close.', customClass: 'ahfc_CustomPadding' },
        ]
    },
    {
        id: "22",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        containsLink:false,
        header: 'hondafinancialservices.com/ir',
        accordionData: [
            { id: 0, item: 'You may obtain investor relations information without providing personally identifiable information.', customClass: 'ahfc_CustomPadding' },
        ]
    },
    {
        id: "23",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        containsLink:false,
        header: 'acurafinancialservices.com',
        accordionData: [
            { id: 0, item: 'Acura Financial Services is a DBA of American Honda Finance Corporation. Acura Financial Services, Acura Care, Acrua Care Maintenance, Acura Luxury Lease, Acura Loyalty Advantage, Leadership Purchase Plan, Momentum Miles, Mileage Forgiveness, iDeal, EasyPay, VIPS, Acura, and the stylized "A" logo are trademarks of Honda Motor Co., Ltd. All rights reserved.', customClass: 'ahfc_CustomPadding' },
            { id: 1, item: 'All other trademarks are the property of their respective owners.', customClass: 'ahfc_CustomPadding' },
            { id: 2, item: 'American Honda Finance Corporation is the copyright owner of acurafinancialservices.com. American Honda Motor Co., Inc. is the copyright owner of the “Applying Online” content, a feature of acurafinancialservices.com. No portion of this site, including but not limited to the text, images, audio or video, may be used in any manner, for any purpose without the express written permission, except as provided herein. Without waiving any of the above rights, you may download a copy of the material on this site for your personal, non-commercial home use only, provided you do not delete or change any copyright, trademark or other proprietary notice.', customClass: 'ahfc_CustomPadding' },
            { id: 3, item: 'This site allows you to choose an Acura ID and Password to gain access to your account and vehicle information. You are responsible for maintaining the confidentiality of your Acura ID and Password, and you are fully responsible for all activities that occur under your Acura ID and Password. We reserve the right to terminate your Acura ID and/or Password for use on this site for any reason, with or without prior notice.', customClass: 'ahfc_CustomPadding' },
            { id: 4, item: 'Any changes to your Acura Financial Services account profile will be reflected on your account within one (1) business day. For lease accounts, an address change may affect the type and amount of tax you pay and your monthly payment. The Easy Pay online feature allows you to electronically pay bills including but not limited to your scheduled monthly payment, NSF fees, and property taxes. If you choose to set up this feature, the AHFC Easy Pay Enrollment Process Terms and Conditions will apply in addition to these Terms.', customClass: 'ahfc_CustomPadding' },
            { id: 5, item: 'You acknowledge that any payment transacted after ' + this.cutOffTime + ' (Pacific Time) or on a non-business day will be posted the following business day. Business Day as used means any day other than a Saturday or Sunday, that is not a legal holiday or a day on which commercial banks are authorized, or required by law, regulation or executive order to close.', customClass: 'ahfc_CustomPadding' },
        ]
    },
    {
        id: "24",
        parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
        class: "slds-accordion__section",
        contentClass: "slds-accordion__content",
        isOpened: false,
        containsLink:false,
        header: 'greendealer.honda.com',
        accordionData: [
            { id: 0, item: 'Honda Green Dealer', customClass: 'ahfc_CustomPadding ahfc_bold' },
            { id: 1, item: 'Email Newsletters', customClass: 'ahfc_CustomPadding ahfc_bold'},
            { id: 2, item: 'You may decide that you wish to sign up to receive email newsletters on Honda environmentally responsible products & technology, “green dealer” guideline updates, and/or other site features. In doing so, you will be required to provide your email address and occupation, and asked to submit your first name, last name, country of origin, and organization. Requesting email newsletters and providing your personal information is your choice.', customClass: 'ahfc_CustomPadding', divOrSpan: true },
            { id: 3, item: ' ', customClass: 'ahfc_bold ahfc_CustomPadding', divOrSpan: false },
            { id: 4, item: 'Download the “Green Dealer” Guide', customClass: 'ahfc_CustomPadding ahfc_bold'},
            { id: 5, item: 'You may download the “green dealer” guideline. In doing so, you will be required to provide your email address and occupation, and asked to submit your first name, last name, country of origin, and organization before your download begins. Downloading the “green dealer” guideline and providing your personal information is your choice.', customClass: 'ahfc_CustomPadding', divOrSpan: true },
            { id: 6, item: ' ', customClass: 'ahfc_bold ahfc_CustomPadding', divOrSpan: false },
            { id: 7, item: 'Locate a “Green Dealer” & “Green Dealers” by Award Level', customClass: 'ahfc_CustomPadding ahfc_bold'},
            { id: 8, item: 'Dealerships referenced herein are Honda and Acura dealers, which are independent from American Honda. Visiting these dealers online or in person is your personal choice.', customClass: 'ahfc_CustomPadding', divOrSpan: true },
            { id: 9, item: ' ', customClass: 'ahfc_bold ahfc_CustomPadding', divOrSpan: false },
            { id: 10, item: 'American Honda Motor Co., Inc., 1919 Torrance Blvd., Torrance, California 90501.', customClass: 'ahfc_CustomPadding', divOrSpan: false },
        ]
    }*/
];


    handleToggle(event) {
        // return !firstBar;
        //  firstBar= !firstBar;
        //  this.firstBar = !this.firstBar;
        // let targetId = event.target.getAttribute("data-id");
        // let target = this.template.target.nextElementSibling;
        console.log(this.document.getElementsByClassName('AHFC_accordianWrap'));
        console.log(event, 'enent');
        var target = event.currentTarget;
        var panel = target.nextElementSibling;
        this.firstBar = !this.firstBar;
        // panel.classList.add("active");   
    }


    //Toggle Accordions in Mobile
    onMobileSectionsClick(event) {
        const open = "slds-accordion__section slds-is-open";
        const close = "slds-accordion__section";

        const parentopen = "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest ahfc_parentOpen";
        const parentclose = "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest";

        const accDataopen = "slds-accordion__content ahfc_accordionContent";
        const accDataclose = "slds-accordion__content";

        if (event.currentTarget.dataset.keyno) {
            if (this.mobileSections[event.target.dataset.keyno].isOpened) {
                this.mobileSections[event.target.dataset.keyno].isOpened = !this
                    .mobileSections[event.target.dataset.keyno].isOpened;
                this.mobileSections[event.target.dataset.keyno].class = close;
                this.mobileSections[event.target.dataset.keyno].parentClass = parentclose;
                this.mobileSections[event.target.dataset.keyno].contentClass = accDataclose;
            } else {
                this.mobileSections[event.target.dataset.keyno].isOpened = !this
                    .mobileSections[event.target.dataset.keyno].isOpened;
                this.mobileSections[event.target.dataset.keyno].class = open;
                this.mobileSections[event.target.dataset.keyno].parentClass = parentopen;
                this.mobileSections[event.target.dataset.keyno].contentClass = accDataopen;
                let adobedata = {
                    'Event_Metadata.action_type': 'Expand',
                    "Event_Metadata.action_label": 'Terms and Conditions:Expand:' + event.currentTarget.title,
                    "Event_Metadata.action_category": "",
                    "Page.page_name": "Terms and Conditions",
                    "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
                };
                fireAdobeEvent(adobedata, 'click-event');
            }
            // this.mobileSections[event.target.dataset.keyno].isOpened = !this
            //     .mobileSections[event.target.dataset.keyno].isOpened;
            // this.mobileSections[event.target.dataset.keyno].class =
            //     this.mobileSections[event.target.dataset.keyno].class === open ? close: open;
            // this.mobileSections[event.target.dataset.keyno].parentClass =
            // this.mobileSections[event.target.dataset.keyno].parentClass === parentopen ? parentclose: parentopen;
            // // contentClass
            // this.mobileSections[event.target.dataset.keyno].contentClass =
            // this.mobileSections[event.target.dataset.keyno].contentClass === accDataopen ? accDataclose: accDataopen;
            // this.mobileSections[event.target.dataset.keyno].contentClass = this
            //     .mobileSections[event.target.dataset.keyno].isOpened
            //     ? "slds-accordion__content mobile-accordion-content"
            //     : "slds-accordion__content";
        }
    }
    connectedCallback() {

        //Strat  added by sagar for bug fix 21917
        let contactUsPageUrl= basePath + "/contact-us-pre-login";

        for(let section in this.mobileSections){
            for(let accData in this.mobileSections[section].accordionData)
            {
               if(this.mobileSections[section].accordionData[accData].item.includes('pricayPolicyUrl'))
               {
                 this.mobileSections[section].accordionData[accData].item=this.mobileSections[section].accordionData[accData].item.replace('pricayPolicyUrl',this.privacyPolicyPdfUrl); 
               }

               if(this.mobileSections[section].accordionData[accData].item.includes('contactUsPageUrl'))
               {
                 this.mobileSections[section].accordionData[accData].item=this.mobileSections[section].accordionData[accData].item.replace('contactUsPageUrl',contactUsPageUrl); 
               }
            }
        }

        /*End bug fix 21917 */

        let adobedata = {
            "Page.referrer_url": document.referrer,
            "Page.site_section": "Terms and Conditions",
            "Page.page_name": "Terms and Conditions",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        loadStyle(this, ahfctheme + "/theme.css").then(() => {});

    }


    handleSetActiveSectionC() {

    }

    navigateBackToDashboard(event) {
        var url = window.location.href;
        var value = url.substr(0, url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    }

    renderedCallback() {
        let firstClass = this.template.querySelector(".main-content");
        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
    }


}