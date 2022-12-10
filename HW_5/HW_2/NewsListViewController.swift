//
//  NewsViewController.swift
//  HW_2
//
//  Created by Lebedev A on 09.12.2022.
//

import UIKit
final class NewsListViewController: UIViewController {
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var isLoading = false
    private var newsViewModels = [NewsViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNews()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        configureTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(fetchNews))
    }
    private func configureTableView() {
        setTableViewUI()
        setTableViewDelegate()
        setTableViewCell()
    }
    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func setTableViewUI() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 120
        tableView.pinLeft(to: view)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view)
    }
    private func setTableViewCell() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    }
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func fetchNews() {
        ApiService.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.newsViewModels = articles.articles.compactMap{
                    NewsViewModel(
                        title: $0.title ?? "",
                        description: $0.description ?? "No description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                }
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
     }
}
extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {

        } else {
            return newsViewModels.count
        }
        return 0;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if isLoading {

        } else {
            let viewModel = newsViewModels[indexPath.row]
            if let newsCell = tableView.dequeueReusableCell(withIdentifier:NewsCell.reuseIdentifier, for: indexPath)
                as? NewsCell {
                newsCell.configure(with: viewModel)
                return newsCell
            }
        }
        return UITableViewCell()
    }
}
extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = NewsViewController()
            newsVC.configure(with: newsViewModels[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}



