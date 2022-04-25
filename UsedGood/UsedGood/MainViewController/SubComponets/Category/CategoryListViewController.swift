//
//  CategoryListViewController.swift
//  UsedGood
//
//  Created by Seonghwan on 2022/02/13.
//
import UIKit
import RxSwift
import RxCocoa

class CategoryListViewController: UIViewController {
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        view.backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(_ viewModel: CategoryViewModel) {
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier:  String(describing: UITableViewCell.self),
                                                  for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = data.name
                return cell
            }
            .disposed(by: disposeBag)
        
        //RxExtension으로 할 수 있다
        viewModel.pop
            .emit(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        //View -> ViewModel
        tableView.rx.itemSelected
            .map { $0.row } //IndexPath전체에서 row
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        
    }
}
