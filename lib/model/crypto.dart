List<int> num = Iterable.generate(10, (x) => x).toList();

class Crypto {
  static List<int> genRandomPasscode() {

    int chara = 'a'.codeUnitAt(0);
    List<int> lower = Iterable.generate(26, (x) => chara + x).toList();

    int charA = 'A'.codeUnitAt(0);
    List<int> higher = Iterable.generate(26, (x) => charA + x).toList();

    lower.addAll(higher);
    lower.addAll(num);

    return lower;
  }
}
