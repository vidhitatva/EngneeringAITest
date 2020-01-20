//
//  RequestManager.swift
//  VidhiEngneeringAIDemo
//
//  Created by MAC105 on 20/01/20.
//  Copyright © 2020 MAC105. All rights reserved.
//

import Foundation
import Alamofire

struct  Request {
    var url : String?
    var method : HTTPMethod
    var parameters : [String : Any]
    var header : HTTPHeaders?
}

final class RequestManager {
    static let share : RequestManager = RequestManager()
    
    func requestWithget(url:String, complition : @escaping(_ success:Bool,_ resultdata:Data,_ message:String) -> Void)  {
        let req = self.createRequest(url: url, method: .get)
        self.sendRequest(request: req) { (success, resultdata, message) in
            complition(success,resultdata,message)
        }
    }
    
    func  sendRequest(request : Request, complition:@escaping(_ success:Bool,_ resultData:Data,_ message:String) -> Void) {
        Alamofire.request(request.url!, method: request.method, parameters: request.parameters, encoding: URLEncoding.default, headers: request.header!).responseData { (response) in
            DispatchQueue.main.async {
                switch response.result {
                case .success:
                    if let resultdata = response.result.value {
                        let resonse = String(data: resultdata, encoding: String.Encoding.utf8)
                        print(resonse!)
                        complition(true,resultdata,"success")
                        
                    }else{
                        complition(false,Data(),"No data found")

                    }
                    break
                case .failure:
                    if let message = response.error {
                        complition(false,Data(),message.localizedDescription)

                    }else {
                        complition(false,Data(),"No data found")
                    }
                    break
                }
            }
        }
        
    }
    
    func createRequest(url:String, method:HTTPMethod,header:[String:String] = [:],parameter:[String:Any] = [:]) -> Request{
        let newRequest = Request(url: url, method: method, parameters: parameter, header: header)
        return newRequest
    }
}
