//
//  DetailWriteFormCell.swift
//  UsedGood
//
//  Created by Seonghwan on 2022/02/13.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class DetailWriteFormCell: UITableViewCell {
    let disposedBag = DisposeBag()
    let contentInputView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: DetailWriteFormCellViewModel) {
        //contentInputView -> contentValue Stream 연결
        contentInputView.rx.text
            .bind(to: viewModel.contentValue)
            .disposed(by: disposedBag)
    }
    
    
    private func attribute() {
        contentInputView.font = .systemFont(ofSize: 17)
    }
    
    private func layout() {
        contentView.addSubview(contentInputView)
        
        contentInputView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(300)
        }
    }
    
}
