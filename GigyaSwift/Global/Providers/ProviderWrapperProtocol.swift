//
//  ProviderWrapperProtocol.swift
//  GigyaSwift
//
//  Created by Shmuel, Sagi on 23/04/2019.
//  Copyright © 2019 Gigya. All rights reserved.
//

import Foundation

protocol ProviderWrapperProtocol {
    var clientID: String? { get set }
    
    func login(params: [String: Any]?, viewController: UIViewController?, completion: @escaping (String?, Error?) -> Void)

    func logout()

}
