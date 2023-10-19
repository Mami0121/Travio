

import UIKit

class ExpandableCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let identifier = "ExpandableCell"
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsMedium.withSize(14)
        label.textColor = AppColor.secondary.color
        label.numberOfLines = 0
        return label
    }()
    
    lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsLight.withSize(10)
        label.textColor = AppColor.secondary.color
        label.numberOfLines = 0
        label.text = nil
        return label
    }()
    
    private lazy var expandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "expandIcon")
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        addShadow()
        addSubviews(questionLabel, answerLabel, expandImageView)
        setupLayout()
    }
    
    private func setupLayout() {
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-46)
        }
        
        expandImageView.snp.makeConstraints { make in
            make.centerY.equalTo(questionLabel.snp.centerY)
            make.leading.equalTo(questionLabel.snp.trailing).offset(16)
            make.width.equalTo(16)
            make.height.equalTo(10)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    // MARK: - Cell Configuration
    
    func configure(with item: FAQItem) {
        questionLabel.text = item.question
        if item.isExpanded {
            answerLabel.text = item.answer
            expandImageView.image = UIImage(named: "expandIcon")?.rotate180Degrees()

        } else {
            answerLabel.text = nil
            expandImageView.image = UIImage(named: "expandIcon")
        }
    }
    
    // MARK: - Actions
}
