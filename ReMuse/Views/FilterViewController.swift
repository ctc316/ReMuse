//
//  FilterViewController.swift
//  ReMuse
//
//  Created by ctc316 on 2018/11/14.
//  Copyright © 2018年 ctc316. All rights reserved.
//

import UIKit


//Implement delegate in your UIViewController
class FilterViewController: UIViewController, SwiftMultiSelectDelegate, SwiftMultiSelectDataSource {
    
    var items:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    var initialValues:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    var selectedItems:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    
    let item = SwiftMultiSelectItem(
        //An incremental unique identifier
        row         : 0,
        //Title for first line
        title       : "Item 0",
        //Description line
        description : "i am description 0",
        //Image asset, shown if no imageURL has been set
        image       : UIImage(),
        //Url of remote image
        imageURL    : "",
        //Custom color, if not present a random color will be assigned
        color       : UIColor.gray,
        //Your custom data, Any object
        userInfo    : ["id" : 10]
    )
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // create item list
        createItems()
        
        //Register delegate
        SwiftMultiSelect.dataSourceType = .custom
        SwiftMultiSelect.dataSource = self
        SwiftMultiSelect.delegate = self
        print("Hi")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Show(to: self)
    }
    
    
    /// Create a custom items set
    func createItems(){
        self.items.removeAll()
        self.initialValues.removeAll()
        for i in 0..<50{
            items.append(SwiftMultiSelectItem(row: i, title: "test\(i)", description: "description for: \(i)", imageURL : (i == 1 ? "https://randomuser.me/api/portraits/women/68.jpg" : nil)))
        }
        self.initialValues = [self.items.first!,self.items[1],self.items[2]]
        self.selectedItems = items
    }
    
    
    func Show(to: UIViewController) {
        // Create instance of selector
        let selector            = MultiSelecetionViewController()
        
        // Set initial items
        selector.selectedItems  = initialValues

        //Create navigation controller
        let navController       = UINavigationController(rootViewController: selector)

        // Present selectora
        to.present(navController, animated: false, completion: nil)
    }
    
    
    
    
    
    //MARK: - SwiftMultiSelectDataSource
    
    func numberOfItemsInSwiftMultiSelect() -> Int {
        print("items.count", items.count)
        return items.count
    }
    
    func swiftMultiSelect(itemAtRow row: Int) -> SwiftMultiSelectItem {
        return items[row]
    }
    
    
    //MARK: - SwiftMultiSelectDelegate
    
    //User write something in searchbar
    func userDidSearch(searchString: String) {
        print("User is looking for: \(searchString)")
    }
    
    //User did unselect an item
    func swiftMultiSelect(didUnselectItem item: SwiftMultiSelectItem) {
        print("row: \(item.title) has been deselected!")
    }
    
    //User did select an item
    func swiftMultiSelect(didSelectItem item: SwiftMultiSelectItem) {
        print("item: \(item.title) has been selected!")
    }
    
    //User did close controller with no selection
    func didCloseSwiftMultiSelect() {
        print("no items selected")
    }
    
    //User completed selection
    func swiftMultiSelect(didSelectItems items: [SwiftMultiSelectItem]) {
        
        print("you have been selected: \(items.count) items!")
        
        for item in items{
            print(item.string)
        }
        
    }
}
