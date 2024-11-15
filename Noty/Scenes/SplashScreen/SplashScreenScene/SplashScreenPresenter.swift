//
//  SplashScreenPresenter.swift
//  Noty
//
//  Created by Youssef Jdidi on 11/2/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
//  This template is meant to work with Swinject.

import UIKit

protocol SplashScreenPresenterProtocol {
    func set(viewController: SplashScreenViewControllerProtocol?)

    // add the functions that are called from interactor
    func handle(error: Error)
    func presentUserState(isConnected: Bool)
}

class SplashScreenPresenter: SplashScreenPresenterProtocol {

    // MARK: DI
    weak var viewController: SplashScreenViewControllerProtocol?

    func set(viewController: SplashScreenViewControllerProtocol?) {
        self.viewController = viewController
    }
}

// MARK: Methods
extension  SplashScreenPresenter {

    func handle(error: Error) {
        viewController?.display(error: error)
    }

    func presentUserState(isConnected: Bool) {
        viewController?.display(isConnected: isConnected)
    }
}