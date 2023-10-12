import 'package:flutter/material.dart';

import 'stage.dart';
import 'stage_notifier.dart';

class StageWatcher extends StatefulWidget {
  StageWatcher(
      {super.key, required this.builder, required this.bindDependencies});

  List<dynamic> bindDependencies;
  Widget Function(BuildContext context) builder;
  Key watcherKey = UniqueKey();

  @override
  State<StageWatcher> createState() => _StageWatcherState();
}

class _StageWatcherState extends State<StageWatcher> {
  @override
  void initState() {
    for (dynamic bind in widget.bindDependencies) {
      StageNotifier? notifier = Stage.notifiers[ObjectKey(bind)];
      if (notifier != null) {
        if (context.findAncestorWidgetOfExactType<StageWatcher>() == null) {
          notifier.updates[widget.watcherKey] = () => setState(() {});
        }
      } else {
        Stage.notifiers[ObjectKey(bind)] = StageNotifier(
            updates: {widget.watcherKey: () => setState(() {})},
            dependency: ObjectKey(bind));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  @override
  void dispose() {
    for (dynamic bind in widget.bindDependencies) {
      StageNotifier? notifier = Stage.notifiers[ObjectKey(bind)];
      notifier!.updates.remove(widget.watcherKey);
      if (notifier.updates.isEmpty) {
        Stage.notifiers.remove(ObjectKey(bind));
      }
    }

    super.dispose();
  }
}
