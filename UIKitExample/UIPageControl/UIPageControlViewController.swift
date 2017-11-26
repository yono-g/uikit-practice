//
//  UIPageControlViewController.swift
//  UIKitExample
//
//  Created by yono on 2017/11/26.
//

import UIKit

class UIPageControlViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let imageSize = (width: CGFloat(300), height: CGFloat(300))
    let imageViews: [UIView] = []
    let imageNames = ["animal01", "animal02"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupPageControl()
    }
    
    private func setupScrollView() {
        imageNames.enumerated().forEach { offset, element in
            let animalImageView = createAnimalImageView(offset, element)
            scrollView.addSubview(animalImageView)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(imageNames.count) * view.frame.width, height: imageSize.height)
    }
    
    private func createAnimalImageView(_ index: Int, _ imageName: String) -> UIView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: imageSize.height))
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.center.x = view.frame.width / 2

        let x = CGFloat(index) * view.frame.width
        let animalImageView = UIView(frame: CGRect(x: x, y: 0, width: view.frame.width, height: imageSize.height))
        animalImageView.addSubview(imageView)

        return animalImageView
    }
    
    private func setupPageControl() {
        // ページ数
        pageControl.numberOfPages = imageNames.count
        // 初期ページ
        pageControl.currentPage = 0
        // タップされたときのイベントハンドラ
        pageControl.addTarget(self, action: #selector(UIPageControlViewController.pageControlTapped), for: .valueChanged)
    }
    
    @objc func pageControlTapped() {
        var frame = scrollView.frame
        frame.origin.x = CGFloat(Int(frame.size.width) * pageControl.currentPage)
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}

extension UIPageControlViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.zoomScale == 1 else { return }
        
        let pageWidth = scrollView.frame.size.width
        if fmod(scrollView.contentOffset.x, pageWidth) == 0 {
            pageControl.currentPage = Int(scrollView.contentOffset.x / pageWidth)
        }
    }
}
