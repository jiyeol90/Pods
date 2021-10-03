//
//  BorderOptions.swift
//  PlaySound
//
//  Created by james on 2021/09/02.
//

import UIKit

// - UIView를 상속하는 어떤 클래스에서도 사용할 수 있는
//   뷰의 상하좌우 어디에든 원하는대로 경계선을 (색상, 두께) 그릴수 있다.

// - OptionSet 프로토콜을 사용 (https://developer.apple.com/documentation/swift/optionset)

struct BorderOptions: OptionSet {
    
    let rawValue: Int
    
    static let top = BorderOptions(rawValue: 1 << 0)
    static let left = BorderOptions(rawValue: 1 << 1)
    static let bottom = BorderOptions(rawValue: 1 << 2)
    static let right = BorderOptions(rawValue: 1 << 3)
    
    static let horizontal: BorderOptions = [.left, .right]
    static let vertical: BorderOptions = [.top, .bottom]
}


extension UIView {
    
    func addBorder(
        toSide options: BorderOptions,
        color: UIColor,
        borderWidth width: CGFloat
    ) {
        // options에 .top이 포함되어있는지 확인
        if options.contains(.top) {
            // 이미 해당 사이드에 경계선이 있는지 확인하고, 있으면 제거
            if let exist = layer.sublayers?.first(where: { $0.name == "top" }) {
                exist.removeFromSuperlayer()
            }
            let border: CALayer = CALayer()
            border.borderColor = color.cgColor
            border.name = "top"
            // 현재 UIView의 frame 정보를 통해 경계선이 그려질 레이어의 영역을 지정
            border.frame = CGRect(
                x: 0, y: 0,
                width: frame.size.width, height: width)
            border.borderWidth = width
            // 현재 그려지고 있는 UIView의 layer의 sublayer중에 가장 앞으로 추가해줌
            let index = layer.sublayers?.count ?? 0
            layer.insertSublayer(border, at: UInt32(index))
        }
        
        if options.contains(.left) {
            // 이미 해당 사이드에 경계선이 있는지 확인하고, 있으면 제거
            if let exist = layer.sublayers?.first(where: { $0.name == "left" }) {
                exist.removeFromSuperlayer()
            }
            let border: CALayer = CALayer()
            border.borderColor = color.cgColor
            border.name = "left"
            // 현재 UIView의 frame 정보를 통해 경계선이 그려질 레이어의 영역을 지정
            border.frame = CGRect(
                x: 0, y: 0,
                width: width, height: frame.height)
            border.borderWidth = width
            // 현재 그려지고 있는 UIView의 layer의 sublayer중에 가장 앞으로 추가해줌
            let index = layer.sublayers?.count ?? 0
            layer.insertSublayer(border, at: UInt32(index))
        }
        
        if options.contains(.bottom) {
            // 이미 해당 사이드에 경계선이 있는지 확인하고, 있으면 제거
            if let exist = layer.sublayers?.first(where: { $0.name == "bottom" }) {
                exist.removeFromSuperlayer()
            }
            let border: CALayer = CALayer()
            border.borderColor = color.cgColor
            border.name = "bottom"
            // 현재 UIView의 frame 정보를 통해 경계선이 그려질 레이어의 영역을 지정
            border.frame = CGRect(
                x: 0, y: frame.height - width,
                width: frame.width, height: width)
            border.borderWidth = width
            // 현재 그려지고 있는 UIView의 layer의 sublayer중에 가장 앞으로 추가해줌
            let index = layer.sublayers?.count ?? 0
            layer.insertSublayer(border, at: UInt32(index))
        }
        
        if options.contains(.right) {
            // 이미 해당 사이드에 경계선이 있는지 확인하고, 있으면 제거
            if let exist = layer.sublayers?.first(where: { $0.name == "right" }) {
                exist.removeFromSuperlayer()
            }
            let border: CALayer = CALayer()
            border.borderColor = color.cgColor
            border.name = "right"
            // 현재 UIView의 frame 정보를 통해 경계선이 그려질 레이어의 영역을 지정
            border.frame = CGRect(
                x: frame.width - width, y: 0,
                width: width, height: frame.height)
            border.borderWidth = width
            // 현재 그려지고 있는 UIView의 layer의 sublayer중에 가장 앞으로 추가해줌
            let index = layer.sublayers?.count ?? 0
            layer.insertSublayer(border, at: UInt32(index))
        }
        
    }
}

extension UIView {
    
    func removeBorder(toSide options: BorderOptions) {
        if options.contains(.top),
           let border = layer.sublayers?.first(where: { $0.name == "top" }) {
            border.removeFromSuperlayer()
        }
        if options.contains(.left),
           let border = layer.sublayers?.first(where: { $0.name == "left" }) {
            border.removeFromSuperlayer()
        }
        if options.contains(.bottom),
           let border = layer.sublayers?.first(where: { $0.name == "bottom" }) {
            border.removeFromSuperlayer()
        }
        if options.contains(.right),
           let border = layer.sublayers?.first(where: { $0.name == "right" }) {
            border.removeFromSuperlayer()
        }
    }
    
}

