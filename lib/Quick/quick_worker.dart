import 'quick.dart';
import 'quick_status.dart';

class QuickWorker {
  dynamic status = QuickStatus.idle;
  Function(dynamic params, Function(dynamic) setStatus) work;
  dynamic key;
  QuickWorker(
    this.work,
    this.key, {
    this.status,
  });

  QuickWorker call({dynamic params}) {
    work(((newStatus) {
      status = newStatus;
    }), params);
    return this;
  }

  kill() {
    Quick.off(key);
  }
}
