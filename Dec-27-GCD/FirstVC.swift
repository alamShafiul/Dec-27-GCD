//
//  ViewController.swift
//  Dec-27-GCD
//
//  Created by Admin on 27/12/22.
//

import UIKit

class FirstVC: UIViewController {

//MARK: - Outlets
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var executeBtnOutlet: UIButton!
    
    var buttonEnable = 1
    
//MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//MARK: - Actions Buttons
    @IBAction func executeBtn(_ sender: Any) {
        //if(buttonEnable == 1) {
            buttonEnable = 0
            // immediate change on UI by pressing execute btn
            DispatchQueue.main.async { [weak self] in
                self!.setLabelStatus(value: 0, flag: 0)
                self!.setLabelStatus(value: 0, flag: 1)
                self!.setLabelStatus(value: 0, flag: 2)
            }
            sleep(1)
            doAlertAction()
        //}
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
        for i in 1...5 {
            let loadingSpeed = UInt32.random(in: 1...3)
            sleep(loadingSpeed)
            self.setLabelStatus(value: i*20, flag: flag)
        }
    }
    
//MARK: - make change on UI
    func setLabelStatus(value: Int, flag: Int) {
        let txt = "task \(value)% done"
        var color: UIColor = .gray
        
        if(value == 20) {
            color = .red
        }
        else if(value == 40) {
            color = .orange
        }
        else if(value == 60) {
            color = .systemYellow
        }
        else if(value == 80) {
            color = .yellow
        }
        else if(value == 100) {
            color = .systemGreen
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            if(flag == 0) {
                self.labelOne.text = txt
                self.labelOne.backgroundColor = color
            }
            else if(flag == 1) {
                self.labelTwo.text = txt
                self.labelTwo.backgroundColor = color
            }
            else {
                self.labelThree.text = txt
                self.labelThree.backgroundColor = color
            }
        }
    }
}

