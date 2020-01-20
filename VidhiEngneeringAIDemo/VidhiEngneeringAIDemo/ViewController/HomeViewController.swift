//
//  HomeViewController.swift
//  VidhiEngneeringAIDemo
//
//  Created by MAC105 on 20/01/20.
//  Copyright © 2020 MAC105. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll
class HomeViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var tableViewPost : UITableView!
    
    //MARK: - Variable
    private var arrayHits : [Hits] = []
    private var page : Int = 0
    private var hasMorePost : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
        self.getPosts()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Methods
    private func prepareView() {
        self.title = "No post selected."
        self.tableViewPost.addInfiniteScroll { (table) in
            table.finishInfiniteScroll()
        }
    }
    
    private func getPosts(pageNumer : Int = 1) {
        PostController.share.getPost(pagenumber: pageNumer) { (allposts) in
            if let allHits = allposts.hits {
                if pageNumer == 1 {
                    self.arrayHits.removeAll()
                }
                for hit in allHits {
                    self.arrayHits.append(hit)
                }
                self.tableViewPost.reloadData()
                self.page = allposts.page!
                self.hasMorePost = self.page < allposts.nbPages!
                if !self.hasMorePost {
                    self.tableViewPost.removeInfiniteScroll()
                }
            }
        }
    }
    
    private func showNumberOfPostSelected() {
        let selectedPost = self.arrayHits.filter { (hint) -> Bool in
            return hint.isActive
        }
        if selectedPost.count == 0 {
            self.title = "No post selected."
        }else if selectedPost.count == 1 {
            self.title = "Number of post selected : \(selectedPost.count)"
        }else {
          self.title = "Number of posts selected : \(selectedPost.count)"
        }
        
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayHits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableCell", for: indexPath) as! PostTableCell
        cell.postHint = self.arrayHits[indexPath.row]
        cell.switchPostActiveDeactive.tag = indexPath.row
        cell.switchPostActiveDeactive.addTarget(self, action: #selector(activeDeactivePost(sender:)), for: .valueChanged)
        return cell
    }
    
    @objc func activeDeactivePost(sender : UISwitch) {
        self.arrayHits[sender.tag].isActive = !self.arrayHits[sender.tag].isActive
        self.tableViewPost.reloadData()
        self.showNumberOfPostSelected()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.arrayHits.count - 1 && self.hasMorePost {
            self.getPosts(pageNumer: self.page + 1)
        }
    }
}
