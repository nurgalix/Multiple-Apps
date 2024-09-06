import UIKit
import SnapKit

final class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    // MARK: - Private
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension CollectionViewCell: Configurable {
    
    struct ViewModel {
        let title: String
    }
    
    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
    }
    
}
