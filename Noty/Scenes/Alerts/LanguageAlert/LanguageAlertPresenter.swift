//
//  LanguageAlertPresenter.swift
//  Noty
//
//  Created by Youssef Jdidi on 24/3/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
//  This template is meant to work with Swinject.

import UIKit

protocol LanguageAlertPresenterProtocol {
    func set(viewController: LanguageAlertViewControllerProtocol?)

    func present(initial language: Locale)
    func presentSaving()
}

class LanguageAlertPresenter: LanguageAlertPresenterProtocol {

    // MARK: DI
    weak var viewController: LanguageAlertViewControllerProtocol?

    func set(viewController: LanguageAlertViewControllerProtocol?) {
        self.viewController = viewController
    }
}

// MARK: Methods
extension  LanguageAlertPresenter {

    func present(initial language: Locale) {
        viewController?.display(initial: language)
    }

    func presentSaving() {
        viewController?.displaySaving()
    }
}
