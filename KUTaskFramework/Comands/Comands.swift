//
//  Comands.swift
//  FireWarWall
//
//  Created by Kurushetra on 12/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation





//MARK: --------------------------------  protocol Comand  --------------------------------
public  protocol Comand    {
    var praser:Prasable {get set}
    var taskPath:String {get set}
    var taskArgs:[String] {get set}
    var name:String {get set}
 
    
}




//MARK: --------------------------------  protocol ComandWithIP  --------------------------------
public protocol ComandWithIP:Comand  {
    var ip:String{get set}
    mutating func addIp()
}






//MARK: --------------------------------  protocol ComandWithID  --------------------------------
public protocol ComandWithID:Comand {
    var Id:String{get set}
    mutating func addId()
}

extension ComandWithID   {
    
    mutating public func addId() {
        
        let comand:String = taskArgs[1]  //FIXME: Aqqui falla no se le pasan los arrgs ??
        let comandWithId:String = comand.replacingOccurrences(of:"¿¿¿", with:self.Id)
        self.taskArgs[1] = comandWithId
        }
    
}




//MARK: --------------------------------  protocol ComandIpId  --------------------------------
public protocol ComandIpId:ComandWithID,ComandWithIP {
    mutating func addIPAndID()
}

extension ComandIpId    {
  
 
    mutating public func addIPAndID() {
        addIp()
        addId()
    }
    
    mutating public func addIp() { //TODO: Sobran ???
        let comand:String = taskArgs[1]
        let comandWithIp:String = comand.replacingOccurrences(of:"???", with:self.ip)
        self.taskArgs[1] = comandWithIp
        
    }
    mutating public func addId() {
        
        let comand:String = taskArgs[1]
        let comandWithId:String = comand.replacingOccurrences(of:"¿¿¿", with:self.Id)
        self.taskArgs[1] = comandWithId
        
    }
}







//MARK: -------------------------------- GENERIC Comand --------------------------------



public struct GenericComand:Comand   {
    
    public var name: String
    public var praser: Prasable
    public var taskPath:String
    public var taskArgs:[String]
    
   public init(name:String, praser:Prasable, taskPath:String, taskArgs:[String] ) {
        self.name = name
        self.praser = praser
        self.taskPath = taskPath
        self.taskArgs = taskArgs
    }
}





 
