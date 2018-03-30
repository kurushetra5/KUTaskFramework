//
//  ComandRuner.swift
//  Prueba-Timer-shellComand-Operations
//
//  Created by Kurushetra on 22/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation



protocol ComandsRunerDelegate {
    func finish(comand:ComandType, withResult result:[String])
}

public enum ComandsRunerError: Error {
    case ComandsRunerFailed(reason: String)
}




public class ComandsRuner {
    
    
    static var timer:Timer!
    static var timer2:Timer!
    public static var comandsRunerId:String!
    
    
    var comandsRunerDelegate:ComandsRunerDelegate!
    static var comand1:Comand!
    static var comand2:Comand!
    static var praser:Prasable!
    
    
    public static func setPraser(praser:Any)  throws  {
        
        guard let thePraser =  praser as? Prasable else {
            throw ComandsRunerError.ComandsRunerFailed(reason:"ERROR Class: ComandsRuner Location: public static func setPraser(praser:Any)  throws Reason: The praser introduced do not conform to protocol Prasabl")
        }
        
        self.praser = thePraser
    }
    
    
    
    
    public static func run(comand:String, toIp:String!, forEver:Bool, completion:@escaping (String) -> Void) {
        
        var ip:String = "0.0.0.0" //TODO: cambiar ???
        var comandForRun:Comand!
        var isOk:Bool = false
        
        if toIp != nil {
            ip = toIp
        }
        
        switch comand {
        // ----------------------- FIREWALL -----------------------
        case ComandType.fireWallState.rawValue:
             praser = StatePraser()
             print("fireWallState")
             isOk = true
             comandForRun = FireWallState(withId:comandsRunerId)
            
        case ComandType.fireWallStart.rawValue:
            praser = GenericPraser()
            print("fireWallStart")
            isOk = true
            comandForRun =  FireWallStart(withId: comandsRunerId)
            
        case ComandType.fireWallStop.rawValue:
            praser = GenericPraser()
            print("fireWallStop")
            isOk = true
            comandForRun =  FireWallStop(withId: comandsRunerId)
            
        case ComandType.fireWallBadHosts.rawValue:
            praser = badHostsPraser()
            print("fireWallBadHosts")
            comandForRun = FireWallBadHosts(withId:comandsRunerId)
            isOk = true
            
        case ComandType.addFireWallBadHosts.rawValue:
            praser = GenericPraser()
            print("addFireWallBadHosts")
            comandForRun =  AddFireWallBadHosts(withIp:ip, withId: comandsRunerId)
            isOk = true
            
        case ComandType.deleteFireWallBadHosts.rawValue:
            praser = GenericPraser()
            print("deleteFireWallBadHosts")
            comandForRun =  DeleteFireWallBadHosts(withIp:ip, withId:comandsRunerId)
            isOk = true
            
        case ComandType.blockIp.rawValue:
            praser = GenericPraser()
            print("blockIp")
            comandForRun =  GenericComand(type:.ping, taskPath:"/usr/bin/block", taskArgs:[ip])
            isOk = true
            
            
        // ----------------------- INFO -----------------------
        case ComandType.mtRoute.rawValue:
            praser = GenericPraser()
            print("mtRoute")
            comandForRun =  MtRoute(withIp:ip, withId:comandsRunerId)
            isOk = true
            
        case ComandType.nsLookup .rawValue:
            praser = GenericPraser()
            print("nsLookup")
            comandForRun =  NsLookup(withIp:ip)
            isOk = true
            
        case ComandType.ping.rawValue:
            praser = GenericPraser()
            print("ping")
            comandForRun = GenericComand(type:.ping, taskPath:"/usr/bin/ping", taskArgs:[ip])
            isOk = true
            
         case ComandType.traceRoute.rawValue:
            praser = GenericPraser()
            print("traceRoute")
            comandForRun =  TraceRoute(withIp:ip)
            isOk = true
            
        case ComandType.whois.rawValue:
            praser = GenericPraser()
            print("whois")
            comandForRun =  Whois(withIp:ip)
            isOk = true
            
        case ComandType.dig.rawValue:
            praser = GenericPraser()
            print("dig")
            comandForRun =  GenericComand(type:.dig, taskPath:"/usr/bin/dig", taskArgs:[ip])
            isOk = true
            
        case ComandType.history.rawValue:
            praser = GenericPraser()
            print("history")
            comandForRun =  GenericComand(type:.history, taskPath:"/usr/bin/history", taskArgs:[ip])
            isOk = true
            
        case ComandType.ports_Services.rawValue:
            praser = GenericPraser()
            print("ports_Services")
            comandForRun =  GenericComand(type:.ports_Services, taskPath:"/usr/bin/nmap", taskArgs:[ip])
            isOk = true
            
            
            //  ----------------------- CONECTIONS -----------------------
        case ComandType.netStat.rawValue:
            praser = NetStatPraser()
            print("netStat")
            isOk = true
            comandForRun =  NetStat()
            
        case ComandType.tcpDump.rawValue:
            praser = GenericPraser()
            print("tcpDump")
            isOk = true
            comandForRun =  TcpDumpCom()
            
            
        //  ----------------------- CONECTIONS -----------------------
         
        case ComandType.conectionData.rawValue:
            praser = GenericPraser()
            print("conectionData")
            comandForRun =  GenericComand(type:.conectionData, taskPath:"/usr/bin/tcpdump", taskArgs:[ip])
            isOk = true
            
            //  ----------------------- GENERICS -----------------------
        case ComandType.genericComand.rawValue:
            praser = GenericPraser()
            print("genericComand")
            comandForRun =  GenericComand(type:.genericComand, taskPath:"/usr/bin/pwd", taskArgs:[ip])
            isOk = true
            
        case ComandType.generic.rawValue:
            praser = GenericPraser()
            print("generic")
            comandForRun =  GenericComand(type:.generic, taskPath:"/usr/bin/ls", taskArgs:[ip])
            isOk = true
            
        default:
            print("no")
            isOk = false
            
        }
        
        
        if isOk {
            run(comand:comandForRun  , forEver: forEver) { (result) in
            print(result)
        
            completion(self.praser.prase(comandResult:result) as! String)
        }
        } else {
            print("The comand is not indexed yet ... run(comand")
        }
        
    }
    
    
    
    
    static func run(comand:Comand, forEver:Bool ,completion:@escaping (String) -> Void) {
        
        switch forEver {
        case true:
            
            if timer  == nil {
                comand1 = comand
                timerStart()
            }else if timer != nil {
                comand2 = comand
                timerStart2()
            }
            
        case false:
            run(comand: comand, completion: { (results,comand) in
                print(results)
                print(comand)
                completion(results[0])
                //                 self.comandsRunerDelegate?.finish(comand:comand, withResult:results)
            })
            //            completion("acabado_1")
        }
        
    }
    
    
    
    
    
    
    private static func run(comand:Comand, completion:@escaping ([String],ComandType) -> Void) {
        
        let task = Process()
        task.launchPath = comand.taskPath
        task.arguments = comand.taskArgs
//        task.arguments = comand.taskArgs
        task.standardOutput = Pipe()
        
        task.terminationHandler = { task in
            guard task.terminationStatus == 0
                else {
                    NSLog("The process fail to operate.")
                    return
            }
            
            guard let data = (task.standardOutput as? Pipe)?.fileHandleForReading.availableData,
                data.count > 0,
                let s = String(data: data, encoding: .utf8)
                else { return }
            
            let dataResult = s.components(separatedBy: "\n").filter{ !$0.contains("/.git/") }
            
            DispatchQueue.main.sync {
                completion(dataResult,comand.type)
            }
        }
        task.launch()
    }
    
    
    
    
    
    
    
    
    //MARK: ---------------------- TIMERS ---------------------------
    
    
    
    static func timerStart() {
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        print("timerStart()")
        
    }
    
    static  func timerStart2() {
        
        timer2 = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.timerAction2), userInfo: nil, repeats: true)
        print("timerStart2()")
        
    }
    
    
    
    
    
    
    @objc func timerAction() {
        print("timer Action()")
        
        
        ComandsRuner.run(comand:ComandsRuner.comand1) { (results, comand) in
            self.comandsRunerDelegate?.finish(comand:comand, withResult:results)
        }
        
        
        
    }
    
    
    
    @objc func timerAction2() {
        print("timer Action2()")
        
        ComandsRuner.run(comand:ComandsRuner.comand2) { (results, comand) in
            self.comandsRunerDelegate?.finish(comand:comand, withResult:results)
        }
        
        
    }
    
    
    
}
