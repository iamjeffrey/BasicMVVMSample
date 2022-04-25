//
//  TitleTextFiledCellTableViewCell.swift
//  UsedGood
//
//  Created by Seonghwan on 2022/02/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TitleTextFiledCellTableViewCell: UITableViewCell {
    let disposeBag = DisposeBag()
    let titleInputField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(_ viewModel: TitleTextFieldViewModel) {
        titleInputField.rx.text
            .bind(to: viewModel.titleText)
            .disposed(by: disposeBag)
        //titleInputField -> viewModel
    }
    
    private func attribute() {
        titleInputField.font = .systemFont(ofSize: 17)
        
    }
    
    private func layout() {
        contentView.addSubview(titleInputField)
        titleInputField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }

}
