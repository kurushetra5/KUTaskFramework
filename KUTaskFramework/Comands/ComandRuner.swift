//
//  ComandRuner.swift
//  Prueba-Timer-shellComand-Operations
//
//  Created by Kurushetra on 22/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation



public protocol ComandsRunerDelegate {
    func finish(comand:String, withResult result:Any)
    func finishWith(error:Error)
    
}

public enum ComandsRunerError: Error {
    case ComandsRunerFailed(reason: String)
}







public class ComandsRuner {
   
    
    public static var comandsRunerDelegate:ComandsRunerDelegate!
    static var timers:[KUTimer] = []
    
    
    
    public static func run(comand:Comand, completion:@escaping (Any) -> Void) {
        run(comand:comand ) { (result) in
            completion( comand.praser.prase(comandResult:result) )
        }
        
        
    }
    
    public static func runForEver(comand:Comand, interval:Double) {
           runTimerTask(comand, every:interval)
    }
    
    
    
    
    
    
    //MARK: ---------------------- PRIVATE API ---------------------------
    
    private  static func run(comand:Comand  ,completion:@escaping ([String]) -> Void) {

        start(comand: comand, completion: { (results,comand) in
                completion(results)
            
        })

    }
    
    
    static  func runTimerTask(_ comand:Comand, every:Double) {
       
        
        for timer in timers  {
            
            if timer.taskType == comand.name {
                comandsRunerDelegate?.finishWith(error:ComandsRunerError.ComandsRunerFailed(reason:"El Comando ya se esta corriendo y se intenta correr otra Vez"))
            } else {
                let timer:KUTimer = KUTimer(timer:Timer() , id:"TimerID_0001", taskType:comand.name) //TODO: poner id random y comprobar por id
                timers.append(timer)
                start(timer:timer, with: comand , every:every)
            }
        }
        
        if timers.count == 0 {
            let timer:KUTimer = KUTimer(timer:Timer() , id:"TimerID_0001", taskType:comand.name)
            timers.append(timer)
            start(timer:timer, with: comand, every:every )
        }
        
    }
    
    private static func start(comand:Comand, completion:@escaping ([String],String) -> Void) {
        
        let task = Process()
        task.launchPath = comand.taskPath
        task.arguments = comand.taskArgs
        task.standardOutput = Pipe()
        task.terminationHandler = { task in
            guard task.terminationStatus == 0
                else {
                    comandsRunerDelegate?.finishWith(error:ComandsRunerError.ComandsRunerFailed(reason:"The process fail to operate."))
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
    
    static  func start(timer:KUTimer, with comand:Comand, every:Double ) {
        timer.timer = Timer.scheduledTimer(timeInterval:every, target: self, selector: #selector(self.timerKU), userInfo:["KUComand":comand], repeats: true)
    }
    
    
    
    @objc static func timerKU(timer:Timer) {
        let timerUserInfo = timer.userInfo as! Dictionary<String, Comand>
        let comandToRun:Comand = timerUserInfo["KUComand"]!
        
        ComandsRuner.start(comand:comandToRun) { (results, comand) in
            
            let comandResults = comandToRun.praser.prase(comandResult: results)
            ComandsRuner.comandsRunerDelegate?.finish(comand:comand, withResult:comandResults)
        }
    }
    
    
    
    
    
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
                comandsRunerDelegate?.finishWith(error:ComandsRunerError.ComandsRunerFailed(reason:"Timer with Procces not Runing... you try to Stoped"))
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
