abstract class PlayListRepository {
  Future<List<Map<String, String>>> fetchMyPlayList();
}

class MyPlayList extends PlayListRepository {
  @override
  Future<List<Map<String, String>>> fetchMyPlayList() async {
    const song1 =
        'https://dl.rozmusic.com/Music/1402/07/05/Asef%20Aria%20-%20Dastat.mp3';
    const song2 =
        'https://dl.rozmusic.com/Music/1402/07/05/Reza%20Bahram%20-%20Mane%20Divaneh.mp3';
    const song3 =
        'https://dl.rozmusic.com/Music/1402/06/11/Erfan%20Tahmasbi%20-%20To.mp3';
    const song4 =
        'https://dl.rozmusic.com/Music/1402/06/30/Pooriya%20Ariyan%20-%20Labkhand.mp3';
    const song5 =
        'https://dls.music-fa.com/tagdl/99/Behnam%20Bani%20-%20KhoshHalam%20(320).mp3';
    return [
      {
        'id': '0',
        'title': 'Dastat',
        'artist': 'Asef Aria',
        'artUri': 'https://www.ganja2music.com/wp-content/themes/Ganja2music-V4/js/timthumb.php?src=/Image/Post/9.2023/Asef%20Aria%20-%20Dastat.jpg&h=450&w=450&zc=0',
        'url': song1,
      },
      {
        'id': '1',
        'title': 'Mane Divaneh',
        'artist': 'Reza Bahram',
        'artUri': 'https://www.ganja2music.com/wp-content/themes/Ganja2music-V4/js/timthumb.php?src=/Image/Post/9.2023/Reza%20Bahram%20-%20Mane%20Divaneh.jpg&h=450&w=450&zc=0',
        'url': song2,
      },
      {
        'id': '2',
        'title': 'Del Az Man Delbari Az To',
        'artist': 'Erfan Tahmasbi',
        'artUri': 'https://rozmusic.com/wp-content/uploads/2023/03/Erfan-Tahmasbi-Del.jpg',
        'url': song3,
      },
      {
        'id': '3',
        'title': 'Labkhand',
        'artist': 'Pooriya Ariyan',
        'artUri': 'https://www.ganja2music.com/wp-content/themes/Ganja2music-V4/js/timthumb.php?src=/Image/Post/9.2023/Pooriya%20Ariyan%20-%20Labkhand.jpg&h=450&w=450&zc=0',
        'url': song4,
      },
      {
        'id': '4',
        'title': 'Khoshhalam',
        'artist': 'Behnam Bani',
        'artUri': 'https://www.ganja2music.com/wp-content/themes/Ganja2music-V4/js/timthumb.php?src=/Image/Post/10.2020/Behnam%20Bani%20-%20Khoshhalam.jpg&h=450&w=450&zc=0',
        'url': song5,
      },
    ];
  }
}
