

import UIKit

class ATCViewControllerContainerCollectionViewCell: UICollectionViewCell {

    @IBOutlet var containerView: UIView!

    func configure(viewModel: ATCViewControllerContainerViewModel) {
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()

        let viewController = viewModel.viewController

        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        self.setNeedsLayout()
        viewModel.parentViewController?.addChild(viewModel.viewController)
    }
}
