import 'package:flutter/material.dart';

import '../models/merchandise/category_model.dart';
import '../models/merchandise/product_model.dart';

class MerchandiseMock {
  MerchandiseMock._();

  // =====================================================
  // PRODUCT IMAGE URL
  // =====================================================

  static String imageFor(String productName) {
    String prompt;

    switch (productName) {
    // =====================================================
    // FIGURES & STATUES
    // =====================================================

      case 'Luffy Grand Line Figure':
        prompt =
        'One Piece anime, Monkey D. Luffy, Grand Line collectible action figure, anime merchandise product photo, detailed figure, standing pose, studio product photography, square image';
        break;

      case 'Gojo Satoru Figure':
      case 'Gojo Satoru Collectible Figure':
        prompt =
        'Jujutsu Kaisen anime, Satoru Gojo collectible figure, white hair, blindfold, blue eyes, detailed premium anime merchandise product photo, studio photography, square image';
        break;

      case 'Naruto Sage Mode Figure':
        prompt =
        'Naruto anime, Naruto Uzumaki Sage Mode collectible figure, orange ninja outfit, sage mode eyes, detailed anime merchandise product photo, studio background, square image';
        break;

      case 'Tanjiro Kamado Figure':
        prompt =
        'Demon Slayer anime, Tanjiro Kamado collectible figure, green black checkered haori, detailed anime merchandise product photo, studio background, square image';
        break;

      case 'Nezuko Kamado Figure':
        prompt =
        'Demon Slayer anime, Nezuko Kamado collectible figure, pink kimono, bamboo muzzle, detailed anime merchandise product photo, studio background, square image';
        break;

      case 'Itachi Uchiha Figure':
        prompt =
        'Naruto anime, Itachi Uchiha collectible figure, Akatsuki cloak, red Sharingan eyes, detailed anime merchandise product photo, studio background, square image';
        break;

      case 'Killua Zoldyck Figure':
        prompt =
        'Hunter x Hunter anime, Killua Zoldyck collectible figure, white hair, blue outfit, detailed anime merchandise product photo, studio background, square image';
        break;

      case 'Goku Super Saiyan Figure':
        prompt =
        'Dragon Ball anime, Goku Super Saiyan collectible figure, golden hair, orange gi, detailed anime merchandise product photo, studio background, square image';
        break;

      case 'Levi Ackerman Figure':
        prompt =
        'Attack on Titan anime, Levi Ackerman collectible figure, Survey Corps uniform, detailed anime merchandise product photo, studio background, square image';
        break;

      case 'Sukuna Collectible Figure':
        prompt =
        'Jujutsu Kaisen anime, Ryomen Sukuna collectible figure, pink hair, cursed markings, detailed anime merchandise product photo, studio background, square image';
        break;

    // =====================================================
    // MANGA
    // =====================================================

      case 'One Piece Manga Vol 1':
        prompt =
        'One Piece manga volume 1 book, Monkey D. Luffy, manga book product photo, Japanese manga cover, clean retail product photography, square image';
        break;

      case 'Naruto Manga Vol 1':
        prompt =
        'Naruto manga volume 1 book, Naruto Uzumaki, manga book product photo, Japanese manga cover, clean retail product photography, square image';
        break;

      case 'Jujutsu Kaisen Manga Vol 1':
        prompt =
        'Jujutsu Kaisen manga volume 1 book, Yuji Itadori, Japanese manga book product photo, clean retail product photography, square image';
        break;

      case 'Demon Slayer Manga Vol 1':
        prompt =
        'Demon Slayer manga volume 1 book, Tanjiro Kamado, Japanese manga book product photo, clean retail product photography, square image';
        break;

      case 'My Hero Academia Manga Vol 1':
        prompt =
        'My Hero Academia manga volume 1 book, Izuku Midoriya, anime manga cover, clean retail product photography, square image';
        break;

      case 'Chainsaw Man Manga Vol 1':
        prompt =
        'Chainsaw Man manga volume 1 book, Denji, chainsaw anime manga cover, clean retail product photography, square image';
        break;

      case 'Spy x Family Manga Vol 1':
        prompt =
        'Spy x Family manga volume 1 book, Anya Forger, Loid Forger and Yor Forger, manga book product photo, square image';
        break;

      case 'Blue Lock Manga Vol 1':
        prompt =
        'Blue Lock manga volume 1 book, Isagi Yoichi, football anime manga, clean retail product photography, square image';
        break;

      case 'Solo Leveling Manga Vol 1':
        prompt =
        'Solo Leveling manga volume 1 book, Sung Jinwoo, dark fantasy manga cover, clean retail product photography, square image';
        break;

      case 'Attack on Titan Manga Vol 1':
        prompt =
        'Attack on Titan manga volume 1 book, Eren Yeager, Titans, manga book product photo, clean retail product photography, square image';
        break;

    // =====================================================
    // TRADING CARDS
    // =====================================================

      case 'One Piece Trading Card Pack':
        prompt =
        'One Piece anime trading card booster pack, Monkey D. Luffy, colorful collectible trading cards, sealed card pack, premium merchandise product photo, square image';
        break;

      case 'Naruto Trading Card Pack':
        prompt =
        'Naruto anime trading card booster pack, Naruto Uzumaki, colorful collectible cards, sealed card pack, premium merchandise product photo, square image';
        break;

      case 'Dragon Ball Trading Card Pack':
        prompt =
        'Dragon Ball anime trading card booster pack, Goku Super Saiyan, colorful collectible cards, sealed card pack, premium merchandise product photo, square image';
        break;

      case 'Jujutsu Kaisen Card Pack':
        prompt =
        'Jujutsu Kaisen anime trading card booster pack, Satoru Gojo and Yuji Itadori, collectible card pack, premium merchandise product photo, square image';
        break;

      case 'Demon Slayer Card Pack':
        prompt =
        'Demon Slayer anime trading card booster pack, Tanjiro and Nezuko, collectible card pack, premium merchandise product photo, square image';
        break;

    // =====================================================
    // POSTERS & ART
    // =====================================================

      case 'Gojo Satoru Art Poster':
        prompt =
        'Jujutsu Kaisen Satoru Gojo anime wall poster, premium anime art print, Gojo character artwork, framed poster product photo, square image';
        break;

      case 'Luffy Wanted Poster':
        prompt =
        'One Piece Monkey D. Luffy wanted poster, pirate bounty poster, anime wall art, vintage paper style, merchandise product photo, square image';
        break;

      case 'Naruto Character Poster':
        prompt =
        'Naruto anime character wall poster, Naruto Uzumaki artwork, premium anime art print, merchandise product photo, square image';
        break;

      case 'Demon Slayer Art Print':
        prompt =
        'Demon Slayer anime art print, Tanjiro and Nezuko artwork, premium wall art, Japanese anime merchandise, square image';
        break;

      case 'Attack on Titan Wall Art':
        prompt =
        'Attack on Titan anime wall art, Levi and Survey Corps artwork, premium poster, anime merchandise product photo, square image';
        break;

    // =====================================================
    // ACCESSORIES
    // =====================================================

      case 'Anime Character Keychain':
        prompt =
        'cute anime character keychain merchandise, colorful Japanese anime keychain, collectible accessory product photo, clean background, square image';
        break;

      case 'Gojo Chibi Keychain':
        prompt =
        'Jujutsu Kaisen Satoru Gojo chibi keychain, cute anime accessory, collectible merchandise product photo, clean studio background, square image';
        break;

      case 'Luffy Keychain':
        prompt =
        'One Piece Monkey D. Luffy keychain, cute anime accessory, collectible merchandise product photo, clean studio background, square image';
        break;

      case 'Naruto Kunai Keychain':
        prompt =
        'Naruto anime kunai keychain, ninja accessory, Naruto merchandise, collectible product photo, clean studio background, square image';
        break;

      case 'Nezuko Keychain':
        prompt =
        'Demon Slayer Nezuko Kamado keychain, cute anime accessory, collectible merchandise product photo, clean studio background, square image';
        break;

    // =====================================================
    // COLLECTIBLES
    // =====================================================

      case 'Anime Mystery Box':
        prompt =
        'anime mystery box, Japanese anime collectible mystery box, colorful sealed gift box filled with anime collectibles, product photography, square image';
        break;

      case 'One Piece Mystery Box':
        prompt =
        'One Piece anime mystery box, Luffy themed collectible gift box, pirate anime merchandise, sealed mystery box, product photography, square image';
        break;

      case 'Jujutsu Kaisen Mystery Box':
        prompt =
        'Jujutsu Kaisen anime mystery box, Gojo and Yuji themed collectible gift box, sealed anime merchandise box, product photography, square image';
        break;

      case 'Anime Mini Statue':
        prompt =
        'anime mini statue collectible, detailed Japanese anime character statue, premium collectible merchandise, studio product photography, square image';
        break;

      case 'Demon Slayer Collectible Set':
        prompt =
        'Demon Slayer anime collectible set, Tanjiro Nezuko anime figures, premium boxed merchandise set, studio product photography, square image';
        break;

    // =====================================================
    // LIMITED EDITION
    // =====================================================

      case 'Limited Edition Gojo Figure':
        prompt =
        'limited edition Satoru Gojo figure from Jujutsu Kaisen, premium collector statue, luxury anime merchandise, collector box, studio product photography, square image';
        break;

      case 'Limited Edition Luffy Figure':
        prompt =
        'limited edition Monkey D. Luffy figure from One Piece, premium collector statue, luxury anime merchandise, collector box, studio product photography, square image';
        break;

      case 'Naruto Collector Set':
        prompt =
        'Naruto anime collector set, Naruto Uzumaki premium figures and accessories, collector box, limited anime merchandise, studio product photography, square image';
        break;

      case 'Attack on Titan Collector Set':
        prompt =
        'Attack on Titan anime collector set, Levi and Survey Corps figures, premium collector box, limited anime merchandise, studio product photography, square image';
        break;

      case 'Dragon Ball Collector Set':
        prompt =
        'Dragon Ball anime collector set, Goku Super Saiyan figures and accessories, premium collector box, limited anime merchandise, studio product photography, square image';
        break;

    // =====================================================
    // ANIME GIFTS
    // =====================================================

      case 'Anime Sticker Collection':
        prompt =
        'anime sticker collection gift set, colorful Japanese anime character stickers, cute collectible gift pack, merchandise product photo, square image';
        break;

      case 'Anime Bookmark Set':
        prompt =
        'anime bookmark gift set, colorful Japanese anime character bookmarks, manga reader accessories, premium gift pack, merchandise product photo, square image';
        break;

      case 'Manga Reader Gift Set':
        prompt =
        'manga reader anime gift set, manga accessories, bookmarks, stickers and anime stationery, premium gift box, Japanese anime merchandise, square image';
        break;

      case 'Anime Collector Gift Box':
        prompt =
        'anime collector gift box, premium anime merchandise gift box, figures, stickers, keychain and collectibles inside, attractive retail product photography, square image';
        break;

      case 'FandomVerse Mystery Gift Box':
        prompt =
        'FandomVerse anime mystery gift box, premium anime collectible gift box, colorful mysterious packaging, anime merchandise, product photography, square image';
        break;

      default:
        prompt =
        'premium anime merchandise product, Japanese anime collectible, colorful studio product photography, square image';
    }

    final encodedPrompt = Uri.encodeComponent(
      '$prompt, no text, no watermark, clean background, high quality',
    );

    final seed = productName.codeUnits.fold<int>(
      0,
          (total, code) => total + code,
    );

    // IMPORTANT:
    // This is a direct URL. Do not wrap it in Markdown.
    return 'https://image.pollinations.ai/prompt/$encodedPrompt'
        '?width=600'
        '&height=600'
        '&seed=$seed'
        '&nologo=true';
  }

  // =====================================================
  // PRODUCTS
  // =====================================================

  static final List<ProductModel> products = [
    // FIGURES

    ProductModel(
      id: 'anime_001',
      name: 'Luffy Grand Line Figure',
      price: 28000,
      imageUrl: imageFor('Luffy Grand Line Figure'),
      category: 'Figures',
    ),
    ProductModel(
      id: 'anime_002',
      name: 'Gojo Satoru Collectible Figure',
      price: 35000,
      imageUrl: imageFor('Gojo Satoru Figure'),
      category: 'Figures',
    ),
    ProductModel(
      id: 'anime_003',
      name: 'Naruto Sage Mode Figure',
      price: 30000,
      imageUrl: imageFor('Naruto Sage Mode Figure'),
      category: 'Figures',
    ),
    ProductModel(
      id: 'anime_004',
      name: 'Tanjiro Kamado Figure',
      price: 27000,
      imageUrl: imageFor('Tanjiro Kamado Figure'),
      category: 'Figures',
    ),
    ProductModel(
      id: 'anime_005',
      name: 'Nezuko Kamado Figure',
      price: 26000,
      imageUrl: imageFor('Nezuko Kamado Figure'),
      category: 'Figures',
    ),
    ProductModel(
      id: 'anime_006',
      name: 'Itachi Uchiha Figure',
      price: 32000,
      imageUrl: imageFor('Itachi Uchiha Figure'),
      category: 'Figures',
    ),
    ProductModel(
      id: 'anime_007',
      name: 'Killua Zoldyck Figure',
      price: 29000,
      imageUrl: imageFor('Killua Zoldyck Figure'),
      category: 'Figures',
    ),
    ProductModel(
      id: 'anime_008',
      name: 'Goku Super Saiyan Figure',
      price: 38000,
      imageUrl: imageFor('Goku Super Saiyan Figure'),
      category: 'Figures',
    ),
    ProductModel(
      id: 'anime_009',
      name: 'Levi Ackerman Figure',
      price: 34000,
      imageUrl: imageFor('Levi Ackerman Figure'),
      category: 'Figures',
    ),
    ProductModel(
      id: 'anime_010',
      name: 'Sukuna Collectible Figure',
      price: 36000,
      imageUrl: imageFor('Sukuna Collectible Figure'),
      category: 'Figures',
    ),

    // MANGA

    ProductModel(
      id: 'anime_011',
      name: 'One Piece Manga Vol. 1',
      price: 6500,
      imageUrl: imageFor('One Piece Manga Vol 1'),
      category: 'Manga',
    ),
    ProductModel(
      id: 'anime_012',
      name: 'Naruto Manga Vol. 1',
      price: 6000,
      imageUrl: imageFor('Naruto Manga Vol 1'),
      category: 'Manga',
    ),
    ProductModel(
      id: 'anime_013',
      name: 'Jujutsu Kaisen Manga Vol. 1',
      price: 7000,
      imageUrl: imageFor('Jujutsu Kaisen Manga Vol 1'),
      category: 'Manga',
    ),
    ProductModel(
      id: 'anime_014',
      name: 'Demon Slayer Manga Vol. 1',
      price: 6500,
      imageUrl: imageFor('Demon Slayer Manga Vol 1'),
      category: 'Manga',
    ),
    ProductModel(
      id: 'anime_015',
      name: 'My Hero Academia Manga Vol. 1',
      price: 6000,
      imageUrl: imageFor('My Hero Academia Manga Vol 1'),
      category: 'Manga',
    ),
    ProductModel(
      id: 'anime_016',
      name: 'Chainsaw Man Manga Vol. 1',
      price: 7000,
      imageUrl: imageFor('Chainsaw Man Manga Vol 1'),
      category: 'Manga',
    ),
    ProductModel(
      id: 'anime_017',
      name: 'Spy x Family Manga Vol. 1',
      price: 6500,
      imageUrl: imageFor('Spy x Family Manga Vol 1'),
      category: 'Manga',
    ),
    ProductModel(
      id: 'anime_018',
      name: 'Blue Lock Manga Vol. 1',
      price: 7000,
      imageUrl: imageFor('Blue Lock Manga Vol 1'),
      category: 'Manga',
    ),
    ProductModel(
      id: 'anime_019',
      name: 'Solo Leveling Manga Vol. 1',
      price: 7500,
      imageUrl: imageFor('Solo Leveling Manga Vol 1'),
      category: 'Manga',
    ),
    ProductModel(
      id: 'anime_020',
      name: 'Attack on Titan Manga Vol. 1',
      price: 7000,
      imageUrl: imageFor('Attack on Titan Manga Vol 1'),
      category: 'Manga',
    ),

    // TRADING CARDS

    ProductModel(
      id: 'anime_021',
      name: 'One Piece Trading Card Pack',
      price: 4500,
      imageUrl: imageFor('One Piece Trading Card Pack'),
      category: 'Trading Cards',
    ),
    ProductModel(
      id: 'anime_022',
      name: 'Naruto Trading Card Pack',
      price: 4000,
      imageUrl: imageFor('Naruto Trading Card Pack'),
      category: 'Trading Cards',
    ),
    ProductModel(
      id: 'anime_023',
      name: 'Dragon Ball Trading Card Pack',
      price: 5000,
      imageUrl: imageFor('Dragon Ball Trading Card Pack'),
      category: 'Trading Cards',
    ),
    ProductModel(
      id: 'anime_024',
      name: 'Jujutsu Kaisen Card Pack',
      price: 4500,
      imageUrl: imageFor('Jujutsu Kaisen Card Pack'),
      category: 'Trading Cards',
    ),
    ProductModel(
      id: 'anime_025',
      name: 'Demon Slayer Card Pack',
      price: 4500,
      imageUrl: imageFor('Demon Slayer Card Pack'),
      category: 'Trading Cards',
    ),

    // POSTERS & ART

    ProductModel(
      id: 'anime_026',
      name: 'Gojo Satoru Art Poster',
      price: 8500,
      imageUrl: imageFor('Gojo Satoru Art Poster'),
      category: 'Posters & Art',
    ),
    ProductModel(
      id: 'anime_027',
      name: 'Luffy Wanted Poster',
      price: 7500,
      imageUrl: imageFor('Luffy Wanted Poster'),
      category: 'Posters & Art',
    ),
    ProductModel(
      id: 'anime_028',
      name: 'Naruto Character Poster',
      price: 7500,
      imageUrl: imageFor('Naruto Character Poster'),
      category: 'Posters & Art',
    ),
    ProductModel(
      id: 'anime_029',
      name: 'Demon Slayer Art Print',
      price: 8000,
      imageUrl: imageFor('Demon Slayer Art Print'),
      category: 'Posters & Art',
    ),
    ProductModel(
      id: 'anime_030',
      name: 'Attack on Titan Wall Art',
      price: 9000,
      imageUrl: imageFor('Attack on Titan Wall Art'),
      category: 'Posters & Art',
    ),

    // ACCESSORIES

    ProductModel(
      id: 'anime_031',
      name: 'Anime Character Keychain',
      price: 2500,
      imageUrl: imageFor('Anime Character Keychain'),
      category: 'Accessories',
    ),
    ProductModel(
      id: 'anime_032',
      name: 'Gojo Chibi Keychain',
      price: 3000,
      imageUrl: imageFor('Gojo Chibi Keychain'),
      category: 'Accessories',
    ),
    ProductModel(
      id: 'anime_033',
      name: 'Luffy Keychain',
      price: 2800,
      imageUrl: imageFor('Luffy Keychain'),
      category: 'Accessories',
    ),
    ProductModel(
      id: 'anime_034',
      name: 'Naruto Kunai Keychain',
      price: 3500,
      imageUrl: imageFor('Naruto Kunai Keychain'),
      category: 'Accessories',
    ),
    ProductModel(
      id: 'anime_035',
      name: 'Nezuko Keychain',
      price: 2800,
      imageUrl: imageFor('Nezuko Keychain'),
      category: 'Accessories',
    ),

    // COLLECTIBLES

    ProductModel(
      id: 'anime_036',
      name: 'Anime Mystery Box',
      price: 12000,
      imageUrl: imageFor('Anime Mystery Box'),
      category: 'Collectibles',
    ),
    ProductModel(
      id: 'anime_037',
      name: 'One Piece Mystery Box',
      price: 15000,
      imageUrl: imageFor('One Piece Mystery Box'),
      category: 'Collectibles',
    ),
    ProductModel(
      id: 'anime_038',
      name: 'Jujutsu Kaisen Mystery Box',
      price: 15000,
      imageUrl: imageFor('Jujutsu Kaisen Mystery Box'),
      category: 'Collectibles',
    ),
    ProductModel(
      id: 'anime_039',
      name: 'Anime Mini Statue',
      price: 18000,
      imageUrl: imageFor('Anime Mini Statue'),
      category: 'Collectibles',
    ),
    ProductModel(
      id: 'anime_040',
      name: 'Demon Slayer Collectible Set',
      price: 22000,
      imageUrl: imageFor('Demon Slayer Collectible Set'),
      category: 'Collectibles',
    ),

    // LIMITED EDITION

    ProductModel(
      id: 'anime_041',
      name: 'Limited Edition Gojo Figure',
      price: 55000,
      imageUrl: imageFor('Limited Edition Gojo Figure'),
      category: 'Limited Edition',
    ),
    ProductModel(
      id: 'anime_042',
      name: 'Limited Edition Luffy Figure',
      price: 60000,
      imageUrl: imageFor('Limited Edition Luffy Figure'),
      category: 'Limited Edition',
    ),
    ProductModel(
      id: 'anime_043',
      name: 'Naruto Collector Set',
      price: 48000,
      imageUrl: imageFor('Naruto Collector Set'),
      category: 'Limited Edition',
    ),
    ProductModel(
      id: 'anime_044',
      name: 'Attack on Titan Collector Set',
      price: 52000,
      imageUrl: imageFor('Attack on Titan Collector Set'),
      category: 'Limited Edition',
    ),
    ProductModel(
      id: 'anime_045',
      name: 'Dragon Ball Collector Set',
      price: 58000,
      imageUrl: imageFor('Dragon Ball Collector Set'),
      category: 'Limited Edition',
    ),

    // ANIME GIFTS

    ProductModel(
      id: 'anime_046',
      name: 'Anime Sticker Collection',
      price: 2500,
      imageUrl: imageFor('Anime Sticker Collection'),
      category: 'Anime Gifts',
    ),
    ProductModel(
      id: 'anime_047',
      name: 'Anime Bookmark Set',
      price: 3000,
      imageUrl: imageFor('Anime Bookmark Set'),
      category: 'Anime Gifts',
    ),
    ProductModel(
      id: 'anime_048',
      name: 'Manga Reader Gift Set',
      price: 10000,
      imageUrl: imageFor('Manga Reader Gift Set'),
      category: 'Anime Gifts',
    ),
    ProductModel(
      id: 'anime_049',
      name: 'Anime Collector Gift Box',
      price: 18000,
      imageUrl: imageFor('Anime Collector Gift Box'),
      category: 'Anime Gifts',
    ),
    ProductModel(
      id: 'anime_050',
      name: 'FandomVerse Mystery Gift Box',
      price: 20000,
      imageUrl: imageFor('FandomVerse Mystery Gift Box'),
      category: 'Anime Gifts',
    ),
  ];

  // =====================================================
  // CATEGORIES
  // =====================================================

  static const List<CategoryModel> categories = [
    CategoryModel(
      id: 'all',
      name: 'All',
      icon: Icons.grid_view,
    ),
    CategoryModel(
      id: 'figures',
      name: 'Figures',
      icon: Icons.toys_outlined,
    ),
    CategoryModel(
      id: 'manga',
      name: 'Manga',
      icon: Icons.menu_book_outlined,
    ),
    CategoryModel(
      id: 'trading_cards',
      name: 'Trading Cards',
      icon: Icons.style_outlined,
    ),
    CategoryModel(
      id: 'posters_art',
      name: 'Posters & Art',
      icon: Icons.image_outlined,
    ),
    CategoryModel(
      id: 'accessories',
      name: 'Accessories',
      icon: Icons.key_outlined,
    ),
    CategoryModel(
      id: 'collectibles',
      name: 'Collectibles',
      icon: Icons.collections_bookmark_outlined,
    ),
    CategoryModel(
      id: 'limited_edition',
      name: 'Limited Edition',
      icon: Icons.workspace_premium_outlined,
    ),
    CategoryModel(
      id: 'anime_gifts',
      name: 'Anime Gifts',
      icon: Icons.card_giftcard_outlined,
    ),
  ];
}