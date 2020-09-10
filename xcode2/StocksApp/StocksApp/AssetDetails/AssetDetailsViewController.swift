
import Charts
import UIKit

class AssetDetailsViewController: ATCGenericCollectionViewController {
    let uiConfig: ATCUIGenericConfigurationProtocol
    let dsProvider: FinanceDataSourceProvider
    let asset: ATCFinanceAsset
    let user: ATCUser?
    private let watchlistButton: UIButton
    
    init(asset: ATCFinanceAsset,
         user: ATCUser?,
         uiConfig: ATCUIGenericConfigurationProtocol,
         dsProvider: FinanceDataSourceProvider) {
        self.uiConfig = uiConfig
        self.dsProvider = dsProvider
        self.asset = asset
        self.user = user
        self.watchlistButton = UIButton()
        let layout = ATCLiquidCollectionViewLayout(cellPadding: 0)
        let homeConfig = ATCGenericCollectionViewControllerConfiguration(pullToRefreshEnabled: false,
                                                                         pullToRefreshTintColor: .white,
                                                                         collectionViewBackgroundColor: UIColor(hexString: "#f4f6f9"),
                                                                         collectionViewLayout: layout,
                                                                         collectionPagingEnabled: false,
                                                                         hideScrollIndicators: true,
                                                                         hidesNavigationBar: false,
                                                                         headerNibName: nil,
                                                                         scrollEnabled: true,
                                                                         uiConfig: uiConfig)
        super.init(configuration: homeConfig)
        self.use(adapter: ATCCardViewControllerContainerRowAdapter(), for: "ATCViewControllerContainerViewModel")
        self.use(adapter: CardHeaderRowAdapter(uiConfig: uiConfig), for: "CardHeaderModel")
        self.use(adapter: CardFooterRowAdapter(uiConfig: uiConfig), for: "CardFooterModel")
        self.use(adapter: FinanceAssetPositionRowAdapter(uiConfig: uiConfig), for: "ATCFinanceAssetPosition")
        self.use(adapter: FinanceNewsRowAdapter(uiConfig: uiConfig), for: "ATCFinanceNewsModel")
        let tradingAdapter = AssetTradingUnitRowAdapter(uiConfig: uiConfig)
        tradingAdapter.delegate = self
        self.use(adapter: tradingAdapter, for: "FinanceTradingModel")
        self.use(adapter: FinanceAssetStatsRowAdapter(uiConfig: uiConfig), for: "ATCFinanceAssetStats")

        self.selectionBlock = {[weak self] (navController, object, indexPath) in
            guard let strongSelf = self else { return }
            if let news = object as? ATCFinanceNewsModel {
                if let url = URL(string: news.url) {
                    let vc = ATCWebViewController(url: url, title: news.publication)
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }

        self.title = asset.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureWatchlistButton()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: watchlistButton)

        dsProvider.fetchAssetDetails(for: user, asset: asset) { [weak self] (position, stats, news) in
            guard let `self` = self else { return }
            // Configuring the Chart
            let dateList: ATCDateList = ATCDateList(dates: [
                ATCChartDate(title: "1D", startDate: Date().yesterday),
                ATCChartDate(title: "1W", startDate: Date().oneWeekAgo),
                ATCChartDate(title: "1M", startDate: Date().oneMonthAgo),
                ATCChartDate(title: "3M", startDate: Date().threeMonthsAgo),
                ATCChartDate(title: "1Y", startDate: Date().oneYearAgo),
                ATCChartDate(title: "All", startDate: Date().infiniteAgo)
                ])

            let lineChartViewController = ATCDatedLineChartViewController(dateList: dateList,
                                                                          uiConfig: uiConfig)
            lineChartViewController.delegate = self

            let chartViewModel = ATCViewControllerContainerViewModel(viewController: lineChartViewController,
                                                                     cellHeight: 300,
                                                                     subcellHeight: nil)
            chartViewModel.parentViewController = self

            var items: [ATCGenericBaseModel] = [chartViewModel]
            if let position = position {
                items.append(position)
            }
            items.append(FinanceTradingModel())
            items.append(stats)
            items.append(CardHeaderModel(title: "Recent News"))
            items = items + news
            items.append(CardFooterModel(title: "View all stories"))

            self.genericDataSource = ATCGenericLocalHeteroDataSource(items: items)

            self.genericDataSource?.loadFirst()
        }
        //        self.use(adapter: ATCDividerRowAdapter(titleFont: uiConfig.regularFont(size: 16), minHeight: 30), for: "ATCDivider")
    }
    
    fileprivate func lineChartData(chart: ATCLineChart, config: ATCLineChartConfiguration) -> LineChartData {
        var lineChartEntry = [ChartDataEntry]()
        for (index, number) in chart.numbers.enumerated() {
            let value = ChartDataEntry(x: Double(index), y: number)
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: nil)
        line1.colors = [config.lineColor]
        line1.lineWidth = 3
        line1.drawValuesEnabled = false
        line1.mode = .cubicBezier
        line1.circleRadius = 0
        line1.circleHoleRadius = 4
        line1.drawFilledEnabled = true
        let colors: CFArray = [config.gradientStartColor.cgColor, config.gradientEndColor.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [1.0, 0.0])
        let fill = Fill(linearGradient: gradient!, angle: 90.0)
        
        line1.fill = fill
        let data = LineChartData()
        data.addDataSet(line1)
        return data
    }

    fileprivate func configureWatchlistButton() {
        let store = ATCDiskPersistenceStore(key: "asset_watchlist")
        let iconString = store.contains(object: asset) ? "add-filled-icon" : "add-empty-icon"
        watchlistButton.configure(icon: UIImage.localImage(iconString, template: true), color: uiConfig.mainThemeBackgroundColor)
        watchlistButton.snp.makeConstraints({ (maker) in
            maker.width.equalTo(25)
            maker.height.equalTo(25)
        })
        watchlistButton.addTarget(self, action: #selector(didTapWatchlistButton), for: .touchUpInside)
    }

    @objc fileprivate func didTapWatchlistButton() {
        let store = ATCDiskPersistenceStore(key: "asset_watchlist")
        if store.contains(object: asset) {
            store.remove(object: asset)
        } else {
            store.append(object: asset)
        }
        let iconString = store.contains(object: asset) ? "add-filled-icon" : "add-empty-icon"
        watchlistButton.configure(icon: UIImage.localImage(iconString, template: true), color: uiConfig.mainThemeBackgroundColor)
        watchlistButton.setNeedsLayout()
        watchlistButton.setNeedsDisplay()
    }
}

extension AssetDetailsViewController: ATCDatedLineChartViewControllerDelegate {
    func datedLineChartViewController(_ viewController: ATCDatedLineChartViewController,
                                      didSelect chartDate: ATCChartDate,
                                      titleLabel: UILabel,
                                      chartView: LineChartView ) -> Void {
        dsProvider.fetchAssetChart(for: self.asset, selectedDate: chartDate) {[weak self] (lineChart) in
            guard let `self` = self else { return }
            if let lineChart = lineChart {
                let config = dsProvider.chartConfig
                chartView.data = self.lineChartData(chart: lineChart, config: config)
                chartView.backgroundColor = config.backgroundColor
                chartView.chartDescription?.enabled = true
                
                chartView.pinchZoomEnabled = false
                chartView.dragEnabled = false
                chartView.setScaleEnabled(false)
                chartView.legend.enabled = false
                chartView.xAxis.enabled = false
                chartView.rightAxis.enabled = true
                chartView.rightAxis.drawGridLinesEnabled = false
                chartView.rightAxis.drawZeroLineEnabled = false
                chartView.rightAxis.drawAxisLineEnabled = false
                chartView.rightAxis.valueFormatter = ATCAbbreviatedAxisValueFormatter()
                chartView.rightAxis.labelTextColor = config.leftAxisColor
                chartView.leftAxis.enabled = false
                
                titleLabel.text = FinanceStaticDataProvider.currencyString + String(Int(lineChart.numbers.last ?? 0.0))
                titleLabel.font = uiConfig.regularFont(size: 30)
                titleLabel.textColor = uiConfig.mainTextColor
                //                chartView.leftAxis.labelTextColor = config.leftAxisColor
                //                chartView.leftAxis.axisLineColor = config.leftAxisColor
                //                chartView.leftAxis.valueFormatter = ATCAbbreviatedAxisValueFormatter()
                
                //                chartView.chartDescription?.text = lineChart.name
                //                chartView.chartDescription?.font = config.descriptionFont
                //                chartView.chartDescription?.textColor = config.descriptionColor
            } else {
                chartView.data = nil
            }
        }
    }
}

extension AssetDetailsViewController: AssetTradingUnitRowAdapterDelegate {
    func rowAdapterDidTapBuyButton(_ rowAdapter: AssetTradingUnitRowAdapter) {
        let vc = AssetTradingViewController(asset: asset,
                                            title: "Buying " + asset.ticker,
                                            keys: dsProvider.tradingNumericKeys,
                                            uiConfig: uiConfig)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func rowAdapterDidTapSellButton(_ rowAdapter: AssetTradingUnitRowAdapter) {
        let vc = AssetTradingViewController(asset: asset,
                                            title: "Selling " + asset.ticker,
                                            keys: dsProvider.tradingNumericKeys,
                                            uiConfig: uiConfig)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
}
