//
//  NestedMenuViewController.swift
//  MachineTest
//
//  Created by SD on 08/01/21.
//

import UIKit

class NestedMenuViewController: UIViewController {
    
    @IBOutlet weak var tableviewNestedMenu: UITableView!
    var viewModel = NestedMenuViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.setup { (isSuccess) in
            isSuccess ? self.tableviewNestedMenu.reloadData() : ()
        }
    }
}

//MARK:- Tableview data source
extension NestedMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NestedMenuCell = tableView.dequeueReusableCell(withIdentifier: NestedMenuCell.string) as! NestedMenuCell
        let menuObj = self.viewModel[indexPath]
        cell.menuObj = menuObj
        
        cell.selectionStyle = .none
        return cell
    }
}

//MARK:- Tableview Delegate
extension NestedMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.toggleMenu(indexPath: indexPath)
        self.tableviewNestedMenu.reloadData()
    }
}

//MARK:- UItableview cell
class NestedMenuCell: UITableViewCell {
    @IBOutlet weak var seperatorView: UIView!
    
    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var leadingConstraintCircle: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintCircle: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintCircle: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var topHierarchyFontSize: CGFloat = 20
    var leadingSpaceConstant: CGFloat = 30
    var menuObj: NestedMenuCellViewModel! {
        didSet {
           // print("isChildmenuObj",menuObj.isChild)
            titleLabel.text = menuObj.name
            switch menuObj.hierarchyPosition {
            case 0:
                seperatorView.isHidden = false
                viewCircle.isHidden = !menuObj.isExpanded
                widthConstraintCircle.constant = 12
                heightConstraintCircle.constant = 12
                viewCircle.layer.cornerRadius = 6
                viewCircle.backgroundColor = .systemOrange
                titleLabel.font = UIFont(name: "HelveticaNeue", size: topHierarchyFontSize)
                titleLabel.alpha = 1.0
                viewCircle.alpha = 1.0
                leadingConstraintCircle.constant = leadingSpaceConstant
            case 1:
                seperatorView.isHidden = true
                leadingConstraintCircle.constant =  leadingSpaceConstant + 15
                viewCircle.isHidden = true
                titleLabel.font = UIFont(name: "HelveticaNeue", size: topHierarchyFontSize - 4)
                titleLabel.alpha = 0.6
            case 2:
                seperatorView.isHidden = true
                viewCircle.isHidden = false
                widthConstraintCircle.constant = 8
                heightConstraintCircle.constant = 8
                viewCircle.layer.cornerRadius = 4
                viewCircle.backgroundColor = .systemGreen
                leadingConstraintCircle.constant =  leadingSpaceConstant + 60
                titleLabel.font = UIFont(name: "HelveticaNeue", size: topHierarchyFontSize - 5)
                titleLabel.alpha = 0.6
                viewCircle.alpha = 0.6
            default:
                seperatorView.isHidden = true
                viewCircle.isHidden = true
                leadingConstraintCircle.constant =  leadingSpaceConstant + 70
                titleLabel.font = UIFont(name: "HelveticaNeue", size: topHierarchyFontSize - 6)
                titleLabel.alpha = 0.6
            }
        }
    }
}
