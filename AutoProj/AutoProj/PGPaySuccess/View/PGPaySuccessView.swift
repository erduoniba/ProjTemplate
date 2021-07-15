import UIKit

class PGPaySuccessView: UIView {

    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: PGPaySuccessViewModel) {
        // configure the view with a PGPaySuccessViewModel
    }
}
