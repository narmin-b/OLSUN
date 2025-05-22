//
//  LoginViewModelTests.swift
//  OLSUNTests
//
//  Created by Narmin Baghirova on 19.03.25.
//

import XCTest
@testable import OLSUN

final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var mockService: MockAuthSessionUseCase!
    var callbackStates: [LoginViewModel.ViewState] = []

    override func setUp() {
        super.setUp()
        mockService = MockAuthSessionUseCase()
        viewModel = LoginViewModel(navigation: nil, authSessionUse: mockService)
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

    func testSuccessfulEmailLoginThroughViewModel() {
        let user = LoginDataModel(email: "test@example.com", password: "Test1234")
        
        mockService.shouldSucceed = true
        viewModel.logInUser(user: user)
        
        let expectation = XCTestExpectation(description: "Wait for async login")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(mockService.loginCalled)
        XCTAssertEqual(callbackStates, [.loading, .loaded, .success])
    }

    func testFailedEmailLogin() {
        let user = LoginDataModel(email: "test@mail.com", password: "wrongpass")
        
        mockService.shouldSucceed = false
        viewModel.logInUser(user: user)
        
        let expectation = XCTestExpectation(description: "Wait for async login")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(mockService.loginCalled)
        XCTAssertEqual(callbackStates, [.loading, .loaded, .error(message: "Invalid credentials")])
    }

    func testGoogleLoginSuccess() {
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
