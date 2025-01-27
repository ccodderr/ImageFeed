//
//  Alert+extensions.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 22.01.2025.
//

import UIKit

enum AlertMessages: Error {
    case likeError
    case networkError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .likeError:
            return "Мы не смогли изменить статус лайка. Попробуйте еще раз!"
        case .networkError:
            return "Не удалось войти в систему."
        case .unknownError:
            return "Не удалось получить данные"
        }
    }
}

extension UIViewController {
    func showErrorAlert(error: Error) {
        showErrorAlert(message: error.localizedDescription)
    }
    
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
