/// The fixed set of fandom categories used across the app — interest
/// selection during onboarding, content filters, merchandise categories,
/// and so on (matches the top nav bar in the team's mockups).
///
/// Centralized here so every feature (ours and teammates') filters
/// against the same list instead of each hand-typing category names that
/// can drift out of sync.
class FandomCategories {
  const FandomCategories._();

  static const List<String> all = [
    'Anime',
    'Gaming',
    'Movies & TV',
    'Comics',
    'Music & K-Pop',
  ];
}
