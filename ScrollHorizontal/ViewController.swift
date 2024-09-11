//
//  ViewController.swift
//  ScrollHorizontal
//
//  Created by Rubén Muñoz López on 10/9/24.
//

import UIKit
import AutolayoutDSL

final class ViewController: UIViewController {
    
    private lazy var leftButton: CustomTabView = {
        let button = CustomTabView(config: TabViewOption(title: "Left", icon: "arrowshape.left.circle", alpha: 1.0))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.delegate = self
        button.addGesture(.moveToRight)
        return button
    }()
    
    
    private lazy var rightButton: CustomTabView = {
        let button = CustomTabView(config: TabViewOption(title: "Right", icon: "arrowshape.right.circle", alpha: 0.0))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.delegate = self
        button.addGesture(.moveToLeft)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [homeView, detailView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var homeView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var detailView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "ScrollView Horizontal"
    }
}

private extension ViewController {
    func setupUI() {
        scrollView.addSubview(stackView)
        view.addSubviews(views: leftButton,
                         rightButton,
                         scrollView)
        setupContraints()
    }
    
    func setupContraints() {
        leftButton.layout {
            $0.top == view.safeAreaLayoutGuide.topAnchor
            $0.leading == view.leadingAnchor
            $0.height == 45.0
        }
       
        rightButton.layout {
            $0.centerY == leftButton.centerYAnchor
            $0.leading == leftButton.trailingAnchor
            $0.trailing == view.trailingAnchor
            $0.height == 45.0
            $0.width == view.widthAnchor * 0.5
        }
        
        scrollView.layout {
            $0.top == rightButton.bottomAnchor + 5.0
            $0 -|- (view)
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor
        }
        
        stackView.layout {
            $0.top == scrollView.topAnchor
            $0.leading == scrollView.leadingAnchor
            $0.trailing == scrollView.trailingAnchor
            $0.height == scrollView.heightAnchor
        }
        
        homeView.layout {
            $0.height == scrollView.heightAnchor
            $0.width == scrollView.widthAnchor
        }
        
        detailView.layout {
            $0.height == scrollView.heightAnchor
            $0.width == scrollView.widthAnchor
        }
    }
    
    func setupUnderlineView(transition: TabViewTransition) {
        switch transition {
        case .moveToLeft:
            leftButton.animateUnderlineView(alpha: 1, color: .orange)
            rightButton.animateUnderlineView(alpha:  0, color: .clear)
        case .moveToRight:
            rightButton.animateUnderlineView(alpha: 1, color: .green)
            leftButton.animateUnderlineView(alpha: 0, color: .clear)
        }
    }
}

extension ViewController: TabViewTransitionDelegate {
    func moveToRight() {
        if scrollView.contentOffset.x > 0 {
            setupUnderlineView(transition: .moveToRight)
            scrollView.contentOffset.x -= view.bounds.width
        }
    }
    
    func moveToLeft() {
        if scrollView.contentOffset.x < (scrollView.contentSize.width - view.frame.width) {
            setupUnderlineView(transition: .moveToLeft)
            scrollView.contentOffset.x += view.bounds.width
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageCount = scrollView.contentOffset.x / view.frame.width
        if pageCount > 0 {
            setupUnderlineView(transition: .moveToRight)
        } else {
            setupUnderlineView(transition: .moveToLeft)
        }
    }
}
