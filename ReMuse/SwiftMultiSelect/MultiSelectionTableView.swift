//
//  MultiSelectionTableView.swift
//  SwiftMultiSelect
//
//  Created by Luca Becchetti on 26/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import Foundation
import Contacts
import UIKit


// MARK: - UITableViewDelegate,UITableViewDataSource
extension MultiSelecetionViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchString == "" {
            return SwiftMultiSelect.items!.count
        }else{
            return SwiftMultiSelect.items!.filter({$0.title.lowercased().contains(searchString.lowercased()) || ($0.description != nil && $0.description!.lowercased().contains(searchString.lowercased())) }).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomOneCell
        
        cell.selectionStyle = .none

        let item:SwiftMultiSelectItem! = (searchString == "") ?  SwiftMultiSelect.items![indexPath.row] : SwiftMultiSelect.items!.filter({$0.title.lowercased().contains(searchString.lowercased()) || ($0.description != nil && $0.description!.lowercased().contains(searchString.lowercased())) })[indexPath.row]
        
        
        //Configure cell properties
        cell.titleLabel.text        = item.title
        cell.backgroundColor = item.color
//        cell.bgImage.image = UIImage(named: "song1")
        
        //Set initial state
        if self.selectedItems.index(where: { (itm) -> Bool in
            itm == item
        }) != nil{
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        
        return cell
    }
    
    
    /// Function that select a random color for passed indexpath
    ///
    /// - Parameter indexpath:
    /// - Returns: UIColor random, from Config.colorArray
    func updateInitialsColorForIndexPath(_ indexpath: IndexPath) -> UIColor{
        
        //Applies color to Initial Label
        let randomValue = (indexpath.row + indexpath.section) % Config.colorArray.count
        
        return Config.colorArray[randomValue]
        
    }
    
    
    /// Function to change accessoryType for passed index
    ///
    /// - Parameters:
    ///   - row: index of row
    ///   - selected: true = chechmark, false = none
    func reloadCellState(row:Int, selected:Bool){
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? CustomOneCell{
            Filters.filter(index: row, on: selected)
            cell.accessoryType = (selected) ? .checkmark : .none
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Get selected cell
        let cell = tableView.cellForRow(at: indexPath) as! CustomOneCell

        let item:SwiftMultiSelectItem! = (searchString == "") ?  SwiftMultiSelect.items![indexPath.row] : SwiftMultiSelect.items!.filter({$0.title.lowercased().contains(searchString.lowercased()) || ($0.description != nil && $0.description!.lowercased().contains(searchString.lowercased())) })[indexPath.row]
        
        //Check if cell is already selected or not
        if cell.accessoryType == UITableViewCell.AccessoryType.checkmark
        {
            Filters.filter(index: indexPath.row, on: false)
            
            //Set accessory type
            cell.accessoryType = UITableViewCell.AccessoryType.none

            //Comunicate deselection to delegate
            SwiftMultiSelect.delegate?.swiftMultiSelect(didUnselectItem: item)
            
            //Reload collectionview
            self.reloadAndPositionScroll(idp: item.row!, remove:true)
            
        }
        else{
            Filters.filter(index: indexPath.row, on: true)
            
            //Set accessory type
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            
            //Add current item to selected
            selectedItems.append(item)
            
            //Comunicate selection to delegate
            SwiftMultiSelect.delegate?.swiftMultiSelect(didSelectItem: item)

            //Reload collectionview
            self.reloadAndPositionScroll(idp: item.row!, remove:false)
            
        }

        //Reset search
        if searchString != ""{
            searchBar.text = ""
            searchString = ""
            SwiftMultiSelect.delegate?.userDidSearch(searchString: "")
            self.tableView.reloadData()
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return CGFloat(Config.tableStyle.tableRowHeight)
        
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchString = searchText

        if (searchText.isEmpty) {
            self.perform(#selector(self.hideKeyboardWithSearchBar(_:)), with: searchBar, afterDelay: 0)
            self.searchString = ""
        }
        
        SwiftMultiSelect.delegate?.userDidSearch(searchString: searchText)
        
        self.tableView.reloadData()
    }
    
    @objc func hideKeyboardWithSearchBar(_ searchBar:UISearchBar){
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool{
        return true
    }
    
}
