//
//  MenuViewController.swift
//  CoffeeShop
//
//  Created by Göktuğ Gümüş on 23.09.2018.
//  Copyright © 2018 Göktuğ Gümüş. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

class MenuViewController: BaseViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  
  private lazy var shoppingCartButton: BadgeBarButtonItem = {
    let button = BadgeBarButtonItem(image: "cart_menu_icon", badgeText: nil, target: self, action: #selector(shoppingCartButtonPressed))
    
    button!.badgeButton!.tintColor = Colors.brown
    
    return button!
  }()
  
  private lazy var coffees: Observable<[Coffee]> = {
    let espresso = Coffee(name: "Espresso", icon: "espresso", price: 4.5)
    let cappuccino = Coffee(name: "Cappuccino", icon: "cappuccino", price: 11)
    let macciato = Coffee(name: "Macciato", icon: "macciato", price: 13)
    let mocha = Coffee(name: "Mocha", icon: "mocha", price: 8.5)
    let latte = Coffee(name: "Latte", icon: "latte", price: 7.5)
    
      return .just([espresso, cappuccino, macciato, mocha, latte])
  }()
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
      
     
      
    navigationItem.rightBarButtonItem = shoppingCartButton
    
    configureTableView()
    coffees.bind(to: tableView
          .rx
        .items(cellIdentifier: "coffeCell",cellType: CoffeeCell.self)){row,element,cell in
            cell.configure(with: element)
            
            
        }
        .disposed(by: disposeBag)
      
      tableView
          .rx
          .modelSelected(Coffee.self)
          .subscribe(onNext : { coffee in
              self.performSegue(withIdentifier: "OrderCofeeSegue", sender: coffee) // 4
                      
              if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow { // 5
                  self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                      }
          }
          )
          .disposed(by: disposeBag)
          
      
                 
      
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let totalOrderCount = ShoppingCart.shared.getTotalCount()
    
    shoppingCartButton.badgeText = totalOrderCount != 0 ? "\(totalOrderCount)" : nil
  }
  
  private func configureTableView() {
      tableView.rowHeight = 104
    tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
  }
  
  @objc private func shoppingCartButtonPressed() {
    performSegue(withIdentifier: "ShowCartSegue", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let coffee = sender as? Coffee else { return }
    
    if segue.identifier == "OrderCofeeSegue" {
      if let viewController = segue.destination as? OrderCoffeeViewController {
        viewController.coffee = coffee
        viewController.title = coffee.name
      }
    }
  }
}

extension MenuViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 104
  }
  
  
}


  
  
    
  
  

