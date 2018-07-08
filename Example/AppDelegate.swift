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

final class App {
    var window: UIWindow
    var storyboard: UIStoryboard
    var navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window

        navigationController = window.rootViewController as! UINavigationController
        storyboard = UIStoryboard.init(name: "Main", bundle: nil)

        let episodesVC = navigationController.viewControllers[0] as! EpisodesViewController

        episodesVC.didSelect = showEpisode
        episodesVC.didTapProfile = showProfile
    }

    func showEpisode(_ episode: Episode) {
        let detailVC = self.storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        detailVC.episode = episode
        navigationController.pushViewController(detailVC, animated: true)
    }

    func showProfile() {
        let profileNC = self.storyboard.instantiateViewController(withIdentifier: "Profile") as! UINavigationController
        let profileVC = profileNC.viewControllers[0] as! ProfileViewController
        profileVC.didTapDone = {
            self.navigationController.dismiss(animated: true, completion: nil)
        }
        self.navigationController.present(profileNC, animated: true, completion: nil)
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var app: App?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        if let window = window {
            app = App.init(window: window)
        }

        return true
    }
}

