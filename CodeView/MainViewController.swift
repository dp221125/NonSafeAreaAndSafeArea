//
//  ViewController.swift
//  CodeView
//
//  Created by Seokho on 2019/11/28.
//  Copyright © 2019 Seokho. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var xLayout: NSLayoutConstraint? {
        didSet {
            guard let xLayout = xLayout else { return }
            xLayout.isActive = true
        }
    }
    private var yLayout: NSLayoutConstraint? {
        didSet {
            guard let yLayout = yLayout else { return }
            yLayout.isActive = true
        }
    }
    private var leftTableViewdataSource: UITableViewDiffableDataSource<Section, Layout>!
    private var rightTableViewdataSource: UITableViewDiffableDataSource<Section, Layout>!
    
    private weak var stackView: UIStackView?
    private weak var topView: UIView?
    private weak var bottomStackView: UIStackView?
    private weak var item: UIView?
    private weak var leftTableView: UITableView?
    private weak var rightTableView: UITableView?
    
    override func loadView() {
        //밑바탕이 되는 뷰
        let view = UIView()
        view.backgroundColor = .systemBackground
        self.view = view
        
        //베이스가 되는 스택뷰
        let baseStackView = UIStackView()
        self.stackView = baseStackView
        baseStackView.axis = .vertical
        baseStackView.distribution = .fillEqually
        view.addSubview(baseStackView)
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: view.topAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        //베이스가 되는 스택뷰의 상단 뷰
        let topView = UIView()
        self.topView = topView
        topView.backgroundColor = .systemPink
        baseStackView.addArrangedSubview(topView)
        
        //움직이는 아이템
        let item = UIView()
        item.backgroundColor = .systemOrange
        self.item = item
        topView.addSubview(item)
        
        self.yLayout = item.topAnchor.constraint(equalTo: topView.topAnchor)
        self.xLayout = item.leadingAnchor.constraint(equalTo: topView.leadingAnchor)
        item.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            item.widthAnchor.constraint(equalToConstant: 60),
            item.heightAnchor.constraint(equalToConstant: 60)
        ])
        item.layer.cornerRadius = 30
        
        //베이스가 되는 스택뷰의 하단 뷰
        let bottomView = UIStackView()
        self.bottomStackView = bottomView
        bottomView.axis = .horizontal
        bottomView.distribution = .fillEqually
        bottomView.backgroundColor = .systemBackground
        baseStackView.addArrangedSubview(bottomView)
        
        let xlayout = [Layout(id: 0, title: "CenterX"), Layout(id: 1, title: "leading"), Layout(id: 2, title: "trailing")]
        let ylayout =  [Layout(id: 3, title: "CenterY"), Layout(id: 4, title: "top"), Layout(id: 5, title: "Bottom")]
        
        let safeXLayout = [Layout(id: 0, title: "Safe CenterX"), Layout(id: 1, title: "Safe leading"), Layout(id: 2, title: "Safe trailing")]
        let safeYLayout = [Layout(id: 3, title: "Safe CenterY"), Layout(id: 4, title: "Safe top"), Layout(id: 5, title: "Safe Bottom")]
        
        let leftTableView = UITableView(frame: .zero, style: .insetGrouped)
        self.leftTableView = leftTableView
        leftTableView.backgroundColor = .systemBlue
        leftTableView.delegate = self
        leftTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        bottomView.addArrangedSubview(leftTableView)
        let leftDataSource = getDataSource(leftTableView)
        applytDataSource(xlayout,ylayout,leftDataSource)
        self.leftTableViewdataSource = leftDataSource
        
        
        let rightTableView = UITableView(frame: .zero, style: .insetGrouped)
        self.rightTableView = rightTableView
        rightTableView.backgroundColor = .systemBlue
        rightTableView.delegate = self
        rightTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        bottomView.addArrangedSubview(rightTableView)
        let rightDataSource = getDataSource(rightTableView)
        applytDataSource(safeXLayout, safeYLayout,rightDataSource)
        self.rightTableViewdataSource = rightDataSource
        
    }
    
    private func getDataSource(_ tableView: UITableView) -> UITableViewDiffableDataSource<Section, Layout> {
        return UITableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = item.title
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            return cell
        }
    }
    
    private func applytDataSource(_ xLayoutList: [Layout], _ yLayoutList: [Layout], _ dataSource: UITableViewDiffableDataSource<Section, Layout>) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Layout>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(xLayoutList, toSection: .x)
        snapshot.appendItems(yLayoutList, toSection: .y)
        dataSource.apply(snapshot,animatingDifferences: true)
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
            
            if interfaceOrientation.isPortrait {
                self.stackView?.axis = .horizontal
            } else {
                self.stackView?.axis = .vertical
            }
        }
    }
    
}

extension MainViewController {
    private func showConstantAlert(completion: @escaping  ((CGFloat) -> Void)) {
        let alert = UIAlertController(title: "Constant", message: "Input Constant", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let constant = alert.textFields?[0].text, let intConstant = Int(constant) {
                completion(CGFloat(intConstant))
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addTextField()
        self.present(alert, animated: true)
    }
}
extension MainViewController {
    private func setCenterX() {
        self.xLayout = item?.centerXAnchor.constraint(equalTo: topView!.centerXAnchor)
    }
    
    private func setSafeAreaCenterX() {
        self.xLayout = item?.centerXAnchor.constraint(equalTo: topView!.safeAreaLayoutGuide.centerXAnchor)
    }
    
    private func setCenterY() {
        self.yLayout = item?.centerYAnchor.constraint(equalTo: topView!.centerYAnchor)
    }
    
    private func setSafeAreaCenterY() {
        self.yLayout = item?.centerYAnchor.constraint(equalTo: topView!.safeAreaLayoutGuide.centerYAnchor)
    }
    
    private func setleading() {
        self.showConstantAlert { constant in
            self.xLayout = self.item?.leadingAnchor.constraint(equalTo: self.topView!.leadingAnchor,constant: constant)
        }
    }
    
    private func setSafeArealeading() {
        self.showConstantAlert { constant in
            self.xLayout = self.item?.leadingAnchor.constraint(equalTo: self.topView!.safeAreaLayoutGuide.leadingAnchor,constant: constant)
        }
    }
    
    private func settrailingAnchor() {
        self.showConstantAlert { constant in
            self.xLayout = self.item?.trailingAnchor.constraint(equalTo: self.topView!.trailingAnchor,constant: constant)
        }
    }
    
    private func setSafeAreatrailingAnchor() {
        self.showConstantAlert { constant in
            self.xLayout = self.item?.trailingAnchor.constraint(equalTo: self.topView!.safeAreaLayoutGuide.trailingAnchor,constant: constant)
        }
    }
    
    private func setTopAnchor() {
        self.showConstantAlert { constant in
            self.yLayout = self.item?.topAnchor.constraint(equalTo: self.topView!.topAnchor,constant: constant)
        }
    }
    
    private func setSafeAreatopAnchor() {
        self.showConstantAlert { constant in
            self.yLayout = self.item?.topAnchor.constraint(equalTo: self.topView!.safeAreaLayoutGuide.topAnchor,constant: constant)
        }
    }
    
    private func setBottomAnchor() {
        self.showConstantAlert { constant in
            self.yLayout = self.item?.bottomAnchor.constraint(equalTo: self.topView!.bottomAnchor,constant: constant)
        }
    }
    
    private func setSafeAreaBottomAnchor() {
        self.showConstantAlert { constant in
            self.yLayout = self.item?.bottomAnchor.constraint(equalTo: self.topView!.safeAreaLayoutGuide.bottomAnchor,constant: constant)
        }
    }
}
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            self.xLayout?.isActive = false
            if tableView == self.leftTableView {
                switch  indexPath.row {
                case 0:
                    setCenterX()
                case 1:
                    setleading()
                case 2:
                    settrailingAnchor()
                default:
                    break
                }
            } else {
                switch indexPath.row {
                case 0:
                    setSafeAreaCenterX()
                case 1:
                    setSafeArealeading()
                case 2:
                    setSafeAreatrailingAnchor()
                default:
                    break
                }
            }
        } else {
            self.yLayout?.isActive = false
            if tableView == self.leftTableView {
                switch  indexPath.row {
                case 0:
                    setCenterY()
                case 1:
                    setTopAnchor()
                case 2:
                    setBottomAnchor()
                default:
                    break
                }
            } else {
                switch indexPath.row {
                case 0:
                    setSafeAreaCenterY()
                case 1:
                    setSafeAreatopAnchor()
                case 2:
                    setSafeAreaBottomAnchor()
                default:
                    break
                }
            }
        }
    }
    
}
