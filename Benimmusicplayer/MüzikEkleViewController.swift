//
//  MüzikEkleViewController.swift
//  Benimmusicplayer
//
//  Created by Alperen yıldız on 4.05.2025.
//

import UIKit

protocol MüzikEkleViewControllerDelegate: AnyObject {
    func didSelectSong(_ song: Song)
}



class MüzikEkleViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var table: UITableView!

    var songs = [Song]()
    weak var delegate: MüzikEkleViewControllerDelegate?
    
    override func viewDidLoad() {
        configureSongs()
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    func configureSongs() {
        songs.append(Song(name: "Cheap Smeels", albumname: "Eylülün Sevdikleri", artistname: "Kovacs", imagename:"Cover1" ,trackname:"song1"))
        songs.append(Song(name: "Put Your Hands On My Shoulder", albumname: "Eylülün Sevdikleri", artistname: "Paul Anka", imagename:"Cover2" ,trackname:"song2"))
        songs.append(Song(name: "Son Damla", albumname: "Eylülün Sevdikleri", artistname: "Selin & ‪sertaberener‬", imagename:"Cover3" ,trackname:"song3"))
        songs.append(Song(name: "I Think They Call This Love", albumname: "Eylülün Sevdikleri", artistname: "Elliot James Reay", imagename:"Cover4" ,trackname:"song4"))
        songs.append( Song(name: "Wicked Game", albumname: "Alperen'in Sevdikleri", artistname: "Chris İsaak", imagename:"Cover5" ,trackname:"song5"))
        
        }

   
   
            
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return songs.count
    
    }
    
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
    cell.textLabel?.text = song.name
    cell.detailTextLabel?.text = song.albumname
    cell.accessoryType = .disclosureIndicator
    cell.imageView?.image = UIImage(named: song.imagename)
    cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18 )
    cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17 )

    return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedSong = songs[indexPath.row]
            delegate?.didSelectSong(selectedSong) // ViewController’a gönder
        navigationController?.popViewController(animated: true)
    }
    
    
    
    


    
    
}


