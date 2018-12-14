//
//  ViewController.swift
//  BoxOffice
//
//  Created by Hyeontae on 06/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let cellIdentifier: String = "movieTableCell"
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var networkErrorAlert: UIAlertController = UIAlertController()
    var sortingAlert: UIAlertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.mainNetworkError(_:)), name: moviesDataRequestError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveData(_:)), name: didReceiveDataNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.orderingData(_:)), name: changeDataOrderNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData(_:)), name: updateDataNotification, object: nil)
        loadingIndicator.startAnimating()
        
        networkErrorAlert = UIAlertController(title: "네트워크 에러", message: "네트워크를 확인하신 뒤 다시 시도해주세요", preferredStyle: .alert)
        networkErrorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.navigationItem.title = "예매율순"
        sortingAlert = UIAlertController(title: "정렬방식", message: "영화를 어떤 방식으로 정렬할까요?", preferredStyle: .actionSheet)
        let sortingByReservation = UIAlertAction(title: "예매율", style: .default, handler: { _ in
            self.loadingIndicator.startAnimating()
            SingletonData.sharedInstance.orderingData(1)
        })
        let sortingByCuration = UIAlertAction(title: "큐레이션", style: .default, handler: { _ in
            self.loadingIndicator.startAnimating()
            SingletonData.sharedInstance.orderingData(2)
        })
        let sortingByDate = UIAlertAction(title: "개봉일", style: .default, handler: { _ in
            self.loadingIndicator.startAnimating()
            SingletonData.sharedInstance.orderingData(3)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        sortingAlert.addAction(sortingByReservation)
        sortingAlert.addAction(sortingByCuration)
        sortingAlert.addAction(sortingByDate)
        sortingAlert.addAction(cancelAction)
        
        refreshControl.addTarget(self, action: #selector(refreshHandler(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    @objc func mainNetworkError(_ noti: Notification) {
        present(networkErrorAlert,animated: true)
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc func didReceiveData(_ noti: Notification) {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    @objc func orderingData(_ noti: Notification){
        DispatchQueue.main.async {
            guard let newTitle: String = noti.userInfo?["navigationBarTitle"] as? String else { return }
            self.navigationItem.title = newTitle
            self.loadingIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    @objc func refreshHandler(_ refreshControl: UIRefreshControl) {
        SingletonData.sharedInstance.requestData(initRequest: false)
    }
    @objc func updateData(_ noti: Notification){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func showSortingAlertSheet(_ sender: UIBarButtonItem) {
        present(sortingAlert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailView: DetailViewController = segue.destination as? DetailViewController else { return }
        guard let cell = sender as? MovieDatasCell else { return }
        detailView.movieId = cell.movieId.text!
    }

}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieDatasCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieDatasCell else { return UITableViewCell() }
        
        let movieData: MovieData = SingletonData.sharedInstance.movieDatas[indexPath.row].basic
        let movieImagedata: Data = SingletonData.sharedInstance.movieDatas[indexPath.row].imageData
        cell.movieTitle.text = movieData.title
        var ageLabelColor: UIColor
        switch movieData.grade {
        case 0:
            // 35FF4E
            ageLabelColor = UIColor.init(red: 0x78, green: 0xB3, blue: 0x7E, alpha: 1.0)
        case 12:
            // 50A8F0
            ageLabelColor = UIColor.init(red: 0x50, green: 0xA8, blue: 0xF0, alpha: 1.0)
        case 15:
            // EF9532
            ageLabelColor = UIColor.init(red: 0xEF, green: 0x95, blue: 0x32, alpha: 1.0)
        case 19:
            // E53D44
            ageLabelColor = UIColor.init(red: 0xE5, green: 0x3D, blue: 0x44, alpha: 1.0)
        default:
            ageLabelColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        cell.movieAge.text = movieData.grade == 0 ? "전체" : String(movieData.grade)
        cell.movieAge.backgroundColor = ageLabelColor
        cell.movieAge.layer.masksToBounds = true
        cell.movieAge.layer.cornerRadius = 15.0
        cell.movieAge.textColor = UIColor.white
//        cell.MAge.highlightedTextColor = UIColor.white
        // highlighted 된거 물어보기
        cell.movieInfo.text = movieData.infoString
        cell.movieDate.text = movieData.openingString
        cell.movieImage.image = nil
        cell.movieId.text = movieData.id
        
        
        DispatchQueue.main.async {
            if let index: IndexPath = tableView.indexPath(for: cell) {
                if index.row == indexPath.row {
                    cell.movieImage.image = UIImage.init(data: movieImagedata)
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SingletonData.sharedInstance.movieDatas.count
    }
    
}

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
