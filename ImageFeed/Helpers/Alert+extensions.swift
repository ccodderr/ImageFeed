//
//  Alert+extensions.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 22.01.2025.
//

import UIKit

enum AlertMessages {
    static let likeError = "Мы не смогли изменить статус лайка. Попробуйте еще раз!"
    static let networkError = "Не удалось войти в систему."
    static let unknownError = "Не удалось получить данные"
}

extension UIViewController {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
