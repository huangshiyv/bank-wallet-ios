import UIKit
import GrouviExtensions
import SnapKit

class TransactionCell: UITableViewCell {
    var highlightBackground = UIView()

    var dateLabel = UILabel()
    var timeLabel = UILabel()

    var statusImageView = UIImageView()

    var amountLabel = UILabel()
    var fiatAmountLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = TransactionsTheme.cellBackground

        highlightBackground.backgroundColor = TransactionsTheme.cellHighlightBackgroundColor
        highlightBackground.alpha = 0
        contentView.addSubview(highlightBackground)
        highlightBackground.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        dateLabel.font = TransactionsTheme.dateLabelFont
        dateLabel.textColor = TransactionsTheme.dateLabelTextColor
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(contentView.snp.leadingMargin).offset(TransactionsTheme.leftAdditionalMargin)
            maker.top.equalToSuperview().offset(TransactionsTheme.cellMediumMargin)
        }
        timeLabel.font = TransactionsTheme.timeLabelFont
        timeLabel.textColor = TransactionsTheme.timeLabelTextColor
        timeLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        timeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(contentView.snp.leadingMargin).offset(TransactionsTheme.leftAdditionalMargin)
            maker.top.equalTo(self.dateLabel.snp.bottom).offset(TransactionsTheme.cellSmallMargin)
        }

        contentView.addSubview(statusImageView)
        statusImageView.snp.makeConstraints { maker in
            maker.size.equalTo(TransactionsTheme.statusImageViewSize)
            maker.leading.equalTo(self.timeLabel.snp.trailing).offset(TransactionsTheme.cellMilliMargin)
            maker.centerY.equalTo(self.timeLabel)
        }


        amountLabel.font = TransactionsTheme.amountLabelFont
        contentView.addSubview(amountLabel)
        amountLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        amountLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        amountLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(self.dateLabel.snp.trailing).offset(TransactionsTheme.cellMediumMargin)
            maker.top.equalToSuperview().offset(TransactionsTheme.cellMediumMargin)
            maker.trailing.equalTo(contentView.snp.trailingMargin)
        }

        fiatAmountLabel.font = TransactionsTheme.fiatAmountLabelFont
        fiatAmountLabel.textColor = TransactionsTheme.fiatAmountLabelColor
        fiatAmountLabel.textAlignment = .right
        contentView.addSubview(fiatAmountLabel)
        fiatAmountLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(self.timeLabel.snp.trailing).offset(TransactionsTheme.cellMediumMargin)
            maker.top.equalTo(self.amountLabel.snp.bottom).offset(TransactionsTheme.cellMicroMargin)
            maker.trailing.equalTo(contentView.snp.trailingMargin)
        }

        let separatorView = UIView()
        separatorView.backgroundColor = TransactionsTheme.separatorColor
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { maker in
            maker.leading.bottom.trailing.equalToSuperview()
            maker.height.equalTo(1 / UIScreen.main.scale)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    func bind(item: TransactionViewItem) {
        dateLabel.text = (item.date.map { DateHelper.instance.formatTransactionDate(from: $0) })?.uppercased()
        timeLabel.text = item.date.map { DateHelper.instance.formatTransactionTime(from: $0) }

        amountLabel.textColor = item.incoming ? TransactionsTheme.incomingTextColor : TransactionsTheme.outgoingTextColor
        amountLabel.text = ValueFormatter.instance.format(coinValue: item.coinValue, explicitSign: true)

        if let value = item.currencyValue, let formattedValue = ValueFormatter.instance.format(currencyValue: value, approximate: true) {
            fiatAmountLabel.text = formattedValue
        } else {
            fiatAmountLabel.text = "n/a"
        }

        switch item.status {
        case .pending:
            statusImageView.image = UIImage(named: "Transaction Processing Icon")
        case .processing:
            statusImageView.image = UIImage(named: "Transaction Processing Icon")
        case .completed:
            statusImageView.image = UIImage(named: "Transaction Success Icon")
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        guard selectionStyle != .none else { return }
        if animated {
            UIView.animate(withDuration: AppTheme.defaultAnimationDuration) {
                self.highlightBackground.alpha = highlighted ? 1 : 0
            }
        } else {
            highlightBackground.alpha = highlighted ? 1 : 0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        guard selectionStyle != .none else { return }
        if animated {
            UIView.animate(withDuration: AppTheme.defaultAnimationDuration) {
                self.highlightBackground.alpha = selected ? 1 : 0
            }
        } else {
            highlightBackground.alpha = selected ? 1 : 0
        }
    }

}
