

import SnapKit
import UIKit
import WebKit

class WebViewController: UIViewController {
    // MARK: - Properties

    var titleWeb: String? {
        didSet {
            titleLabel.text = titleWeb
        }
    }

    var url: String?

    private lazy var componentsView: ComponentsView = .init()

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        guard let url = url else { return webView }
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        webView.backgroundColor = AppColor.background.color
        webView.navigationDelegate = self

        return webView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(32)
        label.text = titleWeb
        label.textColor = .white
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(named: "back")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color
        componentsView.addSubviews(webView)
        componentsView.backgroundColor = .white
        view.addSubviews(backButton,
                         titleLabel,
                         componentsView)
        setupLayout()
    }

    private func setupLayout() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(32)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.top).offset(-6)
            make.leading.equalTo(backButton.snp.trailing).offset(24)
        }

        componentsView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
        }

        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Actions

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let backgroundColorCode = "document.body.style.backgroundColor = '#FFFFFF';"
        webView.evaluateJavaScript(backgroundColorCode)

        let jsCode = """
            var style = document.createElement('style');
            style.innerHTML = 'body { font-family: "Poppins", sans-serif; padding-top: 24px; }';
            document.head.appendChild(style);
        """
        webView.evaluateJavaScript(jsCode)

        let h1Styles = """
            var h1Elements = document.querySelectorAll('h1');
            for (var i = 0; i < h1Elements.length; i++) {
                h1Elements[i].style.fontFamily = 'Poppins-Bold, sans-serif';
                h1Elements[i].style.fontSize = '28px';
                h1Elements[i].style.color = 'black';
            }
        """
        webView.evaluateJavaScript(h1Styles)

        let pStyles = """
            var pElements = document.querySelectorAll('p');
            for (var i = 0; i < pElements.length; i++) {
                pElements[i].style.fontFamily = 'Poppins-Regular, sans-serif';
                pElements[i].style.fontSize = '16px';
                pElements[i].style.color = 'black';
            }
        """
        webView.evaluateJavaScript(pStyles)
    }
}
