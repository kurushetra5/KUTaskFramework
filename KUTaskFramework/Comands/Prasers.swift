//
//  Prasers.swift
//  FireWarWall
//
//  Created by Kurushetra on 16/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation




public protocol Prasable  {
    func prase(comandResult:String) -> Any
}

struct GenericPraser:Prasable   {
    
    func prase(comandResult:String) -> Any {
        return comandResult
    }
}


struct StatePraser:Prasable   {
    
     func prase(comandResult:String) -> Any {
        var state:String!
        
        if comandResult.contains("Status") {
            
            if comandResult.contains("Disabled") {
                state = "Disabled"
            } else if comandResult.contains("Enabled"){
                state = "Enabled"
            }
        }
        return state
    }
}


struct NetStatPraser:Prasable   {
    
    
    func prase(comandResult:String) -> Any {
        var result:String!
        if comandResult.contains("tcp4") {
            result = comandResult
        }
        return result
    }
}


struct badHostsPraser:Prasable   {
    
    func prase(comandResult:String) -> Any {
        return comandResult
    }
}

struct nsLookUpPraser:Prasable   {
    
    func prase(comandResult:String) -> Any {
        var result:String!
        
        if comandResult.contains("Server:") {
            result = comandResult
        }
        return  result
    }
}
