//
//  ToastManager.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 04/05/25.
//


import Foundation
import UIKit

class ToastManager: UIWindow {
    static let shared = ToastManager()

    private var timer: Timer?
    private let toastLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "LeagueSpartan-Regular", size: 18)
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()
    private let toastView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    private init() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene{
            super.init(windowScene: windowScene)
        } else {
            super.init(frame: UIScreen.main.bounds)
        }
        self.backgroundColor = .clear
        self.windowLevel = .normal
        self.isUserInteractionEnabled = false
        
        self.toastView.addSubview(toastLabel)
        self.toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.toastLabel.leadingAnchor.constraint(equalTo: self.toastView.leadingAnchor, constant: 8),
            self.toastLabel.trailingAnchor.constraint(equalTo: self.toastView.trailingAnchor, constant: -8),
            self.toastLabel.bottomAnchor.constraint(equalTo: self.toastView.bottomAnchor, constant: -16),
            self.toastLabel.topAnchor.constraint(equalTo: self.toastView.topAnchor, constant: 16)
        ])
        
        self.toastView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toastView)
        NSLayoutConstraint.activate([
            self.toastView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.toastView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.toastView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(ScreenDetails.bottomSafeArea - 2))
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showToast(message: String) {
        self.timer?.invalidate()
        self.toastView.alpha = 0
        self.makeKeyAndVisible()
        toastLabel.text = message
        
        self.toastView.transform = CGAffineTransform(translationX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.33, animations: {
            self.toastView.transform = .identity
            self.toastView.alpha = 1
        })
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
            self.resignKey()
            self.isHidden = true
        })
    }
}
