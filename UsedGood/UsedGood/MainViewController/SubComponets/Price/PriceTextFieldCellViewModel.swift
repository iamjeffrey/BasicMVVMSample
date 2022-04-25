//
//  PriceTextFieldCellViewModel.swift
//  UsedGood
//
//  Created by Seonghwan on 2022/02/13.
//

import RxSwift
import RxCocoa

struct PriceTextFieldCellViewModel {
    //button show : ViewModel -> View
    let showFreeShareButton: Signal<Bool>
    
    //reset price
    let resetPrice: Signal<Void>
    
    //price value : view -> ViewModel
    //텍스트 입력한 text, UI Event이기 때문에 PublishRelay
    let priceValue = PublishRelay<String?>()
    
    //Button 이벤트 전달
    let freeShareButtonTapped = PublishRelay<Void>()
    
    init() {
        //view -> viewModel
        
        //price value를 확인했을 때 0이거나 빈값, 프리 버튼이 선택되었을 때 버튼 show여부
        self.showFreeShareButton = Observable.merge(
            priceValue.map { $0 ?? "" == "0" },
            freeShareButtonTapped.map { _ in false })
            .asSignal(onErrorJustReturn: false)
        
        //freeShareButtonTapped 선택하면 reset
        self.resetPrice = freeShareButtonTapped
            .asSignal(onErrorSignalWith: .empty())
    }
}
