//
//  DetailViewController.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 25.06.2024.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class DetailViewController: BaseViewController, UIScrollViewDelegate {
    
    private let viewModel: DetailViewModel
    
    private let pokemonImage1: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.tintColor = .none
        v.setContentHuggingPriority(.required, for: .horizontal)
        v.setContentCompressionResistancePriority(.required, for: .horizontal)
        v.setContentHuggingPriority(.required, for: .vertical)
        v.setContentCompressionResistancePriority(.required, for: .vertical)
        return v
    }()
    
    private let pokemonImage2: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.tintColor = .none
        v.setContentHuggingPriority(.required, for: .horizontal)
        v.setContentCompressionResistancePriority(.required, for: .horizontal)
        v.setContentHuggingPriority(.required, for: .vertical)
        v.setContentCompressionResistancePriority(.required, for: .vertical)
        return v
    }()
    
    private let pokemonImageContainer: UIView = {
        let v = UIView()
        return v
    }()
    
    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.showsHorizontalScrollIndicator = true
        v.isScrollEnabled = true
        return v
    }()
    
    private let pokemonInfoContainer: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .equalSpacing
        v.spacing = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .medium)
        v.color = .black
        v.alpha = 1
        v.hidesWhenStopped = true
        v.isHidden = true
        return v
    }()
        
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.pokemonName.capitalizingFirstLetter()
        self.setupViews()
        self.setupConstraints()
        self.observeData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateScrollView()
    }
    
    private func setupViews() {
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.loadingIndicator)
        
        self.scrollView.addSubview(self.pokemonInfoContainer)
        
        self.pokemonInfoContainer.addArrangedSubview(self.pokemonImageContainer)
        self.pokemonInfoContainer.setCustomSpacing(16, after: self.pokemonImageContainer)
        
        self.pokemonImageContainer.addSubview(self.pokemonImage1)
        self.pokemonImageContainer.addSubview(self.pokemonImage2)
    }
    
    private func setupConstraints() {
        self.loadingIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        self.scrollView.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        self.pokemonInfoContainer.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.pokemonImage1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(self.pokemonInfoContainer.snp.width).multipliedBy(0.4).offset(-24)
            make.top.bottom.equalToSuperview()
        }
        self.pokemonImage2.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.width.equalTo(self.pokemonInfoContainer.snp.width).multipliedBy(0.4).offset(-24)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func observeData() {
        viewModel.$apiResult.observe(self) { [weak self] result in
            guard let self = self else { return }
            result.onLoading {
                self.loadingIndicator.isHidden = false
            }.onSuccess { data in
                self.loadingIndicator.isHidden = true
                self.processData(data: data)
            }.onError { apiError, message in
                self.loadingIndicator.isHidden = true
                self.showAlertMessage(message: message) { [weak self] in
                    self?.viewModel.requestData()
                }
            }
        }
    }
    
    private func processData(data: PokemonDetailUiItem) {
        // remove previously added subviews if any, keep first view
        while (self.pokemonInfoContainer.subviews.count > 1) {
            self.pokemonInfoContainer.subviews[1].removeFromSuperview()
        }
        
        // set images
        if data.backImage != nil {
            pokemonImage1.kf.setImage(with: URL(string: data.backImage!))
        }
        if data.frontImage != nil {
            pokemonImage2.kf.setImage(with: URL(string: data.frontImage!))
        }
        
        // set texts
        data.texts.forEach { textItem in
            switch textItem.type {
            case .bigHeader:
                self.pokemonInfoContainer.addArrangedSubview(createBigHeader(text: textItem.text))
                break
            case .header:
                self.pokemonInfoContainer.addArrangedSubview(createHeader(text: textItem.text))
                break
            case .label:
                self.pokemonInfoContainer.addArrangedSubview(createSmallLabel(text: textItem.text))
                break
            }
        }
        updateScrollView()
    }
    
    private func updateScrollView() {
        self.pokemonInfoContainer.setNeedsLayout()
        self.pokemonInfoContainer.layoutIfNeeded()
        let w = self.pokemonInfoContainer.frame.width
        let h = self.pokemonInfoContainer.frame.height
        self.scrollView.contentSize = CGSize(
            width: w,
            height: h
        )
    }
    
    private func createBigHeader(text: String) -> UILabel {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 22)
        l.textColor = .black
        l.textAlignment = .center
        l.adjustsFontSizeToFitWidth = true
        l.text = text
        return l
    }
    
    private func createHeader(text: String) -> UILabel {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 16)
        l.textColor = .black
        l.textAlignment = .center
        l.adjustsFontSizeToFitWidth = true
        l.text = text
        return l
    }
    
    private func createSmallLabel(text: String) -> UILabel {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .darkGray
        l.textAlignment = .center
        l.adjustsFontSizeToFitWidth = true
        l.text = text
        return l
    }
}
