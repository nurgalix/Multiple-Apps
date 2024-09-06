protocol Configurable: AnyObject {
    
    associatedtype ViewModel
    
    func configure(with viewModel: ViewModel)
}
