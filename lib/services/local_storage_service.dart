import 'package:hive/hive.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const String _boxName = 'thumbs_out';
  static const String _bestKey = 'best_score';
  late Box<int> _box;

  Future<void> init() async {
    _box = await Hive.openBox<int>(_boxName);
  }

  int updateBest(int blue, int red) {
    final winner = blue > red ? blue : red;
    final current = _box.get(_bestKey, defaultValue: 0) ?? 0;
    if (winner > current) {
      _box.put(_bestKey, winner);
      return winner;
    }
    return current;
  }

  int getBest() => _box.get(_bestKey, defaultValue: 0) ?? 0;
}
