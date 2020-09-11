//
//  ViewController.swift
//  FoldingTableView
//
//  Created by lishenghui on 2020/9/10.
//  Copyright © 2020 JackLi. All rights reserved.
//

import UIKit

class CarBand: NSObject {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class CarSeries: NSObject {
    var name: String
    var bands: [CarBand]
    var folding: Bool = false
    init(name: String, bands: [CarBand]) {
        self.name = name
        self.bands = bands
    }
}

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        var tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    lazy var carGroups: [CarSeries] = {
        let filePath = Bundle.main.path(forResource: "CarBrand", ofType: "plist")
        guard let path = filePath else {
            return []
        }
        
        //使用NSDictionary的初始化方法
//        let dic: [String: [String]] = NSDictionary.init(contentsOfFile: path) as! [String: [String]]
//        var carGroups: [CarSeries] = []
//        for (index, element) in dic.enumerated() {
//            let series = element.key
//            let bands = element.value
//            var carBands: [CarBand] = []
//            for band in bands {
//                let carBand = CarBand.init(name: band)
//                carBands.append(carBand)
//            }
//            let carSeries = CarSeries.init(name: series, bands: carBands)
//            carGroups.append(carSeries)
//        }
//        return carGroups

        //使用属性列表序列号类PropertyListSerialization方法将从plist转化NSData转化为Dictionary
        let data = NSData.init(contentsOfFile: path)! as Data

        let options: PropertyListSerialization.ReadOptions = []
        do {
            let plist = try PropertyListSerialization.propertyList(from: data, options: options, format: nil)
            
            let dictionary: [String: [String]] = plist as! [String: [String]]
            
            var carGroups1: [CarSeries] = []
            for (index, element) in dictionary.enumerated() {
                let series = element.key
                let bands = element.value
                var carBands: [CarBand] = []
                for band in bands {
                    let carBand = CarBand.init(name: band)
                    carBands.append(carBand)
                }
                let carSeries = CarSeries.init(name: series, bands: carBands)
                carGroups1.append(carSeries)
            }
            return carGroups1
        }
        catch {
            return []
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return carGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let carSeries = carGroups[section]
        if carSeries.folding {
            /**
             * 如果直接返回0，控制台会报错，"[Assert] Unable to determine new global row index for preReloadFirstVisibleRow (0)"，所以解决方案：返回一个0px高度的cell
            return 0
             */
            return 1
        }
        return carGroups[section].bands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt : IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init()
        cell.textLabel?.text = carGroups[cellForRowAt.section].bands[cellForRowAt.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let reuseIdentifier = NSStringFromClass(self.classForCoder)
        let carSeries = carGroups[section]
        let headerView = FoldingHeaderView.init(reuseIdentifier: reuseIdentifier)
        headerView.carSeries = carSeries
        headerView.foldClosure = {(isFold) in
            carSeries.folding = isFold
            DispatchQueue.main.async {
                tableView.reloadSections([section], with: .none)
            }
            
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let carSeries = carGroups[indexPath.section]
        //如果是折叠的，cell的高度为0
        if carSeries.folding {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

