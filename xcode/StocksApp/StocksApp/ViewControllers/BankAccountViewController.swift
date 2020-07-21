

import Charts
import UIKit

class BankAccountViewController: ATCGenericCollectionViewController {
    let uiConfig: ATCUIGenericConfigurationProtocol
    let dsProvider: FinanceDataSourceProvider
    let financeAccount: ATCFinanceAccount

    init(uiConfig: ATCUIGenericConfigurationProtocol,
         financeAccount: ATCFinanceAccount,
         transactionDataSource: ATCGenericCollectionViewControllerDataSource,
         dsProvider: FinanceDataSourceProvider) {
        self.uiConfig = uiConfig
        self.dsProvider = dsProvider
        self.financeAccount = financeAccount
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

        // Configuring the Stock Chart
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

        // Configuring stock list
        let transactionsVC = TransactionsViewController(transactionDataSource: transactionDataSource,
                                                        dsProvider: dsProvider,
                                                        scrollingEnabled: false,
                                                        uiConfig: uiConfig)
        let transactionsListModel = ATCViewControllerContainerViewModel(viewController: transactionsVC,
                                                                        subcellHeight: 70)
        transactionsListModel.parentViewController = self

        self.genericDataSource = ATCGenericLocalHeteroDataSource(items: [chartViewModel,
                                                                         transactionsListModel])
        self.use(adapter: ATCCardViewControllerContainerRowAdapter(), for: "ATCViewControllerContainerViewModel")
        self.title = financeAccount.institution + ": " + financeAccount.title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
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
}

extension BankAccountViewController: ATCDatedLineChartViewControllerDelegate {
    func datedLineChartViewController(_ viewController: ATCDatedLineChartViewController,
                                      didSelect chartDate: ATCChartDate,
                                      titleLabel: UILabel,
                                      chartView: LineChartView ) -> Void {
        dsProvider.fetchBankAccountChart(for: financeAccount, selectedDate: chartDate) {[weak self] (lineChart) in
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
            } else {
                chartView.data = nil
            }
        }
    }
}
