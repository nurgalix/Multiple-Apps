import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Properties
    
    private let appsName = ["Stopwatch", "BMI Calculator"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Apps"
        view.backgroundColor = .systemBackground
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(8)
            $0.bottom.right.equalToSuperview().inset(8)
        }
    }
    
    
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let viewModel = CollectionViewCell.ViewModel(title: appsName[indexPath.row % 2])
        cell.configure(with: viewModel)
        cell.backgroundColor = .systemMint
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            navigationController?.pushViewController(StopwatchViewController(), animated: false)
        } else {
            navigationController?.pushViewController(BMICalculatorViewController(), animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let firstWindow = firstScene.windows.first {
                if let interfaceOrientation = firstWindow.windowScene?.interfaceOrientation {
                    if(interfaceOrientation == .landscapeLeft || interfaceOrientation == .landscapeRight)
                    {
                        return CGSizeMake(collectionView.frame.size.width, (collectionView.frame.size.height-32)/8)
                    }
                    else{
                        return CGSize(width: collectionView.frame.width, height: (collectionView.frame.height - 16) / 2)
                    }
                }
            }
        }
        return CGSize(width: collectionView.frame.width, height: (collectionView.frame.height - 16) / 2)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
