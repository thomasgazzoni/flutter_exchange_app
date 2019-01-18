//

enum Flavor { MOCK, PRO }

//Simple DI
class Injector {
  static final Injector _singleton = Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) async {
    _flavor = flavor;
  }

  factory Injector() => _singleton;

  Injector._internal();
}
