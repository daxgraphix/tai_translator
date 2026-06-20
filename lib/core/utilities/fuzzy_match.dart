/// Lightweight Levenshtein-distance based fuzzy matcher used by the
/// Dictionary Module's Fuzzy Search (e.g. "komputa" -> "computer").
/// No external package required — keeps APK size down per spec target
/// (Under 40 MB).
int levenshteinDistance(String a, String b) {
  a = a.toLowerCase();
  b = b.toLowerCase();
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;

  List<int> prev = List.generate(b.length + 1, (i) => i);
  List<int> curr = List.filled(b.length + 1, 0);

  for (int i = 1; i <= a.length; i++) {
    curr[0] = i;
    for (int j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      curr[j] = [
        curr[j - 1] + 1, // insertion
        prev[j] + 1, // deletion
        prev[j - 1] + cost, // substitution
      ].reduce((x, y) => x < y ? x : y);
    }
    prev = List.from(curr);
  }
  return prev[b.length];
}

/// Returns a 0..1 similarity score (1 = identical).
double similarity(String a, String b) {
  final maxLen = a.length > b.length ? a.length : b.length;
  if (maxLen == 0) return 1;
  return 1 - (levenshteinDistance(a, b) / maxLen);
}
