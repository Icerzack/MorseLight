//
//  SettingsViewController.swift
//  MorseLight
//
//  Created by Max Kuznetsov on 20.02.2023.
//

import UIKit
import SwiftMessages

protocol SettingsViewProtocol: AnyObject {
    func didSetupLanguage(result: Result<String, Error>)
    func didReceiveDefaultLocalizationSetupResult(result: Result<String, Error>)
    func didReceiveSavedSettings(settings: Settings)
}

final class SettingsViewController: UIViewController {
    
    var presenter: SettingsPresenterProtocol?
    
    private var currentLanguage = Languages.english
    private var currentDotValue: Float = 0.2 {
        didSet {
            dotValueTextLabel.text = "\(round(currentDotValue*10)/10)"
            dotSlider.value = currentDotValue
        }
    }
    private var currentDashValue: Float = 0.6 {
        didSet {
            dashValueTextLabel.text = "\(round(currentDashValue*10)/10)"
        }
    }
    
    private var screenStrings: [AppStrings:String] = [:] {
        didSet {
            guard !screenStrings.isEmpty else { return }
            
            topTitle.text = screenStrings[.settingsScreenTitle]
            speedTitle.text = screenStrings[.settingsScreenBlinkingSpeedTitle]
            otherTitle.text = screenStrings[.settingsScreenOtherTitle]
            dotTextLabel.text = screenStrings[.settingsScreenDotSpeedTitle]
            dashTextLabel.text = screenStrings[.settingsScreenDashSpeedTitle]
            languageTextLabel.text = screenStrings[.settingsScreenLanguageTitle]
            languageIconLabel.text = screenStrings[.settingsScreenLanguageLabel]
            speedHintLabel.text = screenStrings[.settingsScreenBlinkingSpeedHint]
            UIView.performWithoutAnimation {
                aboutButton.setTitle(screenStrings[.settingsScreenAboutButton], for: .normal)
                aboutButton.layoutIfNeeded()
            }
        }
    }
    
    private let topTitle: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 238, green: 242, blue: 254)
        return titleLabel
    }()
    
    private let speedTitle: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 238, green: 242, blue: 254)
        return titleLabel
    }()
    
    private let otherTitle: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 238, green: 242, blue: 254)
        return titleLabel
    }()
    
    private let speedSection: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 20, green: 24, blue: 62)
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let otherSection: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 20, green: 24, blue: 62)
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let dotStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 20
        return sv
    }()
    
    private let dashStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 20
        return sv
    }()
    
    private let dotTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(red: 238, green: 242, blue: 254)
        return label
    }()
    
    private let dashTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(red: 238, green: 242, blue: 254)
        return label
    }()
    
    private let dotSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.2
        slider.maximumValue = 1
        slider.addTarget(self, action: #selector(dotSliderChanged), for: .valueChanged)
        return slider
    }()
    
    private let dotValueTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 238, green: 242, blue: 254)
        return label
    }()
    
    private let dashValueTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 238, green: 242, blue: 254)
        return label
    }()
    
    private let speedHintLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemGray
        return label
    }()
    
    private let languageStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    private let languageTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 238, green: 242, blue: 254)
        label.textAlignment = .left
        return label
    }()
    
    private let languageIconLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 238, green: 242, blue: 254)
        label.isUserInteractionEnabled = true
        label.textAlignment = .right
        return label
    }()
    
    private let aboutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        button.addTarget(self, action: #selector(aboutTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLanguageLabel))
        languageIconLabel.addGestureRecognizer(tap)
        
        view.backgroundColor = UIColor(red: 4, green: 7, blue: 46)
        
        topTitle.font = UIFont.boldSystemFont(ofSize: view.bounds.height/25)
        speedTitle.font = UIFont.boldSystemFont(ofSize: view.bounds.height/45)
        otherTitle.font = UIFont.boldSystemFont(ofSize: view.bounds.height/45)
        
        currentDotValue = dotSlider.value
        
        dotValueTextLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height/50)
        //Workaround to set fixed size
        dotValueTextLabel.widthAnchor.constraint(equalToConstant: view.bounds.width/10).isActive = true
        dotValueTextLabel.text = "\(currentDotValue)"
        
        dashValueTextLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.height/50)
        //Workaround to set fixed size
        dashValueTextLabel.widthAnchor.constraint(equalToConstant: view.bounds.width/10).isActive = true
        dashValueTextLabel.text = "\(currentDashValue)"
        
        dotTextLabel.font = UIFont.systemFont(ofSize: view.bounds.height/65)
        dashTextLabel.font = UIFont.systemFont(ofSize: view.bounds.height/65)
        
        speedHintLabel.font = UIFont.systemFont(ofSize: view.bounds.height/75)
        
        languageTextLabel.font = UIFont.systemFont(ofSize: view.bounds.height/50)
        languageIconLabel.font = UIFont.systemFont(ofSize: view.bounds.height/60)
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.viewDidAppear()
    }
    
    private func setupConstraints(){
        [topTitle, speedTitle, otherTitle, speedSection, otherSection].forEach { element in
            view.addSubview(element)
        }
        
        [dotStackView, dashStackView, speedHintLabel, dotTextLabel, dashTextLabel].forEach { element in
            speedSection.addSubview(element)
        }
        
        [dotSlider, dotValueTextLabel].forEach { element in
            dotStackView.addArrangedSubview(element)
        }
        
        [dashTextLabel, dashValueTextLabel].forEach { element in
            dashStackView.addArrangedSubview(element)
        }
        
        [languageStackView, aboutButton].forEach { element in
            otherSection.addSubview(element)
        }
        
        [languageTextLabel, languageIconLabel].forEach { element in
            languageStackView.addArrangedSubview(element)
        }
        
        let height = view.bounds.height
        
        topTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: height/25, paddingLeft: height/30, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        speedTitle.anchor(top: topTitle.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: height/15, paddingLeft: 60, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        speedSection.anchor(top: speedTitle.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: height/4, enableInsets: false)
        dotTextLabel.anchor(top: speedSection.topAnchor, left: speedSection.leadingAnchor, bottom: nil, right: speedSection.trailingAnchor, paddingTop: 15, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        dotStackView.anchor(top: dotTextLabel.bottomAnchor, left: speedSection.leadingAnchor, bottom: nil, right: speedSection.trailingAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 10, width: 0, height: height/15, enableInsets: false)
        dashStackView.anchor(top: dotStackView.bottomAnchor, left: speedSection.leadingAnchor, bottom: nil, right: speedSection.trailingAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 10, width: 0, height: height/15, enableInsets: false)
        speedHintLabel.anchor(top: nil, left: speedSection.leadingAnchor, bottom: speedSection.bottomAnchor, right: speedSection.trailingAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 15, paddingRight: 20, width: 0, height: 0, enableInsets: false)
        
        otherTitle.anchor(top: speedSection.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: height/15, paddingLeft: 60, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        otherSection.anchor(top: otherTitle.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: height/6, enableInsets: false)
        languageStackView.anchor(top: otherSection.topAnchor, left: otherSection.leadingAnchor, bottom: nil, right: otherSection.trailingAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 15, width: 0, height: height/12, enableInsets: false)
        aboutButton.anchor(top: nil, left: otherSection.leadingAnchor, bottom: otherSection.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: height/12, enableInsets: false)
    }
    
    @objc func dotSliderChanged(){
        currentDotValue = dotSlider.value
        currentDashValue = round(currentDotValue*10)/10 * 3
        presenter?.didRequestToSaveAllChanges(newSettings: Settings(dotSpeed: currentDotValue, dashSpeed: currentDashValue, language: currentLanguage))
    }
    
    @objc func didTapLanguageLabel() {
        if currentLanguage == .english {
            presenter?.didTapLanguageLabel(requestedLanguage: .russian)
            currentLanguage = .russian
            presenter?.didRequestToSaveAllChanges(newSettings: Settings(dotSpeed: currentDotValue, dashSpeed: currentDashValue, language: currentLanguage))
        } else {
            presenter?.didTapLanguageLabel(requestedLanguage: .english)
            currentLanguage = .english
            presenter?.didRequestToSaveAllChanges(newSettings: Settings(dotSpeed: currentDotValue, dashSpeed: currentDashValue, language: currentLanguage))
        }
    }
    
    @objc func aboutTapped() {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 250)
        messageView.configureContent(title: "🕯️", body: "Morse Light 1.0 \n\n Developer: Max Kuznetsov \n Telegram: @icerzack", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK") { button in
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
    }
    
}

extension SettingsViewController: LocalizationServiceObserver {
    func didUpdateCurrentLocalization(newLocalizationCollection: [AppStrings : String]) {
        screenStrings = newLocalizationCollection
    }
}

extension SettingsViewController: SettingsViewProtocol {
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
    func didSetupLanguage(result: Result<String, Error>) {
        switch result {
        case .success(let lang):
            print("Now current language is: ", lang)
        case .failure(let error):
            print("Error occured: ", error)
        }
    }
    
    //Get from Presenter
    func didReceiveSavedSettings(settings: Settings) {
        self.currentLanguage = settings.language
        self.currentDotValue = settings.dotSpeed
        self.currentDashValue = settings.dashSpeed
    }
    
}
