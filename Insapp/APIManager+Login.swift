//
//  APIManager+Login.swift
//  Insapp
//
//  Created by Florent THOMAS-MOREL on 9/13/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

extension APIManager{
    
    static func signin(username: String, password: String, controller: UIViewController, completion:@escaping (Optional<Credentials>) -> ()){
        let params = [
            kLoginUsername: username,
            kLoginPassword: password
        ]
        request(url: "/signin/user", method: .post, parameters: params as [String : AnyObject], completion: { result in
            guard let json = result as? Dictionary<String, AnyObject> else { completion(.none) ; return }
            completion(Credentials.parseJson(json))
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
    }
    
    static func login(_ credentials: Credentials, controller:UIViewController, completion:@escaping (Optional<Credentials>) -> ()){
        let params = [
            kCredentialsUserId: credentials.userId,
            kCredentialsUsername: credentials.username,
            kCredentialsAuthToken: credentials.authToken
        ]
        request(url: "/login/user", method: .post, parameters: params as [String : AnyObject], completion: { result in
            guard let json = result as? Dictionary<String, AnyObject> else { completion(.none) ; return }
            guard let credentialsJson = json["credentials"] as? Dictionary<String, AnyObject> else { completion(.none) ; return }
            guard let token = json["sessionToken"] as? Dictionary<String, AnyObject> else { completion(.none) ; return }
            guard let user = json["user"] as? Dictionary<String, AnyObject> else { completion(.none) ; return }
            guard let _ = User.parseJson(user) else { completion(.none) ; return }
            
            APIManager.token = token["Token"] as! String
            
            completion(Credentials.parseJson(credentialsJson))
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
    }
    
}
