//
//  LanguageAlertViewController.swift
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
import Speech
import FlagKit

protocol LanguageAlertViewControllerProtocol: class, UIViewControllerRouting {
    func set(interactor: LanguageAlertInteractorProtocol)
    func set(router: LanguageAlertRouterProtocol)

    // add the functions that are called from the presenter
    func display(initial language: Locale)
    func displaySaving()
}

protocol NewLanguageSelectedDelegate: class {
    func finishSaving()
}

class LanguageAlertViewController: UIViewController, LanguageAlertViewControllerProtocol {

    // MARK: DI
    var interactor: LanguageAlertInteractorProtocol?
    var router: LanguageAlertRouterProtocol?

    func set(interactor: LanguageAlertInteractorProtocol) {
        self.interactor = interactor
    }

    func set(router: LanguageAlertRouterProtocol) {
        self.router = router
    }
    
    // MARK: Outlets
    @IBOutlet weak var languagePickerView: UIPickerView! {
        didSet {
            languagePickerView.delegate = self
            languagePickerView.dataSource = self
        }
    }

    // MARK: Properties
    private lazy var supportedLanguages: [Locale] = Array(SFSpeechRecognizer.supportedLocales()).sorted { lhs, rhs -> Bool in
        return Locale.autoupdatingCurrent.localizedString(forIdentifier: lhs.identifier)! < Locale.autoupdatingCurrent.localizedString(forIdentifier: rhs.identifier)!
    }

    weak var delegate: NewLanguageSelectedDelegate?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.handleInitialLanguage()
    }

    // MARK: Actions
    @IBAction func okClicked(_ sender: Any) {
        let language = supportedLanguages[languagePickerView.selectedRow(inComponent: 0)]
        interactor?.handleSavingLanguage(language: language)
        delegate?.finishSaving()
    }
}

// MARK: Methods
extension LanguageAlertViewController {

    func display(initial language: Locale) {
        if let index = supportedLanguages.firstIndex(of: language) {
            languagePickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }

    func displaySaving() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: PickerView delegate and DataSource
extension LanguageAlertViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return supportedLanguages.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let locale = supportedLanguages[row]
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = Locale.current.localizedString(forIdentifier: locale.identifier)?.uppercased()
        label.textAlignment = .left

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        if let region = locale.regionCode, let flag = Flag(countryCode: region) {
            imageView.image = flag.image(style: .roundedRect)
        }

        let horizontalStackView = UIStackView(arrangedSubviews: [label, imageView])
        horizontalStackView.axis = .horizontal
        return horizontalStackView
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return languagePickerView.frame.width - 30
    }
}
