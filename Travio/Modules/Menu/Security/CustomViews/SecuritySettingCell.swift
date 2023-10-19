

import UIKit

class SecuritySettingCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let identifier = "SecuritySettingCell"

    lazy var privacyView: PrivacyView = {
        let view = PrivacyView()
        return view
    }()
    
    lazy var passwordView: TravioUIView = {
        let view = TravioUIView()
        view.isSecure = true
        return view
    }()

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        contentView.addSubviews(privacyView, passwordView)
        
        passwordView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        privacyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Cell Configuration
    
    func configure(with item: Item) {
        switch item.type {
        case .textInput(let title, let placeholder):
            passwordView.titleView = title
            passwordView.placeholderText = placeholder
            passwordView.isHidden = false
            privacyView.isHidden = true
        case .switchItem(let title):
            privacyView.titleView = title
            passwordView.isHidden = true
            privacyView.isHidden = false
        }
    }
    
    // MARK: - Actions
}
