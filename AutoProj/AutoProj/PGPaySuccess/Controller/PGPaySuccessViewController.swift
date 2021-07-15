import UIKit

class PGPaySuccessViewController: UIViewController {
    
    let viewModel: PGPaySuccessViewModel
    let mainView: PGPaySuccessView
    
    init() {
        viewModel = PGPaySuccessViewModel(withModel: PGPaySuccessModel())
        mainView = PGPaySuccessView()
        super.init(nibName: nil, bundle: nil)
        
        mainView.configure(with: viewModel)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(mainView)
    }
}
