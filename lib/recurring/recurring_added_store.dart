import 'package:shared_preferences/shared_preferences.dart';

/// Persists transaction IDs created by recurring materialization on app open,
/// so the user can review catch-up additions later (not only “today”).
class RecurringAddedStore {
  RecurringAddedStore._();

  static const _idsKey = 'recurring_added_since_last_open_ids';

  static Future<void> saveIds(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _idsKey,
      ids.map((id) => id.toString()).toList(),
    );
  }

  static Future<List<int>> loadIds() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_idsKey) ?? const [];
    return raw.map(int.parse).toList();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idsKey);
  }
}
