import 'package:flutter_test/flutter_test.dart';

import 'package:tai_translator/core/utilities/fuzzy_match.dart';

void main() {
  group('fuzzy matching', () {
    test('identical strings have distance 0', () {
      expect(levenshteinDistance('computer', 'computer'), 0);
    });

    test('komputa is close to computer', () {
      expect(similarity('komputa', 'computer'), greaterThan(0.5));
    });

    test('completely different strings have low similarity', () {
      expect(similarity('hello', 'xyzxyz'), lessThan(0.3));
    });
  });
}
