

import UIKit

class TravioTextView: UIView {
    var titleView: String = "Default" {
        didSet {
            updateLabel()
        }
    }

    private func updateLabel() {
        label.text = titleView
    }

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.secondary.color
        label.font = AppFont.poppinsMedium.withSize(14)
        label.text = "Default"
        return label
    }()

    public var textView: UITextView = {
        let textView = UITextView()
        textView.font = AppFont.poppinsRegular.withSize(12)
        textView.backgroundColor = .white
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.textColor = AppColor.secondary.color
        return textView
    }()

    var insets: UIEdgeInsets

    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.insets = insets
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        addShadow()
        addSubviews(label, textView)
        setupConstraints()
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(12)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.equalTo(label.snp.leading)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}

