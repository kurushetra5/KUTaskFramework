//
//  Prasers.swift
//  FireWarWall
//
//  Created by Kurushetra on 16/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation




public protocol Prasable  {
    func prase(comandResult:[String]) -> PraserResult
}

public   enum  PraserType {
    case generic,state
    
    
    public  func praserToUse() -> Prasable {
        var  praser:Prasable!
        
        switch self {
            
        case .generic:
            print("generic Praser")
            praser =  Prasers.GenericPraser()
        case .state:
            print("state Praser")
            praser =  Prasers.StatePraser()
        }
        return praser
    }
    
}


public protocol PraserResultable  {
    var dataType:String {get set}
    var dataString:String {get set}
    var dataArray:[String] {get set}
   
}

public struct PraserResult:PraserResultable {
   public var dataType: String
   public var dataString: String
   public var dataArray: [String]
    
    
}



public   class Prasers  {
    
    
    struct GenericPraser:Prasable   {
        
        public func prase(comandResult:[String]) -> PraserResult { //FIXME: Si puede ser devolver [String]
            let result:PraserResult = PraserResult(dataType:"array", dataString:"nil", dataArray:comandResult)
            return result
        }
        
    }
    
    
    struct StatePraser:Prasable   {
        
        func prase(comandResult:[String]) -> PraserResult { //FIXME: Si puede ser devolver String
            var state:String!
            
            if comandResult[0].contains("Status:") { //FIXME: Arreglar
                
                if comandResult[0].contains("Disabled") {
                    state = "Disabled"
                } else if comandResult[0].contains("Enabled"){
                    state = "Enabled"
                }
            }
            let result:PraserResult = PraserResult(dataType:"string", dataString:state, dataArray:["nil"])
            return result
        }
    }
    
    
    struct NetStatPraser:Prasable   {
        
        
        func prase(comandResult:[String]) -> PraserResult { //FIXME: Si puede ser devolver String
            var result:[String]!
            if comandResult[0].contains("tcp4") {
                result = comandResult
            }
            let results:PraserResult = PraserResult(dataType:"array", dataString:"nil", dataArray:result)
            return results
        }
    }
    
    
    struct badHostsPraser:Prasable   {
        
        func prase(comandResult:[String]) -> PraserResult { //FIXME: Si puede ser devolver String
            let results:PraserResult = PraserResult(dataType:"array", dataString:"nil", dataArray:comandResult)
            return results
        }
    }
    
    struct nsLookUpPraser:Prasable   {
        
        func prase(comandResult:[String]) -> PraserResult { //FIXME: Si puede ser devolver String
            var result:[String]!
            
            if comandResult.contains("Server:") {
                
                result = comandResult
            }
            let results:PraserResult = PraserResult(dataType:"array", dataString:"nil", dataArray:result)
            return  results
        }
    }
    
    
}
