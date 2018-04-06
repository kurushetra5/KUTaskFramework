//
//  Prasers.swift
//  FireWarWall
//
//  Created by Kurushetra on 16/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation




public protocol Prasable  {
    func prase(comandResult:[String]) -> Any
}




public   class Prasers  {
    
    struct GenericPraser:Prasable   {
        public func prase(comandResult:[String]) -> Any {
            return comandResult
        }
    }
}
