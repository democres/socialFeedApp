//
//  HomeFeedContracts.swift
//  socialFeedApp
//
//  Created by David Figueroa on 3/03/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - View
protocol HomeFeedViewProtocol: class {
    func handlePresenterOutput(_ output: HomeFeedPresenterOutput)
}

// MARK: - Interactor
protocol HomeFeedInteractorProtocol: class {
    var interactorOutputDelegate: HomeFeedInteractorDelegate? { get set }
    func getSocialPosts(index: Int) -> Observable<[Post]>
}

protocol HomeFeedInteractorDelegate: class {
    func handleInteractorOutput(_ output: HomeFeedInteractorOutput)
}

enum HomeFeedInteractorOutput {
    case showSocialPosts([Post])
}

// MARK: - Presenter
protocol HomeFeedPresenterProtocol: class {
    func showSocialPosts(index: Int)
}

enum HomeFeedPresenterOutput {
    case showSocialPosts([Post])
}
