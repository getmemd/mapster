import UIKit
import Combine

// Расширение для UIViewController для привязки к Store
public extension UIViewController {
    // Метод для привязки Store к контроллеру
    func bindStore<Event, Action>(_ store: Store<Event, Action>,
                                  handler: @escaping (Event) -> Void) -> AnyCancellable {
        // Подписка на события из Store с обработкой на главном потоке
        store
            .events
            .receiveOnMainQueue()
            .sink { event in
                handler(event)
            }
    }
}
