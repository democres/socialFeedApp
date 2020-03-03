//
//  HomeFeedPresenter.swift
//  socialFeedApp
//
//  Created by David Figueroa on 3/03/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import RxSwift

final class HomeFeedPresenter: HomeFeedPresenterProtocol {
    
    private let view: HomeFeedViewProtocol
    private let interactor: HomeFeedInteractorProtocol
    
    private let disposeBag = DisposeBag()
    
    init(view: HomeFeedViewProtocol, interactor: HomeFeedInteractorProtocol) {
        self.view = view
        self.interactor = interactor
        self.interactor.interactorOutputDelegate = self
    }
    
    
    func showSocialPosts() {
        interactor.getSocialPosts()
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] postArray in
                self?.view.handlePresenterOutput(.showSocialPosts(postArray))
        }, onError: { (error) in
            print(error)
            // HANDLE THE ERROR
        })
        .disposed(by: disposeBag)
        
    }
    
}

extension HomeFeedPresenter: HomeFeedInteractorDelegate{
    func handleInteractorOutput(_ output: HomeFeedInteractorOutput) {
        switch output {
        case .showSocialPosts(let postArray):
//            view.handlePresenterOutput(.showSocialPosts(postArray))
            print("THIS TASK IS DONE BY RxSwift THIS DELEGATE IS LEFT HERE BECAUSE OF THE TECHNICAL TEST PURPOSES TO DISCUSS LATER.")
        }
    }
}
