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







protocol Praserable {
    var praser:Prasable {get set}
}


protocol ComandPraserable:Comand,Praserable {
    init(praser:Prasable)
}
protocol ComandIpPraserable:ComandIp,Praserable {
    init(withIp:String,praser:Prasable)
}
protocol ComandIdPraserable:ComandRunerId,Praserable {
    init(withId:String,praser:Prasable)
}
protocol ComandIdIpPraserable:ComandRunerId,ComandIp ,Praserable {
    init(withId:String,withIp:String, praser:Prasable)
}



protocol Comand   {
    var taskPath:String{get set}
    var taskArgs:[String]{get set}
    var type:ComandType{get set}
    
}


protocol ComandIp:Comand  {
    var ip:String{get set}
//    init(withIp:String)
    mutating func addIp()
}






protocol ComandRunerId {
    var comandRunerId:String{get set}
//     init(withId:String)
    mutating func addId()
}


extension ComandRunerId where Self : Comand {
    
    mutating func addId() {
        
        let comand:String = taskArgs[1]  //FIXME: Aqqui falla no se le pasan los arrgs ??
        let comandWithId:String = comand.replacingOccurrences(of:"¿¿¿", with:self.comandRunerId)
        self.taskArgs[1] = comandWithId
        }
    
}






protocol ComandIpId:ComandRunerId,ComandIp {
    
    init(withIp:String,withId:String)
}

extension ComandIpId    {
    //TODO: mirar si se pueden quitar los inits
    init(withIp:String) {
        self.init(withIp:withIp)
    }
    init(withId:String) {
        self.init(withId:withId)
    }
 
    mutating func addIp() {
        let comand:String = taskArgs[1]
        let comandWithIp:String = comand.replacingOccurrences(of:"???", with:self.ip)
        self.taskArgs[1] = comandWithIp
        
    }
    mutating func addId() {
        
        let comand:String = taskArgs[1]
        let comandWithId:String = comand.replacingOccurrences(of:"¿¿¿", with:self.comandRunerId)
        self.taskArgs[1] = comandWithId
        
    }
}





protocol comandDelegate   {
    func  comand(finish:ComandType,result:Any)
}




//MARK: -------------------------------- NetStatConection  --------------------------------

struct NetStatConection  {
    
    var ipLocation:IPLocation!
    var sourceIp:String = ""
    var destinationIp:String = ""
    
}










//MARK: -------------------------------- GENERIC--------------------------------
struct GenericComand:Comand   {
    
    var praser: Prasable
    var type: ComandType = .generic
    var taskPath:String =  ""
    var taskArgs:[String] = [] //FIXME: Aqui creo que falta que se pongan los parametros
}




struct GenericComandIp:ComandIpPraserable  {
    
 
    var praser: Prasable
    var ip: String
    
    var type: ComandType = .generic
    var taskPath:String =  ""
    var taskArgs:[String] = []
    
    init(withIp:String, praser:Prasable) {
        self.praser = praser
        self.ip = withIp

        addIp()
    }
    
    mutating func addIp() {
        self.taskArgs = [self.ip]
    }
    
}


struct GenericComandId:Comand,ComandIdPraserable  {
    
    var praser: Prasable
    var comandRunerId: String = ""
    var type: ComandType = .generic
    var taskPath:String =  ""
    var taskArgs:[String] = []
    
    init(withId: String, praser: Prasable) {
        self.praser = praser
        self.comandRunerId = withId
        addId()
    }
    
}



struct GenericComandIpId:ComandIdIpPraserable {
    
    
    func addIp() {
        
    }
    
    var praser: Prasable
    
    
    
    var comandRunerId: String
    var ip: String
    var type: ComandType = .generic
    var taskPath:String =  ""
    var taskArgs:[String] = []
    
    init(withId: String, withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
        self.comandRunerId = withId
        addId()
        addIp()
    }
    
 
}





//MARK: -------------------------------- CONECTIONS --------------------------------
struct NetStat:ComandPraserable  {
    
    var praser: Prasable
    var type: ComandType = .netStat
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "netstat -an  | grep ESTABLISHED"]
    
    init(praser: Prasable) {
        self.praser = praser
    }
}





//MARK: -------------------------------- INFO COMANDS --------------------------------
struct TcpDumpCom:ComandIpPraserable {
    
    var type: ComandType = .tcpDump
    var taskPath:String =  "/usr/sbin/tcpdump"
    var taskArgs:[String] = ["-i","en4","-n" ," not (src net 192.168.8.1 and dst net 192.168.8.100) and not  (src net 192.168.8.100 and dst net 192.168.8.1) and not (src net 192.168.8.1 and dst net 239.255.255.250)"]
    
    var ip:String = ""
    
    var praser: Prasable
    
    init(withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
//        addIp()
    }
    
    mutating func block(ip:String) {
        let notIpArgs:String = "and not (src net " + ip + " and dst net " + ip + ")"
        self.taskArgs.append(notIpArgs)
    }
    
    mutating func addIp() {
//        self.taskArgs[2] = self.ip
    }
}



struct TraceRoute:ComandIpPraserable {
    
    
    var praser: Prasable
    
    
 
    var type: ComandType = .traceRoute
    
    var ip:String = ""
    var taskPath:String =  "/usr/sbin/traceroute"
    var taskArgs:[String] = ["-w 1" , "-m30" ,"???"]
    
    
    init(withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
        addIp()
    }
    
 
    
    mutating func addIp() {
        self.taskArgs[2] = self.ip
    }
}




struct NsLookup:ComandIpPraserable {
    var praser: Prasable
    
 
    var type: ComandType = .nsLookup
    
    var ip:String = ""
    var taskPath:String =  "/usr/bin/nslookup"
    var taskArgs:[String] = []
  
    
    init(withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
        addIp()
    }
    
 
    mutating func addIp() {
        self.taskArgs = [self.ip]
    }
}


struct Whois:ComandIpPraserable {
    var praser: Prasable
    
 
    var type: ComandType = .whois
    
    var ip:String = ""
    var taskPath:String =  "/usr/bin/whois"
    var taskArgs:[String] = []
    
    
    init(withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
        addIp()
    }
    
    mutating func addIp() {
        self.taskArgs = [self.ip]
    }
}


struct MtRoute:ComandIdIpPraserable {
    
    
    var praser: Prasable
    
 
    var comandRunerId: String = ""
    var type: ComandType = .mtRoute
    
    
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S  ./mtr -rw -n ??? | awk '{print $2}'"] //FIXME: ruta de mtr no es esta
    
    
    init(withId: String, withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
        self.comandRunerId = withId
        addId()
        addIp()
    }
    
    func addIp() {
     
    }
 
}




//MARK: -------------------------------- FIREWALL --------------------------------
struct FireWallStart:Comand, ComandIdPraserable  {
    
    
    var praser: Prasable
    
    
    
    
    var comandRunerId: String = ""
    var type: ComandType = .fireWallStart
    
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl -e -f  /etc/pf.conf"]
    
    init(withId: String, praser: Prasable) {
        self.praser = praser
        self.comandRunerId = withId
        addId()
    }
 
}


struct FireWallStop:Comand,ComandIdPraserable  {
    var praser: Prasable
    
    
    var comandRunerId: String = ""
    var type: ComandType = .fireWallStop
    
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S  pfctl -d"]
    
    init(withId: String, praser: Prasable) {
        self.praser = praser
        self.comandRunerId = withId
        addId()
    }
    
 
}



struct FireWallState:Comand, ComandIdPraserable  {
    var praser: Prasable
    
    var comandRunerId: String = ""
    var type: ComandType = .fireWallState
    
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl  -s info | grep Status"]
    
    init(withId: String, praser: Prasable) {
        self.praser = praser
        self.comandRunerId = withId
        addId()
    }
 
}



struct FireWallBadHosts:Comand, ComandIdPraserable  {
    var praser: Prasable
    
    
    var comandRunerId: String = ""
    var type: ComandType = .fireWallBadHosts
    
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl -t badhosts -T show"]
    
    init(withId: String, praser: Prasable) {
        self.praser = praser
        self.comandRunerId = withId
        addId()
    }
}


struct AddFireWallBadHosts:ComandIdIpPraserable   {
    var praser: Prasable
    
    
    var comandRunerId: String = ""
    var type: ComandType = .addFireWallBadHosts
    
    
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl  -t badhosts -T add ???"]
    
    init(withId: String, withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
        self.comandRunerId = withId
        addId()
        addIp()
    }
    
 
    mutating func addIp() {
        let comand:String = taskArgs[1]
        let comandWithIp:String = comand.replacingOccurrences(of:"???", with:self.ip)
        self.taskArgs[1] = comandWithIp

    }
}


struct DeleteFireWallBadHosts:ComandIdIpPraserable  {
    var praser: Prasable
    
    var comandRunerId: String = ""
    var type: ComandType = .deleteFireWallBadHosts
    
    
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl  -t badhosts -T delete ???"]
    
    init(withId: String, withIp: String, praser: Prasable) {
        self.praser = praser
        self.ip = withIp
        self.comandRunerId = withId
        addId()
        addIp()
    }
 
    mutating func addIp() {
        let comand:String = taskArgs[1]
        let comandWithIp:String = comand.replacingOccurrences(of:"???", with:self.ip)
        self.taskArgs[1] = comandWithIp

    }
}
