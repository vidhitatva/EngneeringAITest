//
//  APIEndPoint.swift
//  VidhiEngneeringAIDemo
//
//  Created by MAC105 on 21/01/20.
//  Copyright © 2020 MAC105. All rights reserved.
//

import Foundation

var BASEURL : String = "https://hn.algolia.com/api/"

struct API {
    static var getPostList : String = BASEURL + "v1/search_by_date?tags=story&page="
}
