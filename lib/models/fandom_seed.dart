// this will save in the firebase instead of creating in the firebase

import 'fandom-service.dart';
import 'fandom_models.dart';

class FandomSeed {
  final FandomService _fandomService = FandomService();

  Future<void> seedFandoms() async {
    final fandoms = [
      const FandomModels(
        id: 'anime',
        name: 'Anime',
        description:
        'Dive into legendary anime worlds, unforgettable characters, epic battles, fan theories, stunning moments and everything you love about anime.',
        image: 'assets/images/homeSearch/luffy-the-one-piece.jpg',
        category: 'Anime',
      ),

      const FandomModels(
        id: 'marvel',
        name: 'Marvel',
        description:
        'Step into the Marvel Universe and discover iconic heroes, powerful villains, legendary stories, epic battles, comics, movies and fan theories.',
        image: 'assets/images/homeSearch/mervel.jpg',
        category: 'Marvel',
      ),

      const FandomModels(
        id: 'gaming',
        name: 'Gaming',
        description:
        'Level up your fandom with legendary games, unforgettable characters, epic quests, gaming moments, communities, news and everything in between.',
        image: 'assets/images/homeSearch/gtagaming.jpg',
        category: 'Gaming',
      ),

      const FandomModels(
        id: 'movies',
        name: 'Movies',
        description:
        'Discover unforgettable movies, iconic characters, blockbuster moments, trailers, behind-the-scenes stories, fan theories and cinematic worlds.',
        image: 'assets/images/homeSearch/movies.webp',
        category: 'Movies',
      ),

      const FandomModels(
        id: 'pop_culture',
        name: 'Pop Culture',
        description:
        'Stay in the heart of what everyone is talking about with trending stars, viral moments, iconic personalities, internet culture and fan communities.',
        image: 'assets/images/homeSearch/PopCulture.png',
        category: 'Pop Culture',
      ),

      const FandomModels(
        id: 'tv_universes',
        name: 'TV Universes',
        description:
        'Get lost in unforgettable TV worlds filled with iconic characters, shocking twists, fan theories, legendary episodes and stories worth talking about.',
        image: 'assets/images/homeSearch/TVUniverses.webp',
        category: 'TV Universes',
      ),

      const FandomModels(
        id: 'comic_books',
        name: 'Comic Books',
        description:
        'Turn the pages of incredible comic book worlds filled with legendary heroes, fierce villains, powerful stories, rare editions and unforgettable artwork.',
        image: 'assets/images/homeSearch/comic_books.jpg',
        category: 'Comic Books',
      ),

      const FandomModels(
        id: 'music',
        name: 'Music',
        description:
        'Feel the sound of fandom with legendary artists, unforgettable songs, albums, concerts, music moments, fan communities and the stories behind the music.',
        image: 'assets/images/homeSearch/music.jpeg',
        category: 'Music',
      ),

      const FandomModels(
        id: 'idol_culture',
        name: 'Idol Culture',
        description:
        'Enter the world of idols, passionate fandoms, unforgettable performances, fan moments, music, personalities and the culture that brings fans together.',
        image: 'assets/images/homeSearch/idolculture.jpg',
        category: 'Idol Culture',
      ),
    ];

    for (final fandom in fandoms) {
      await _fandomService.addFandom(fandom);
    }
  }
}