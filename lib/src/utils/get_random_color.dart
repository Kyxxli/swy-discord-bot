import 'dart:math';

List<int> getRandomPastelColor() {
  Random rand = Random();

  int r = rand.nextInt(75) + 180;
  int g = rand.nextInt(75) + 180;
  int b = rand.nextInt(75) + 180;

  return [r, g, b];
}
