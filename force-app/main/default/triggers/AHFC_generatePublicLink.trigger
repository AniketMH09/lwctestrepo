trigger AHFC_generatePublicLink on ContentVersion (after insert) {
    AHFC_publicLinkClassHandler.createPublicLink(trigger.new);
}