//
//  CategoryViewModel.swift
//  UsedGood
//
//  Created by Seonghwan on 2022/02/13.
//

import RxSwift
import RxCocoa

struct CategoryViewModel {
    let disposeBag = DisposeBag()
    
    //ViewModel -> View
    let cellData: Driver<[Category]> //cell data를 뷰에 전달
    let pop: Signal<Void>
    
    //View -> ViewModel
    let itemSelected = PublishRelay<Int>() //선택한 로우
    
    //View -> ParentViewModel로 전달
    let selectedCategory = PublishSubject<Category>() //카테고리 데이터 전달
    
    init() {
        let categories = [
            Category(id: 1, name: "디지털/가전"),
            Category(id: 2, name: "게임"),
            Category(id: 3, name: "스포츠/레저"),
            Category(id: 4, name: "유아/아동용품"),
            Category(id: 5, name: "여성패션/잡화"),
            Category(id: 6, name: "뷰티/미용"),
            Category(id: 7, name: "남성패션/잡화"),
            Category(id: 8, name: "생활/식품"),
            Category(id: 9, name: "가구"),
            Category(id: 10, name: "도서/티켓/취미"),
            Category(id: 11, name: "기타")
        ]
        
        self.cellData = Driver.just(categories) //data 전달
        self.itemSelected.map {
            categories[$0]
        }
        .bind(to: selectedCategory) //선택한 item의 카테고리 전달
        .disposed(by: disposeBag)
        
        //로우를 선택했다는 이벤트 만 전달
        self.pop = itemSelected
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .empty())
    }
}
