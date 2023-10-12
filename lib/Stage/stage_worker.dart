import 'stage.dart';
import 'stage_status.dart';

class StageWorker {
  dynamic status = StageStatus.idle;
  Function(dynamic params, Function(dynamic) setStatus) work;
  dynamic key;
  StageWorker(
    this.work,
    this.key, {
    this.status,
  });

  StageWorker call({dynamic params}) {
    work(((newStatus) {
      status = newStatus;
    }), params);
    return this;
  }

  kill() {
    Stage.off(key);
  }
}
