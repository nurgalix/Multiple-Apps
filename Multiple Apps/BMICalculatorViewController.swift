import UIKit
import SnapKit

final class BMICalculatorViewController: UIViewController {
    
    // MARK: - UI
    
    var heightSlider: UISlider!
    var weightSlider: UISlider!
    
    var heightLabel: UILabel!
    var weightLabel: UILabel!
    
    var calculateBMIButton: UIButton!
    
    var bmi = BMI()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupHeightSlider()
        setupWeightSlider()
        setupHeightLabel()
        setupWeightLabel()
        setupCalculateButton()
        
        calculateBMIButton.layer.cornerRadius = 25
    }
    
    
    func setupHeightSlider() {
        heightSlider = UISlider()
        heightSlider.minimumValue = 0.5
        heightSlider.maximumValue = 2.5
        heightSlider.value = 1.75
        heightSlider.addTarget(self, action: #selector(heightSliderChanged(_:)), for: .valueChanged)
        view.addSubview(heightSlider)
        
        heightSlider.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            $0.width.equalTo(300)
        }
    }
    
    func setupWeightSlider() {
        weightSlider = UISlider()
        weightSlider.minimumValue = 30
        weightSlider.maximumValue = 150
        weightSlider.value = 70
        weightSlider.addTarget(self, action: #selector(weightSliderChanged(_:)), for: .valueChanged)
        view.addSubview(weightSlider)
        
        weightSlider.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(heightSlider.snp.bottom).offset(50)
            $0.width.equalTo(300)
        }
    }
    
    func setupHeightLabel() {
        heightLabel = UILabel()
        heightLabel.text = "1.75 m"
        view.addSubview(heightLabel)
        
        heightLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(heightSlider.snp.bottom).offset(10)
        }
    }
    
    func setupWeightLabel() {
        weightLabel = UILabel()
        weightLabel.text = "70 KG"
        view.addSubview(weightLabel)
        
        weightLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(weightSlider.snp.bottom).offset(10)
        }
    }
    
    func setupCalculateButton() {
        calculateBMIButton = UIButton(type: .system)
        calculateBMIButton.setTitle("Calculate BMI", for: .normal)
        calculateBMIButton.addTarget(self, action: #selector(calculateBMIAction), for: .touchUpInside)
        view.addSubview(calculateBMIButton)
        
        calculateBMIButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(weightLabel.snp.bottom).offset(50)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    @objc func heightSliderChanged(_ sender: UISlider) {
        updateLabelFromSlider(label: heightLabel, slider: sender, measurement: "m", decimalPlaces: 2)
    }
    
    @objc func weightSliderChanged(_ sender: UISlider) {
        updateLabelFromSlider(label: weightLabel, slider: sender, measurement: "KG", decimalPlaces: 0)
    }
    
    func updateLabelFromSlider(label: UILabel, slider: UISlider, measurement: String, decimalPlaces: Int = 1) {
        label.text = "\(String(format: "%.\(decimalPlaces)f", slider.value)) \(measurement)"
    }
    
    @objc func calculateBMIAction() {
        bmi.calculate(weight: weightSlider.value, height: heightSlider.value)
        let resultVC = ResultViewController()
        resultVC.bmi = bmi
        self.present(resultVC, animated: true, completion: nil)
    }
    
    
}
