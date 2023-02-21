//
//  ViewController.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 20.02.2023.
//

import UIKit
import AVFoundation

protocol MainScreenViewProtocol: AnyObject {
    func displayConvertedToMorseText(textToDisplay: String)
}

class MainScreenViewController: UIViewController, MainScreenViewProtocol {
    
    var presenter: MainScreenPresenterProtocol?
    private var shouldContinueFlashing = true
    private let device = AVCaptureDevice.default(for: .video)
    
    
    private let topTitle: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "MorseLight  🔦"
        titleLabel.textColor = UIColor(red: 238, green: 242, blue: 254)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    private let inputArea: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 20, green: 24, blue: 62)
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let outputArea: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 20, green: 24, blue: 62)
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let flashButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 82, green: 25, blue: 241)
        button.setTitle("Flash! 💡", for: .normal)
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapFlashButton), for: .touchUpInside)
        return button
    }()
    
    private let inputAreaTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 18)
        tv.textColor = .white
        tv.layer.cornerRadius = 25
        tv.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return tv
    }()
    
    private let outputAreaTextView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 25
        tv.textColor = .white
        tv.font = .systemFont(ofSize: 15)
        tv.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        tv.isEditable = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 4, green: 7, blue: 46)
        topTitle.font = UIFont.boldSystemFont(ofSize: view.bounds.height/25)
        
        inputAreaTextView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        setupConstraints()
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupConstraints() {
        [topTitle, inputArea, outputArea, flashButton].forEach { element in
            view.addSubview(element)
        }
        
        let height = view.bounds.height
        
        topTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: height/25, paddingLeft: height/30, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        inputArea.anchor(top: topTitle.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: height/15, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: height/3, enableInsets: false)
        outputArea.anchor(top: inputArea.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: height/17, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: height/6, enableInsets: false)
        flashButton.anchor(top: nil, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 30, paddingRight: 20, width: 0, height: 50, enableInsets: false)
        
        inputArea.addSubview(inputAreaTextView)
        
        inputAreaTextView.anchor(top: inputArea.topAnchor, left: inputArea.leadingAnchor, bottom: inputArea.bottomAnchor, right: inputArea.trailingAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0, enableInsets: false)
        
        outputArea.addSubview(outputAreaTextView)
        
        outputAreaTextView.anchor(top: outputArea.topAnchor, left: outputArea.leadingAnchor, bottom: outputArea.bottomAnchor, right: outputArea.trailingAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0, enableInsets: false)
    }
    
    //Get From Presenter
    func displayConvertedToMorseText(textToDisplay: String) {
        outputAreaTextView.text = textToDisplay
    }
    
    @objc func didTapFlashButton(){
        
        if flashButton.backgroundColor == .red {
            stopFlashing()
            flashButton.setTitle("Flash! 💡", for: .normal)
            UIView.animate(withDuration: 0.6, delay: 0.0, options:[.curveEaseOut], animations: { [weak self] in
                self?.flashButton.backgroundColor = UIColor(red: 82, green: 25, blue: 241)
            }, completion: nil)
        } else {
            flashButton.setTitle("Stop ⛔️", for: .normal)
            UIView.animate(withDuration: 0.6, delay: 0.0, options:[.curveEaseIn], animations: { [weak self] in
                self?.flashButton.backgroundColor = .red
            }, completion: nil)
            
            let text = outputAreaTextView.text.trimmingCharacters(in: .whitespaces)
            guard !text.isEmpty else { return }
            performFlashing(withText: text)
        }
        
    }
    
    private func performFlashing(withText: String){
        
        if (device?.isTorchModeSupported(.on))! {
            let textToDisplay = Array(withText)
            shouldContinueFlashing = true
            DispatchQueue.global().async { [self] in
                for character in textToDisplay {
                    if !self.shouldContinueFlashing {
                        flashLightOff()
                        return
                    }
                    if character == "." {
                        flashLightOn()
                        Thread.sleep(forTimeInterval: 0.2)
                        flashLightOff()
                        Thread.sleep(forTimeInterval: 0.2)
                    } else if character == "-" {
                        flashLightOn()
                        Thread.sleep(forTimeInterval: 0.5)
                        flashLightOff()
                        Thread.sleep(forTimeInterval: 0.2)
                    } else {
                        Thread.sleep(forTimeInterval: 0.4)
                    }
                }
                DispatchQueue.main.async {
                    stopFlashing()
                    flashButton.setTitle("Flash! 💡", for: .normal)
                    UIView.animate(withDuration: 0.6, delay: 0.0, options:[.curveEaseOut], animations: { [weak self] in
                        self?.flashButton.backgroundColor = UIColor(red: 82, green: 25, blue: 241)
                    }, completion: nil)
                }
            }
        }
    }
    
    private func flashLightOn() {
        do {
            try device?.lockForConfiguration()
            device?.torchMode = .on
            
            device?.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    private func flashLightOff() {
        do {
            try device?.lockForConfiguration()
            device?.torchMode = .off
            
            device?.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    private func stopFlashing(){
        shouldContinueFlashing = false
    }
}

extension MainScreenViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter?.didChangeTextField(newText: textView.text)
    }
}
