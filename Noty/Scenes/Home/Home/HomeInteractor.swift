//
//  HomeInteractor.swift
//  Noty
//
//  Created by Youssef Jdidi on 12/2/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
//  This template is meant to work with Swinject.

import UIKit
import MessageUI

protocol HomeInteractorProtocol {
    func startRecording()
    func pauseRecording()
    func clearRecording()
    func getCurrentAmplitude()
    func handleViewWillDisappear()
    func prepareChoiceActionSheet(with note: String)
}

class HomeInteractor: HomeInteractorProtocol {
    
    // MARK: DI
    var presenter: HomePresenterProtocol
    var permissionManager: PermissionManagerProtocol
    var transcriptorManager: TranscriptorManagerProtocol
    var noteService: NoteServiceProtocol
    
    init(
        presenter: HomePresenterProtocol,
        permisssionManager: PermissionManagerProtocol,
        transcriptorManager: TranscriptorManagerProtocol,
        noteService: NoteServiceProtocol
    ) {
        self.presenter = presenter
        self.permissionManager = permisssionManager
        self.transcriptorManager = transcriptorManager
        self.noteService = noteService
    }
}

extension HomeInteractor {

    func prepareChoiceActionSheet(with note: String) {
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let email = UIAlertAction(title: "Send in Email", style: .default, handler: {[weak self] _ in
            guard let self = self else { return }
            self.handleEmailOpenApp(with: note)
        })
        let save = UIAlertAction(title: "Save", style: .default) {[weak self] _ in
            guard let self = self else { return }
            self.routeToTitle()
        }
        let choiceActionSheet = UIAlertController(title: "Action", message: nil, preferredStyle: .actionSheet)
        choiceActionSheet.addAction(cancel)
        choiceActionSheet.addAction(email)
        choiceActionSheet.addAction(save)
        presenter.present(choiceActionSheet: choiceActionSheet)
    }

    private func routeToTitle() {
        presenter.presentRoutingToTitle()
    }

    func handleEmailOpenApp(with body: String) {
        let emailActionSheet = UIAlertController(title: "Open Email", message: nil, preferredStyle: .actionSheet)
        guard let body = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }

        emailActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let action = openAction(withURL: "googlegmail://co?to=&subject=&body=\(body)", andTitleActionTitle: "Gmail") {
            emailActionSheet.addAction(action)
        }

        if let action = openAction(withURL: "readdle-spark://compose?recipient=&subject=&body=\(body)", andTitleActionTitle: "Spark") {
            emailActionSheet.addAction(action)
        }

        if let action = openAction(withURL: "ms-outlook://compose?to=&subject=&body=\(body)", andTitleActionTitle: "Outlook") {
            emailActionSheet.addAction(action)
        }
        presenter.present(actionSheet: emailActionSheet)
    }

    private func openAction(withURL: String, andTitleActionTitle: String) -> UIAlertAction? {
        guard let url = URL(string: withURL), UIApplication.shared.canOpenURL(url) else {
            return nil
        }
        let action = UIAlertAction(title: andTitleActionTitle, style: .default) { _ in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return action
    }

//    func saveNote(with text: String) {
//        presenter.presentSpinner()
//        var model = NoteModel(
//            id: nil,
//            text: text,
//            isFavorite: false,
//            isReminded: false,
//            remindedDate: nil)
//        noteService.save(from: &model) {[weak self] result in
//            guard let self = self else { return }
//            self.presenter.present(save: result)
//        }
//    }

    func startRecording() {
        self.checkPermission { [weak self] in
            guard let self = self else { return }
            if self.transcriptorManager.delegate == nil {
                self.handlePrepare()
            }
            self.transcriptorManager.startRecording()
            self.presenter.presentRecordingState(.isRecoding)
        }
    }

    func pauseRecording() {
        transcriptorManager.pauseRecording()
        presenter.presentRecordingState(.isPaused)
    }

    func clearRecording() {
        transcriptorManager.tearDown()
        transcriptorManager.delegate = nil
        presenter.presentRecordingState(.isCleared)
    }

    func handlePrepare() {
        transcriptorManager.delegate = self
        transcriptorManager.prepare()
    }

    func getCurrentAmplitude() {
        presenter.presentCurrentAmplitude(with: transcriptorManager.getCurrentAmplitude())
    }

    func handleViewWillDisappear() {
        transcriptorManager.tearDown()
        transcriptorManager.delegate = nil
    }
}

private extension HomeInteractor {
    func checkPermission(onCompletion: @escaping () -> Void) {
        self.requestAudioPermission {
            self.requestSpeechPermission {
                onCompletion()
            }
        }
    }
    
    func requestAudioPermission(onCompletion: @escaping () -> Void) {
        permissionManager.requestAudioPermission { result in
            switch result {
            case .success: onCompletion()
            case .failure: self.presenter.presentPermissionError(error: .audio)
            }
        }
    }
    
    func requestSpeechPermission(onCompletion: @escaping () -> Void) {
        permissionManager.requestSpeechPermission { result in
            switch result {
            case .success: onCompletion()
            case .failure: self.presenter.presentPermissionError(error: .speech)
            }
        }
    }
}

extension HomeInteractor: SpeechTranscriptionDelegate {
    func transcriptor(failedWithError error: Error) {
        Console.log(type: .error, error.localizedDescription)
    }

    func transcriptor(didTranscript transcription: String, completed: Bool) {
        presenter.presentTranscripted(transcripted: transcription)
    }
}