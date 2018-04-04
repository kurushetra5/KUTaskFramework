//
//  Comands.swift
//  FireWarWall
//
//  Created by Kurushetra on 12/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation



public protocol Praserable {
    var praser:Prasable {get set}
}




//MARK: --------------------------------  protocol Comand  --------------------------------
public  protocol Comand:Praserable   {
    var taskPath:String {get set}
    var taskArgs:[String] {get set}
    var name:String {get set}
 
    
}




//MARK: --------------------------------  protocol ComandWithIP  --------------------------------
protocol ComandWithIP:Comand  {
    var ip:String{get set}
    mutating func addIp()
}

extension ComandWithIP   {
    
    mutating func addIp() {
        let comand:String = taskArgs[1]
        let comandWithIp:String = comand.replacingOccurrences(of:"???", with:self.ip)
        self.taskArgs[1] = comandWithIp
        
    }
    
}




//MARK: --------------------------------  protocol ComandWithID  --------------------------------
protocol ComandWithID:Comand {
    var Id:String{get set}
    mutating func addId()
}

extension ComandWithID   {
    
    mutating func addId() {
        
        let comand:String = taskArgs[1]  //FIXME: Aqqui falla no se le pasan los arrgs ??
        let comandWithId:String = comand.replacingOccurrences(of:"¿¿¿", with:self.Id)
        self.taskArgs[1] = comandWithId
        }
    
}




//MARK: --------------------------------  protocol ComandIpId  --------------------------------
protocol ComandIpId:ComandWithID,ComandWithIP {
}

extension ComandIpId    {
  
 
    mutating func addIPAndID() {
        addIp()
        addId()
    }
    
    mutating func addIp() { //TODO: Sobran ???
        let comand:String = taskArgs[1]
        let comandWithIp:String = comand.replacingOccurrences(of:"???", with:self.ip)
        self.taskArgs[1] = comandWithIp
        
    }
    mutating func addId() {
        
        let comand:String = taskArgs[1]
        let comandWithId:String = comand.replacingOccurrences(of:"¿¿¿", with:self.Id)
        self.taskArgs[1] = comandWithId
        
    }
}







//MARK: -------------------------------- GENERIC Comand --------------------------------



public struct GenericComand:Comand   {     //FIXME: Quitar y usar SimpleComand
    
    public var name: String
    public var praser: Prasable
    public var taskPath:String =  ""
    public var taskArgs:[String] = [] //FIXME: Aqui creo que falta que se pongan los parametros
    
   public init(name:String, praser:Prasable, taskPath:String, taskArgs:[String] ) {
        self.name = name
        self.praser = praser
        self.taskPath = taskPath
        self.taskArgs = taskArgs
    }
}



public struct SimpleComand:Comand   {
    
    public var name: String
    public var praser: Prasable
    public var taskPath: String
    public var taskArgs: [String]
    
    public init(name:String, praser: Prasable, taskPath:String, taskArgs:[String]) {
        self.name = name
        self.praser = praser
        self.taskPath = taskPath
        self.taskArgs = taskArgs
    }
}



public struct IdComand:ComandWithID   {
    
    public var Id: String
    public var name: String
    public var praser: Prasable
    public var taskPath: String
    public var taskArgs: [String]
    
    public init(id: String, name:String, praser: Prasable, taskPath:String, taskArgs:[String]) {
        self.Id = id
        self.name = name
        self.praser = praser
        self.taskPath = taskPath
        self.taskArgs = taskArgs
    }
}

public struct IpComand:ComandWithIP   {
    
    public var ip: String
    public var name: String
    public var praser: Prasable
    public var taskPath: String
    public var taskArgs: [String]
    
    public init(ip: String, name:String, praser: Prasable, taskPath:String, taskArgs:[String]) {
        self.ip = ip
        self.name = name
        self.praser = praser
        self.taskPath = taskPath
        self.taskArgs = taskArgs
    }
}

public struct IdIpComand:ComandIpId  {
    
    public var Id: String
    public var ip: String
    public var name: String
    public var praser: Prasable
    public var taskPath: String
    public var taskArgs: [String]
    
    public init(id: String, ip: String, name:String, praser: Prasable, taskPath:String, taskArgs:[String]) {
        self.Id = id
        self.ip = ip
        self.name = name
        self.praser = praser
        self.taskPath = taskPath
        self.taskArgs = taskArgs
    }
}


 



 
