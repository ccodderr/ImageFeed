//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 22.01.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanData()
        navigateToSplashScreen()
    }
    
    private func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanData() {
        ImagesListService.shared.cleanData()
        ProfileImageService.shared.cleanData()
        ProfileService.shared.cleanData()
        OAuth2TokenStorage.shared.token = ""
    }
    
    private func navigateToSplashScreen() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let splashViewController = SplashViewController()
        UIView
            .transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    window.rootViewController = splashViewController
                },
                
                completion: nil)
    }
}

