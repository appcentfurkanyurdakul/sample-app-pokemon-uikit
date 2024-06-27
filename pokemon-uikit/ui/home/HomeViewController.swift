//
//  HomeViewController.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 24.06.2024.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController: BaseViewController {
    
    private let viewModel = HomeViewModel()
    private let numOfColumnsInCollection = 3
    
    private lazy var pokemonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.dataSource = self
        v.delegate = self
        v.backgroundColor = .none
        v.showsVerticalScrollIndicator = true
        v.showsHorizontalScrollIndicator = false
        v.isScrollEnabled = true
        v.alwaysBounceVertical = true
        v.isUserInteractionEnabled = true
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pokemons"
        self.setupViews()
        self.setupConstraints()
        self.observeData()
    }
    
    private func setupViews() {
        self.view.addSubview(pokemonCollectionView)
        self.view.addSubview(loadingIndicator)
        
        self.pokemonCollectionView.register(
            HomePokemonViewCell.self,
            forCellWithReuseIdentifier: HomePokemonViewCell.identifier
        )
    }
    
    private func setupConstraints() {
        self.loadingIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        self.pokemonCollectionView.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.loadingIndicator.snp.top).offset(-3)
        }
    }
    
    private func observeData() {
        viewModel.apiResult.observe(self) { [weak self] result in
            guard let self = self else { return }
            result.onSuccess { data in
                self.loadingIndicator.isHidden = true
                self.pokemonCollectionView.reloadData()
            }.onError { apiError, message in
                self.loadingIndicator.isHidden = true
                self.showAlertMessage(message: message) { [weak self] in
                    self?.viewModel.requestMore()
                }
            }.onLoading {
                self.loadingIndicator.isHidden = false
                self.loadingIndicator.startAnimating()
            }
        }
        viewModel.requestMore()
    }
    
    private func openDetailScreen(data: PokemonHomePageItem) {
        self.navigationController?.pushViewController(
            DetailViewController(
                viewModel: DetailViewModel(
                    pokemonName: data.name,
                    detailUrl: data.url
                )
            ), 
            animated: true
        )
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = pokemonCollectionView.dequeueReusableCell(withReuseIdentifier: HomePokemonViewCell.identifier, for: indexPath) as! HomePokemonViewCell
        cell.setData(data: viewModel.items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width) / CGFloat(numOfColumnsInCollection)
        return CGSize(width: cellWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openDetailScreen(data: viewModel.items[indexPath.row])
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.row == self.viewModel.items.count - 1 {
            self.viewModel.requestMore()
        }
    }
}
