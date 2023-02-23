//
//  ViewController.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 20.02.2023.
//

import UIKit
import AVFoundation
import SwiftMessages

protocol MainScreenViewProtocol: AnyObject {
    func displayConvertedToMorseText(textToDisplay: String)
    func didReceiveDefaultLocalizationSetupResult(result: Result<String, Error>)
    func didReceiveSavedSettings(dotSpeed: Float, dashSpeed: Float)
}

final class MainScreenViewController: UIViewController {
    
    var presenter: MainScreenPresenterProtocol?
    
    private var shouldContinueFlashing = true
    private var dotSpeed: Float = 0.2
    private var dashSpeed: Float = 0.6
    private let device = AVCaptureDevice.default(for: .video)
    
    private var screenStrings: [AppStrings:String] = [:] {
        didSet {
            guard !screenStrings.isEmpty else { return }
            
            topTitle.text = screenStrings[.mainScreenTitle]
            inputAreaHint.text = screenStrings[.mainScreenInputAreaHint]
            outputAreaHint.text = screenStrings[.mainScreenOutputAreaHint]
            if flashButton.backgroundColor != .red {
                UIView.performWithoutAnimation {
                    flashButton.setTitle(screenStrings[.mainScreenFlashButtonStart], for: .normal)
                    flashButton.layoutIfNeeded()
                }
            } else {
                UIView.performWithoutAnimation {
                    flashButton.setTitle(screenStrings[.mainScreenFlashButtonStop], for: .normal)
                    flashButton.layoutIfNeeded()
                }
            }
        }
    }
    
    private let topTitle: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 238, green: 242, blue: 254)
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
    
    private let inputAreaHint: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.layer.cornerRadius = 25
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let outputAreaHint: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.layer.cornerRadius = 25
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let flashButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 82, green: 25, blue: 241)
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
        presenter?.viewDidLoad()

        view.backgroundColor = UIColor(red: 4, green: 7, blue: 46)
        topTitle.font = UIFont.boldSystemFont(ofSize: view.bounds.height/25)
        inputAreaHint.font = UIFont.systemFont(ofSize: view.bounds.height/65)
        outputAreaHint.font = UIFont.systemFont(ofSize: view.bounds.height/65)
        
        inputAreaTextView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let tapForInput = UITapGestureRecognizer(target: self, action: #selector(didTapInputArea))
        inputAreaHint.addGestureRecognizer(tapForInput)
        
        setupConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.viewDidAppear()
    }
    
    private func setupConstraints() {
        [topTitle, inputArea, outputArea, flashButton].forEach { element in
            view.addSubview(element)
        }
        
        [inputAreaTextView, inputAreaHint].forEach { element in
            inputArea.addSubview(element)
        }
        
        [outputAreaTextView, outputAreaHint].forEach { element in
            outputArea.addSubview(element)
        }
        
        let height = view.bounds.height
        
        topTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: height/25, paddingLeft: height/30, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        inputArea.anchor(top: topTitle.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: height/15, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: height/3, enableInsets: false)
        outputArea.anchor(top: inputArea.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: height/17, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: height/6, enableInsets: false)
        flashButton.anchor(top: nil, left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.trailingAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 30, paddingRight: 20, width: 0, height: 50, enableInsets: false)
        
        inputAreaTextView.anchor(top: inputArea.topAnchor, left: inputArea.leadingAnchor, bottom: inputArea.bottomAnchor, right: inputArea.trailingAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0, enableInsets: false)
        inputAreaHint.anchor(top: inputArea.topAnchor, left: inputArea.leadingAnchor, bottom: inputArea.bottomAnchor, right: inputArea.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        outputAreaTextView.anchor(top: outputArea.topAnchor, left: outputArea.leadingAnchor, bottom: outputArea.bottomAnchor, right: outputArea.trailingAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0, enableInsets: false)
        outputAreaHint.anchor(top: outputArea.topAnchor, left: outputArea.leadingAnchor, bottom: outputArea.bottomAnchor, right: outputArea.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }
    
    @objc func didTapFlashButton(){
        guard !inputAreaTextView.text.isEmpty else { return }
        guard device?.isTorchModeSupported(.on) == true else {
            let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
            messageView.configureBackgroundView(width: 250)

            messageView.configureContent(title: "😱", body: screenStrings[.mainScreenErrorMessageNoFlashlight], iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK") { button in
                SwiftMessages.hide()
            }
            messageView.backgroundView.layer.cornerRadius = 10
            messageView.configureTheme(backgroundColor: UIColor(red: 20, green: 24, blue: 62), foregroundColor: .white)
            var config = SwiftMessages.defaultConfig
            config.presentationStyle = .center
            config.duration = .forever
            config.dimMode = .blur(style: .dark, alpha: 0.9, interactive: true)
            config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
            SwiftMessages.show(config: config, view: messageView)
            
            return
        }
        if flashButton.backgroundColor == .red {
            stopFlashing()
            flashButton.setTitle(screenStrings[.mainScreenFlashButtonStart], for: .normal)
            UIView.animate(withDuration: 0.6, delay: 0.0, options:[.curveEaseOut], animations: { [weak self] in
                self?.flashButton.backgroundColor = UIColor(red: 82, green: 25, blue: 241)
            }, completion: nil)
        } else {
            flashButton.setTitle(screenStrings[.mainScreenFlashButtonStop], for: .normal)
            UIView.animate(withDuration: 0.6, delay: 0.0, options:[.curveEaseIn], animations: { [weak self] in
                self?.flashButton.backgroundColor = .red
            }, completion: nil)
            
            let text = outputAreaTextView.text.trimmingCharacters(in: .whitespaces)
            guard !text.isEmpty else { return }
            performFlashing(withText: text)
        }
        
    }
    
    @objc func dismissKeyboard() {
        if inputAreaTextView.text.isEmpty {
            if inputAreaHint.isHidden {
                inputAreaHint.fadeIn()
            }
        }
        view.endEditing(true)
    }
    
    @objc func didTapInputArea() {
        inputAreaHint.fadeOut()
        inputAreaTextView.becomeFirstResponder()
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
                        Thread.sleep(forTimeInterval: Double(dotSpeed))
                        flashLightOff()
                        Thread.sleep(forTimeInterval: Double(dotSpeed))
                    } else if character == "-" {
                        flashLightOn()
                        Thread.sleep(forTimeInterval: Double(dashSpeed))
                        flashLightOff()
                        Thread.sleep(forTimeInterval: Double(dotSpeed))
                    } else {
                        Thread.sleep(forTimeInterval: 2*Double(dotSpeed))
                    }
                }
                DispatchQueue.main.async { [self] in
                    stopFlashing()
                    flashButton.setTitle(screenStrings[.mainScreenFlashButtonStart], for: .normal)
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
        if !textView.text.isEmpty {
            outputAreaHint.fadeOut()
        } else {
            outputAreaHint.fadeIn()
        }
        presenter?.didChangeTextField(newText: textView.text)
    }
}


extension MainScreenViewController: LocalizationServiceObserver {
    func didUpdateCurrentLocalization(newLocalizationCollection: [AppStrings : String]) {
        screenStrings = newLocalizationCollection
    }
}

extension MainScreenViewController: MainScreenViewProtocol {
    //Get From Presenter
    func displayConvertedToMorseText(textToDisplay: String) {
        outputAreaTextView.text = textToDisplay
    }
    
    //Get from Presenter
    func didReceiveDefaultLocalizationSetupResult(result: Result<String, Error>) {
        switch result {
        case .success(let success):
            print("Setup default lang: ", success)
        case .failure(let failure):
            print("Error setting up default lang: ", failure)
        }
    }
    
    //Get from Presenter
    func didReceiveSavedSettings(dotSpeed: Float, dashSpeed: Float) {
        self.dotSpeed = dotSpeed
        self.dashSpeed = dashSpeed
    }
}
