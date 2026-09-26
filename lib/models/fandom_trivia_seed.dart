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
    ];

    for (final question in trivia) {
      await _triviaService.addTrivia(question);
    }
  }
}