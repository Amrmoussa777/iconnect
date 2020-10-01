//
//  addfreindViewController.swift
//  iConnect
//
//  Created by Amr Moussa on 9/28/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import UIKit

class addfreindViewController: UIViewController {
    let DB = DBop()
    var freinds = [freindModel]()
    @IBOutlet weak var freindsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        freindsTable.delegate = self
        freindsTable.dataSource = self
        freindsTable.register(UINib(nibName: const.identifiers.freindcellnibname, bundle: nil), forCellReuseIdentifier: const.identifiers.freindsCellID)
        DB.fetchFreinds("") { (freinds) in
            if  let newfreinds = freinds{
                self.freinds = newfreinds
                print(freinds?.count)
                self.freindsTable.reloadData()
            }
            else{
            print("freinds not found")
            }
        }
    }
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension addfreindViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freinds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: const.identifiers.freindsCellID, for: indexPath) as! freindCell
        let freind = freinds[indexPath.row]
        cell.freindNameLabel.text = freind.name
        cell.lastActiveLabel.text = freind.lastActive
        DB.fetchimage(freind.imgUrl){(data:Data?) in
            if let data = data{
            DispatchQueue.main.async {
              cell.imageView?.image = UIImage(data: data)
                cell.imageView?.contentMode = .scaleAspectFit
                cell.setNeedsLayout()
            }
            }
        }
        return cell
    }
    
     
     
     
     
 }

