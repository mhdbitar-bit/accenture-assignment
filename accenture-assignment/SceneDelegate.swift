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
        let remoteUrl = Endpoints.getCategories.url(baseURL: URL(string: "https://private-anon-72c71498a5-androidtestmobgen.apiary-mock.com")!)
        let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remoteCategoryLoader = RemoteLoader(url: remoteUrl, client: remoteClient, mapper: CategoryItemsMapper.map)
        
        let localURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("categories.store")
        let localStore = CodableCategoryStore(storeURL: localURL)
        let localCategoryLoader = LocalCategoryLoader(store: localStore, currentDate: Date.init)
        
        let viewModel = CategoryViewModel(
            loader: MainQueueDispatchDecorator(decoratee: CategoryLoaderWithFallbackComposite(
                primary: remoteCategoryLoader,
                fallback: localCategoryLoader)))
        
        return CategoriesViewController(viewModel: viewModel) { [weak self] item in
            guard let self = self else { return }
            switch item.category {
            case .Books:
                self.navigationController.show(Self.makeBookViewController(with: item.category.rawValue), sender: self)
            case .Houses:
                break
            case .Characters:
                break
            }
        }
    }
    
    private static func makeBookViewController(with type: Int) -> BooksTableViewController {
        let remoteUrl = Endpoints.getLists(type).url(baseURL: URL(string: "https://private-anon-72c71498a5-androidtestmobgen.apiary-mock.com")!)
        let cleint = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        
        let loader = RemoteLoader(url: remoteUrl, client: cleint, mapper: BooksItemMapper.map)
        let viewModel = BookViewModel(loader: MainQueueDispatchDecorator(decoratee: loader))
        return BooksTableViewController(viewModel: viewModel)
    }
}

extension RemoteLoader: CategoryLoader where Resource == [CategoryItem] {}
extension RemoteLoader: BookLoader where Resource == [BookItem] {}
extension RemoteLoader: HouseLoader where Resource == [HouseItem] {}
