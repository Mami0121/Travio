

import SnapKit
import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let identifier = "SectionHeaderView"
    
    let label: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(16)
        label.textColor = AppColor.primary.color
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        label.text = title
    }
}
