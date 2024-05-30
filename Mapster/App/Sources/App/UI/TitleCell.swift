import UIKit

// Финальный класс для ячейки с заголовком
final class TitleCell: UITableViewCell {
    // UILabel для заголовка
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .bold, size: 22)
        label.numberOfLines = 0
        return label
    }()
    
    // Инициализация ячейки
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    // Инициализация из storyboard или xib не поддерживается
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Конфигурация ячейки с заголовком
    func configure(title: String) {
        titleLabel.text = title
    }
    
    // Настройка видов
    private func setupViews() {
        backgroundColor = .clear
        contentView.addSubview(titleLabel)
    }
    
    // Настройка ограничений для видов
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(36)
        }
    }
}
