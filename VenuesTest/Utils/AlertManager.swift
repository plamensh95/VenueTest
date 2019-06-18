//
//  AlertManager.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//
import UIKit

class AlertManager {
    
    static let sharedInstance = AlertManager()
    
    private init(){}
    
    func showMessageAlert(with title: String? = nil, message: String) {
        UIAlertController(title: title ?? "", message: message,
                          defaultActionButtonTitle: Title.kOK, tintColor: .blue).show()
    }
    
    func showErrorAlert(with title: String? = nil, message: String? = nil,
                        tryAgainCompletion: ((Bool) -> ())? = nil) {

        if let safeTryAgainCompletion = tryAgainCompletion {
            let alert = UIAlertController(title: title ?? Title.kErrorOccured,
                                          message: message ?? Message.kTryAgain, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Title.kTryAgain, style: .default) { _ in
                safeTryAgainCompletion(true)
            })
            alert.addAction(UIAlertAction(title: Title.kCancel, style: .cancel, handler: nil))
            alert.show()
        } else {
            UIAlertController(title: title ?? Title.kErrorOccured,
                              message: message ?? Message.kSomethingWentWrong).show()
        }
    }
}

protocol AlertDisplayer {
    func showMessageAlert(message: String)
    func showErrorAlertWithOK(message: String)
    func showErrorAlertWithTryAgain(title: String, tryAgainCompletion: @escaping ((Bool) -> ()))
}

extension AlertDisplayer {
    func showMessageAlert(message: String) {
        DispatchQueue.main.async {
            AlertManager.sharedInstance.showMessageAlert(message: message)
        }
    }
    
    func showErrorAlertWithOK(message: String) {
        DispatchQueue.main.async {
            AlertManager.sharedInstance.showErrorAlert(message: message)
        }
    }
    
    func showErrorAlertWithTryAgain(title: String, tryAgainCompletion: @escaping ((Bool) -> ())) {
        DispatchQueue.main.async {
            return AlertManager.sharedInstance.showErrorAlert(with: title)
        }
    }
}
