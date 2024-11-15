////
//  LanguageRouter.swift
//  Noty
//
//  Created by Youssef Jdidi on 14/2/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
//  This template is meant to work with Swinject.

import UIKit

protocol LanguageRouterProtocol {
  func set(viewController: LanguageViewControllerProtocol?)
  func route(to scene: LanguageRouter.Scene)
}

class LanguageRouter: NSObject, LanguageRouterProtocol {

    // MARK: DI
    weak var viewController: LanguageViewControllerProtocol?
    private let rootNavigator: RootNavigatorProtocol
    private let onBoardingStoryboard: Storyboard

    func set(viewController: LanguageViewControllerProtocol?) {
        self.viewController = viewController
    }

    init(
        rootNavigator: RootNavigatorProtocol,
        onBoardingStoryboard: Storyboard
    ) {
        self.rootNavigator = rootNavigator
        self.onBoardingStoryboard = onBoardingStoryboard
    }
}

// MARK: Routing logic
extension LanguageRouter {

    enum Scene {
        case permission
    }

    func route(to scene: LanguageRouter.Scene) {
        switch scene {
        case .permission:
            guard let permissionVC = onBoardingStoryboard.viewController(identifier: OnBoardingStoryboardId.permission) as? PermissionViewController else { return }
            viewController?.show(permissionVC, sender: nil)
        }
    }
}
