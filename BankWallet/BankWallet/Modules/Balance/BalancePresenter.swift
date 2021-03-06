import RxSwift

class BalancePresenter {
    private let interactor: IBalanceInteractor
    private let router: IBalanceRouter

    weak var view: IBalanceView?

    init(interactor: IBalanceInteractor, router: IBalanceRouter) {
        self.interactor = interactor
        self.router = router
    }

    private func updateView() {
        var totalBalance: Double = 0

        var viewItems = [BalanceViewItem]()
        let currency = interactor.baseCurrency

        var allSynced = true

        for wallet in interactor.wallets {
            let balance = wallet.adapter.balance
            let rate = interactor.rate(forCoin: wallet.coin)

            var rateExpired = true

            if let rate = rate {
                rateExpired = rate.expired
                totalBalance += balance * rate.value
            }

            viewItems.append(BalanceViewItem(
                    coinValue: CoinValue(coin: wallet.coin, value: balance),
                    exchangeValue: rate.map { CurrencyValue(currency: currency, value: $0.value) },
                    currencyValue: rate.map { CurrencyValue(currency: currency, value: balance * $0.value) },
                    state: wallet.adapter.state,
                    rateExpired: rateExpired
            ))

            if case .syncing = wallet.adapter.state {
                allSynced = false
            }
            allSynced = allSynced && !rateExpired
        }

        view?.show(totalBalance: CurrencyValue(currency: currency, value: totalBalance), upToDate: allSynced)
        view?.show(items: viewItems)
    }

}

extension BalancePresenter: IBalanceInteractorDelegate {

    func didUpdate() {
        updateView()
    }

    func didRefresh() {
        view?.didRefresh()
    }

}

extension BalancePresenter: IBalanceViewDelegate {

    func viewDidLoad() {
        view?.set(title: "balance.title")

        updateView()
    }

    func refresh() {
        interactor.refresh()
    }

    func onReceive(for coin: Coin) {
        router.openReceive(for: coin)
    }

    func onPay(for coin: Coin) {
        router.openSend(for: coin)
    }

}
