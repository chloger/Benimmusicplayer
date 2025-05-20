//
//  ViewController.swift
//  Benimmusicplayer
//
//  Created by Alperen yıldız on 4.05.2025.
//

import UIKit
struct Song : Codable {
    let name : String
    let albumname : String
    let artistname : String
    let imagename : String
    let trackname : String
} 
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MüzikEkleViewControllerDelegate {

    @IBOutlet var table : UITableView!
    var songs = [Song]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSongs()
        table.delegate = self
        table.dataSource = self
    }
    
    func configureSongs() {
        if songs.isEmpty {
            
        }
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
    tableView.deselectRow(at: indexPath, animated: true)
    
    let position = indexPath.row
    guard let vc =   storyboard?.instantiateViewController(withIdentifier: "player") as? PlayerViewController
    else{ return}
    vc.songs = songs
    vc.position = position
    present (vc, animated: true )
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMuzikEkle" {
            if let destinationVC = segue.destination as? MüzikEkleViewController {
                destinationVC.delegate = self
            }
        }
    }
    func didSelectSong(_ song: Song) {
        songs.append(song)
                saveSongs()    // Her eklemede kaydet
                table.reloadData()
    }
    func saveSongs() {
        if let data = try? JSONEncoder().encode(songs) {
            UserDefaults.standard.set(data, forKey: "songs")
        }
    }
    func loadSongs() {
        if let data = UserDefaults.standard.data(forKey: "songs"),
           let savedSongs = try? JSONDecoder().decode([Song].self, from: data) {
            songs = savedSongs
        } else {
            configureSongs() // ilk açılış için default şarkılar
        }
        table.reloadData() // mutlaka çağır, yüklemeden sonra UI güncellenir
    }


    // Silme işlemini aktif etmek için:
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Silme işlemi yapıldığında çağrılır
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleting song:", songs[indexPath.row].name)
            songs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveSongs()
            table.reloadData()// kalıcı olarak kaydet
        }
    }
    

    
    
    


    
    
}

