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
    private let baseURL = URL(string: "https://private-anon-72c71498a5-androidtestmobgen.apiary-mock.com")!
    private let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    
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
    
    private func makeCategoryLoaders() -> (remote: RemoteLoader<[CategoryItem]>, local: LocalCategoryLoader) {
        let remoteUrl = Endpoints.getCategories.url(baseURL: baseURL)
        let remoteCategoryLoader = RemoteLoader(url: remoteUrl, client: remoteClient, mapper: CategoryItemsMapper.map)
        
        let localURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("categories.store")
        let localStore = CodeableCategoryStore(storeURL: localURL)
        let localCategoryLoader = LocalCategoryLoader(store: localStore, currentDate: Date.init)
        
        return (remoteCategoryLoader, localCategoryLoader)
    }
    
    private func makeRootViewController() -> SplashViewController {
        let (remote, local) = makeCategoryLoaders()
        let viewModel = SplashViewModel(
            loader: MainQueueDispatchDecorator(decoratee: CategoryLoaderWithFallbackComposite(
                primary: CategoryLoaderCacheDecorator(
                    decoratee: remote,
                    cache: local
                ),
                fallback: local)))
        return SplashViewController(viewModel: viewModel) { [weak self] in
            guard let self = self else { return }
            self.navigationController.setViewControllers([self.makeCategoriesViewController()], animated: false)
        }
    }
    
    func makeCategoriesViewController() -> CategoriesViewController {
        let (remote, local) = makeCategoryLoaders()
        let viewModel = CategoryViewModel(
            loader: MainQueueDispatchDecorator(decoratee: CategoryLoaderWithFallbackComposite(
                primary: local,
                fallback:  CategoryLoaderCacheDecorator(
                    decoratee: remote,
                    cache: local
                ))))
        
        return CategoriesViewController(viewModel: viewModel) { [weak self] item in
            guard let self = self else { return }
            switch item.category {
            case .Books:
                self.navigationController.show(self.makeBookViewController(with: item.category.rawValue), sender: self)
            case .Houses:
                self.navigationController.show(self.makeHousesViewController(with: item.category.rawValue), sender: self)
            case .Characters:
                self.navigationController.show(self.makeCharacterViewController(with: item.category.rawValue), sender: self)
            }
        }
    }
    
    private func makeBookViewController(with type: Int) -> BooksTableViewController {
        let remoteUrl = Endpoints.getLists(type).url(baseURL: baseURL)
        let loader = RemoteLoader(url: remoteUrl, client: remoteClient, mapper: BooksItemMapper.map)
        let viewModel = BookViewModel(loader: MainQueueDispatchDecorator(decoratee: loader))
        return BooksTableViewController(viewModel: viewModel)
    }
    
    private func makeCharacterViewController(with type: Int) -> CharactersTableViewController {
        let remoteUrl = Endpoints.getLists(type).url(baseURL: baseURL)
        let loader = RemoteLoader(url: remoteUrl, client: remoteClient, mapper: CharacterItemMapper.map)
        let viewModel = CharacterViewModel(loader: MainQueueDispatchDecorator(decoratee: loader))
        return CharactersTableViewController(viewModel: viewModel)
    }
    
    private func makeHousesViewController(with type: Int) -> HousesTableViewController {
        let remoteUrl = Endpoints.getLists(type).url(baseURL: baseURL)
        let loader = RemoteLoader(url: remoteUrl, client: remoteClient, mapper: HouseItemMapper.map)
        let imageLoader = RemoteImageDataLoader(client: remoteClient)
        return HouseUIComposer.housesComposedWith(houseLoader: MainQueueDispatchDecorator(decoratee: loader), imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader))
    }
}

extension RemoteLoader: CategoryLoader where Resource == [CategoryItem] {}
extension RemoteLoader: BookLoader where Resource == [BookItem] {}
extension RemoteLoader: HouseLoader where Resource == [HouseItem] {}
extension RemoteLoader: CharacterLoader where Resource == [CharacterItem] {}
