//
//  ViewController.swift
//  Deloitte Challenge
//
//  Created by Lu Quoc Man on 11/23/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    //MARK: - IBOutlet declerations
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Private declerations
    private var movieListViewModel = MovieListViewModel()
    private let MARGIN:CGFloat = 30
    
    //MARK: - View Controllers declerations
    lazy var movieDetailViewController: MovieDetailViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: MovieDetailViewController.identifier) as! MovieDetailViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        return controller
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateForUI()
    }

    
}

//MARK: - UI Configuration
extension ViewController {
    func configurateForUI() {
        movieListViewModel.bind = {
            self.updateMovieList()
        }
        
        movieListViewModel.searchFor(keyword: "mafia")
        configureForCollection()
        configureForTextfield()
    }
    
    func configureForCollection(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: MovieListCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier
        )
        collectionView.register(
            UINib(nibName: EmptyCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: EmptyCollectionViewCell.identifier
        )
    }
    
    func configureForTextfield(){
        searchTextField.delegate = self
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string:  Messages().typeSomething ,
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)]
        )
    }
    
    func updateMovieList() {
        self.collectionView.reloadData()
    }
}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let keyword = text.replacingCharacters(in: textRange, with: string)
            movieListViewModel.searchFor(keyword: keyword)
        }
        
        return true
    }
}

//MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        return movieListViewModel.movieList?.count ?? 1
    }
    
    func collectionView(_
        collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if movieListViewModel.movieList == nil {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmptyCollectionViewCell.identifier,
                for: indexPath
            )  as! EmptyCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieListCollectionViewCell.identifier,
                for: indexPath
            )  as! MovieListCollectionViewCell
            
            if let data = movieListViewModel.movieList?[indexPath.row] {
                cell.setTitle(data.Title ?? "")
                if let poster = data.Poster, poster.contains("http") {
                    cell.setPoster(url: poster)
                    cell.layoutIfNeeded()
                }else{
                    cell.setBlank()
                }
            }
            
            return cell
        }
        
    }
    
    func collectionView(_
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if movieListViewModel.movieList == nil {
            return collectionView.frame.size
        } else {
            let width = (view.frame.width - MARGIN * 3) / 2
            return CGSize(width: width, height: width * 1.5)
        }
        
    }
    
    func collectionView(_
        collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath)
    {
        if let data = self.movieListViewModel.movieList?[indexPath.row] {
            presentMovieDetailViewController(data: data)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height - 200 {
            self.movieListViewModel.loadMore()
        }
    }
}

//MARK: - View Controller presentation
extension ViewController {
    func presentMovieDetailViewController(data:MovieListItemData) {
        movieDetailViewController.movieItemData = data
        self.present(movieDetailViewController, animated: true, completion: nil)
    }
}
