//
//  AppRouter.swift
//  socialFeedApp
//
//  Created by David Figueroa on 3/03/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import UIKit

final class AppRouter {
    var window: UIWindow?
    
    func launchHomeFeed(){
        let viewController = HomeFeedBuilder.make()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}
