//
//  LoginWebViewController.swift
//  MobileUpGallery
//
//  Created by Natalia on 14.08.2024.
//

import UIKit
import WebKit

protocol LoginWebViewProtocol: AnyObject {
    func loadWebView(_ url: URL)
}

final class LoginWebViewController: UIViewController {

    private let presenter: LoginWebViewPresenterProtocol

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()
    
    init(presenter: LoginWebViewPresenterProtocol) {
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
        
        presenter.loadWebView()
    }
    
}

extension LoginWebViewController: LoginWebViewProtocol {
    func loadWebView(_ url: URL) {
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}

extension LoginWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, let _ = url.fragment else {
            decisionHandler(.allow)
            return
        }
        presenter.fetchAccessToken(from: url)
        decisionHandler(.cancel)
    }
}
