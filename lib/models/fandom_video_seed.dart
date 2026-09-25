import 'fandom_video.dart';
import 'fandom_video_service.dart';

class FandomVideoSeed {
  final FandomVideoService _videoService =
  FandomVideoService();

  Future<void> seedVideos() async {
    final videos = [
       FandomVideo(
        id: 'video_1',
        fandomId: 'anime',
        title: 'Anime Fandom Video',
        videoUrl: 'assets/video/onepieceVideo.mp4',
        thumbnail: 'assets/images/homeSearch/anime_01.jpg',
        category: 'Anime',
        uploadedAt: DateTime(2026, 9, 24),
      ),

       FandomVideo(
        id: 'video_1',
        fandomId: 'marvel',
        title: 'Marvel Fandom Video',
        videoUrl: 'assets/video/marvelVideo.mp4',
        thumbnail: 'assets/images/homeSearch/anime_06.jpg',
        category: 'Marvel',
        uploadedAt: DateTime(2026, 9, 24),
      ),

       FandomVideo(
        id: 'video_1',
        fandomId: 'gaming',
        title: 'Gaming Fandom Video',
        videoUrl: 'assets/video/autoVideo.mp4',
        thumbnail: 'assets/images/homeSearch/anime_09.jpg',
        category: 'Gaming',
        uploadedAt: DateTime(2026, 9, 24),
      ),

       FandomVideo(
        id: 'video_1',
        fandomId: 'movies',
        title: 'Movies Fandom Video',
        videoUrl: 'assets/video/actionMovie.mp4',
        thumbnail: 'assets/images/homeSearch/idolculture_02.jpg',
        category: 'Movies',
        uploadedAt: DateTime(2026, 9, 24),
      ),

       FandomVideo(
        id: 'video_1',
        fandomId: 'pop_culture',
        title: 'Pop Culture Video',
        videoUrl: 'assets/video/popVideo.mp4',
        thumbnail: 'assets/images/homeSearch/popCulture_01',
        category: 'Pop Culture',
        uploadedAt: DateTime(2026, 9, 24),
      ),

       FandomVideo(
        id: 'video_1',
        fandomId: 'tv_universes',
        title: 'TV Universes Video',
        videoUrl: 'assets/video/tvmovies.mp4',
        thumbnail: 'assets/images/homeSearch/tv_01.jpg',
        category: 'TV Universes',
        uploadedAt: DateTime(2026, 9, 24),
      ),

       FandomVideo(
        id: 'video_1',
        fandomId: 'comic_books',
        title: 'Comic Books Video',
        videoUrl: 'assets/video/comicVideo.mp4',
        thumbnail: 'assets/images/homeSearch/comic_01',
        category: 'Comic Books',
        uploadedAt: DateTime(2026, 9, 24),
      ),

       FandomVideo(
        id: 'video_1',
        fandomId: 'music',
        title: 'Music Fandom Video',
        videoUrl: 'assets/video/musicVideo.mp4',
        thumbnail: 'assets/images/homeSearch/music_01.jpg',
        category: 'Music',
        uploadedAt: DateTime(2026, 9, 24),
      ),

       FandomVideo(
        id: 'video_1',
        fandomId: 'idol_culture',
        title: 'Idol Culture Video',
        videoUrl: 'assets/video/idolCultureVideo.mp4',
        thumbnail: 'assets/images/homeSearch/idolculture_02.jpg',
        category: 'Idol Culture',
        uploadedAt: DateTime(2026, 9, 24),
      ),
    ];

    for (final video in videos) {
      await _videoService.addVideo(video);
    }
  }
}