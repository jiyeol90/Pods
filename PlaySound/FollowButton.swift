//
//  FollowButton.swift
//  PlaySound
//
//  Created by james on 2021/09/29.
//

import UIKit

@IBDesignable
class FollowButton: UIButton {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    // MARK: - Properties
    @IBInspectable var checked: Bool = false {
        didSet {
            // Toggle the check/uncheck images
            updateStatus()
        }
    }
    
    @IBInspectable var cornerRadiusValue: CGFloat = 10.0 {
        didSet {
            setUpView()
        }
    }
    
    //prepareForInterfaceBuilder() is called within the Storyboard editor itself for rendering @IBDesignable controls
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        setUpView()
    }
    
    func setUpView() {
        self.layer.cornerRadius = self.cornerRadiusValue
        self.clipsToBounds = true
    }
    
    //init(frame:) is for programmatically created buttons
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setUpView()
    }
    
    //init?(coder:) is for Storyboard/.xib created buttons
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setUpView()
    }
    
    private func setup() {
        updateStatus()
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    private func updateStatus() {
        let status = checked ? "Following" : "Follow"
        
        if checked {
            self.setBackgroundColor(.orange, for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.setTitle(status, for: .normal)
            
        } else {
            
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.orange.cgColor
            self.setBackgroundColor(.white, for: .normal)
            self.setTitleColor(.orange, for: .normal)
            self.setTitle(status, for: .normal)
            
        }
        
    }
    
    /// Called each time the button is tapped, and toggles the checked property
    @objc private func tapped() {
        checked = !checked
        print("New value: \(checked)")
    }
}

extension FollowButton {
    
    //- 출처 : https://jmkim0213.github.io/ios/swift/ui/2019/02/05/button_background.html
    //UIButton은 backgroundColor를 상태에 맞게 지정하는 방법을 지원하지 않는다.
    //ImageContext를 생성하여 색으로 채운 뒤 이미지를 생성한다.
    //그리고 생성된 이미지를 setBackgroundImage함수를 이용해 각 상태별로 지정한다.
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
