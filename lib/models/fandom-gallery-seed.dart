import 'fandom_gallery.dart';
import 'fandom-gallery-service.dart';

class FandomGallerySeed {
  final FandomGalleryService _galleryService =
  FandomGalleryService();

  Future<void> seedGallery() async {
    final gallery = [
      // =====================================================
      // ANIME - 5
      // =====================================================

      FandomGallery(
        id: 'anime_gallery_001',
        fandomId: 'anime',
        title: 'One Piece',
        image: 'assets/images/homeSearch/anime_01.jpg',
        category: 'Anime',
        uploadedAt: DateTime(2026, 9, 24),
      ),

      FandomGallery(
        id: 'anime_gallery_002',
        fandomId: 'anime',
        title: 'Naruto',
        image: 'assets/images/homeSearch/anime_05.jpg',
        category: 'Anime',
        uploadedAt: DateTime(2026, 9, 23),
      ),

      FandomGallery(
        id: 'anime_gallery_003',
        fandomId: 'anime',
        title: 'Dragon Ball',
        image: 'assets/images/homeSearch/anime_04.jpg',
        category: 'Anime',
        uploadedAt: DateTime(2026, 9, 22),
      ),

      // FandomGallery(
      //   id: 'anime_gallery_004',
      //   fandomId: 'anime',
      //   title: 'Demon Slayer',
      //   image: 'assets/images/gallery/anime/anime_4.jpg',
      //   category: 'Anime',
      //   uploadedAt: DateTime(2026, 9, 21),
      // ),

      // FandomGallery(
      //   id: 'anime_gallery_005',
      //   fandomId: 'anime',
      //   title: 'Jujutsu Kaisen',
      //   image: 'assets/images/gallery/anime/anime_5.jpg',
      //   category: 'Anime',
      //   uploadedAt: DateTime(2026, 9, 20),
      // ),

      // =====================================================
      // MARVEL - 5
      // =====================================================

      FandomGallery(
        id: 'marvel_gallery_001',
        fandomId: 'marvel',
        title: 'Marvel Heroes',
        image: 'assets/images/homeSearch/anime_06.jpg',
        category: 'Marvel',
        uploadedAt: DateTime(2026, 9, 24),
      ),

      FandomGallery(
        id: 'marvel_gallery_002',
        fandomId: 'marvel',
        title: 'Spider-Man',
        image: 'assets/images/homeSearch/anime_07.jpg',
        category: 'Marvel',
        uploadedAt: DateTime(2026, 9, 23),
      ),

      FandomGallery(
        id: 'marvel_gallery_003',
        fandomId: 'marvel',
        title: 'Iron Man',
        image: 'assets/images/homeSearch/anime_08.jpg',
        category: 'Marvel',
        uploadedAt: DateTime(2026, 9, 22),
      ),

      FandomGallery(
        id: 'marvel_gallery_004',
        fandomId: 'marvel',
        title: 'Avengers',
        image: 'assets/images/homeSearch/anime_08.jpg',
        category: 'Marvel',
        uploadedAt: DateTime(2026, 9, 21),
      ),

      // FandomGallery(
      //   id: 'marvel_gallery_005',
      //   fandomId: 'marvel',
      //   title: 'Black Panther',
      //   image: 'assets/images/gallery/marvel/marvel_5.jpg',
      //   category: 'Marvel',
      //   uploadedAt: DateTime(2026, 9, 20),
      // ),

      // =====================================================
      // GAMING - 5
      // =====================================================

      FandomGallery(
        id: 'gaming_gallery_001',
        fandomId: 'gaming',
        title: 'Grand Theft Auto',
        image: 'assets/images/homeSearch/anime_09.jpg',
        category: 'Gaming',
        uploadedAt: DateTime(2026, 9, 24),
      ),

      FandomGallery(
        id: 'gaming_gallery_002',
        fandomId: 'gaming',
        title: 'Call of Duty',
        image: 'assets/images/homeSearch/anime_10.jpg',
        category: 'Gaming',
        uploadedAt: DateTime(2026, 9, 23),
      ),

      FandomGallery(
        id: 'gaming_gallery_003',
        fandomId: 'gaming',
        title: 'Fortnite',
        image: 'assets/images/homeSearch/anime_11.jpg',
        category: 'Gaming',
        uploadedAt: DateTime(2026, 9, 22),
      ),

      // FandomGallery(
      //   id: 'gaming_gallery_004',
      //   fandomId: 'gaming',
      //   title: 'Minecraft',
      //   image: 'assets/images/gallery/gaming/gaming_4.jpg',
      //   category: 'Gaming',
      //   uploadedAt: DateTime(2026, 9, 21),
      // ),
      //
      // FandomGallery(
      //   id: 'gaming_gallery_005',
      //   fandomId: 'gaming',
      //   title: 'PlayStation',
      //   image: 'assets/images/gallery/gaming/gaming_5.jpg',
      //   category: 'Gaming',
      //   uploadedAt: DateTime(2026, 9, 20),
      // ),

      // =====================================================
      // MOVIES - 5
      // =====================================================

      FandomGallery(
        id: 'movies_gallery_001',
        fandomId: 'movies',
        title: 'Action Movies',
        image: 'assets/images/gallery/homeSearch/movies_01.jpg',
        category: 'Movies',
        uploadedAt: DateTime(2026, 9, 24),
      ),

      //  FandomGallery(
      //   id: 'movies_gallery_002',
      //   fandomId: 'movies',
      //   title: 'Blockbusters',
      //   image: 'assets/images/gallery/movies/movies_2.jpg',
      //   category: 'Movies',
      //   uploadedAt: DateTime(2026, 9, 23),
      // ),

      //  FandomGallery(
      //   id: 'movies_gallery_003',
      //   fandomId: 'movies',
      //   title: 'Movie Stars',
      //   image: 'assets/images/gallery/movies/movies_3.jpg',
      //   category: 'Movies',
      //   uploadedAt: DateTime(2026, 9, 22),
      // ),

      //  FandomGallery(
      //   id: 'movies_gallery_004',
      //   fandomId: 'movies',
      //   title: 'Cinema',
      //   image: 'assets/images/gallery/movies/movies_4.jpg',
      //   category: 'Movies',
      //   uploadedAt: DateTime(2026, 9, 21),
      // ),
      //
      //  FandomGallery(
      //   id: 'movies_gallery_005',
      //   fandomId: 'movies',
      //   title: 'Movie Moments',
      //   image: 'assets/images/gallery/movies/movies_5.jpg',
      //   category: 'Movies',
      //   uploadedAt: DateTime(2026, 9, 20),
      // ),

      // =====================================================
      // POP CULTURE - 5
      // =====================================================

       FandomGallery(
        id: 'pop_culture_gallery_001',
        fandomId: 'pop_culture',
        title: 'Pop Culture',
        image:
        'assets/images/gallery/homeSearch/popCulture_01',
        category: 'Pop Culture',
        uploadedAt: DateTime(2026, 9, 24),
      ),

      //  FandomGallery(
      //   id: 'pop_culture_gallery_002',
      //   fandomId: 'pop_culture',
      //   title: 'Trending Moments',
      //   image:
      //   'assets/images/gallery/homeSearch/tv_01.jpg',
      //   category: 'Pop Culture',
      //   uploadedAt: DateTime(2026, 9, 23),
      // ),

      //  FandomGallery(
      //   id: 'pop_culture_gallery_003',
      //   fandomId: 'pop_culture',
      //   title: 'Celebrity Culture',
      //   image:
      //   'assets/images/gallery/homeSearch/tv_01.jpg',
      //   category: 'Pop Culture',
      //   uploadedAt: DateTime(2026, 9, 22),
      // ),

      //  FandomGallery(
      //   id: 'pop_culture_gallery_004',
      //   fandomId: 'pop_culture',
      //   title: 'Viral Moments',
      //   image:
      //   'assets/images/gallery/pop_culture/pop_culture_4.jpg',
      //   category: 'Pop Culture',
      //   uploadedAt: DateTime(2026, 9, 21),
      // ),
      //
      //  FandomGallery(
      //   id: 'pop_culture_gallery_005',
      //   fandomId: 'pop_culture',
      //   title: 'Internet Culture',
      //   image:
      //   'assets/images/gallery/pop_culture/pop_culture_5.jpg',
      //   category: 'Pop Culture',
      //   uploadedAt: DateTime(2026, 9, 20),
      // ),

      // =====================================================
      // TV UNIVERSES - 5
      // =====================================================

      //  FandomGallery(
      //   id: 'tv_universes_gallery_001',
      //   fandomId: 'tv_universes',
      //   title: 'TV Series',
      //   image:
      //   'assets/images/gallery/homeSearch/comic_03',
      //   category: 'TV Universes',
      //   uploadedAt: DateTime(2026, 9, 24),
      // ),

      //  FandomGallery(
      //   id: 'tv_universes_gallery_002',
      //   fandomId: 'tv_universes',
      //   title: 'Iconic Characters',
      //   image:
      //   'assets/images/gallery/homeSearch/comic_03',
      //   category: 'TV Universes',
      //   uploadedAt: DateTime(2026, 9, 23),
      // ),

       FandomGallery(
        id: 'tv_universes_gallery_003',
        fandomId: 'tv_universes',
        title: 'TV Moments',
        image:
        'assets/images/gallery/homeSearch/tv_01.jpg',
        category: 'TV Universes',
        uploadedAt: DateTime(2026, 9, 22),
      ),

      //  FandomGallery(
      //   id: 'tv_universes_gallery_004',
      //   fandomId: 'tv_universes',
      //   title: 'Popular Shows',
      //   image:
      //   'assets/images/gallery/tv_universes/tv_4.jpg',
      //   category: 'TV Universes',
      //   uploadedAt: DateTime(2026, 9, 21),
      // ),
      //
      //  FandomGallery(
      //   id: 'tv_universes_gallery_005',
      //   fandomId: 'tv_universes',
      //   title: 'TV Fandom',
      //   image:
      //   'assets/images/gallery/tv_universes/tv_5.jpg',
      //   category: 'TV Universes',
      //   uploadedAt: DateTime(2026, 9, 20),
      // ),

      // =====================================================
      // COMIC BOOKS - 5
      // =====================================================

       FandomGallery(
        id: 'comic_books_gallery_001',
        fandomId: 'comic_books',
        title: 'Comic Heroes',
        image:
        'assets/images/gallery/homeSearch/comic_01',
        category: 'Comic Books',
        uploadedAt: DateTime(2026, 9, 24),
      ),

       FandomGallery(
        id: 'comic_books_gallery_002',
        fandomId: 'comic_books',
        title: 'Classic Comics',
        image:
        'assets/images/gallery/homeSearch/comic_02',
        category: 'Comic Books',
        uploadedAt: DateTime(2026, 9, 23),
      ),

      FandomGallery(
        id: 'comic_books_gallery_003',
        fandomId: 'comic_books',
        title: 'Comic Characters',
        image:
        'assets/images/gallery/homeSearch/comic_03',
        category: 'Comic Books',
        uploadedAt: DateTime(2026, 9, 22),
      ),

      // FandomGallery(
      //   id: 'comic_books_gallery_004',
      //   fandomId: 'comic_books',
      //   title: 'Comic Art',
      //   image:
      //   'assets/images/gallery/comic_books/comic_4.jpg',
      //   category: 'Comic Books',
      //   uploadedAt: DateTime(2026, 9, 21),
      // ),
      //
      // FandomGallery(
      //   id: 'comic_books_gallery_005',
      //   fandomId: 'comic_books',
      //   title: 'Comic Universe',
      //   image:
      //   'assets/images/gallery/comic_books/comic_5.jpg',
      //   category: 'Comic Books',
      //   uploadedAt: DateTime(2026, 9, 20),
      // ),

      // =====================================================
      // MUSIC - 5
      // =====================================================

      FandomGallery(
        id: 'music_gallery_001',
        fandomId: 'music',
        title: 'Music Artists',
        image: 'assets/images/gallery/homeSearch/music_01.jpg',
        category: 'Music',
        uploadedAt: DateTime(2026, 9, 24),
      ),

      FandomGallery(
        id: 'music_gallery_002',
        fandomId: 'music',
        title: 'Live Concert',
        image: 'assets/images/gallery/homeSearch/music_02.jpg',
        category: 'Music',
        uploadedAt: DateTime(2026, 9, 23),
      ),

      FandomGallery(
        id: 'music_gallery_003',
        fandomId: 'music',
        title: 'Music Performance',
        image: 'assets/images/gallery/homeSearch/music_03.jpg',
        category: 'Music',
        uploadedAt: DateTime(2026, 9, 22),
      ),

      // FandomGallery(
      //   id: 'music_gallery_004',
      //   fandomId: 'music',
      //   title: 'Music Festival',
      //   image: 'assets/images/gallery/music/music_4.jpg',
      //   category: 'Music',
      //   uploadedAt: DateTime(2026, 9, 21),
      // ),
      //
      // FandomGallery(
      //   id: 'music_gallery_005',
      //   fandomId: 'music',
      //   title: 'Music Fans',
      //   image: 'assets/images/gallery/music/music_5.jpg',
      //   category: 'Music',
      //   uploadedAt: DateTime(2026, 9, 20),
      // ),

      // =====================================================
      // IDOL CULTURE - 5
      // =====================================================

       FandomGallery(
        id: 'idol_culture_gallery_001',
        fandomId: 'idol_culture',
        title: 'Idol Performance',
        image:
        'assets/images/gallery/homeSearch/idolculture_03.jpg',
        category: 'Idol Culture',
        uploadedAt: DateTime(2026, 9, 24),
      ),

      FandomGallery(
        id: 'idol_culture_gallery_002',
        fandomId: 'idol_culture',
        title: 'Idol Stage',
        image:
        'assets/images/gallery/homeSearch/idolculture_02.jpg',
        category: 'Idol Culture',
        uploadedAt: DateTime(2026, 9, 23),
      ),

      FandomGallery(
        id: 'idol_culture_gallery_003',
        fandomId: 'idol_culture',
        title: 'Idol Fans',
        image:
        'assets/images/gallery/homeSearch/idolculture_01.jpg',
        category: 'Idol Culture',
        uploadedAt: DateTime(2026, 9, 22),
      ),

      //  FandomGallery(
      //   id: 'idol_culture_gallery_004',
      //   fandomId: 'idol_culture',
      //   title: 'Idol Concert',
      //   image:
      //   'assets/images/gallery/idol_culture/idol_4.jpg',
      //   category: 'Idol Culture',
      //   uploadedAt: DateTime(2026, 9, 21),
      // ),
      //
      //  FandomGallery(
      //   id: 'idol_culture_gallery_005',
      //   fandomId: 'idol_culture',
      //   title: 'Idol Culture',
      //   image:
      //   'assets/images/gallery/idol_culture/idol_5.jpg',
      //   category: 'Idol Culture',
      //   uploadedAt: DateTime(2026, 9, 20),
      // ),
    ];

    for (final item in gallery) {
      await _galleryService.addGallery(item);
    }
  }
}