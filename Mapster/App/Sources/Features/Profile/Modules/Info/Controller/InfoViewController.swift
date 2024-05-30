import UIKit

protocol InfoNavigationDelegate: AnyObject {
    func didTapClose(_ viewController: InfoViewController)
}

final class InfoViewController: BaseViewController {
    weak var navigationDelegate: InfoNavigationDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .bold, size: 18)
        label.numberOfLines = 0
        label.text = "Политика конфиденциальности"
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        textView.font = Font.mulish(name: .regular, size: 14)
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.tintColor = .textHighlight
        textView.text = """
        Введение

        Добро пожаловать в Mapster! Мы уважаем вашу конфиденциальность и стремимся защитить ваши персональные данные. Настоящая Политика конфиденциальности объясняет, какие данные мы собираем, как мы их используем и защищаем.

        Сбор данных

        Мы можем собирать следующие данные о вас:

        Имя и контактные данные (электронная почта, телефон).
        Информация о профиле (логин, пароль).
        Данные об объявлениях (тексты, фотографии).
        Технические данные (IP-адрес, тип устройства, информация о браузере).
        Использование данных

        Мы используем собранные данные для:

        Предоставления и улучшения наших услуг.
        Связи с вами по вопросам, связанным с вашим аккаунтом или объявлениями.
        Обеспечения безопасности и предотвращения мошенничества.
        Анализа и улучшения работы приложения.
        Передача данных

        Мы не передаем ваши личные данные третьим лицам, за исключением следующих случаев:

        С вашего согласия.
        Для выполнения юридических обязательств.
        В случае продажи или реорганизации компании.
        Защита данных

        Мы принимаем все необходимые меры для защиты ваших данных от несанкционированного доступа, изменения, раскрытия или уничтожения.

        Ваши права

        Вы имеете право на доступ, исправление или удаление ваших персональных данных, а также на ограничение их обработки. Для этого вы можете связаться с нами по электронной почте: privacy@mapster.com.

        Изменения в Политике конфиденциальности

        Мы можем периодически обновлять нашу Политику конфиденциальности. О любых изменениях мы будем сообщать на этой странице. Рекомендуем регулярно проверять эту страницу для получения актуальной информации.

        Контакты

        Если у вас есть вопросы по поводу данной Политики конфиденциальности, пожалуйста, свяжитесь с нами по электронной почте: privacy@mapster.com.

        Спасибо, что выбрали Mapster!
        """
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    @objc
    private func didTapClose() {
        navigationDelegate?.didTapClose(self)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        [closeButton, titleLabel, textView].forEach { scrollView.addSubview($0) }
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(24)
        }
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalTo(scrollView.frameLayoutGuide)
            $0.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide)
        }
        textView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide)
        }
    }
}
