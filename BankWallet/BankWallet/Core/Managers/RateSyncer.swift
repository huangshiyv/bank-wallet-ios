import Foundation
import RxSwift

class RateSyncer {
    private let disposeBag = DisposeBag()

    weak var delegate: IRateSyncerDelegate?

    private let networkManager: IRateNetworkManager
    private let timer: IPeriodicTimer
    private let async: Bool

    init(networkManager: IRateNetworkManager, timer: IPeriodicTimer, async: Bool = true) {
        self.networkManager = networkManager
        self.timer = timer
        self.async = async
    }

}

extension RateSyncer: IRateSyncer {

    func sync(coins: [String], currencyCode: String) {
        for coin in coins {
            var observable = networkManager.getLatestRate(coin: coin, currencyCode: currencyCode)

            if async {
                observable = observable.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background)).observeOn(MainScheduler.instance)
            }

            observable
                    .subscribe(onNext: { [weak self] latestRate in
                        self?.delegate?.didSync(coin: coin, currencyCode: currencyCode, latestRate: latestRate)
                    })
                    .disposed(by: disposeBag)
        }

        timer.schedule()
    }

}
