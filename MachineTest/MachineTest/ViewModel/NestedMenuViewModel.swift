//
//  NestedMenuViewModel.swift
//  MachineTest
//
//  Created by SD on 08/01/21.
//

import Foundation


protocol Copying {
    init(original: Self)
}

class NestedMenuViewModel {
    var arrNestedMenu = [NestedMenuCellViewModel]()
    var lastExpandedHierarchyPos = -1
    
    ///Parsing  from local json
    func setup(completion: ((Bool) -> Void)) {
        self.arrNestedMenu.removeAll()
        do {
            let assetData = try Data(contentsOf: Bundle.main.url(forResource: "NestedMenu", withExtension: "json")!)
            let tempArr = try JSONDecoder().decode(NestedMenu.self, from: (assetData))
            if let objectiveArr = tempArr.data?.first?.planning?.objective,objectiveArr.count > 0 {
                for (index,item) in objectiveArr.enumerated() {
                    self.arrNestedMenu.append(NestedMenuCellViewModel(objective: item,rootIndex: index))
                }
                completion(true)
            } else {
                completion(false)
            }
        }
        catch(let error) {
            debugPrint("error->",error.localizedDescription)
            completion(false)
        }
    }
    
    /// get particular row object using subscript
    subscript(indexPath: IndexPath) -> NestedMenuCellViewModel {
        return self.arrNestedMenu[indexPath.row]
    }
    ///Row count
    func count() -> Int {
        return self.arrNestedMenu.count
    }
    
    /// Toggle Menu
    func toggleMenu(indexPath: IndexPath)  {
        guard self.arrNestedMenu.count > indexPath.row else {
            return
        }
        
        //Preparing for Append
        func appendRows(at index: Int)  {
            if self.arrNestedMenu[index].child.count > 0 {
                self.arrNestedMenu[index].isExpanded = true
                _ = self.arrNestedMenu.map({ (obj) in
                    obj.lastExpandedNode = false
                })
                self.arrNestedMenu[index].lastExpandedNode = true
                self.lastExpandedHierarchyPos = self.arrNestedMenu[index].hierarchyPosition
                self.append(to: index)
            }
        }
        //Remove old child nodes from array
        func removeOldNodes() {
            var position = 0
            for item in self.arrNestedMenu {
                if item.lastExpandedNode {
                    item.isExpanded = false
                    position = item.hierarchyPosition
                    break
                }
            }
            self.arrNestedMenu.removeAll { (objToDel) in
                return objToDel.hierarchyPosition > position
            }
        }
        
        ///After deleting old nodes, get new index to add all the respective child nodes
        func getNewIndexAfterDelete() -> Int {
            for (index,item) in self.arrNestedMenu.enumerated() {
                if item.currentlyExpandedNode {
                    return index
                }
            }
            return 0
        }
        
        
        let currentHierrachyPos = self.arrNestedMenu[indexPath.row].hierarchyPosition
        //Only for current root node
        if currentHierrachyPos > 0 {
            //below block is to collapse already expanded nodes
            if self.arrNestedMenu[indexPath.row].isExpanded {
                self.arrNestedMenu[indexPath.row].isExpanded = false
                /// Already expanded row
                _ = self.arrNestedMenu.map({ (obj) in
                    obj.currentlyExpandedNode = false
                })
                self.arrNestedMenu[indexPath.row].currentlyExpandedNode = false
                let position = self.arrNestedMenu[indexPath.row].hierarchyPosition
                self.arrNestedMenu.removeAll { (objToDel) in
                    return objToDel.hierarchyPosition > position
                }
                return
            }
            
            //below block is to delete all expanded nodes and add selected child nodes if any within a same root node
            if self.arrNestedMenu[indexPath.row].child.count > 0 {
                if currentHierrachyPos <= self.lastExpandedHierarchyPos {
                    ///Marking curently expanded row
                    _ = self.arrNestedMenu.map({ (obj) in
                        obj.currentlyExpandedNode = false
                    })
                    self.arrNestedMenu[indexPath.row].currentlyExpandedNode = true
                    
                    removeOldNodes()
                    
                    let newIndex = getNewIndexAfterDelete()
                    appendRows(at: newIndex)
                    return
                }
            }
        } else {
            //This is for different root node
            
            //This will trigger when this root node is already expanded and will collapse
            if self.arrNestedMenu[indexPath.row].isExpanded {
                /// Already expanded row
                self.arrNestedMenu.removeAll { (objToDel) in
                    return objToDel.hierarchyPosition > currentHierrachyPos
                }
                self.arrNestedMenu[indexPath.row].isExpanded = false
                return
            } else {
                //New Root row
                _ = self.arrNestedMenu.map({ (obj) in
                    obj.isExpanded = false
                })
                
                //evaluate old(other one) root nodes for deletion
                var rootIndex = 0
                for item in self.arrNestedMenu {
                    if (item.currentlyExpandedNode || item.lastExpandedNode) {
                        rootIndex = item.rootIndex
                        break
                    }
                }
                
                ///clearing all the  curently expanded row and setting up the current one
                _ = self.arrNestedMenu.map({ (obj) in
                    obj.currentlyExpandedNode = false
                })
                self.arrNestedMenu[indexPath.row].currentlyExpandedNode = true
                
                ///clearing all the  last expanded row
                _ = self.arrNestedMenu.map({ (obj) in
                    obj.lastExpandedNode = false
                })
                
                //Remove all the other child nodes which need to collapse
                self.arrNestedMenu.removeAll { (objToDel) in
                    return (objToDel.rootIndex == rootIndex) && objToDel.hierarchyPosition > 0
                }
                //Append new child nodes which need to show
                let newIndex = getNewIndexAfterDelete()
                appendRows(at: newIndex)
                return
            }
        }
        
        ///This will trigger only when all the above alternatives would not
        appendRows(at: indexPath.row)
        return
    }
    
    //Appending all the child rows to the main array
    func append(to rowPosition: Int)  {
        let tempArr = self.arrNestedMenu[rowPosition].child
        for (index,item) in tempArr.enumerated() {
            self.arrNestedMenu.insert(item, at: (rowPosition + (index + 1)))
        }
    }
}

class NestedMenuCellViewModel: Copying {
    var name: String = ""
    var isExpanded: Bool = false
    var hierarchyPosition: Int = 0
    var child: [NestedMenuCellViewModel] = []
    var rootIndex: Int = 0
    var lastExpandedNode: Bool = false
    var currentlyExpandedNode: Bool = false
    
    //Incase of adding new property , need to add in below method also
    required init(original: NestedMenuCellViewModel) {
        name = original.name
        isExpanded = original.isExpanded
        child = original.child
        hierarchyPosition = original.hierarchyPosition
        rootIndex = original.rootIndex
        lastExpandedNode = original.lastExpandedNode
        currentlyExpandedNode = original.currentlyExpandedNode
    }
    
    init(objective: Objective,rootIndex: Int,position: Int = 0) {
        self.rootIndex = rootIndex
        self.name = objective.contentObj ?? ""
        self.hierarchyPosition = position
        self.child = (objective.objective ?? []).map({ (keyObj) in
            return NestedMenuCellViewModel(objective: keyObj,rootIndex: rootIndex,position: self.hierarchyPosition + 1)
        })
    }
}
