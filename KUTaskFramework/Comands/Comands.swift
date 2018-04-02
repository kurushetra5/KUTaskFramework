//
//  Comands.swift
//  FireWarWall
//
//  Created by Kurushetra on 12/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation




public enum ComandType:String {
    case tcpDump,traceRoute,mtRoute,whois,nsLookup,blockIp,netStat,fireWallState,fireWallBadHosts,addFireWallBadHosts,deleteFireWallBadHosts,fireWallStop,fireWallStart,genericComand,dig,history,ports_Services,ping,conectionData,generic
}



public enum CustomComand  {
    
    case custom(praser:Prasable,taskPath:String,taskArgs:[String])
    
    public  func  comand() ->  Comand {
        var comand:Comand!
        
        switch self {
        case .custom(let praser ,let path ,let args):
            print("custom")
            comand = GenericComand(praser: praser, type:.generic, taskPath: path, taskArgs: args)
        }
        return comand
   }
}



public enum NetInfoComands  {
    
    case  netStat
    
    case whois(ip:String)
    case traceRoute(ip:String)
    case nsLookup(ip:String)
    case dig(ip:String)
    case nmap(ip:String)
    case ping(ip:String)
    case tcpDump(ip:String)
    case mtRoute(withId:String, ip:String)
    
    public  func  comand() ->  Comand {
        
        var comand:Comand!
        
        switch self {
        case .whois(let ip):
            print("whois to: \(ip)")
            comand = Whois(withIp: ip, praser:Prasers.GenericPraser())
            
        case .traceRoute(let ip):
            print("traceRoute to: \(ip)")
            comand =  TraceRoute(withIp:ip, praser: Prasers.GenericPraser())
            
        case .dig(let ip):
            print("dig to: \(ip)")
             comand =  TraceRoute(withIp:ip, praser: Prasers.GenericPraser())
            
        case .nsLookup(let ip):
            print("nsLookup to: \(ip)")
            comand =  NsLookup(withIp: ip, praser: Prasers.GenericPraser())
            
         
            
        case .nmap(let ip):
            print("nmap")
            print("nmap to: \(ip) ")
//            comand =  TraceRoute(withIp:ip, praser: GenericPraser())
            
        case .ping(let ip):
            print("ping to: \(ip) ")
            //comand =  TraceRoute(withIp:ip, praser: GenericPraser())
            
        case .tcpDump(let ip) :
            print("tcpDump to: \(ip)")
            comand = TcpDumpCom(withIp: ip, praser: Prasers.GenericPraser())
            
        case .mtRoute(let id, let ip) :
            print("mtRoute to: \(ip)")
            comand = MtRoute(withId:id , withIp: ip, praser: Prasers.GenericPraser())
            
         
        case .netStat :
            print("netStat")
            comand = NetStat(praser:Prasers.NetStatPraser())
         
         
    }
    return comand
   }
}




public enum FireWallComands  {
    
    case  fireWallState(id:String)
    case  fireWallBadHosts(id:String)
    case  fireWallStart(id:String)
    case  fireWallStop(id:String)
    case  addFireWallBadHosts(id:String, ip:String)
    case  deleteFireWallBadHosts(id:String, ip:String)
    
    public  func  comand() ->  Comand {
        
        var comand:Comand!
        
        switch self {
        case .fireWallState(let id):
            print("fireWallState")
            comand =  FireWallState(withId:id, praser:Prasers.StatePraser()) //TODO: poner el praser ya en cada struct menos la generica
            
        case .fireWallBadHosts(let id):
            print("fireWallBadHosts")
             comand =  FireWallBadHosts(withId:id, praser: Prasers.GenericPraser())
        case .fireWallStart(let id):
            print("fireWallStart")
            comand =  FireWallStart(withId: id, praser: Prasers.GenericPraser())
            
        case .fireWallStop(let id):
            print("fireWallStop")
             comand =  FireWallStop(withId: id, praser: Prasers.GenericPraser())
            
        case .addFireWallBadHosts(let id,let ip):
            print("addFireWallBadHosts")
             comand =  AddFireWallBadHosts(withId: id, withIp:ip, praser: Prasers.GenericPraser())
            
        case .deleteFireWallBadHosts(let id,let ip):
            print("deleteFireWallBadHosts")
             comand =  DeleteFireWallBadHosts(withId:id, withIp:ip, praser: Prasers.GenericPraser())
        }
        return comand
    }
    
}






public protocol Praserable {
    var praser:Prasable {get set}
}


//MARK: --------------------------------  protocol Comand  --------------------------------
public  protocol Comand:Praserable   {
    var taskPath:String {get set}
    var taskArgs:[String] {get set}
    var type:ComandType {get}
    
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
    
    mutating func addIp() {
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






//MARK: -------------------------------- NetStatConection  --------------------------------

struct NetStatConection  {
    
    var ipLocation:IPLocation!
    var sourceIp:String = ""
    var destinationIp:String = ""
    
}





//MARK: -------------------------------- GENERIC Comand --------------------------------
struct GenericComand:Comand   {
    
    var praser: Prasable
    var type: ComandType = .generic
    var taskPath:String =  ""
    var taskArgs:[String] = [] //FIXME: Aqui creo que falta que se pongan los parametros
}



 



 
