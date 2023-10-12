import 'package:flutter/material.dart';

import 'quick.dart';
import 'quick_notifier.dart';

class QuickWatcher extends StatefulWidget {
  QuickWatcher(
      {super.key, required this.builder, required this.bindDependencies});

  List<dynamic> bindDependencies;
  Widget Function(BuildContext context) builder;
  Key watcherKey = UniqueKey();

  @override
  State<QuickWatcher> createState() => _QuickWatcherState();
}

class _QuickWatcherState extends State<QuickWatcher> {
  @override
  void initState() {
    for (dynamic bind in widget.bindDependencies) {
      QuickNotifier? notifier = Quick.notifiers[ObjectKey(bind)];
      if (notifier != null) {
        if (context.findAncestorWidgetOfExactType<QuickWatcher>() == null) {
          notifier.updates[widget.watcherKey] = () => setState(() {});
        }
      } else {
        Quick.notifiers[ObjectKey(bind)] = QuickNotifier(
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
      QuickNotifier? notifier = Quick.notifiers[ObjectKey(bind)];
      notifier!.updates.remove(widget.watcherKey);
      if (notifier.updates.isEmpty) {
        Quick.notifiers.remove(ObjectKey(bind));
      }
    }

    super.dispose();
  }
}
