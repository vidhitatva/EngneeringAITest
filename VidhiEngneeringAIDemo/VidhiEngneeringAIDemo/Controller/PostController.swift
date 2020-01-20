//
//  PostController.swift
//  VidhiEngneeringAIDemo
//
//  Created by MAC105 on 20/01/20.
//  Copyright © 2020 MAC105. All rights reserved.
//

import Foundation

final class PostController{
    static let share : PostController = PostController()
    
    func getPost(pagenumber:Int,complition:@escaping(_ posts: Post) -> Void) {
        RequestManager.share.requestWithget(url: API.getPostList+"\(pagenumber)") { (success, posts, message) in
            if success {
                let allPosts = try? JSONDecoder().decode(Post.self, from: posts)
                if let listPost = allPosts{
                    complition(listPost)
                }
            }
        }
    }
}
