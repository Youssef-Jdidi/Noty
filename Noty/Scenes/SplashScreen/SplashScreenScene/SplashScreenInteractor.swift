//
//  SplashScreenInteractor.swift
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

protocol SplashScreenInteractorProtocol {
    func checkUser()
}

class SplashScreenInteractor: SplashScreenInteractorProtocol {

    // MARK: DI
    var presenter: SplashScreenPresenterProtocol
    private var userDefaultManager: UserDefaultsManagerProtocol

    init(
        presenter: SplashScreenPresenterProtocol,
        userDefaultManager: UserDefaultsManagerProtocol
    ) {
        self.presenter = presenter
        self.userDefaultManager = userDefaultManager
    }

    func checkUser() {
        presenter.presentUserState(isConnected: userDefaultManager.isConnected)
    }
}
