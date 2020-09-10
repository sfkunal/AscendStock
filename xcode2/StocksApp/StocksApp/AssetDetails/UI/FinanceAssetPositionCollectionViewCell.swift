

import UIKit

class FinanceAssetPositionCollectionViewCell: UICollectionViewCell {
    @IBOutlet var containerView: UIView!

    @IBOutlet var sharesContainerView: UIView!
    @IBOutlet var sharesTitleLabel: UILabel!
    @IBOutlet var sharesLabel: UILabel!

    @IBOutlet var equityContainerView: UIView!
    @IBOutlet var equityTitleLabel: UILabel!
    @IBOutlet var equityLabel: UILabel!
    
    @IBOutlet var avgCostContainerView: UIView!
    @IBOutlet var avgCostTitleLabel: UILabel!
    @IBOutlet var avgCostLabel: UILabel!
    
    @IBOutlet var diversityContainerView: UIView!
    @IBOutlet var diversityTitleLabel: UILabel!
    @IBOutlet var diversityLabel: UILabel!
    
    @IBOutlet var todayContainerView: UIView!
    @IBOutlet var todayBorderBottomView: UIView!
    @IBOutlet var todayLabel: UILabel!
    @IBOutlet var todayTitleLabel: UILabel!

    @IBOutlet var totalContainerView: UIView!
    @IBOutlet var totalBorderBottomView: UIView!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var totalTitleLabel: UILabel!

    @IBOutlet var positionTitleLabel: UILabel!
}
