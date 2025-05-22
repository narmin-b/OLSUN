//
//  SignUpViewModelTests.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 30.04.25.
//

import XCTest
@testable import OLSUN

final class SignUpViewModelTests: XCTestCase {
    var viewModel: SignUpViewModel!
    var mockService: MockAuthSessionUseCase!
    var callbackStates: [SignUpViewModel.ViewState] = []

    override func setUp() {
        super.setUp()
        mockService = MockAuthSessionUseCase()
        viewModel = SignUpViewModel(navigation: nil, authSessionUse: mockService)
        viewModel.requestCallback = { [weak self] state in
            Logger.debug("\(state)")
            self?.callbackStates.append(state)
        }
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        callbackStates = []
        super.tearDown()
    }

    func testGoogleLoginSuccess() {
        let user = SingInUser(name: "Test", email: "test@example.com", idToken: "token")
        
        mockService.shouldSucceed = true
        mockService.shouldReturnEmailStatus = true
        viewModel.googleEmailCheck(user: user)

        let expectation = XCTestExpectation(description: "Wait for async login")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(mockService.googleCheckCalled)
        XCTAssertEqual(callbackStates, [.loading, .loaded, .success])
    }
    
    func testGoogleLoginLaunchFlow() {
        let user = SingInUser(name: "Test", email: "test@example.com", idToken: "token")
        
        mockService.shouldSucceed = true
        mockService.shouldReturnEmailStatus = false
        viewModel.googleEmailCheck(user: user)

        let expectation = XCTestExpectation(description: "Wait for async login")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(mockService.googleCheckCalled)
        XCTAssertEqual(callbackStates, [.loading, .loaded, .error(message: "Google login found.")])
    }

    func testGoogleLoginFailure() {
        let user = SingInUser(name: "Test", email: "test@example.com", idToken: "token")
        
        mockService.shouldSucceed = false
        viewModel.googleEmailCheck(user: user)

        let expectation = XCTestExpectation(description: "Wait for async login")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(mockService.googleCheckCalled)
        XCTAssertEqual(callbackStates, [.loading, .loaded, .error(message: "Google login requires email input.")])
    }
}
