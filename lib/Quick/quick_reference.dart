import 'quick.dart';

class QuickReference {
  final String _key;
  final Type type;

  QuickReference(this._key, this.type);

  String get key => _key;

  set key(String newKey) {
    Quick.set(_key, newKey);
  }

  get value => Quick.get(_key);

  set value(dynamic newValue) {
    Quick.set(_key, newValue);
  }

  QuickReference lock() {
    Quick.lock(key);
    return this;
  }

  QuickReference unlock() {
    Quick.unlock(key);
    return this;
  }

  QuickReference store() {
    Quick.store(key, value);
    return this;
  }

  QuickReference to(dynamic newValue) {
    Quick.set(key, newValue);
    return this;
  }

  QuickReference notify() {
    Quick.notify(this);
    return this;
  }
}
