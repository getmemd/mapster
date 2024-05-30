import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import IQKeyboardManagerSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var applicationCoordinator: AppCoordinator?
    
    // Метод запуска приложения
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Включение менеджера клавиатуры
        IQKeyboardManager.shared.enable = true
        // Конфигурация Firebase
        FirebaseApp.configure()
        // Установка языка аутентификации
        Auth.auth().useAppLanguage()
        // Настройка координатора
        setupCoordinator()
        return true
    }
    
    // Настройка координатора
    private func setupCoordinator() {
        let navigationController = UINavigationController()
        // Инициализация окна
        window = UIWindow(frame: UIScreen.main.bounds)
        // Отображение окна
        window?.makeKeyAndVisible()
        // Установка корневого контроллера
        window?.rootViewController = navigationController
        // Создание и запуск координатора
        applicationCoordinator = AppCoordinator(router: .init(navigationController: navigationController))
        applicationCoordinator?.start()
    }
}
