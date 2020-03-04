//
//  socialFeedAppTests.swift
//  socialFeedAppTests
//
//  Created by David Figueroa on 3/03/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import XCTest
import RxSwift
import Moya

@testable import Social_Feed_App

class socialFeedAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    var disposeBag = DisposeBag()
    
    func testValidAuthorNames(){
        
        let expectation =  self.expectation(description: "Get first page of posts")
            
            let interactor = HomeFeedInteractor()
            interactor.getSocialPosts(index: 1)
                .subscribe(onNext: { postArray in
                    XCTAssertGreaterThan(postArray.count, 0)
                    postArray.forEach { post in
                        self.isValidName(name: post.author?.name ?? "")
                    }
                    expectation.fulfill()
                }, onError: { (error) in
                    // HANDLE THE ERROR
                    print(error)
                    XCTFail("ERROR OCCURRED WHILE DOWNLOADING POSTS")
                })
                .disposed(by: disposeBag)
            waitForExpectations(timeout: 10) { error in
                if (error != nil) {
                    XCTFail("TIMEOUT REACHED")
                }
            }
        
    }

    func isValidName(name: String){
        // Check if name has more than two chars
        XCTAssertGreaterThan(name.count, 1)
        
        // Check if only letters
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
        if name.rangeOfCharacter(from: characterset.inverted) != nil {
            XCTFail("name: \(name) contains special characters or numbers")
        }
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
