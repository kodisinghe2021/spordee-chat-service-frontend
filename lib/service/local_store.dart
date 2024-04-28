import 'package:get_storage/get_storage.dart';
import 'package:spordee_messaging_app/util/keys.dart';

class LocalStore {
  final GetStorage _storage = GetStorage();

  Future<bool> addToLocal(Keys key, String value) async {
    try {
      await _storage.write(key.name, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getFromLocal(Keys key) async {
    try {
      if (_storage.hasData(key.name)) {
        var value = await _storage.read(key.name);
        return value.toString();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteOne(Keys key) async {
    try {
      if (_storage.hasData(key.name)) {
        await _storage.remove(key.name);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearStorage() async {
    try {
      await _storage.erase();
      return true;
    } catch (e) {
      return false;
    }
  }
}
