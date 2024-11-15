//
//  SettingsPresenter.swift
//  Noty
//
//  Created by Youssef Jdidi on 9/3/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
//  This template is meant to work with Swinject.

import UIKit

protocol SettingsPresenterProtocol {
    func set(viewController: SettingsViewControllerProtocol?)

    // add the functions that are called from interactor
    func present(locale: Locale)
    func present(new color: UIColor)
}

class SettingsPresenter: SettingsPresenterProtocol {

    // MARK: DI
    weak var viewController: SettingsViewControllerProtocol?

    func set(viewController: SettingsViewControllerProtocol?) {
        self.viewController = viewController
    }
}

// MARK: Methods
extension  SettingsPresenter {

    func present(locale: Locale) {
        let configs = [
            Config(
                mainText: "SHARE NOTY",
                secondaryText: nil,
                flagImage: nil),
            Config(
                mainText: "VOICE-TO-TEXT LANGUAGE",
                secondaryText: Locale.current.localizedString(forIdentifier: locale.identifier)?.uppercased(),
                flagImage: locale),
            Config(
                mainText: "REPORT AN ISSUE",
                secondaryText: nil,
                flagImage: nil)
        ]
        viewController?.display(config: configs)
    }

    func present(new color: UIColor) {
        viewController?.display(new: color)
    }
}
