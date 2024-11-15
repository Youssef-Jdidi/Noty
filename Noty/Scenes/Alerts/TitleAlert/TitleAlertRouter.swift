////
//  TitleAlertRouter.swift
//  Noty
//
//  Created by Youssef Jdidi on 25/3/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
//  This template is meant to work with Swinject.

import UIKit

protocol TitleAlertRouterProtocol {
  func set(viewController: TitleAlertViewControllerProtocol?)
  func route(to scene: TitleAlertRouter.Scene)
}

class TitleAlertRouter: NSObject, TitleAlertRouterProtocol {

    //MARK: DI
    weak var viewController: TitleAlertViewControllerProtocol?
    private let rootNavigator: RootNavigatorProtocol
    private let alertsStoryboard: Storyboard

    func set(viewController: TitleAlertViewControllerProtocol?) {
        self.viewController = viewController
    }

    init(
        rootNavigator: RootNavigatorProtocol,
        alertsStoryboard: Storyboard
    ) {
        self.rootNavigator = rootNavigator
        self.alertsStoryboard = alertsStoryboard
    }
}

// MARK: Routing logic
extension TitleAlertRouter {

    enum Scene {
        case destination1
    }

    func route(to scene: TitleAlertRouter.Scene) {
        switch scene {
        case .destination1:
            /// TODO: Implement routing
            break
        }
    }
}
