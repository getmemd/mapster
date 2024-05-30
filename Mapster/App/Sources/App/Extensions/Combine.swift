import Combine
import Dispatch

// Расширение для Publisher, добавляющее метод для получения данных на главном потоке
public extension Publisher {
    func receiveOnMainQueue() -> Publishers.ReceiveOn<Self, DispatchQueue> {
        receive(on: DispatchQueue.main)
    }
}
