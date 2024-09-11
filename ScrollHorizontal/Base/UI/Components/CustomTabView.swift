//
//  CustomTabView.swift
//  ScrollHorizontal
//
//  Created by Rubén Muñoz López on 10/9/24.
//

import UIKit
import AutolayoutDSL

struct TabViewOption {
    let title: String
    let icon: String
    let alpha: CGFloat
}

enum TabViewTransition {
    case moveToLeft
    case moveToRight
}

protocol TabViewTransitionDelegate {
    func moveToRight()
    func moveToLeft()
}

final class CustomTabView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var config: TabViewOption
    var delegate: TabViewTransitionDelegate?
    
    init(config: TabViewOption) {
        self.config = config
        super.init(frame: .zero)
        setupUI()
        setupConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGesture(_ transition: TabViewTransition) {
        switch transition {
        case .moveToLeft:
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveToRight)))
        case .moveToRight:
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveToLeft)))
        }
    }
    
    func animateUnderlineView(alpha: CGFloat) {
        UIView.animate(withDuration: 0.2) { [self] in
            self.underlineView.alpha = alpha
        }
    }
}

private extension CustomTabView {
    func setupUI() {
        addSubviews(views: iconImage,
                    titleLabel,
                    underlineView)
        setupConstraints()
    }
    
    func setupConstraints() {
        iconImage.layout {
            $0.top == topAnchor
            $0.leading == leadingAnchor + 10.0
            ($0.width, $0.height) == (30.0 * 30.0)
        }
        
        titleLabel.layout {
            $0.centerY == iconImage.centerYAnchor
            $0.leading == iconImage.trailingAnchor + 10.0
        }
        
        underlineView.layout {
            $0.top == titleLabel.bottomAnchor + 5.0
            $0 -|- (self)
            $0.height == 3.0
            $0.bottom == bottomAnchor
        }
    }
    
    func setupConfig() {
        titleLabel.text = config.title
        iconImage.image = UIImage(systemName: config.icon)
        underlineView.alpha = config.alpha
    }
    
    @objc func moveToRight() {
        delegate?.moveToRight()
    }
    
    @objc func moveToLeft() {
        delegate?.moveToLeft()
    }
}
