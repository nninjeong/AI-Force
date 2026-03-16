@isTest
private class ManagerControllerTest {
    
    @testSetup
    static void setup() {
        // 기술자 생성
        insert new Technician__c(Name = 'Test Tech', Status__c = 'Active');
        // 주문 생성
        insert new RepairOrder__c(CustomerName__c = 'Customer 1', ContactPhone__c = '010-0000-0000', Status__c = 'Received');
    }

    @isTest
    static void testGetPendingOrders() {
        List<RepairOrder__c> orders = ManagerController.getPendingOrders();
        System.assertEquals(1, orders.size());
    }

    @isTest
    static void testGetAvailableTechnicians() {
        List<Technician__c> techs = ManagerController.getAvailableTechnicians();
        System.assertEquals(1, techs.size());
    }

    @isTest
    static void testAssignTechnician() {
        RepairOrder__c ro = [SELECT Id FROM RepairOrder__c LIMIT 1];
        Technician__c tech = [SELECT Id FROM Technician__c LIMIT 1];
        
        Test.startTest();
        ManagerController.assignTechnician(ro.Id, tech.Id);
        Test.stopTest();

        RepairOrder__c updatedRo = [SELECT Status__c, Technician__c FROM RepairOrder__c WHERE Id = :ro.Id];
        System.assertEquals('Assigned', updatedRo.Status__c);
        System.assertEquals(tech.Id, updatedRo.Technician__c);
    }

    @isTest
    static void testGetRepairStats() {
        Map<String, Integer> stats = ManagerController.getRepairStats();
        System.assert(stats.containsKey('Received'));
        System.assertEquals(1, stats.get('Received'));
    }
}
