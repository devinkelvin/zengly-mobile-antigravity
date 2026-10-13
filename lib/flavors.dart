enum Flavor { dev, prod }

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Zengly Dev';
      case Flavor.prod:
        return 'Zengly';
    }
  }

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'https://zengly.fly.dev/';
      case Flavor.prod:
        return 'https://zengly.fly.dev/';
    }
  }
}
