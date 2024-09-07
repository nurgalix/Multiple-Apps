import UIKit
import SnapKit

final class ResultViewController: UIViewController {
    
    // MARK: - Properties
    
    var bmi: BMI?
    var defaultValue: Float = 0.0
    
    // MARK: - UI
    
    var bmiResultLabel: UILabel!
    var adviceLabel: UILabel!
    var recalculateButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupBMIResultLabel()
        setupAdviceLabel()
        setupRecalculateButton()
        
        bmiResultLabel.text = self.bmi?.textValue
    }
    
    func setupBMIResultLabel() {
        bmiResultLabel = UILabel()
        bmiResultLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        bmiResultLabel.textAlignment = .center
        view.addSubview(bmiResultLabel)
        
        // Use SnapKit for constraints
        bmiResultLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
        }
    }
    
    func setupAdviceLabel() {
        adviceLabel = UILabel()
        adviceLabel.font = UIFont.systemFont(ofSize: 20)
        adviceLabel.textAlignment = .center
        adviceLabel.numberOfLines = 0
        view.addSubview(adviceLabel)
        
        adviceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bmiResultLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func setupRecalculateButton() {
        recalculateButton = UIButton(type: .system)
        recalculateButton.setTitle("Recalculate", for: .normal)
        recalculateButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        recalculateButton.addTarget(self, action: #selector(recalculateAction), for: .touchUpInside)
        view.addSubview(recalculateButton)
        
        recalculateButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(adviceLabel.snp.bottom).offset(50)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    @objc func recalculateAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
