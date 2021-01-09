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
    
    ///Parsing up from local json
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
        
        //Appending data
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
        func removeOldNodes() {
            var position = 0
            for item in self.arrNestedMenu {
                if item.currentlyExpandedNode {
                    position = item.hierarchyPosition
                    break
                }
            }
            self.arrNestedMenu.removeAll { (objToDel) in
                return objToDel.hierarchyPosition > position
            }
        }
        func getNewIndexAfterDelete() -> Int {
            for (index,item) in self.arrNestedMenu.enumerated() {
                if item.currentlyExpandedNode {
                    return index
                }
            }
            return 0
        }
        func deselectLastExpandedRow()  {
            for (index,item) in self.arrNestedMenu.enumerated() {
                if item.hierarchyPosition == self.lastExpandedHierarchyPos {
                    self.arrNestedMenu[index].isExpanded = false
                    return
                }
            }
        }
        
        let currentHierrachyPos = self.arrNestedMenu[indexPath.row].hierarchyPosition
        if currentHierrachyPos > 0 {
//            if self.arrNestedMenu[indexPath.row].isExpanded {
//                self.arrNestedMenu[indexPath.row].isExpanded = false
//                /// Already expanded row
//                self.arrNestedMenu.removeAll { (objToDel) in
//                    return objToDel.hierarchyPosition > currentHierrachyPos
//                }
//                return
//            }
            
            
            if self.arrNestedMenu[indexPath.row].child.count > 0 {
                if currentHierrachyPos <= self.lastExpandedHierarchyPos {
                    ///Marking curently expanded row
                    _ = self.arrNestedMenu.map({ (obj) in
                        obj.currentlyExpandedNode = false
                    })
                    self.arrNestedMenu[indexPath.row].currentlyExpandedNode = true
                    
                    //deselectLastExpandedRow()
                    removeOldNodes()
                    
                    let newIndex = getNewIndexAfterDelete()
                    appendRows(at: newIndex)
                    return
                }
            }
        } else {
            //different root row
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
        
        
        appendRows(at: indexPath.row)
        return
    }
    
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
