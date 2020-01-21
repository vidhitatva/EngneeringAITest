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
    private var isWSLoading : Bool = false
    private var refreshControl = UIRefreshControl()
    
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
        self.tableViewPost.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshPostData), for: .valueChanged)
    }
    
    private func getPosts(pageNumer : Int = 1) {
        self.isWSLoading = true
        PostController.share.getPost(pagenumber: pageNumer) { (allposts) in
            self.isWSLoading = false
            if let allHits = allposts.hits {
                if pageNumer == 1 {
                    self.refreshControl.endRefreshing()
                    self.arrayHits.removeAll()
                    self.showNumberOfPostSelected()
                }
                self.arrayHits.append(contentsOf: allHits)
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
        self.tableViewPost.reloadData()
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
    
    @objc private func refreshPostData() {
        self.getPosts()
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayHits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableCell", for: indexPath) as! PostTableCell
        cell.postHint = self.arrayHits[indexPath.row]
        cell.changeNavigationTitle = {(hit : Hits) -> () in
            self.arrayHits[indexPath.row] = hit
            self.showNumberOfPostSelected()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.arrayHits.count - 1 && self.hasMorePost && !self.isWSLoading{
            self.getPosts(pageNumer: self.page + 1)
        }
    }
}
