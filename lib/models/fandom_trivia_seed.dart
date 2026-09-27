import 'package:techwiz7_starter/models/trending_fandom_trivia.dart';

import 'fandom_trivia_service.dart';

class FandomTriviaSeed {
  final FandomTriviaService _triviaService =
  FandomTriviaService();

  Future<void> seedTrivia() async {
    final trivia = [
      // =========================
      // ANIME
      // =========================

      const FandomTrivia(
        id: 'question_1',
        fandomId: 'anime',
        question:
        'Who is the captain of the Straw Hat Pirates?',
        options: [
          'Roronoa Zoro',
          'Monkey D. Luffy',
          'Sanji',
          'Usopp',
        ],
        correctAnswer: 'Monkey D. Luffy',
        category: 'Anime',
        questionNumber: 1,
      ),

      const FandomTrivia(
        id: 'question_2',
        fandomId: 'anime',
        question:
        'What is Naruto Uzumaki known for becoming?',
        options: [
          'Hokage',
          'Pirate King',
          'Soul Reaper',
          'Hashira',
        ],
        correctAnswer: 'Hokage',
        category: 'Anime',
        questionNumber: 2,
      ),

      const FandomTrivia(
        id: 'question_3',
        fandomId: 'anime',
        question:
        'Which anime features the Saiyans?',
        options: [
          'One Piece',
          'Bleach',
          'Dragon Ball',
          'Demon Slayer',
        ],
        correctAnswer: 'Dragon Ball',
        category: 'Anime',
        questionNumber: 3,
      ),

      const FandomTrivia(
        id: 'question_4',
        fandomId: 'anime',
        question:
        'Who uses a Nichirin sword in Demon Slayer?',
        options: [
          'Tanjiro Kamado',
          'Izuku Midoriya',
          'Gojo Satoru',
          'Light Yagami',
        ],
        correctAnswer: 'Tanjiro Kamado',
        category: 'Anime',
        questionNumber: 4,
      ),

      const FandomTrivia(
        id: 'question_5',
        fandomId: 'anime',
        question:
        'What is the name of Ichigo Kurosaki’s sword?',
        options: [
          'Zangetsu',
          'Enma',
          'Samehada',
          'Excalibur',
        ],
        correctAnswer: 'Zangetsu',
        category: 'Anime',
        questionNumber: 5,
      ),

      // =========================
      // MARVEL
      // =========================

      const FandomTrivia(
        id: 'question_1',
        fandomId: 'marvel',
        question:
        'Who is known as the God of Thunder?',
        options: [
          'Iron Man',
          'Thor',
          'Hulk',
          'Loki',
        ],
        correctAnswer: 'Thor',
        category: 'Marvel',
        questionNumber: 1,
      ),

      const FandomTrivia(
        id: 'question_2',
        fandomId: 'marvel',
        question:
        'What is Captain America’s shield primarily made from?',
        options: [
          'Adamantium',
          'Vibranium',
          'Titanium',
          'Uru',
        ],
        correctAnswer: 'Vibranium',
        category: 'Marvel',
        questionNumber: 2,
      ),

      const FandomTrivia(
        id: 'question_3',
        fandomId: 'marvel',
        question:
        'What is Spider-Man’s real name?',
        options: [
          'Peter Parker',
          'Tony Stark',
          'Steve Rogers',
          'Bruce Banner',
        ],
        correctAnswer: 'Peter Parker',
        category: 'Marvel',
        questionNumber: 3,
      ),

      const FandomTrivia(
        id: 'question_4',
        fandomId: 'marvel',
        question:
        'What country is Black Panther associated with?',
        options: [
          'Wakanda',
          'Latveria',
          'Genosha',
          'Sokovia',
        ],
        correctAnswer: 'Wakanda',
        category: 'Marvel',
        questionNumber: 4,
      ),

      const FandomTrivia(
        id: 'question_5',
        fandomId: 'marvel',
        question:
        'Who created the Infinity Gauntlet storyline in the MCU?',
        options: [
          'Thanos',
          'Nick Fury',
          'Doctor Strange',
          'Loki',
        ],
        correctAnswer: 'Thanos',
        category: 'Marvel',
        questionNumber: 5,
      ),

      // =========================
      // GAMING
      // =========================

      const FandomTrivia(
        id: 'question_1',
        fandomId: 'gaming',
        question:
        'What is Mario’s brother called?',
        options: [
          'Luigi',
          'Link',
          'Kirby',
          'Sonic',
        ],
        correctAnswer: 'Luigi',
        category: 'Gaming',
        questionNumber: 1,
      ),

      const FandomTrivia(
        id: 'question_2',
        fandomId: 'gaming',
        question:
        'Which game features the character Master Chief?',
        options: [
          'Halo',
          'Fortnite',
          'Minecraft',
          'Valorant',
        ],
        correctAnswer: 'Halo',
        category: 'Gaming',
        questionNumber: 2,
      ),

      const FandomTrivia(
        id: 'question_3',
        fandomId: 'gaming',
        question:
        'Which game uses Creepers?',
        options: [
          'Minecraft',
          'Roblox',
          'GTA',
          'FIFA',
        ],
        correctAnswer: 'Minecraft',
        category: 'Gaming',
        questionNumber: 3,
      ),

      const FandomTrivia(
        id: 'question_4',
        fandomId: 'gaming',
        question:
        'Who is the main character in The Legend of Zelda?',
        options: [
          'Mario',
          'Link',
          'Kirby',
          'Samus',
        ],
        correctAnswer: 'Link',
        category: 'Gaming',
        questionNumber: 4,
      ),

      const FandomTrivia(
        id: 'question_5',
        fandomId: 'gaming',
        question:
        'Which game is associated with the character Kratos?',
        options: [
          'God of War',
          'Halo',
          'FIFA',
          'Overwatch',
        ],
        correctAnswer: 'God of War',
        category: 'Gaming',
        questionNumber: 5,
      ),

      // =========================
      // MOVIES
      // =========================

      const FandomTrivia(
        id: 'question_1',
        fandomId: 'movies',
        question:
        'Which movie features Jack and Rose?',
        options: [
          'Avatar',
          'Titanic',
          'Inception',
          'Interstellar',
        ],
        correctAnswer: 'Titanic',
        category: 'Movies',
        questionNumber: 1,
      ),

      const FandomTrivia(
        id: 'question_2',
        fandomId: 'movies',
        question:
        'Who directed Jurassic Park?',
        options: [
          'James Cameron',
          'Steven Spielberg',
          'Christopher Nolan',
          'Peter Jackson',
        ],
        correctAnswer: 'Steven Spielberg',
        category: 'Movies',
        questionNumber: 2,
      ),

      const FandomTrivia(
        id: 'question_3',
        fandomId: 'movies',
        question:
        'Which movie features the character Neo?',
        options: [
          'The Matrix',
          'Avatar',
          'Gladiator',
          'Joker',
        ],
        correctAnswer: 'The Matrix',
        category: 'Movies',
        questionNumber: 3,
      ),

      const FandomTrivia(
        id: 'question_4',
        fandomId: 'movies',
        question:
        'Which movie features Middle-earth?',
        options: [
          'Harry Potter',
          'The Lord of the Rings',
          'Star Wars',
          'Dune',
        ],
        correctAnswer: 'The Lord of the Rings',
        category: 'Movies',
        questionNumber: 4,
      ),

      const FandomTrivia(
        id: 'question_5',
        fandomId: 'movies',
        question:
        'Which movie features the character Darth Vader?',
        options: [
          'Star Wars',
          'Dune',
          'Avatar',
          'The Matrix',
        ],
        correctAnswer: 'Star Wars',
        category: 'Movies',
        questionNumber: 5,
      ),
      const FandomTrivia(
        id: 'comic_question_1',
        fandomId: 'comic_books',
        question: 'Who is known as the Dark Knight?',
        options: [
          'Batman',
          'Superman',
          'Spider-Man',
          'Iron Man',
        ],
        correctAnswer: 'Batman',
        category: 'Comic Books',
        questionNumber: 1,
      ),

      const FandomTrivia(
        id: 'comic_question_2',
        fandomId: 'comic_books',
        question: 'What is Superman’s home planet?',
        options: [
          'Krypton',
          'Asgard',
          'Wakanda',
          'Xandar',
        ],
        correctAnswer: 'Krypton',
        category: 'Comic Books',
        questionNumber: 2,
      ),

      const FandomTrivia(
        id: 'comic_question_3',
        fandomId: 'comic_books',
        question: 'Which superhero uses a shield made of vibranium?',
        options: [
          'Captain America',
          'Thor',
          'Hulk',
          'Doctor Strange',
        ],
        correctAnswer: 'Captain America',
        category: 'Comic Books',
        questionNumber: 3,
      ),

      const FandomTrivia(
        id: 'comic_question_4',
        fandomId: 'comic_books',
        question: 'What is Spider-Man’s real name?',
        options: [
          'Peter Parker',
          'Bruce Wayne',
          'Clark Kent',
          'Matt Murdock',
        ],
        correctAnswer: 'Peter Parker',
        category: 'Comic Books',
        questionNumber: 4,
      ),

      const FandomTrivia(
        id: 'comic_question_5',
        fandomId: 'comic_books',
        question: 'Which villain is the archenemy of Batman?',
        options: [
          'Joker',
          'Thanos',
          'Green Goblin',
          'Lex Luthor',
        ],
        correctAnswer: 'Joker',
        category: 'Comic Books',
        questionNumber: 5,
      ),
      const FandomTrivia(
        id: 'pop_culture_question_1',
        fandomId: 'pop_culture',
        question: 'Which artist is known as the King of Pop?',
        options: [
          'Michael Jackson',
          'Elvis Presley',
          'Bruno Mars',
          'Justin Timberlake',
        ],
        correctAnswer: 'Michael Jackson',
        category: 'Pop Culture',
        questionNumber: 1,
      ),

      const FandomTrivia(
        id: 'pop_culture_question_2',
        fandomId: 'pop_culture',
        question: 'Which social media platform is known for short-form videos and trends?',
        options: [
          'TikTok',
          'LinkedIn',
          'Pinterest',
          'Reddit',
        ],
        correctAnswer: 'TikTok',
        category: 'Pop Culture',
        questionNumber: 2,
      ),

      const FandomTrivia(
        id: 'pop_culture_question_3',
        fandomId: 'pop_culture',
        question: 'Which singer released the song "Bad Guy"?',
        options: [
          'Billie Eilish',
          'Ariana Grande',
          'Dua Lipa',
          'Selena Gomez',
        ],
        correctAnswer: 'Billie Eilish',
        category: 'Pop Culture',
        questionNumber: 3,
      ),

      const FandomTrivia(
        id: 'pop_culture_question_4',
        fandomId: 'pop_culture',
        question: 'Which film series features the character Jack Sparrow?',
        options: [
          'Pirates of the Caribbean',
          'Fast & Furious',
          'The Hunger Games',
          'Mission: Impossible',
        ],
        correctAnswer: 'Pirates of the Caribbean',
        category: 'Pop Culture',
        questionNumber: 4,
      ),

      const FandomTrivia(
        id: 'pop_culture_question_5',
        fandomId: 'pop_culture',
        question: 'Which award is primarily associated with achievements in music?',
        options: [
          'Grammy Awards',
          'Emmy Awards',
          'Tony Awards',
          'Academy Awards',
        ],
        correctAnswer: 'Grammy Awards',
        category: 'Pop Culture',
        questionNumber: 5,
      ),
      const FandomTrivia(
        id: 'music_question_1',
        fandomId: 'music',
        question: 'Which artist is known as the King of Pop?',
        options: [
          'Michael Jackson',
          'Elvis Presley',
          'Usher',
          'Bruno Mars',
        ],
        correctAnswer: 'Michael Jackson',
        category: 'Music',
        questionNumber: 1,
      ),

      const FandomTrivia(
        id: 'music_question_2',
        fandomId: 'music',
        question: 'Which instrument has 88 keys?',
        options: [
          'Piano',
          'Guitar',
          'Violin',
          'Drums',
        ],
        correctAnswer: 'Piano',
        category: 'Music',
        questionNumber: 2,
      ),

      const FandomTrivia(
        id: 'music_question_3',
        fandomId: 'music',
        question: 'Which Nigerian artist released the hit song "Essence" with Tems?',
        options: [
          'Wizkid',
          'Davido',
          'Burna Boy',
          'Olamide',
        ],
        correctAnswer: 'Wizkid',
        category: 'Music',
        questionNumber: 3,
      ),

      const FandomTrivia(
        id: 'music_question_4',
        fandomId: 'music',
        question: 'Which award is one of the most famous awards in the music industry?',
        options: [
          'Grammy Awards',
          'Emmy Awards',
          'Oscar Awards',
          'Tony Awards',
        ],
        correctAnswer: 'Grammy Awards',
        category: 'Music',
        questionNumber: 4,
      ),

      const FandomTrivia(
        id: 'music_question_5',
        fandomId: 'music',
        question: 'Which singer is known for the album "21"?',
        options: [
          'Adele',
          'Rihanna',
          'Taylor Swift',
          'Beyoncé',
        ],
        correctAnswer: 'Adele',
        category: 'Music',
        questionNumber: 5,
      ),
      const FandomTrivia(
        id: 'tv_universes_question_1',
        fandomId: 'tv_universes',
        question: 'In which TV universe does the character Eleven appear?',
        options: [
          'Stranger Things',
          'The Walking Dead',
          'Wednesday',
          'The Vampire Diaries',
        ],
        correctAnswer: 'Stranger Things',
        category: 'TV Universes',
        questionNumber: 1,
      ),

      const FandomTrivia(
        id: 'tv_universes_question_2',
        fandomId: 'tv_universes',
        question: 'What is the name of the town where Stranger Things is set?',
        options: [
          'Hawkins',
          'Riverdale',
          'Sunnydale',
          'Mystic Falls',
        ],
        correctAnswer: 'Hawkins',
        category: 'TV Universes',
        questionNumber: 2,
      ),

      const FandomTrivia(
        id: 'tv_universes_question_3',
        fandomId: 'tv_universes',
        question: 'Which TV series follows the survivors of a zombie apocalypse?',
        options: [
          'The Walking Dead',
          'The Flash',
          'Friends',
          'Wednesday',
        ],
        correctAnswer: 'The Walking Dead',
        category: 'TV Universes',
        questionNumber: 3,
      ),

      const FandomTrivia(
        id: 'tv_universes_question_4',
        fandomId: 'tv_universes',
        question: 'What is Wednesday Addams known for in the series Wednesday?',
        options: [
          'Her dark personality',
          'Her super speed',
          'Her magic hammer',
          'Her detective badge',
        ],
        correctAnswer: 'Her dark personality',
        category: 'TV Universes',
        questionNumber: 4,
      ),
      const FandomTrivia(
        id: 'tv_universes_question_5',
        fandomId: 'tv_universes',
        question: 'Which fictional town is home to the Salvatore brothers in The Vampire Diaries?',
        options: [
          'Mystic Falls',
          'Hawkins',
          'Riverdale',
          'Gotham',
        ],
        correctAnswer: 'Mystic Falls',
        category: 'TV Universes',
        questionNumber: 5,
      ),
    ];


    for (final question in trivia) {
      await _triviaService.addTrivia(question);
    }
  }
}