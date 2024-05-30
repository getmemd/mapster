import Combine

// Открытый класс Store для управления событиями и действиями
open class Store<Event, Action> {
    // Субъект для событий
    private(set) var events = PassthroughSubject<Event, Never>()
    // Субъект для действий
    private(set) var actions = PassthroughSubject<Action, Never>()
    
    // Мешок для хранения подписок
    var bag = Bag()
    
    // Инициализация
    public init() {
        setupActionHandlers()
    }
    
    // Отправка действия
    public func sendAction(_ action: Action) {
        actions.send(action)
    }
    
    // Отправка события
    public func sendEvent(_ event: Event) {
        events.send(event)
    }
    
    // Настройка обработчиков действий
    func setupActionHandlers() {
        actions.sink { [weak self] action in
            self?.handleAction(action)
        }.store(in: &bag)
    }
    
    // Обработка действий (переопределяется в подклассах)
    open func handleAction(_ action: Action) {
        
    }
}
