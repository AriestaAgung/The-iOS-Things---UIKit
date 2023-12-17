//
//  BulletIndicatorView.swift
//  The iOS Things
//
//  Created by Ariesta APP on 10/12/23.
//

import UIKit

class BulletIndicatorView: UIView {
 
    private var totalCapsule: Int = 0
    private var capsuleSize: CGSize = CGSize(width: 8, height: 8)
    var capsules: [CapsuleView] = []
    var currentActiveCapsule = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    convenience init(frame: CGRect, totalCapsule: Int) {
        self.init(frame: frame)
        self.totalCapsule = totalCapsule
        commonInit()
    }
    
    private func commonInit() {
        let baseView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: capsuleSize.width * CGFloat(totalCapsule), height: capsuleSize.height)))
        for index in 1...totalCapsule {
            let capsule = CapsuleView(frame: CGRect(origin: .zero, size: capsuleSize))
            capsule.frame.size = capsuleSize
            capsule.tag = index-1
            capsules.append(capsule)
        }
        let capsuleStack = UIStackView(arrangedSubviews: capsules)
        capsuleStack.axis = .horizontal
        capsuleStack.spacing = 4.0
        capsuleStack.distribution = .fillEqually
        baseView.addSubview(capsuleStack)
        self.addSubview(baseView)
        capsuleStack.translatesAutoresizingMaskIntoConstraints = false
        baseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: self.topAnchor),
            baseView.leftAnchor.constraint(equalTo: self.leftAnchor),
            baseView.rightAnchor.constraint(equalTo: self.rightAnchor),
            baseView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            capsuleStack.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 0),
            capsuleStack.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0),
            capsuleStack.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 0),
            capsuleStack.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: 0)
        ])
    }
    
    func setActiveCapsule(index: Int) {
        currentActiveCapsule = -1
        for capsuleIndex in capsules.indices where capsuleIndex != index{
            capsules[capsuleIndex].isActive = false
        }
        capsules[index].isActive = true
        currentActiveCapsule = index
    }
}


class CapsuleView: UIView {
    var base: UIView!
    var isActive: Bool = false {
        didSet {
            if isActive {
                base.backgroundColor = .gray
            } else {
                base.backgroundColor = .lightGray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        base = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 16, height: 4)))
        self.addSubview(base)
        base.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            base.topAnchor.constraint(equalTo: self.topAnchor),
            base.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            base.leftAnchor.constraint(equalTo: self.leftAnchor),
            base.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        if isActive {
            base.backgroundColor = .gray
        } else {
            base.backgroundColor = .lightGray
        }
        base.layer.cornerRadius = base.frame.height / 2
    }
    
    
}
