

import SnapKit
import UIKit

class RegisterViewController: UIViewController {
    // MARK: - Properties

    weak var delegate: LoginViewControllerDelegate?

    private lazy var viewModel: RegisterViewModel = {
        let vm = RegisterViewModel()
        return vm
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(named: "back")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(36)
        label.textAlignment = .center
        label.text = "Sign Up"
        label.textColor = .white
        return label
    }()

    private lazy var componentsView = ComponentsView()

    private lazy var usernameView: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = "Enter your full name"
        view.titleView = "Full Name"
        return view
    }()

    private lazy var emailView: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = "Enter your email address"
        view.titleView = "Email"
        return view
    }()

    private lazy var passwordView: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = "*************"
        view.isSecure = true
        view.titleView = "Password"
        return view
    }()

    private lazy var passwordConfirmView: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = "*************"
        view.isSecure = true
        view.titleView = "Password Confirm"
        return view
    }()

    private lazy var registerButton: TravioButton = {
        let button = TravioButton()
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.isEnabled = false
        registerButton.backgroundColor = .gray

        usernameView.textField.delegate = self
        emailView.textField.delegate = self
        passwordView.textField.delegate = self
        passwordConfirmView.textField.delegate = self

        setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        componentsView.addSubviews(usernameView,
                                   emailView,
                                   passwordView,
                                   passwordConfirmView,
                                   registerButton)

        view.addSubviews(backButton,
                         signUpLabel,
                         componentsView)

        view.backgroundColor = AppColor.primary.color
        setupLayout()
    }

    private func setupLayout() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(32)
        }

        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }

        componentsView.snp.makeConstraints { make in
            make.top.equalTo(signUpLabel.snp.bottom).offset(56)
            make.leading.trailing.bottom.equalToSuperview()
        }

        usernameView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(72)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }

        emailView.snp.makeConstraints { make in
            make.top.equalTo(usernameView.snp.bottom).offset(24)
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

        passwordConfirmView.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }

        registerButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(56)
        }
    }

    // MARK: - Public Methods

    // MARK: - Actions

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func registerButtonTapped() {
        guard let username = usernameView.textField.text,
              let email = emailView.textField.text,
              let password = passwordView.textField.text,
              let passwordConfirm = passwordConfirmView.textField.text else { return }

        let input = Register(fullName: username, email: email, password: password)

        showSpinner()

        viewModel.register(input, passConfirm: passwordConfirm, callback: { [weak self] message, confirm in
            if confirm {
                self?.backButtonTapped()
                self?.delegate?.registrationSuccessAlert(title: "Success", message: message)
                self?.hideSpinner()
            } else {
                self?.showAlert(title: "Error", message: message)
                self?.hideSpinner()
            }
        })
    }
}

// MARK: - Extensions

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let username = usernameView.textField.text,
              let email = emailView.textField.text,
              let password = passwordView.textField.text,
              let passwordConfirm = passwordConfirmView.textField.text else { return }

        let isButtonEnabled = viewModel.fieldValidation(username: username, email: email, pass: password, passConfirm: passwordConfirm)

        registerButton.isEnabled = isButtonEnabled

        if !isButtonEnabled {
            registerButton.backgroundColor = .gray
        } else {
            registerButton.backgroundColor = AppColor.primary.color
        }
    }
}
