import 'stage.dart';

class StageReference {
  final String _key;
  final Type type;

  StageReference(this._key, this.type);

  String get key => _key;

  set key(String newKey) {
    Stage.set(_key, newKey);
  }

  get value => Stage.get(_key);

  set value(dynamic newValue) {
    Stage.set(_key, newValue);
  }

  StageReference lock() {
    Stage.lock(key);
    return this;
  }

  StageReference unlock() {
    Stage.unlock(key);
    return this;
  }

  StageReference store() {
    Stage.store(key, value);
    return this;
  }

  StageReference to(dynamic newValue) {
    Stage.set(key, newValue);
    return this;
  }

  StageReference notify() {
    Stage.notify(this);
    return this;
  }
}