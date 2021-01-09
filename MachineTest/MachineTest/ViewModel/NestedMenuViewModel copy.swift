//
//  NestedMenuViewModel.swift
//  MachineTest
//
//  Created by SD on 08/01/21.
//
/*
import Foundation


protocol Copying {
    init(original: Self)
}

class NestedMenuViewModel {
    var arrMainNestedMenu = [NestedMenuCellViewModel]()
    var arrNestedMenu = [NestedMenuCellViewModel]()
    var lastExpandedHierarchyPos = -1
    
    ///Parsing up from local json
    func setup(completion: ((Bool) -> Void)) {
        self.arrMainNestedMenu.removeAll()
        self.arrNestedMenu.removeAll()
        do {
            let assetData = try Data(contentsOf: Bundle.main.url(forResource: "NestedMenu", withExtension: "json")!)
            let tempArr = try JSONDecoder().decode(NestedMenu.self, from: (assetData))
            if let objectiveArr = tempArr.data?.first?.planning?.objective,objectiveArr.count > 0 {
//                self.arrMainNestedMenu = objectiveArr.map({ (obj) in
//                    return NestedMenuCellViewModel(objective: obj)
//                })
                for (index,item) in objectiveArr.enumerated() {
                    self.arrMainNestedMenu.append(NestedMenuCellViewModel(objective: item,rootIndex: index))
                }
                self.arrNestedMenu = self.arrMainNestedMenu
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
        
        let currentHierrachyPos = self.arrNestedMenu[indexPath.row].hierarchyPosition
        if currentHierrachyPos > 0 {
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
*/


/*
 
 class NestedMenuCellViewModel: Copying {
     var name: String = ""
     var isExpanded: Bool = false
     var hierarchyPosition: Int = 0
     var child: [NestedMenuCellViewModel] = []
     
     required init(original: NestedMenuCellViewModel) {
         name = original.name
         isExpanded = original.isExpanded
         child = original.child
         hierarchyPosition = original.hierarchyPosition
     }
     
     init(objective: Objective? = nil,keyResult: KeyResult? = nil) {
         if let objective = objective {
             self.name = objective.contentObj ?? ""
             self.child = (objective.keyResult ?? []).map({ (keyObj) in
                 return NestedMenuCellViewModel(keyResult: keyObj)
             })
         }
         if let keyResult = keyResult {
             self.name = keyResult.keyResult ?? ""
             //self.isChild = true
 //            self.child = (objective?.keyResult ?? []).map({ (keyObj) in
 //                return NestedMenuCellViewModel(keyResult: keyObj)
 //            })
         }
     }
 }

 */






///OLD code

/*
///If expanded , then prepare all child items and append them to array
func checkForChild(_ indexPath: IndexPath) -> Bool {
    var tempArr = self.arrMainNestedMenu.clone()
    guard tempArr.count > indexPath.row else {return false}
    let objective = tempArr[indexPath.item]
    if objective.isExpanded {
        guard  objective.child.count > 0 else {return false}
        self.arrNestedMenu.removeAll()
        for item in objective.child {
            print("isChild",item.isChild)
            tempArr.insert(item, at: (indexPath.item + 1))
        }
        self.arrNestedMenu = tempArr//.clone()
        return true
    }
    ///below line is for resetting the array and collapsing all rows
  // self.arrNestedMenu = self.arrMainNestedMenu.clone()
    return true //returning true as need to collapse all the rows
}

/// if expandable , then append it to array else do nothing
func shouldExpand(with indexPath: IndexPath,completion: ((Bool)-> Void))  {
    guard self.arrMainNestedMenu.count > indexPath.row else {
        completion(false)
        return
    }
    
    guard !self.arrMainNestedMenu[indexPath.row].isExpanded else {
        //If already expanded
        _ = self.arrMainNestedMenu.map({ (obj) in
            obj.isExpanded = false
        })
        self.arrNestedMenu = self.arrMainNestedMenu.clone()
        completion(true)//returning true as need to collapse the row
        return
    }
    
    let object = self.arrMainNestedMenu[indexPath.row]
    object.isExpanded = object.child.count > 0 ? true : false
    if !object.isExpanded {
            _ = self.arrMainNestedMenu.map({ (obj) in
                obj.isExpanded = false
            })
            self.arrNestedMenu = self.arrMainNestedMenu.clone()
            completion(true)
        
        return
    }
    
    completion(self.checkForChild(indexPath))
    return
}
*/
