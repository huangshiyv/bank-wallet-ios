import Foundation

protocol IPinView: class {
    func set(title: String)
    func addPage(withDescription description: String, showKeyboard: Bool)
    func show(page index: Int)
    func show(error: String, forPage index: Int)
    func show(error: String)
    func showPinWrong(page index: Int)
    func showKeyboard(for index: Int)
    func showCancel()
    func showSuccess()
}

protocol IPinViewDelegate {
    func viewDidLoad()
    func onEnter(pin: String, forPage index: Int)
    func onCancel()
}

protocol IPinInteractor {
    func set(pin: String?)
    func validate(pin: String) -> Bool
    func save(pin: String)

    func unlock(with pin: String) -> Bool
}

protocol IPinInteractorDelegate: class {
    func didSavePin()
    func didFailToSavePin()
}
