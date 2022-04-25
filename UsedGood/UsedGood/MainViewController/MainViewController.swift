//
//  ViewController.swift
//  UsedGood
//
//  Created by Seonghwan on 2022/02/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    let submitButton = UIBarButtonItem()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func bind(_ viewModel: MainViewModel) {
    //ViewModel -> View
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section:0)
                var identifier: String
                switch row {
                case 0:
                    identifier = String(describing: TitleTextFiledCellTableViewCell.self)
                    let cell = tv.dequeueReusableCell(withIdentifier: identifier,
                                                      for:index) as! TitleTextFiledCellTableViewCell
                    cell.selectionStyle = .none
                    cell.titleInputField.placeholder = data
                    cell.bind(viewModel.titileTextFieldCellViewModel)
                    return cell
                case 1:
                    identifier = "CategorySelectCell"
                    let cell = tv.dequeueReusableCell(withIdentifier: identifier, for: index)
                    cell.selectionStyle = .none
                    cell.textLabel?.text = data
                    cell.accessoryType = .disclosureIndicator
                    return cell
                case 2:
                    identifier = String(describing: PriceTextFieldCell.self)
                    let cell = tv.dequeueReusableCell(withIdentifier: identifier,
                                                      for:index) as! PriceTextFieldCell
                    cell.selectionStyle = .none
                    cell.priceInputField.placeholder = data
                    cell.bind(viewModel.priceTextFieldCellViewModel)
                    return cell
                case  3:
                    identifier = String(describing: DetailWriteFormCell.self)
                    let cell = tv.dequeueReusableCell(withIdentifier: identifier,
                                                      for:index) as! DetailWriteFormCell
                    cell.selectionStyle = .none
                    cell.contentInputView.text = data
                    cell.bind(viewModel.detailWriteFormCellViewModel)
                    return cell
                default:
                    fatalError()
                }
            }.disposed(by: disposeBag)
        
        //RxExtension
        viewModel.presentAlert
            .emit(to: self.rx.setAlert)
            .disposed(by: disposeBag)
        
        viewModel.push
            .drive(onNext: { viewModel in
                let viewController = CategoryListViewController()
                viewController.bind(viewModel)
                self.show(viewController, sender: nil) //ViewController 
            }).disposed(by: disposeBag)
        
//View -> ViewModel
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.itemSelected) //select tableview cell ->
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: viewModel.submitButtonTapped)
            .disposed(by: disposeBag)
    }

    private func attribute() {
        title = "중고거래 글쓰기"
        view.backgroundColor = .white
        submitButton.title = "Submit"
        submitButton.style = .done
        navigationItem.setRightBarButton(submitButton, animated: true)
        
        tableView.backgroundColor = .white
        
        tableView.register(TitleTextFiledCellTableViewCell.self,
                           forCellReuseIdentifier: "TitleTextFiledCellTableViewCell")
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "CategorySelectCell")
        tableView.register(PriceTextFieldCell.self,
                           forCellReuseIdentifier: String(describing: PriceTextFieldCell.self))
        tableView.register(DetailWriteFormCell.self,
                           forCellReuseIdentifier: String(describing: DetailWriteFormCell.self))
        
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
    
    func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

typealias Alert = (title: String, message: String?)
extension Reactive where Base: MainViewController {
    var setAlert: Binder<Alert> {
        return Binder(base) { base, data in
            //base = MainViewController
            let alertController = UIAlertController(title: data.title,
                                                    message: data.message,
                                                    preferredStyle: .alert)
            let action = UIAlertAction(title: "Confirm", style: .cancel, handler: nil)
            alertController.addAction(action)
            base.present(alertController, animated: true, completion: nil)
        }
    }
}

