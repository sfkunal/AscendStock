

import UIKit

class InstaMultiRowPageCarouselCollectionViewCell: UICollectionViewCell, ATCGenericCollectionViewScrollDelegate {
    @IBOutlet var containerView: UIView!
    @IBOutlet var carouselTitleLabel: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var carouselContainerView: UIView!

    func genericScrollView(_ scrollView: UIScrollView, didScrollToPage page: Int) {
        pageControl.currentPage = page
    }
}
