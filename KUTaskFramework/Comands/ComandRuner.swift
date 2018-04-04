//
//  ComandRuner.swift
//  Prueba-Timer-shellComand-Operations
//
//  Created by Kurushetra on 22/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation



public protocol ComandsRunerDelegate {
    func finish(comand:String, withResult result:[String])
}

public enum ComandsRunerError: Error {
    case ComandsRunerFailed(reason: String)
}






public class ComandsRuner {
   
    
    public static var comandsRunerDelegate:ComandsRunerDelegate!
    static var praser:Prasable! //TODO: Sobra ? lo paso en el ennum
    static var timers:[KUTimer] = []
    
    
    
    //MARK: ---------------------- PUBLIC API ---------------------------
    
    public static func setPraser(praser:Any)  throws  {  //TODO: Sobra ???
        
        guard let thePraser =  praser as? Prasable else {
            throw ComandsRunerError.ComandsRunerFailed(reason:"ERROR Class: ComandsRuner Location: public static func setPraser(praser:Any)  throws Reason: The praser introduced do not conform to protocol Prasabl")
        }
        self.praser = thePraser
    }
    
    
    
    public static func runGeneric(comand:String, args:[String], completion:@escaping (PraserResult) -> Void) {
        
        praser =  Prasers.GenericPraser()
        print("Generic")
        let comandForRun:Comand  = GenericComand(name:"generic", praser: praser, taskPath: comand, taskArgs:args)
        
        run(comand:comandForRun  , forEver:false) { (result) in
            completion(self.praser.prase(comandResult:result) )
        }
        
    }
    
    
    public static func run(comand:Comand, completion:@escaping (PraserResult) -> Void) {
        run(comand:comand  , forEver:false) { (result) in
            completion( comand.praser.prase(comandResult:result) )
        }
    }
    
    
    
    public static func runForEver(comand:Comand, completion:@escaping (PraserResult) -> Void) {
        run(comand:comand  , forEver:true) { (result) in
            print(result)
            completion(comand.praser.prase(comandResult:result) )
        }
    }
    
    
    
    
    //MARK: ---------------------- PRIVATE API ---------------------------
    
    private  static func run(comand:Comand, forEver:Bool ,completion:@escaping ([String]) -> Void) {
        
        switch forEver {
        case true:
            runTimerTask(comand)
            
            
        case false:
            run(comand: comand, completion: { (results,comand) in
                completion(results)
                
            })
            
        }
        
    }
    
    static  func runTimerTask(_ comand:Comand) {
       
        
        for timer in timers  {
            
            if timer.taskType == comand.name {
                print("El Comando ya se esta corriendo ...???")
            } else {
                let timer:KUTimer = KUTimer(timer:Timer() , id:"TimerID_0001", taskType:comand.name) //TODO: poner id random y comprobar por id
                timers.append(timer)
                start(timer:timer, with: comand )
            }
        }
        
        if timers.count == 0 {
            let timer:KUTimer = KUTimer(timer:Timer() , id:"TimerID_0001", taskType:comand.name)
            timers.append(timer)
            start(timer:timer, with: comand )
        }
        
    }
    
    private static func run(comand:Comand, completion:@escaping ([String],String) -> Void) {
        
        let task = Process()
        task.launchPath = comand.taskPath
        task.arguments = comand.taskArgs
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
                else {
                    return
            }
            
            let dataResult = s.components(separatedBy: "\n")
            
            DispatchQueue.main.sync {
                completion(dataResult,comand.name)
            }
        }
        task.launch()
    }
    
    
    
    
    
    
    
    
    //MARK: ---------------------- TIMERS ---------------------------
    
    public static func stopForEver(comand:String) {
        stop(comandName:comand)
    }
    
    
    static  func stop(comandName:String) {
        
        for timer in timers {
            if timer.taskType == comandName {
                timer.timer.invalidate()
                
                if let index = timers.index(where: {$0.taskType == comandName}) {
                    timers.remove(at: index)
                }
            } else {
                print("Timer with Procces not Runing..")
            }
        }
    }
    
    
    static  func start(timer:KUTimer, with comand:Comand ) {
 
        timer.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.timerKU), userInfo:["KUComand":comand], repeats: true)
    }
    
    
    @objc static func timerKU(timer:Timer) {
        let timerUserInfo = timer.userInfo as! Dictionary<String, Comand>
        let comandToRun:Comand = timerUserInfo["KUComand"]!
        
        ComandsRuner.run(comand:comandToRun) { (results, comand) in
            ComandsRuner.comandsRunerDelegate?.finish(comand:comand, withResult:results)
        }
    }
    
    
    
    
    
    
}
