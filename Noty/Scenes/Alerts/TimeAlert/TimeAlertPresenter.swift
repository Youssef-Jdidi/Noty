//
//  TimeAlertPresenter.swift
//  Noty
//
//  Created by Youssef Jdidi on 20/3/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
//  This template is meant to work with Swinject.

import UIKit

protocol TimeAlertPresenterProtocol {
    func set(viewController: TimeAlertViewControllerProtocol?)

    func present(time: String)
    func present(permission error: HomeModels.PermissionError)
    func presentAddingNotif()
    func present(theme color: UIColor)
}

class TimeAlertPresenter: TimeAlertPresenterProtocol {

    // MARK: DI
    weak var viewController: TimeAlertViewControllerProtocol?

    func set(viewController: TimeAlertViewControllerProtocol?) {
        self.viewController = viewController
    }
}

// MARK: Methods
extension TimeAlertPresenter {
    func present(time: String) {
        viewController?.display(
            time: time
                .replacingOccurrences(of: " PM", with: "")
                .replacingOccurrences(of: " AM", with: ""),
            isAm: time.contains("AM"))
    }

    func present(permission error: HomeModels.PermissionError) {
        viewController?.display(permission: error)
    }

    func presentAddingNotif() {
        viewController?.displayAddingnotif()
    }

    func present(theme color: UIColor) {
        viewController?.display(theme: color)
    }
}
