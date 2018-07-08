//
//  AppDelegate.swift
//  Example
//
//  Created by Chris Eidhof on 17/05/16.
//  Copyright © 2016 objc.io. All rights reserved.
//

import UIKit


struct Episode {
    var title: String
}


class ProfileViewController: UIViewController {
    var person: String = ""
    var didTapDone: () -> () = {}
    @IBAction func didTapDone(_ sender: UIBarButtonItem) {
        didTapDone()
    }
}


class EpisodesViewController: UITableViewController {
    let episodes = [Episode(title: "Episode One"), Episode(title: "Episode Two"), Episode(title: "Episode Three")]
    var didSelect: (Episode) -> () = { _ in }
    var didTapProfile: () -> () = {}

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        didSelect(episode)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = episode.title
        return cell
    }
    @IBAction func didTapProfile(_ sender: UIBarButtonItem) {
        didTapProfile()
    }
}


class DetailViewController: UIViewController {
    @IBOutlet weak var label: UILabel? {
        didSet {
            label?.text = episode?.title
        }
    }
    var episode: Episode?
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let navigationController = window?.rootViewController as! UINavigationController
        let episodesVC = navigationController.viewControllers[0] as! EpisodesViewController
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

        episodesVC.didSelect = { episode in
            let detailVC = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
            detailVC.episode = episode
            navigationController.pushViewController(detailVC, animated: true)
        }
        episodesVC.didTapProfile = {
            let profileNC = storyboard.instantiateViewController(withIdentifier: "Profile") as! UINavigationController
            let profileVC = profileNC.viewControllers[0] as! ProfileViewController
            profileVC.didTapDone = {
                navigationController.dismiss(animated: true, completion: nil)
            }
            navigationController.present(profileNC, animated: true, completion: nil)
        }

        return true
    }
}

