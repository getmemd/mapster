import CoreLocation
import UIKit

@MainActor
final class LocationDataManager: NSObject, ObservableObject {
    static let shared = LocationDataManager()  // Singleton экземпляр
    private let locationManager = CLLocationManager()  // Менеджер локаций
    
    // Инициализация менеджера локаций
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Начать обновление локации
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    // Остановить обновление локации
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    // Получить текущую локацию
    func getCurrentLocation() -> CLLocation? {
        locationManager.location
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationDataManager: CLLocationManagerDelegate {
    // Обработка изменения авторизации
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            break
        default:
            break
        }
    }
}
