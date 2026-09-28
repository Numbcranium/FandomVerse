import '../features/home/presentation/widgets/fandom_news.dart';
import 'fandom-news-service.dart';

class FandomNewsSeed {
  final FandomNewsService _newsService =
  FandomNewsService();

  Future<void> seedNews() async {
    final news = [
      // =========================
      // ANIME NEWS
      // =========================

      FandomNews(
        id: 'anime_news_001',
        fandomId: 'anime',
        title: 'One Piece Continues Its Epic Journey',
        description:
        'The world of One Piece continues to grow with new adventures, characters and unforgettable moments.',
        content:
        'One Piece continues to deliver exciting moments to fans around the world. '
            'The story continues to explore new adventures, powerful characters and '
            'mysteries that have kept fans engaged for years.',
        image:
        'assets/images/homeSearch/luffy-the-one-piece.jpg',
        category: 'Anime',
        publishedAt: DateTime(2026, 9, 24),
      ),

      FandomNews(
        id: 'anime_news_002',
        fandomId: 'anime',
        title: 'New Anime Adventures Excite Fans',
        description:
        'Fans are getting excited about the latest anime releases and upcoming stories.',
        content:
        'Anime fans have plenty to look forward to as new series and continuing '
            'stories bring fresh characters, battles and adventures to the screen.',
        image: 'assets/images/homeImages/naru.jpg',
        category: 'Anime',
        publishedAt: DateTime(2026, 9, 22),
      ),

      // =========================
      // MARVEL NEWS
      // =========================

      FandomNews(
        id: 'marvel_news_001',
        fandomId: 'marvel',
        title: 'Marvel Universe Continues to Expand',
        description:
        'New Marvel stories continue to expand the universe with heroes and villains.',
        content:
        'The Marvel Universe continues to introduce new stories and explore '
            'different characters. Fans continue to discuss upcoming projects, '
            'characters and the future of the cinematic universe.',
        image: 'assets/images/homeSearch/mervel.jpg',
        category: 'Marvel',
        publishedAt: DateTime(2026, 9, 23),
      ),

      // =========================
      // GAMING NEWS
      // =========================

      FandomNews(
        id: 'gaming_news_001',
        fandomId: 'gaming',
        title: 'Gaming Fans Get Ready for New Adventures',
        description:
        'The gaming community continues to follow new releases and upcoming experiences.',
        content:
        'Gaming continues to evolve with new titles, updates and experiences. '
            'Players around the world are keeping up with new adventures, characters '
            'and worlds across different platforms.',
        image: 'assets/images/homeSearch/gtagaming.jpg',
        category: 'Gaming',
        publishedAt: DateTime(2026, 9, 21),
      ),

      // =========================
      // MOVIES NEWS
      // =========================

      FandomNews(
        id: 'movies_news_001',
        fandomId: 'movies',
        title: 'New Movies Bring Exciting Stories',
        description:
        'Movie fans have new stories and cinematic experiences to look forward to.',
        content:
        'The movie world continues to deliver new stories across different genres. '
            'Fans are following upcoming releases, trailers, characters and stories '
            'that are expected to attract audiences around the world.',
        image: 'assets/images/homeSearch/movies.webp',
        category: 'Movies',
        publishedAt: DateTime(2026, 9, 20),
      ),
    ];

    for (final item in news) {
      await _newsService.addNews(item);
    }
  }
}