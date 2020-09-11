

import UIKit

class InstaTopLinedPageCarouselCollectionViewCell: UICollectionViewCell, ATCGenericCollectionViewScrollDelegate {
    @IBOutlet var containerView: UIView!
    @IBOutlet var carouselContainerView: UIView!
    @IBOutlet var linePageControl: InstaLinePageControl!
    
    func genericScrollView(_ scrollView: UIScrollView, didScrollToPage page: Int) {
        linePageControl.selectedPage = page
    }
}
