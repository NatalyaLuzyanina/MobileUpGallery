//
//  VideoViewController.swift
//  MobileUpGallery
//
//  Created by Natalia on 18.08.2024.
//

import UIKit
import WebKit

protocol VideoViewControllerProtocol: AnyObject {
    func updateView(with model: DetailVideoModel)
    func showError(_ error: ErrorModel)
}

final class VideoViewController: UIViewController {
    
    private let presenter: VideoPresenterProtocol
    private var model: DetailVideoModel?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.scrollView.backgroundColor = .white
        webView.navigationDelegate = self
        return webView
    }()
    
    init(presenter: VideoPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .share,
            style: .done,
            target: self,
            action: #selector(shareMenuTapped)
        )
        
        presenter.loadData()
    }
    
    @objc private func shareMenuTapped() {
        guard let item = model?.url else { return }
        let activityViewController = UIActivityViewController(
            activityItems: [item],
            applicationActivities: [UIActivity()]
        )
        activityViewController.completionWithItemsHandler = { _, success, _, error in
            if let error = error {
                self.showAlert(
                    title: Strings.Error.commonError,
                    message: error.localizedDescription,
                    needsOkAction: false
                )
            }
        }
        present(activityViewController, animated: true)
    }
}

extension VideoViewController: VideoViewControllerProtocol {
    func updateView(with model: DetailVideoModel) {
        self.model = model
        title = model.title
        guard let url = URL(string: model.url) else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    func showError(_ error: ErrorModel) {
        showAlert(title: error.title, message: error.message)
    }
}

extension VideoViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy
        ) -> Void) {
        decisionHandler(.allow)
    }
}
