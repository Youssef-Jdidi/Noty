//
//  TimeAlertViewController.swift
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

protocol TimeAlertViewControllerProtocol: class, UIViewControllerRouting {
    func set(interactor: TimeAlertInteractorProtocol)
    func set(router: TimeAlertRouterProtocol)
    func set(date: Date)
    func set(note: NoteModel)
    func set(alertPresenter: AlertPresenterProtocol)
    func set(delegate: DidSaveReminderDelegate?)

    func display(time: String, isAm: Bool)
    func display(permission errors: HomeModels.PermissionError)
    func displayAddingnotif()
    func display(theme color: UIColor)
}

class TimeAlertViewController: UIViewController, TimeAlertViewControllerProtocol {

    // MARK: DI
    var interactor: TimeAlertInteractorProtocol?
    var router: TimeAlertRouterProtocol?

    func set(interactor: TimeAlertInteractorProtocol) {
        self.interactor = interactor
    }

    func set(router: TimeAlertRouterProtocol) {
        self.router = router
    }

    func set(date: Date) {
        self.date = date
    }

    func set(note: NoteModel) {
        self.note = note
    }

    func set(alertPresenter: AlertPresenterProtocol) {
        self.alertPresenter = alertPresenter
    }

    func set(delegate: DidSaveReminderDelegate?) {
        self.delegate = delegate
    }

    // MARK: Outlets
    @IBOutlet weak var timePicker: UIDatePicker! {
        didSet {
            timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        }
    }
    @IBOutlet weak var containerView: RoundedView! {
        didSet {
            containerView.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amLabel: UILabel!
    @IBOutlet weak var pmLabel: UILabel!
    @IBOutlet weak var labelView: UIView!

    // MARK: Properties
    var date: Date?
    var note: NoteModel?
    var alertPresenter: AlertPresenterProtocol?
    weak var delegate: DidSaveReminderDelegate?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDate()
        interactor?.handleThemeColor()
    }

    // MARK: Actions
    @IBAction func okClicked(_ sender: Any) {
        guard let date = date, let note = note else { return }
        showSpinner()
        let hours = Calendar.current.component(.hour, from: timePicker.date)
        let minutes = Calendar.current.component(.minute, from: timePicker.date)
        let finalDate = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: date)
        interactor?.addNotif(on: finalDate ?? date, with: note)
    }

    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(adding: false)
    }
}

// MARK: Methods
extension TimeAlertViewController {

    func display(time: String, isAm: Bool) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.amLabel.textColor = isAm ? UIColor.white.withAlphaComponent(1) : UIColor.white.withAlphaComponent(0.5)
            self.pmLabel.textColor = isAm ? UIColor.white.withAlphaComponent(0.5) :
                UIColor.white.withAlphaComponent(1)
            self.timeLabel.text = time
        }
    }

    func displayAddingnotif() {
        guard let note = self.note else { return }
        delegate?.reminderSaved(on: note)
        dismiss(adding: true)
    }

    func display(permission errors: HomeModels.PermissionError) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.hideSpinner()
            self.alertPresenter?.presentPermissionAlert(with: .notif)
        }
    }

    func display(theme color: UIColor) {
        labelView.backgroundColor = color
    }

    private func checkDate() {
        guard let date = self.date else { return }
        let currentDay = Date()
        timePicker.minimumDate = Calendar.current.isDateInToday(date) ? currentDay : nil
        interactor?.convertDate(date: currentDay)
    }

    @objc private func timePickerValueChanged() {
        interactor?.convertDate(date: timePicker.date)
    }

    private func dismiss(adding notif: Bool) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            notif ? self.hideSpinner() : ()
            let date = self.presentingViewController
            date?.view.isHidden = true
            self.dismiss(animated: true) {
                date?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

protocol DidSaveReminderDelegate: class {
    func reminderSaved(on note: NoteModel)
}
