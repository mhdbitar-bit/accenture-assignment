//
//  SceneDelegate.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 6/30/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let navigationController = UINavigationController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        configureWindow()
    }
    
    func configureWindow() {
        navigationController.setViewControllers([makeRootViewController()], animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func makeRootViewController() -> CategoriesViewController {
        let url = URL(string: "https://private-anon-72c71498a5-androidtestmobgen.apiary-mock.com/categories")!
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let categoryLoader = RemoteCategoryLoader(url: url, client: client)
        return CategoriesViewController(loader: categoryLoader)
    }
}

