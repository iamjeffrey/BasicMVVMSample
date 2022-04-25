//
//  DetailWriteFormCellViewModel.swift
//  UsedGood
//
//  Created by Seonghwan on 2022/02/13.
//

import RxSwift
import RxCocoa

struct DetailWriteFormCellViewModel {
    //Category List에서 선택한 내용 스트림 전달
    //View -> ViewMode
    let contentValue = PublishRelay<String?>()
}
