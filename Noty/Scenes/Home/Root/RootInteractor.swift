//
//  RootInteractor.swift
//  Noty
//
//  Created by Youssef Jdidi on 8/3/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
//  This template is meant to work with Swinject.

import UIKit

protocol RootInteractorProtocol {
    func handleViewDidLoad()
    func handleChangeState(state: RootTabView.State)
}

class RootInteractor: RootInteractorProtocol {

    // MARK: DI
    var presenter: RootPresenterProtocol
    var userDefaults: UserDefaultsManagerProtocol

    init(
        presenter: RootPresenterProtocol,
        userDefaults: UserDefaultsManagerProtocol
    ) {
        self.presenter = presenter
        self.userDefaults = userDefaults
    }

    func handleViewDidLoad() {
        presenter.present(with: .new)
        presenter.present(saved: userDefaults.themeColor)
    }

    func handleChangeState(state: RootTabView.State) {
        presenter.present(with: state)
        presenter.presentContainerTabView(state)
    }
}