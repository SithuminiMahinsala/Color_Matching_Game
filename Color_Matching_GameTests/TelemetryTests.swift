import XCTest
@testable import Color_Matching_Game

final class TelemetryTests: XCTestCase {
    
    var telemetryManager: TelemetryManager!

    override func setUp() {
        super.setUp()
        telemetryManager = TelemetryManager.shared
        // Clear any existing logs before each test to ensure a clean state
        telemetryManager.clearLogs()
    }

    override func tearDown() {
        telemetryManager.clearLogs()
        telemetryManager = nil
        super.tearDown()
    }

    //Tracking Logic Tests

    func testStartAndEndTrackingCalculatesDuration() {
        //Start tracking the session
        telemetryManager.startTracking()
        
        let expectation = self.expectation(description: "Wait for duration")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            // End tracking with dummy data
            self.telemetryManager.endTracking(mode: "Test Mode", clicks: 5)
            
            //Verify a session was recorded
            XCTAssertFalse(self.telemetryManager.sessions.isEmpty, "A session should be recorded after endTracking is called.")
            
            let lastSession = self.telemetryManager.sessions.first
            XCTAssertEqual(lastSession?.mode, "Test Mode")
            XCTAssertEqual(lastSession?.clicks, 5)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }

    //Persistence Tests

    func testSessionPersistence() {
        // Log a session
        telemetryManager.startTracking()
        telemetryManager.endTracking(mode: "Persistence Test", clicks: 10)
        
        //Create a fresh manager instance to simulate an app restart
        let newManagerInstance = TelemetryManager()
        let fetchedSessions = newManagerInstance.fetchSessions()
        
        // Verify the session still exists in UserDefaults
        XCTAssertTrue(fetchedSessions.contains(where: { $0.mode == "Persistence Test" }), "Sessions should be saved to UserDefaults and retrievable after restart.")
    }

    //Utility Tests

    func testClearLogs() {
        // Add a log
        telemetryManager.startTracking()
        telemetryManager.endTracking(mode: "Clear Test", clicks: 1)
        
        // Clear the logs
        telemetryManager.clearLogs()
        
        // Verify it is empty
        XCTAssertTrue(telemetryManager.sessions.isEmpty, "The sessions list should be empty after calling clearLogs.")
    }
}