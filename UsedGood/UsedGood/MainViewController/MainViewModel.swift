//
//  MainViewModel.swift
//  UsedGood
//
//  Created by Seonghwan on 2022/02/13.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModel {
    let titileTextFieldCellViewModel = TitleTextFieldViewModel()
    let priceTextFieldCellViewModel = PriceTextFieldCellViewModel()
    let detailWriteFormCellViewModel = DetailWriteFormCellViewModel()
    
    //ViewModel -> View
    //MainView CellData, Stream으로 전달(Driver)
    let cellData: Driver<[String]>
    let presentAlert: Signal<Alert>
    let push: Driver<CategoryViewModel>
    
    //View -> ViewModel
    let itemSelected = PublishRelay<Int>()
    let submitButtonTapped = PublishRelay<Void>()
    
    init(model: MainModel = MainModel()) {
        //MARK:-cell data
        let title = Observable.just("Subject")
        let categoryViewModel = CategoryViewModel()
        let category = categoryViewModel.selectedCategory
            .map { $0.name }
            .startWith("카테고리 선택")
        
        let price = Observable.just("₩ 가격 (선택사항)")
        let detail = Observable.just("내용을 입력하세요.")
        
        //combineLatest
        self.cellData = Observable
            .combineLatest(
                title, category, price, detail
            ) { [$0, $1, $2, $3] } //배열로 묶어서 전달
            .asDriver(onErrorDriveWith: .empty())
        
        //MARK:-present alert (제출 버튼 선택 시)
        let titleMessage = titileTextFieldCellViewModel
            .titleText
            .map { $0?.isEmpty ?? true } //비어 있으면 true
            .startWith(true) //초기값 true
            .map { $0 ? ["- 글 제목을 입력해주세요."] : [] }
        
        let categoryMessage = categoryViewModel
            .selectedCategory
            .map { _ in false } //선택했으면 false로
            .startWith(true)
            .map { $0 ? ["- 카테고리를 선택해주세요."] : [] }
        
        let detailMessage = detailWriteFormCellViewModel
            .contentValue
            .map { $0?.isEmpty ?? true }
            .startWith(true)
            .map { $0 ? ["- 내용을 입력해주세요."] : [] } //내용이 있으면 빈배열
        
        let errorMessages = Observable
            .combineLatest(
                titleMessage, categoryMessage, detailMessage
            ) { $0 + $1 + $2 }
        
        //제출 버튼이 선택되었을때만 presentAlert을 트리거로
        self.presentAlert = submitButtonTapped
            .withLatestFrom(errorMessages) { $1 }
            .map(model.setAlert)
            // error 메시지를 Alert타입으로
//            .map { errorMessage -> (title: String, message: String?) in
//                let title = errorMessage.isEmpty ? "Success": "Failed"
//                let message = errorMessage.isEmpty ? nil : errorMessage.joined(separator: "\n")
//                return (title: title, message: message)
//            }
        //-> MainModel로
            .asSignal(onErrorSignalWith: .empty())
        
        //MARK:-push, 카테고리를 선택했을때만 CategoryViewModel로 변환
        self.push = itemSelected
            .compactMap { row -> CategoryViewModel? in
                guard case 1 = row else {
                    return nil
                }
                return categoryViewModel
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
