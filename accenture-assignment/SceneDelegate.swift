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
        let remoteUrl = URL(string: "https://private-anon-72c71498a5-androidtestmobgen.apiary-mock.com/categories")!
        let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remoteCategoryLoader = RemoteCategoryLoader(url: remoteUrl, client: remoteClient)
        
        let localURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("categories.store")
        let localStore = CodableCategoryStore(storeURL: localURL)
        let localCategoryLoader = LocalCategoryLoader(store: localStore, currentDate: Date.init)
        
        return CategoriesViewController(
            loader: MainQueueDispatchDecorator(
                decoratee: CategoryLoaderWithFallbackComposite(
                    primary: CategoryLoaderCacheDecorator(
                        decoratee: remoteCategoryLoader,
                        cache: localCategoryLoader
                    ),
                    fallback: localCategoryLoader
                )
            )
        )
    }
}

