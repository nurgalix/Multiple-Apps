import Foundation

struct BMI {
    
    // MARK: - Properties
    
    var value: Float?
    var textValue: String?
    
    mutating func calculate(weight: Float, height: Float) {
        self.value = (weight)/(pow(height, 2))
        self.textValue = "\(String(format: "%.1f", self.value ?? 0.0))"
    }
    
}
