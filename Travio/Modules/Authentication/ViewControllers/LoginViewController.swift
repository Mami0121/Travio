

import SnapKit
import UIKit

class LoginViewController: UIViewController {
    // MARK: - Properties

    private lazy var viewModel: LoginViewModel = {
        let vm = LoginViewModel()
        return vm
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "travio-logo 1"))
        return imageView
    }()

    private lazy var componentsView = ComponentsView()

    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsMedium.withSize(24)
        label.textAlignment = .center
        label.text = "Welcome to Travio"
        label.textColor = AppColor.secondary.color
        return label
    }()

    private lazy var emailView: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = "Enter your email address"
        view.textField.text = "furkanikb@gmail.com"
        view.titleView = "Email"
        return view
    }()

    private lazy var passwordView: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = "*************"
        view.textField.text = "123123123"
        view.isSecure = true
        view.titleView = "Password"

        return view
    }()

    private lazy var loginButton: TravioButton = {
        let button = TravioButton()
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Dont have any acoount?"
        label.font = AppFont.poppinsSemiBold.withSize(14)
        label.textColor = AppColor.secondary.color
        return label
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(AppColor.secondary.color, for: .normal)
        button.titleLabel?.font = AppFont.poppinsSemiBold.withSize(14)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv

    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods

    func showAlert(from viewController: UIViewController, title: String, message: String, completion: (() -> Void)?) {
        showAlert(title: title, message: message)
    }

    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        stackView.addArrangedSubviews(signUpLabel, signUpButton)
        view.addSubviews(logoImageView, componentsView, emailView, passwordView, loginButton, stackView)
        componentsView.addSubviews(welcomeLabel)
        view.backgroundColor = AppColor.primary.color
        setupLayout()
    }

    private func setupLayout() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(178)
            make.width.equalTo(149)
        }
        componentsView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
        }

        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
        }

        emailView.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(42)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }

        passwordView.snp.makeConstraints { make in
            make.top.equalTo(emailView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(54)
        }

        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Public Methods

    // MARK: - Actions

    @objc func signUpButtonTapped() {
        let registerVc = RegisterViewController()
        registerVc.delegate = self
        navigationController?.pushViewController(registerVc, animated: true)
    }

    @objc func loginButtonTapped() {
        guard let email = emailView.textField.text,
              let password = passwordView.textField.text else { return }

        let input = Login(email: email, password: password)
        showSpinner()
        viewModel.login(input, callback: { [weak self] message, confirm in
            if confirm {
                let mainTbc = MainTabBarController()
                self?.navigationController?.pushViewController(mainTbc, animated: true)
                self?.hideSpinner()
            } else {
                self?.showAlert(title: "Error", message: message)
                self?.hideSpinner()
            }
        })
    }
}

// MARK: - Extensions

protocol LoginViewControllerDelegate: AnyObject {
    func registrationSuccessAlert(title: String, message: String)
}

extension LoginViewController: LoginViewControllerDelegate {
    func registrationSuccessAlert(title: String, message: String) {
        showAlert(title: title, message: message)
    }
}
