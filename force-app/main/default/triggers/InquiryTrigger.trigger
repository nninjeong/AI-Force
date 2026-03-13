trigger InquiryTrigger on Inquiry__c (after insert) {
    InquiryTriggerHandler handler = new InquiryTriggerHandler();

    if (Trigger.isAfter && Trigger.isInsert) {
        handler.onAfterInsert(Trigger.new);
    }
}