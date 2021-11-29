//
//  ViewController.swift
//  RxSkeletonTest
//
//  Created by Inpyo Hong on 2021/11/29.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources
import SkeletonView

enum Row {
    case skeleton
    case username(String)
}

typealias Section = SectionModel<Void, Row>

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()

    let skeletons: BehaviorRelay<[Row]> = BehaviorRelay(value: Array(repeating: .skeleton, count: 10))
    var dataSources: BehaviorRelay<[Row]> = BehaviorRelay(value: [Row]() )
        
    private let dataSource = RxTableViewSectionedReloadDataSource<Section>(configureCell: { _, tableView, indexPath, row -> UITableViewCell in
        switch row {
        case .skeleton:
            return UsernameTableViewCell.configure(tableView: tableView, indexPath: indexPath, username: "")
            
        case .username(let username):
            return UsernameTableViewCell.configure(tableView: tableView, indexPath: indexPath, username: username)
        }
    })
    
    override func viewDidLoad() {
        configTableView()
        refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.showSkeleton()
    }
    
    func configTableView() {
        view.isSkeletonable = true
        
        self.tableView.delegate = self
        
        let nib = UINib(nibName: "UsernameTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "UsernameTableViewCell")
        
        Observable.merge(dataSources.asObservable())
            .map { [SectionModel(model: (), items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func refreshData() {
        dataSources.accept(Array(repeating: .skeleton, count: 10))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
            dataSources.accept([.username("scorpion"), .username("vanilla"), .username("couch"), .username("meat")])
            view.hideSkeleton()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
