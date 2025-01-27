//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 15.11.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    private let image: Photo
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.contentMode = .scaleToFill
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var shareButton: UIButton = {
        let shareButton = UIButton.systemButton(
            with: UIImage(named: "sharing")?.withRenderingMode(.alwaysOriginal) ?? UIImage(),
            target: self,
            action: #selector(didTapShareButton)
        )
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        return shareButton
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "placeholderImageList")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(image: Photo) {
        self.image = image
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadImage()
    }
    
    @objc func didTapShareButton() {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
    
private extension SingleImageViewController {
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let backImage = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setupView() {
        view.backgroundColor = .ypBlack
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(shareButton)
        
        imageView.center = scrollView.center
        
        NSLayoutConstraint.activate([
            backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundImageView.widthAnchor.constraint(equalToConstant: 83),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 75),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
   func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func loadImage() {
        backgroundImageView.isHidden = false
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(
            with: image.largeImageURL,
            placeholder: nil
        ) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let image):
                self?.backgroundImageView.isHidden = true
                self?.rescaleAndCenterImageInScrollView(image: image.image)
            case .failure:
                print("[loadImage]: Failed to load image")
                self?.showErrorAlert(error: AlertMessages.unknownError)
            }
        }
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
