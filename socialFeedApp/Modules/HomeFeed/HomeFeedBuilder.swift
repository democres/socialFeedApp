//
//  HomeFeedBuilder.swift
//  socialFeedApp
//
//  Created by David Figueroa on 3/03/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import UIKit

final class HomeFeedBuilder {
    static func make() -> HomeFeedViewController {
        let storyboard = UIStoryboard(name: "HomeFeed", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "HomeFeedViewController") as! HomeFeedViewController
        let interactor = HomeFeedInteractor()
        let presenter = HomeFeedPresenter(view: view, interactor: interactor)
        view.presenter = presenter
        return view
    }
}
