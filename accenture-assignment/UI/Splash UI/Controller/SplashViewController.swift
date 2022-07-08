//
//  SplashViewController.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import UIKit
import Combine

final class SplashViewController: UIViewController, Alertable {

    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "applelogo")
        image.tintColor = .secondaryLabel
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var viewModel: SplashViewModel!
    private var onComplete: (([CategoryItem]) -> Void)?
    private var cancellables: Set<AnyCancellable> = []
    
    convenience init(viewModel: SplashViewModel, onComplete: (([CategoryItem]) -> Void)?) {
        self.init()
        self.viewModel = viewModel
        self.onComplete = onComplete
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    
        viewModel.loadCategories()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
    }
    
    private func bind() {
        bindCategories()
        bindError()
    }
    
    private func bindCategories() {
        viewModel.$categories.sink { [weak self] categories in
            guard let self = self else { return }
            self.onComplete?(categories)
        }.store(in: &cancellables)
    }
    
    private func bindError() {
        viewModel.$error.sink { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: error)
            }
        }.store(in: &cancellables)
    }
}
