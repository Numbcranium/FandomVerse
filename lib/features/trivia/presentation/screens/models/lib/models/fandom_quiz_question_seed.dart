

import '../../fandom_quiz_question.dart';
import '../../fandom_quiz_question_service.dart';

class FandomQuizQuestionSeed {
  // getting the service service to work
  final FandomQuizQuestionService _service = FandomQuizQuestionService();

  Future<void> seedQuestions() async {
    final questions = <FandomQuizQuestion>[
      // =====================================================
      // ANIME - 5
      // =====================================================

      const FandomQuizQuestion(
        id: 'anime_q1',
        fandomId: 'anime',
        question:
        'Which anime features the phrase "I\'m gonna be the Pirate King"?',
        image:
        'assets/images/homeSearch/luffy-the-one-piece.jpg',
        options: [
          'Naruto',
          'One Piece',
          'Bleach',
          'Demon Slayer',
        ],
        correctAnswer: 'One Piece',
        questionNumber: 1,
        category: 'Anime',
      ),

      const FandomQuizQuestion(
        id: 'anime_q2',
        fandomId: 'anime',
        question:
        'What is Naruto Uzumaki\'s signature technique?',
        image:
        'assets/images/quizImage/Rasengan.webp',
        options: [
          'Rasengan',
          'Getsuga Tensho',
          'Domain Expansion',
          'Shadow Clone Jutsu '
        ],
        correctAnswer: 'Shadow Clone Jutsu ',
        questionNumber: 2,
        category: 'Anime',
      ),

      const FandomQuizQuestion(
        id: 'anime_q3',
        fandomId: 'anime',
        question:
        'Who is the main character of Demon Slayer?',
        image:
        'assets/images/quizImage/demon.jpg',
        options: [
          'Tanjiro Kamado',
          'Eren Yeager',
          'Ichigo Kurosaki',
          'Saitama',
        ],
        correctAnswer: 'Tanjiro Kamado',
        questionNumber: 3,
        category: 'Anime',
      ),

      const FandomQuizQuestion(
        id: 'anime_q4',
        fandomId: 'anime',
        question:
        'What is the name of the notebook in Death Note?',
        image:
        'assets/images/quizImage/deathnote.jpg',
        options: [
          'Death Note',
          'Black Book',
          'Soul Book',
          'Dark Journal',
        ],
        correctAnswer: 'Death Note',
        questionNumber: 4,
        category: 'Anime',
      ),

      const FandomQuizQuestion(
        id: 'anime_q5',
        fandomId: 'anime',
        question:
        'Which anime follows the adventures of Goku?',
        image:
        'assets/images/quizImage/gokuani.jpg',
        options: [
          'Dragon Ball',
          'One Punch Man',
          'Bleach',
          'Fairy Tail',
        ],
        correctAnswer: 'Dragon Ball',
        questionNumber: 5,
        category: 'Anime',
      ),

      // =====================================================
      // MARVEL - 5
      // =====================================================

      const FandomQuizQuestion(
        id: 'marvel_q1',
        fandomId: 'marvel',
        question:
        'Who is known as the Iron Man in the Marvel Universe?',
        image: 'assets/images/quizImage/ironmann.webp',
        options: [
          'Steve Rogers',
          'Tony Stark',
          'Bruce Banner',
          'Peter Parker',
        ],
        correctAnswer: 'Tony Stark',
        questionNumber: 1,
        category: 'Marvel',
      ),

      const FandomQuizQuestion(
        id: 'marvel_q2',
        fandomId: 'marvel',
        question:
        'What is Captain America\'s shield primarily made from?',
        image: 'assets/images/quizImage/captainA.jpg',
        options: [
          'Vibranium',
          'Titanium',
          'Carbon Fiber',
          'vibranium and steel'
        ],
        correctAnswer: 'vibranium and steel',
        questionNumber: 2,
        category: 'Marvel',
      ),

      const FandomQuizQuestion(
        id: 'marvel_q3',
        fandomId: 'marvel',
        question:
        'What is Thor\'s famous hammer called?',
        image: 'assets/images/quizImage/Thor-Hammer.webp',
        options: [
          'Stormbreaker',
          'Mjolnir',
          'Gungnir',
          'Excalibur',
        ],
        correctAnswer: 'Mjolnir',
        questionNumber: 3,
        category: 'Marvel',
      ),

      const FandomQuizQuestion(
        id: 'marvel_q4',
        fandomId: 'marvel',
        question:
        'What is Spider-Man\'s real name?',
        image: 'assets/images/quizImage/spidermanbrandnewday_lob_mas_mob_02_0.webp',
        options: [
          'Peter Parker',
          'Miles Morales',
          'Matt Murdock',
          'Peter Benjamin Parker'
        ],
        correctAnswer: 'Peter Benjamin Parker',
        questionNumber: 4,
        category: 'Marvel',
      ),

      const FandomQuizQuestion(
        id: 'marvel_q5',
        fandomId: 'marvel',
        question:
        'Which fictional country is Black Panther associated with?',
        image: 'assets/images/quizImage/marvel_black_panther_concept_art.webp',
        options: [
          'Wakanda',
          'Genosha',
          'Latveria',
          'Sokovia',
        ],
        correctAnswer: 'Wakanda',
        questionNumber: 5,
        category: 'Marvel',
      ),

      // =====================================================
      // GAMING - 5
      // =====================================================

      const FandomQuizQuestion(
        id: 'gaming_q1',
        fandomId: 'gaming',
        question:
        'Which character is the main hero of the Super Mario series?',
        image: 'assets/images/quizImage/super-mario-movie-characters-mario2.jpg',
        options: [
          'Mario',
          'Link',
          'Sonic',
          'Kirby',
        ],
        correctAnswer: 'Mario',
        questionNumber: 1,
        category: 'Gaming',
      ),

      const FandomQuizQuestion(
        id: 'gaming_q2',
        fandomId: 'gaming',
        question:
        'Which game features the character Link?',
        image: 'assets/images/quizImage/GVuQaWb5oS5fbtxZajfeKT.jpg',
        options: [
          'The Legend of Zelda (1986)',
          'God of War',
          'Halo',
          'Minecraft',
        ],
        correctAnswer: 'The Legend of Zelda',
        questionNumber: 2,
        category: 'Gaming',
      ),

      const FandomQuizQuestion(
        id: 'gaming_q3',
        fandomId: 'gaming',
        question:
        'Which game is known for building with blocks?',
        image: 'assets/images/quizImage/help-me-find-what-this-kind-of-arcade-game-is-called-v0-vzgpu5zdljgb1.webp',
        options: [
          'Minecraft',
          'Fortnite',
          'Valorant',
          'FIFA',
        ],
        correctAnswer: 'Minecraft',
        questionNumber: 3,
        category: 'Gaming',
      ),

      const FandomQuizQuestion(
        id: 'gaming_q4',
        fandomId: 'gaming',
        question:
        'Which company created the PlayStation?',
        image: 'assets/images/quizImage/ps4700003jpg-5ebd03.jpg',
        options: [
          'Nintendo',
          'Sony Interactive Entertainment',
          'Sony',
          'Sega',
        ],
        correctAnswer: 'Sony Interactive Entertainment',
        questionNumber: 4,
        category: 'Gaming',
      ),

      const FandomQuizQuestion(
        id: 'gaming_q5',
        fandomId: 'gaming',
        question:
        'Which game features the battle royale mode called Battle Royale?',
        image: 'assets/images/quizImage/QYqM3b4cCgvPcczseysxTj.jpg',
        options: [
          'Fortnite',
          'Minecraft',
          'The Sims',
          'Battle Royale',
        ],
        correctAnswer: 'Battle Royale',
        questionNumber: 5,
        category: 'Gaming',
      ),

      // =====================================================
      // MOVIES - 5
      // =====================================================

      const FandomQuizQuestion(
        id: 'movies_q1',
        fandomId: 'movies',
        question:
        'Which movie features the character Jack Sparrow?',
        image: 'assets/images/quizImage/open-uri20160811-32147-165j62f_73741a4c.jpeg',
        options: [
          'Pirates of the Caribbean',
          'Titanic',
          'Avatar',
          'Jurassic Park',
        ],
        correctAnswer: 'Pirates of the Caribbean',
        questionNumber: 1,
        category: 'Movies',
      ),

      const FandomQuizQuestion(
        id: 'movies_q2',
        fandomId: 'movies',
        question:
        'Which movie features the fictional world of Pandora?',
        image: 'assets/images/quizImage/1228-science-avatar-movie.jpg',
        options: [
          'Avatar',
          'Inception',
          'Interstellar',
          'Dune',
        ],
        correctAnswer: 'Avatar',
        questionNumber: 2,
        category: 'Movies',
      ),

      const FandomQuizQuestion(
        id: 'movies_q3',
        fandomId: 'movies',
        question:
        'Which movie follows dinosaurs brought back through genetic engineering?',
        image: 'assets/images/quizImage/download-16x9.jpg',
        options: [
          'Jurassic Park',
          'King Kong',
          'Godzilla',
          'The Meg',
        ],
        correctAnswer: 'Jurassic Park',
        questionNumber: 3,
        category: 'Movies',
      ),

      const FandomQuizQuestion(
        id: 'movies_q4',
        fandomId: 'movies',
        question:
        'Which movie features the character Neo?',
        image: 'assets/images/quizImage/Neo.The-Matrix.webp',
        options: [
          'The Matrix',
          'Inception',
          'Tenet',
          'Blade Runner',
        ],
        correctAnswer: 'The Matrix',
        questionNumber: 4,
        category: 'Movies',
      ),

      const FandomQuizQuestion(
        id: 'movies_q5',
        fandomId: 'movies',
        question:
        'Which film series features the character John Wick?',
        image: 'assets/images/quizImage/John_Wick_Falcon_and_The_Winter_Soldier.jpg',
        options: [
          'John Wick',
          'Mission Impossible',
          'Taken',
          'Die Hard',
        ],
        correctAnswer: 'John Wick',
        questionNumber: 5,
        category: 'Movies',
      ),

      // =====================================================
      // POP CULTURE - 5
      // =====================================================

      const FandomQuizQuestion(
        id: 'pop_culture_q1',
        fandomId: 'pop_culture',
        question:
        'Which platform is widely known for short-form videos?',
        image:
        'assets/images/quizImage/blog_shortvideo.jpg',
        options: [
          'TikTok',
          'LinkedIn',
          'Wikipedia',
          'GitHub',
        ],
        correctAnswer: 'TikTok',
        questionNumber: 1,
        category: 'Pop Culture',
      ),

      const FandomQuizQuestion(
        id: 'pop_culture_q2',
        fandomId: 'pop_culture',
        question:
        'Which award ceremony is associated with film achievements?',
        image:
        'assets/images/quizImage/Oscar-statuettes-76th-Academy-Awards-ceremony-2003.webp',
        options: [
          'Academy Awards',
          'Grammy Awards',
          'Tony Awards',
          'Emmy Awards',
        ],
        correctAnswer: 'Academy Awards',
        questionNumber: 2,
        category: 'Pop Culture',
      ),

      const FandomQuizQuestion(
        id: 'pop_culture_q3',
        fandomId: 'pop_culture',
        question:
        'Which social platform is represented by the X logo today?',
        image:
        'assets/images/quizImage/hero-image.fill.size_1248x702.v1756499617.webp',
        options: [
          'X',
          'Snapchat',
          'Pinterest',
          'Reddit',
        ],
        correctAnswer: 'X',
        questionNumber: 3,
        category: 'Pop Culture',
      ),

      const FandomQuizQuestion(
        id: 'pop_culture_q4',
        fandomId: 'pop_culture',
        question:
        'Which type of content is commonly associated with viral internet trends?',
        image:
        'assets/images/quizImage/c91ca2e4-7d01-4a9d-b914-024042ac4101.webp',
        options: [
          'Memes',
          'Textbooks',
          'Tax forms',
          'Weather reports',
        ],
        correctAnswer: 'Memes',
        questionNumber: 4,
        category: 'Pop Culture',
      ),

      const FandomQuizQuestion(
        id: 'pop_culture_q5',
        fandomId: 'pop_culture',
        question:
        'Which medium is commonly used to share viral dance trends?',
        image:
        'assets/images/quizImage/danceb07-2560x1100.webp',
        options: [
          'Social media',
          'Newspapers only',
          'Printed dictionaries',
          'Postal mail',
        ],
        correctAnswer: 'Social media',
        questionNumber: 5,
        category: 'Pop Culture',
      ),

      // =====================================================
      // TV UNIVERSES - 5
      // =====================================================

      const FandomQuizQuestion(
        id: 'tv_universes_q1',
        fandomId: 'tv_universes',
        question:
        'Which series follows the character Eleven?',
        image:
        'assets/images/quizImage/StrangerThings-seriesfinale-Eleven-solo.1_535c64.webp',
        options: [
          'Stranger Things',
          'Wednesday',
          'The Witcher',
          'Lost',
        ],
        correctAnswer: 'Stranger Things',
        questionNumber: 1,
        category: 'TV Universes',
      ),

      const FandomQuizQuestion(
        id: 'tv_universes_q2',
        fandomId: 'tv_universes',
        question:
        'Which series features the character Wednesday Addams?',
        image:
        'assets/images/quizImage/AAAAQYOeCCpkwPAFykI7lEUIouxmiXsvxOnDs_bjQGo2Whf9FrwPXpQ6VmVKlnmMbxHBfqja2iOaEOayofhH0erJrzKxVkRz5-yQZDVFcRWnALggiACpb-9VbXOi6r6bFDT2EIPaW59Vh6GKpjsGRuvP-aASPhs.jpg',
        options: [
          'Wednesday',
          'Riverdale',
          'Friends',
          'The Office',
        ],
        correctAnswer: 'Wednesday',
        questionNumber: 2,
        category: 'TV Universes',
      ),

      const FandomQuizQuestion(
        id: 'tv_universes_q3',
        fandomId: 'tv_universes',
        question:
        'Which fantasy series features Westeros?',
        image:
        'assets/images/quizImage/westeros-map-complete-atlas-throneatlas.webp',
        options: [
          'Game of Thrones',
          'The Boys',
          'The Office',
          'Lost',
        ],
        correctAnswer: 'Game of Thrones',
        questionNumber: 3,
        category: 'TV Universes',
      ),

      const FandomQuizQuestion(
        id: 'tv_universes_q4',
        fandomId: 'tv_universes',
        question:
        'Which series features a character named Walter White?',
        image:
        'assets/images/quizImage/bryan-cranston-aaron-paul-breaking-bad.webp',
        options: [
          'Breaking Bad',
          'Suits',
          'Sherlock',
          'Dexter',
        ],
        correctAnswer: 'Breaking Bad',
        questionNumber: 4,
        category: 'TV Universes',
      ),

      const FandomQuizQuestion(
        id: 'tv_universes_q5',
        fandomId: 'tv_universes',
        question:
        'Which series follows a group of survivors after a zombie outbreak?',
        image:
        'assets/images/quizImage/AAAAQS4PiRXVTWsBLEAguqTpsQyXDwtDg6fHRE7HIm-1f2jgIpf2-vULQahFAvfZ-bBxd0zRaU_ehdJ5IDs4S9jUK_Uq7rYqplG_-2y5tAjwgRqIbDJI8FTAM9MEM7wFYy-goBXxMzHI8e_h4i28vRiUQ6AF.jpg',
        options: [
          'The Walking Dead',
          'Friends',
          'Suits',
          'The Crown',
        ],
        correctAnswer: 'The Walking Dead',
        questionNumber: 5,
        category: 'TV Universes',
      ),

      // =====================================================
      // COMIC BOOKS - 5
      // =====================================================

      const FandomQuizQuestion(
        id: 'comic_books_q1',
        fandomId: 'comic_books',
        question:
        'Which superhero is known as the Dark Knight?',
        image:
        'assets/images/quizImage/Publicity-still-showing-Christian-Bale-in-The-Dark-Knight-Batman-movie.webp',
        options: [
          'Batman',
          'Superman',
          'Flash',
          'Green Lantern',
        ],
        correctAnswer: 'Batman',
        questionNumber: 1,
        category: 'Comic Books',
      ),

      const FandomQuizQuestion(
        id: 'comic_books_q2',
        fandomId: 'comic_books',
        question:
        'Which superhero is also known as the Man of Steel?',
        image:
        'assets/images/quizImage/20130620-075310.webp',
        options: [
          'Superman',
          'Batman',
          'Aquaman',
          'Cyborg',
        ],
        correctAnswer: 'Superman',
        questionNumber: 2,
        category: 'Comic Books',
      ),

      const FandomQuizQuestion(
        id: 'comic_books_q3',
        fandomId: 'comic_books',
        question:
        'What city is Batman primarily associated with?',
        image:
        'assets/images/quizImage/81055747d8b7b6ccc4a497093dc56c42.jpg',
        options: [
          'Gotham State',
          'Metropolis',
          'Central City',
          'Gotham City'
        ],
        correctAnswer: 'Gotham City',
        questionNumber: 3,
        category: 'Comic Books',
      ),

      const FandomQuizQuestion(
        id: 'comic_books_q4',
        fandomId: 'comic_books',
        question:
        'Which superhero can manipulate the weather using the X-Men universe?',
        image:
        'assets/images/quizImage/039stm_com_cut_mob_01_1.webp',
        options: [
          'Storm',
          'Rogue',
          'Mystique',
          'Jean Grey',
        ],
        correctAnswer: 'Storm',
        questionNumber: 4,
        category: 'Comic Books',
      ),

      const FandomQuizQuestion(
        id: 'comic_books_q5',
        fandomId: 'comic_books',
        question:
        'Which hero is associated with the fictional city of Central City?',
        image:
        'assets/images/quizImage/039stm_com_cut_mob_01_1.webp',
        options: [
          'The Flash',
          'Batman',
          'Superman',
          'Green Arrow',
        ],
        correctAnswer: 'The Flash',
        questionNumber: 5,
        category: 'Comic Books',
      ),

      // =====================================================
      // MUSIC - 5
      // =====================================================

      const FandomQuizQuestion(
        id: 'music_q1',
        fandomId: 'music',
        question:
        'Which instrument commonly has 88 keys?',
        image:
        'assets/images/quizImage/7445.webp',
        options: [
          'Piano',
          'Guitar',
          'Violin',
          'Trumpet',
        ],
        correctAnswer: 'Piano',
        questionNumber: 1,
        category: 'Music',
      ),

      const FandomQuizQuestion(
        id: 'music_q2',
        fandomId: 'music',
        question:
        'How many strings does a standard guitar usually have?',
        image:
        'assets/images/quizImage/mechanism_p02_01_480x480.webp',
        options: [
          '4',
          '5',
          '6',
          '8',
        ],
        correctAnswer: '6',
        questionNumber: 2,
        category: 'Music',
      ),

      const FandomQuizQuestion(
        id: 'music_q3',
        fandomId: 'music',
        question:
        'Which award is strongly associated with music recording achievements?',
        image:
        'assets/images/quizImage/Latin-Grammy-Award-statues-2015.webp',
        options: [
          'Grammy Awards',
          'Oscars',
          'Emmys',
          'Tonys',
        ],
        correctAnswer: 'Grammy Awards',
        questionNumber: 3,
        category: 'Music',
      ),

      const FandomQuizQuestion(
        id: 'music_q4',
        fandomId: 'music',
        question:
        'What term describes the speed of a piece of music?',
        image:
        'assets/images/quizImage/Poetic-Metre.jpg',
        options: [
          'Tempo',
          'Pitch',
          'Harmony',
          'Timbre',
        ],
        correctAnswer: 'Tempo',
        questionNumber: 4,
        category: 'Music',
      ),

      const FandomQuizQuestion(
        id: 'music_q5',
        fandomId: 'music',
        question:
        'Which musical symbol indicates silence?',
        image:
        'assets/images/quizImage/images.png',
        options: [
          'Rest',
          'Clef',
          'Sharp',
          'Flat',
        ],
        correctAnswer: 'Rest',
        questionNumber: 5,
        category: 'Music',
      ),

      // =====================================================
      // IDOL CULTURE - 5
      // =====================================================

      const FandomQuizQuestion(
        id: 'idol_culture_q1',
        fandomId: 'idol_culture',
        question:
        'Which country is strongly associated with modern K-pop?',
        image:
        'assets/images/quizImage/Blackpink_Coachella_2023_02_(cropped).jpg.webp',
        options: [
          'South Korea',
          'Canada',
          'Brazil',
          'France',
        ],
        correctAnswer: 'South Korea',
        questionNumber: 1,
        category: 'Idol Culture',
      ),

      const FandomQuizQuestion(
        id: 'idol_culture_q2',
        fandomId: 'idol_culture',
        question:
        'What does K-pop commonly stand for?',
        image:
        'assets/images/quizImage/p0ltdsv5.jpg',
        options: [
          'Korean Pop',
          'King Pop',
          'Kinetic Pop',
          'Karaoke Pop',
        ],
        correctAnswer: 'Korean Pop',
        questionNumber: 2,
        category: 'Idol Culture',
      ),

      const FandomQuizQuestion(
        id: 'idol_culture_q3',
        fandomId: 'idol_culture',
        question:
        'What do many idol groups release alongside songs to promote a new release?',
        image:
        'assets/images/quizImage/a19fca70-8c79-11ef-8a4d-3d83d5927fa4.jpg',
        options: [
          'Music videos',
          'Textbooks',
          'Newsletters only',
          'Recipe books',
        ],
        correctAnswer: 'Music videos',
        questionNumber: 3,
        category: 'Idol Culture',
      ),

      const FandomQuizQuestion(
        id: 'idol_culture_q4',
        fandomId: 'idol_culture',
        question:
        'What is a group of dedicated fans commonly called?',
        image:
        'assets/images/quizImage/Star_Trek_cosplayers_in_Dragon_Con_Parade_2010.jpg',
        options: [
          'Fandom',
          'Audience',
          'Panel',
          'Cast',
        ],
        correctAnswer: 'Fandom',
        questionNumber: 4,
        category: 'Idol Culture',
      ),

      const FandomQuizQuestion(
        id: 'idol_culture_q5',
        fandomId: 'idol_culture',
        question:
        'What is commonly performed by idol groups during concerts?',
        image:
        'assets/images/quizImage/4843485c-e663-404b-8b36-ce0217c74fb9_1024x683.jpg',
        options: [
          'Choreographed performances',
          'Court trials',
          'Cooking lessons',
          'News broadcasts',
        ],
        correctAnswer: 'Choreographed performances',
        questionNumber: 5,
        category: 'Idol Culture',
      ),
    ];

    for (final question in questions) {
      await _service.addQuestion(question);
    }
  }
}