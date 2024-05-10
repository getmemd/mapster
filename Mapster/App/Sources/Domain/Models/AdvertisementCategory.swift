enum AdvertisementCategory: String, CaseIterable {
    case cars
    case realEstate
    case furniture
    case electronics
    case phonesAndAccessories
    case clothingAndAccessories
    case sportsGoods
    case tools
    case booksAndEducation
    case kidsGoods
    case hobbiesAndLeisure
    case pets
    case musicalInstruments
    case computersAndAccessories
    case collecting
    case homeAppliances
    case gardenAndOutdoor
    case buildingMaterials
    case services
    case cosmeticsAndCare
    case other

    var icon: String {
        switch self {
        case .cars:
            return "car.fill"
        case .realEstate:
            return "house.fill"
        case .furniture:
            return "bed.double.fill"
        case .electronics:
            return "desktopcomputer"
        case .phonesAndAccessories:
            return "phone.fill"
        case .clothingAndAccessories:
            return "tshirt.fill"
        case .sportsGoods:
            return "sportscourt.fill"
        case .tools:
            return "wrench.fill"
        case .booksAndEducation:
            return "books.vertical.fill"
        case .kidsGoods:
            return "figure.child"
        case .hobbiesAndLeisure:
            return "airplane"
        case .pets:
            return "pawprint.fill"
        case .musicalInstruments:
            return "music.note"
        case .computersAndAccessories:
            return "laptopcomputer"
        case .collecting:
            return "star.fill"
        case .homeAppliances:
            return "microwave.fill"
        case .gardenAndOutdoor:
            return "leaf.fill"
        case .buildingMaterials:
            return "hammer.fill"
        case .services:
            return "person.2.fill"
        case .cosmeticsAndCare:
            return "mouth.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }

    var displayName: String {
        switch self {
        case .cars:
            return "Автомобили"
        case .realEstate:
            return "Недвижимость"
        case .furniture:
            return "Мебель"
        case .electronics:
            return "Электроника"
        case .phonesAndAccessories:
            return "Телефоны и аксессуары"
        case .clothingAndAccessories:
            return "Одежда и аксессуары"
        case .sportsGoods:
            return "Спортивные товары"
        case .tools:
            return "Инструменты"
        case .booksAndEducation:
            return "Книги и образование"
        case .kidsGoods:
            return "Товары для детей"
        case .hobbiesAndLeisure:
            return "Хобби и отдых"
        case .pets:
            return "Животные"
        case .musicalInstruments:
            return "Музыкальные инструменты"
        case .computersAndAccessories:
            return "Компьютеры и аксессуары"
        case .collecting:
            return "Коллекционирование"
        case .homeAppliances:
            return "Бытовая техника"
        case .gardenAndOutdoor:
            return "Сад и огород"
        case .buildingMaterials:
            return "Строительные материалы"
        case .services:
            return "Услуги"
        case .cosmeticsAndCare:
            return "Косметика и уход"
        case .other:
            return "Прочее"
        }
    }
}
