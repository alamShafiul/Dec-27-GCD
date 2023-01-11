//
//  SecondVC.swift
//  Dec-27-GCD
//
//  Created by Admin on 28/12/22.
//

import UIKit

class SecondVC: UIViewController {
    
    @IBOutlet weak var progressBarOne: UIProgressView!
    @IBOutlet weak var progressBarTwo: UIProgressView!
    @IBOutlet weak var progressBarThree: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarOne.progress = 0.0
        progressBarTwo.progress = 0.0
        progressBarThree.progress = 0.0
    }
    
    @IBAction func actionBtnPress(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.progressBarOne.setProgress(0.0, animated: true)
            self.progressBarTwo.setProgress(0.0, animated: true)
            self.progressBarThree.setProgress(0.0, animated: true)
        }
        //sleep(1)
        doAlertAction()
    }
    
//MARK: - Alert part
    func doAlertAction() {
        let parentSerial = DispatchQueue(label: "com.serial.parent")
        
        let alertVC = UIAlertController(title: "Action", message: "What do you want to do??", preferredStyle: .actionSheet)
        
        present(alertVC, animated: true)
        
        let serialAsync = UIAlertAction(title: "Serial - Async", style: .default, handler: {
            [weak self] _ in
            guard let self = self else {
                return
            }
            parentSerial.async {
                self.doSerialAsync()
            }
            parentSerial.async {
                self.doSmallWork(flag: 2)
            }
            self.dismiss(animated: true)
        })
        
        let serialSync = UIAlertAction(title: "Serial - Sync", style: .default, handler: {
            [weak self] _ in
            guard let self = self else {
                return
            }
            parentSerial.async {
                self.doSerialSync()
            }
            parentSerial.async {
                self.doSmallWork(flag: 2)
            }
            self.dismiss(animated: true)
        })
        
        let concurrentAsync = UIAlertAction(title: "Concurrent - Async", style: .default, handler: {
            [weak self] _ in
            guard let self = self else {
                return
            }
            parentSerial.async {
                self.doConcurrentAsync()
            }
            parentSerial.async {
                self.doSmallWork(flag: 2)
            }
            self.dismiss(animated: true)
        })
        
        let concurrentSync = UIAlertAction(title: "Concurrent - Sync", style: .default, handler: {
            [weak self] _ in
            guard let self = self else {
                return
            }
            parentSerial.async {
                self.doConcurrentSync()
            }
            parentSerial.async {
                self.doSmallWork(flag: 2)
            }
            self.dismiss(animated: true)
        })
        
        let closeAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            [weak self] _ in
            self!.dismiss(animated: true)
        })
        
        alertVC.addAction(serialAsync)
        alertVC.addAction(serialSync)
        alertVC.addAction(concurrentAsync)
        alertVC.addAction(concurrentSync)
        alertVC.addAction(closeAlert)
    }
    
//MARK: - Serial Async
    func doSerialAsync() {
        let serialQueue = DispatchQueue(label: "com.serial.queue")
        serialQueue.async { [weak self] in
            self!.doSmallWork(flag: 0)
        }
        serialQueue.async { [weak self] in
            self!.doSmallWork(flag: 1)
        }
//        serialQueue.async { [weak self] in
//            self!.doSmallWork(flag: 2)
//        }
    }
    
//MARK: - Serial Sync
    func doSerialSync() {
        let serialQueue = DispatchQueue(label: "com.serial.queue")
        serialQueue.sync { [weak self] in
            self!.doSmallWork(flag: 0)
        }
        serialQueue.sync { [weak self] in
            self!.doSmallWork(flag: 1)
        }
//        serialQueue.sync { [weak self] in
//            self!.doSmallWork(flag: 2)
//        }
    }
    
//MARK: - Concurrent Async
    func doConcurrentAsync() {
        let concurrentQueue = DispatchQueue(label: "com.concurrent.queue", attributes: .concurrent)
        concurrentQueue.async { [weak self] in
            self!.doSmallWork(flag: 0)
        }
        concurrentQueue.async { [weak self] in
            self!.doSmallWork(flag: 1)
        }
//        concurrentQueue.async { [weak self] in
//            self!.doSmallWork(flag: 2)
//        }
    }
    
//MARK: - Concurrent Sync
    func doConcurrentSync() {
        let concurrentQueue = DispatchQueue(label: "com.concurrent.queue", attributes: .concurrent)
        concurrentQueue.sync { [weak self] in
            self!.doSmallWork(flag: 0)
        }
        concurrentQueue.sync { [weak self] in
            self!.doSmallWork(flag: 1)
        }
//        concurrentQueue.sync { [weak self] in
//            self!.doSmallWork(flag: 2)
//        }
    }
    
//MARK: - Small Work
    func doSmallWork(flag: Int) {
        let loadingSpeed = UInt32.random(in: 1...3)
        sleep(loadingSpeed)
        self.setLabelStatus(flag: flag)
    }
    
//MARK: - make change on UI
    func setLabelStatus(flag: Int) {
        let limit = 100
        if(flag == 0) {
            for i in 1...limit {
                Thread.sleep(forTimeInterval: 0.05)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.progressBarOne.setProgress(Float(i)/Float(limit), animated: true)
                }
            }
        }
        else if(flag == 1) {
            for i in 1...limit {
                Thread.sleep(forTimeInterval: 0.05)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.progressBarTwo.setProgress(Float(i)/Float(limit), animated: true)
                }
            }
        }
        else {
            for i in 1...limit {
                Thread.sleep(forTimeInterval: 0.05)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.progressBarThree.setProgress(Float(i)/Float(limit), animated: true)
                }
            }
        }
    }
}
