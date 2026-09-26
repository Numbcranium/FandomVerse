import 'package:flutter/material.dart';

import '../models/merchandise/category_model.dart';
import '../models/merchandise/product_model.dart';

class MerchandiseMock {
  MerchandiseMock._();

  // =====================================================
  // MERCHANDISE CATEGORIES
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

  // =====================================================
  // PRODUCTS
  // =====================================================

  static final List<ProductModel> products = [
    // =====================================================
    // FIGURES
    // =====================================================

    ProductModel(
      id: 'anime_001',
      name: 'Luffy Grand Line Figure',
      category: 'Figures',
      price: 25000,
      imageUrl: imageFor('Luffy Grand Line Figure'),
    ),
    ProductModel(
      id: 'anime_002',
      name: 'Gojo Satoru Figure',
      category: 'Figures',
      price: 30000,
      imageUrl: imageFor('Gojo Satoru Figure'),
    ),
    ProductModel(
      id: 'anime_003',
      name: 'Naruto Sage Mode Figure',
      category: 'Figures',
      price: 28000,
      imageUrl: imageFor('Naruto Sage Mode Figure'),
    ),
    ProductModel(
      id: 'anime_004',
      name: 'Tanjiro Kamado Figure',
      category: 'Figures',
      price: 27000,
      imageUrl: imageFor('Tanjiro Kamado Figure'),
    ),
    ProductModel(
      id: 'anime_005',
      name: 'Nezuko Kamado Figure',
      category: 'Figures',
      price: 27000,
      imageUrl: imageFor('Nezuko Kamado Figure'),
    ),
    ProductModel(
      id: 'anime_006',
      name: 'Itachi Uchiha Figure',
      category: 'Figures',
      price: 29000,
      imageUrl: imageFor('Itachi Uchiha Figure'),
    ),
    ProductModel(
      id: 'anime_007',
      name: 'Killua Zoldyck Figure',
      category: 'Figures',
      price: 26000,
      imageUrl: imageFor('Killua Zoldyck Figure'),
    ),
    ProductModel(
      id: 'anime_008',
      name: 'Goku Super Saiyan Figure',
      category: 'Figures',
      price: 32000,
      imageUrl: imageFor('Goku Super Saiyan Figure'),
    ),
    ProductModel(
      id: 'anime_009',
      name: 'Levi Ackerman Figure',
      category: 'Figures',
      price: 30000,
      imageUrl: imageFor('Levi Ackerman Figure'),
    ),
    ProductModel(
      id: 'anime_010',
      name: 'Sukuna Collectible Figure',
      category: 'Figures',
      price: 31000,
      imageUrl: imageFor('Sukuna Collectible Figure'),
    ),

    // =====================================================
    // MANGA
    // =====================================================

    ProductModel(
      id: 'anime_011',
      name: 'One Piece Manga Vol 1',
      category: 'Manga',
      price: 8500,
      imageUrl: imageFor('One Piece Manga Vol 1'),
    ),
    ProductModel(
      id: 'anime_012',
      name: 'Naruto Manga Vol 1',
      category: 'Manga',
      price: 8500,
      imageUrl: imageFor('Naruto Manga Vol 1'),
    ),
    ProductModel(
      id: 'anime_013',
      name: 'Jujutsu Kaisen Manga Vol 1',
      category: 'Manga',
      price: 9000,
      imageUrl: imageFor('Jujutsu Kaisen Manga Vol 1'),
    ),
    ProductModel(
      id: 'anime_014',
      name: 'Demon Slayer Manga Vol 1',
      category: 'Manga',
      price: 9000,
      imageUrl: imageFor('Demon Slayer Manga Vol 1'),
    ),
    ProductModel(
      id: 'anime_015',
      name: 'My Hero Academia Manga Vol 1',
      category: 'Manga',
      price: 8500,
      imageUrl: imageFor('My Hero Academia Manga Vol 1'),
    ),
    ProductModel(
      id: 'anime_016',
      name: 'Chainsaw Man Manga Vol 1',
      category: 'Manga',
      price: 9000,
      imageUrl: imageFor('Chainsaw Man Manga Vol 1'),
    ),
    ProductModel(
      id: 'anime_017',
      name: 'Spy x Family Manga Vol 1',
      category: 'Manga',
      price: 9000,
      imageUrl: imageFor('Spy x Family Manga Vol 1'),
    ),
    ProductModel(
      id: 'anime_018',
      name: 'Blue Lock Manga Vol 1',
      category: 'Manga',
      price: 9500,
      imageUrl: imageFor('Blue Lock Manga Vol 1'),
    ),
    ProductModel(
      id: 'anime_019',
      name: 'Solo Leveling Manga Vol 1',
      category: 'Manga',
      price: 9500,
      imageUrl: imageFor('Solo Leveling Manga Vol 1'),
    ),
    ProductModel(
      id: 'anime_020',
      name: 'Attack on Titan Manga Vol 1',
      category: 'Manga',
      price: 9000,
      imageUrl: imageFor('Attack on Titan Manga Vol 1'),
    ),

    // =====================================================
    // TRADING CARDS
    // =====================================================

    ProductModel(
      id: 'anime_021',
      name: 'One Piece Trading Card Pack',
      category: 'Trading Cards',
      price: 5000,
      imageUrl: imageFor('One Piece Trading Card Pack'),
    ),
    ProductModel(
      id: 'anime_022',
      name: 'Naruto Trading Card Pack',
      category: 'Trading Cards',
      price: 5000,
      imageUrl: imageFor('Naruto Trading Card Pack'),
    ),
    ProductModel(
      id: 'anime_023',
      name: 'Dragon Ball Trading Card Pack',
      category: 'Trading Cards',
      price: 5500,
      imageUrl: imageFor('Dragon Ball Trading Card Pack'),
    ),
    ProductModel(
      id: 'anime_024',
      name: 'Jujutsu Kaisen Card Pack',
      category: 'Trading Cards',
      price: 5500,
      imageUrl: imageFor('Jujutsu Kaisen Card Pack'),
    ),
    ProductModel(
      id: 'anime_025',
      name: 'Demon Slayer Card Pack',
      category: 'Trading Cards',
      price: 5500,
      imageUrl: imageFor('Demon Slayer Card Pack'),
    ),

    // =====================================================
    // POSTERS & ART
    // =====================================================

    ProductModel(
      id: 'anime_026',
      name: 'Gojo Satoru Art Poster',
      category: 'Posters & Art',
      price: 7000,
      imageUrl: imageFor('Gojo Satoru Art Poster'),
    ),
    ProductModel(
      id: 'anime_027',
      name: 'Luffy Wanted Poster',
      category: 'Posters & Art',
      price: 6500,
      imageUrl: imageFor('Luffy Wanted Poster'),
    ),
    ProductModel(
      id: 'anime_028',
      name: 'Naruto Character Poster',
      category: 'Posters & Art',
      price: 6500,
      imageUrl: imageFor('Naruto Character Poster'),
    ),
    ProductModel(
      id: 'anime_029',
      name: 'Demon Slayer Art Print',
      category: 'Posters & Art',
      price: 7000,
      imageUrl: imageFor('Demon Slayer Art Print'),
    ),
    ProductModel(
      id: 'anime_030',
      name: 'Attack on Titan Wall Art',
      category: 'Posters & Art',
      price: 7500,
      imageUrl: imageFor('Attack on Titan Wall Art'),
    ),

    // =====================================================
    // ACCESSORIES
    // =====================================================

    ProductModel(
      id: 'anime_031',
      name: 'Anime Character Keychain',
      category: 'Accessories',
      price: 3000,
      imageUrl: imageFor('Anime Character Keychain'),
    ),
    ProductModel(
      id: 'anime_032',
      name: 'Gojo Chibi Keychain',
      category: 'Accessories',
      price: 3500,
      imageUrl: imageFor('Gojo Chibi Keychain'),
    ),
    ProductModel(
      id: 'anime_033',
      name: 'Luffy Keychain',
      category: 'Accessories',
      price: 3000,
      imageUrl: imageFor('Luffy Keychain'),
    ),
    ProductModel(
      id: 'anime_034',
      name: 'Naruto Kunai Keychain',
      category: 'Accessories',
      price: 3000,
      imageUrl: imageFor('Naruto Kunai Keychain'),
    ),
    ProductModel(
      id: 'anime_035',
      name: 'Nezuko Keychain',
      category: 'Accessories',
      price: 3500,
      imageUrl: imageFor('Nezuko Keychain'),
    ),

    // =====================================================
    // COLLECTIBLES
    // =====================================================

    ProductModel(
      id: 'anime_036',
      name: 'Anime Mystery Box',
      category: 'Collectibles',
      price: 15000,
      imageUrl: imageFor('Anime Mystery Box'),
    ),
    ProductModel(
      id: 'anime_037',
      name: 'One Piece Mystery Box',
      category: 'Collectibles',
      price: 18000,
      imageUrl: imageFor('One Piece Mystery Box'),
    ),
    ProductModel(
      id: 'anime_038',
      name: 'Jujutsu Kaisen Mystery Box',
      category: 'Collectibles',
      price: 18000,
      imageUrl: imageFor('Jujutsu Kaisen Mystery Box'),
    ),
    ProductModel(
      id: 'anime_039',
      name: 'Anime Mini Statue',
      category: 'Collectibles',
      price: 12000,
      imageUrl: imageFor('Anime Mini Statue'),
    ),
    ProductModel(
      id: 'anime_040',
      name: 'Demon Slayer Collectible Set',
      category: 'Collectibles',
      price: 22000,
      imageUrl: imageFor('Demon Slayer Collectible Set'),
    ),

    // =====================================================
    // LIMITED EDITION
    // =====================================================

    ProductModel(
      id: 'anime_041',
      name: 'Limited Edition Gojo Figure',
      category: 'Limited Edition',
      price: 50000,
      imageUrl: imageFor('Limited Edition Gojo Figure'),
    ),
    ProductModel(
      id: 'anime_042',
      name: 'Limited Edition Luffy Figure',
      category: 'Limited Edition',
      price: 50000,
      imageUrl: imageFor('Limited Edition Luffy Figure'),
    ),
    ProductModel(
      id: 'anime_043',
      name: 'Naruto Collector Set',
      category: 'Limited Edition',
      price: 45000,
      imageUrl: imageFor('Naruto Collector Set'),
    ),
    ProductModel(
      id: 'anime_044',
      name: 'Attack on Titan Collector Set',
      category: 'Limited Edition',
      price: 48000,
      imageUrl: imageFor('Attack on Titan Collector Set'),
    ),
    ProductModel(
      id: 'anime_045',
      name: 'Dragon Ball Collector Set',
      category: 'Limited Edition',
      price: 50000,
      imageUrl: imageFor('Dragon Ball Collector Set'),
    ),

    // =====================================================
    // ANIME GIFTS
    // =====================================================

    ProductModel(
      id: 'anime_046',
      name: 'Anime Sticker Collection',
      category: 'Anime Gifts',
      price: 2500,
      imageUrl: imageFor('Anime Sticker Collection'),
    ),
    ProductModel(
      id: 'anime_047',
      name: 'Anime Bookmark Set',
      category: 'Anime Gifts',
      price: 2500,
      imageUrl: imageFor('Anime Bookmark Set'),
    ),
    ProductModel(
      id: 'anime_048',
      name: 'Manga Reader Gift Set',
      category: 'Anime Gifts',
      price: 8000,
      imageUrl: imageFor('Manga Reader Gift Set'),
    ),
    ProductModel(
      id: 'anime_049',
      name: 'Anime Collector Gift Box',
      category: 'Anime Gifts',
      price: 15000,
      imageUrl: imageFor('Anime Collector Gift Box'),
    ),
    ProductModel(
      id: 'anime_050',
      name: 'FandomVerse Mystery Gift Box',
      category: 'Anime Gifts',
      price: 20000,
      imageUrl: imageFor('FandomVerse Mystery Gift Box'),
    ),
  ];

  // =====================================================
  // PRODUCT IMAGE URL
  // =====================================================

  static String imageFor(String productName) {
    switch (productName) {
    // FIGURES
      case 'Luffy Grand Line Figure':
        return 'data:image/jpeg;base64,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';

      case 'Gojo Satoru Figure':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSB-EMDLXc5xFQhXKgRK89T89LCB-hLacMUdapDjWv0RQ&s=10';

      case 'Naruto Sage Mode Figure':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS67bwef0GSr4ivrvZwwaxSSrBgzbHsx9wC6WLJEA-oJQ&s=10';

      case 'Tanjiro Kamado Figure':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4VnAU5D8AfBDqikEPSbonPZy1liRPHo2SkitpmEZXGg&s=10';

      case 'Nezuko Kamado Figure':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRe82rX76ysZaLxs4ROmYktK-NH0gG6Pn31vyUNZ4pE-Q&s=10';

      case 'Itachi Uchiha Figure':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTTN6fdSXtVQHMDKL2EaVrauZOcQeWAcf-D3WeLDpmxw&s=10';

      case 'Killua Zoldyck Figure':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQOd_quK2SNtiNJRI0_gLNaTvv5XxhMDaMoEbI1t-7ig&s=10';

      case 'Goku Super Saiyan Figure':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0gL-9RId8zVxNxVNt6KMq8WS8WORRgAZAmx_w36UVIA&s=10';

      case 'Levi Ackerman Figure':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsDgRkYuqo-TpazuSawtblBNfzm3LGfpXKv7qegddU1A&s=10';

      case 'Sukuna Collectible Figure':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHNxdP44W_L02cacCjuaISyY-cZydwgDDffHlMC26WTA&s=10';

    // MANGA
      case 'One Piece Manga Vol 1':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO3hgwvhbH7_5DLI-B38N3GewADzKGY9rQP_rOjOTLZA&s=10';

      case 'Naruto Manga Vol 1':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTb-Qhl6Und0lmtzcyq9lD98azgj5uBHTrMlIQkUAvwXg&s=10';

      case 'Jujutsu Kaisen Manga Vol 1':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRikahskae2xhmUl1tt7vYAMfHg_60xbDd10u34BC7bQg&s=10';

      case 'Demon Slayer Manga Vol 1':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuS0xUrNM6S74C9ZDVwUenHOjCXa-p7DONtk9dblYxWg&s=10';

      case 'My Hero Academia Manga Vol 1':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAdcW9KfRbjSxvgTFpG7WxIboFKAhhJMIGY8wI4Ezj1w&s=10';

      case 'Chainsaw Man Manga Vol 1':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXJeHwWD1o2Kd4p8xiPMBBXV3brP2f-ROvOyEy9fgyCQ&s=10';

      case 'Spy x Family Manga Vol 1':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2ZUgUsKlUis_1xJvA_SwIFj6_uhyewp5tvezQqudr-g&s=10';

      case 'Blue Lock Manga Vol 1':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6j2MN2Hg2FcXW6meievb8a4qNkLwk0qFKaPQ1iNkqCQ&s=10';

      case 'Solo Leveling Manga Vol 1':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnETJOxdN3q5-mgfp578XXkDC-a1CISacw4LFyvxYFww&s=10';

      case 'Attack on Titan Manga Vol 1':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJ2ZvlgeeKTtMWUnwYKdNHftdgRSnFYcaV5DJ3SX5kOg&s=10';

    // TRADING CARDS
      case 'One Piece Trading Card Pack':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqeY0RkkKxOemJilaUXrFFJAfWRdQkaPYotJ9rjWlJng&s=10';

      case 'Naruto Trading Card Pack':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRU0NgpPNs--2fbhZ1-C6GafxWyXMojdXwXrh-owIA5pg&s=10';

      case 'Dragon Ball Trading Card Pack':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_EjxH783HlOlQOoyj8gqd6Knc0gMu0SVuV53ZnP-hhw&s=10';

      case 'Jujutsu Kaisen Card Pack':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSY3bfJ_rag8EU_3QKaOGlm--hkfH1JWxerk0G5KKVb3Q&s=10';

      case 'Demon Slayer Card Pack':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVk0R3hCKmDoGbsYfn5922SeHD0WbPNfKAZpZ8xPC9Mw&s=10';

    // POSTERS & ART
      case 'Gojo Satoru Art Poster':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoTl5UyyJEVd5N578cQkofCIFPhlRUWNjeIxcwmnwfEg&s=10';

      case 'Luffy Wanted Poster':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0uYv7h0xdAmFJL8o4sZVvnXr1wHijevsI45FD-LMgtQ&s=10';

      case 'Naruto Character Poster':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIc1V327zzV_R1kDgTUMSMpH0Pb75l-y4RDmqEWtmpBQ&s=10';

      case 'Demon Slayer Art Print':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQUa-2DDltTxCAGO1Z1mm8e7-nxBPpMlYDnluiJ7mLkw&s=10';

      case 'Attack on Titan Wall Art':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHYVQLzSfdbDT6zpQsqND0O7A3ZkhEGCjz4czMdTjurw&s=10';

    // ACCESSORIES
      case 'Anime Character Keychain':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgGrU7K6w-QOtJdtkZQF9akoAUDQh1IwM1w0BD3hsOhw&s=10';

      case 'Gojo Chibi Keychain':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSswrOZdkG1nweGSSpgsvFUKzfnEIGYoXRGV8uv3nz6Ow&s=10';

      case 'Luffy Keychain':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSG6mmEqgTWMNRFDTPLyN1tXzv6-3nUAW0cLeUTvpsCww&s=10';

      case 'Naruto Kunai Keychain':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuASC7OeNfdc22qm1vPAo-ujXEeRR2U8vdF9q8xnj6cQ&s=10';

      case 'Nezuko Keychain':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTie4OC-8B52ISbBjWfjzgGdeonBbgEU_7SpVHdPajulg&s=10';

    // COLLECTIBLES
      case 'Anime Mystery Box':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQNSzg-cnHtpv1wE5eQEveFyerLBdI5V5f6I7zRRkWnQ&s=10';

      case 'One Piece Mystery Box':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzTGOkEvP4LNMVwYzP0X1vCZS1NOCmSDr3XzVmPMgc5A&s=10';

      case 'Jujutsu Kaisen Mystery Box':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7M6FC1_4-XveI_jKdilK9voSkB9uUBmS_cWfTXv84xw&s=10';

      case 'Anime Mini Statue':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJW8SC5zgczCW8ddyPikdRrWYbKOV5iqwM-X4x1lhY3g&s=10';

      case 'Demon Slayer Collectible Set':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQe10PCgBlr4NVCiez939uADs3d7uoEgd61tRsdR4te6Q&s=10';

    // LIMITED EDITION
      case 'Limited Edition Gojo Figure':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9pIJfEVzzgNHsgnxU3z_EcFk352vJh89txHLGACo59g&s=10';

      case 'Limited Edition Luffy Figure':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJ3ocLcFRVmm8LvztMFX1hkqkBVA11-GxHbWR9I3ublA&s=10';

      case 'Naruto Collector Set':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCzeRj_IW-qmBa6s7-2PfR0t9aErJmxnIEeEo5422i2g&s=10';

      case 'Attack on Titan Collector Set':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXXuD93MRtWLkLkFPaWO3u8wk1ydm4oSF9ABiMFufNKg&s=10';

      case 'Dragon Ball Collector Set':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI3hwcHQiWMGb6gO5Am84uHFWYHTif-nN97w-_AL_CAg&s=10';

    // ANIME GIFTS
      case 'Anime Sticker Collection':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8UwGW6f-9BN_Ly4BCtqVFTNjPAB1C1gf4Lr1CIy6bQA&s=10';

      case 'Anime Bookmark Set':
        return '';

      case 'Manga Reader Gift Set':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQ29Dj-BEeuIwxbQlUFD-InFYB2TwP8iI4gTBdc3aW3A&s';

      case 'Anime Collector Gift Box':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5QOLK7rIk6QNBmkS-p3wHlkZBAFH_AAKcUZ-xi872Ag&s';

      case 'FandomVerse Mystery Gift Box':
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbpb_iNGRsnmht0QinkDTNf08LS333z7Bs6VtueZuQ2A&s=10';

      default:
        return 'https://picsum.photos/seed/animeproduct/600/600';
    }
  }
}