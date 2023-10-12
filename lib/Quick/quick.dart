// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'quick_notifier.dart';
import 'quick_reference.dart';
import 'quick_status.dart';
import 'quick_watcher.dart';
import 'quick_worker.dart';

class Quick {
  static final SplayTreeMap<String, dynamic> _quicks = SplayTreeMap();
  static final SplayTreeMap<String, QuickWorker> _workers = SplayTreeMap();
  static final SplayTreeMap<String, dynamic> _binds = SplayTreeMap();
  static final List<String> _lockedKeys = [];
  static dynamic defaultAbsentWorkerStatus = QuickStatus.absent;
  static Map<Key, QuickNotifier> notifiers = {};
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  static void notify(dynamic dependency) {
    notifiers[ObjectKey(dependency)]?.updateDependencies();
  }

  static void notifyAll() {
    notify(Null);
  }

  static dynamic statusOf(String key) {
    return _workers[key]?.status ?? defaultAbsentWorkerStatus;
  }

  static void setStatus(String key, dynamic status) {
    _workers[key]?.status = status;
  }

  static QuickReference set(String key, dynamic value) {
    _quicks[key] = value;
    Type T = value.runtimeType;
    return QuickReference(key, T);
  }

  static QuickReference make(String key, Function(dynamic) maker) {
    dynamic value = maker(_quicks[key]);
    _quicks[key] = value;
    Type T = value.runtimeType;
    return QuickReference(key, T);
  }

  static dynamic get(String key) {
    return _quicks[key];
  }

  static T getAs<T extends Object>(String key) {
    return _quicks[key] as T;
  }

  static Future<void> store(String key, dynamic value) async {
    await storage.write(key: key, value: jsonEncode(value));
  }

  static Future<T?> fromStore<T extends Object>(String key) async {
    String? storeValue = await storage.read(key: key);
    if (storeValue == null) {
      return null;
    } else {
      T data = jsonDecode(storeValue) as T;
      set(key, data);
      return data;
    }
  }

  static bool free(String key) {
    return _quicks.remove(key);
  }

  static QuickReference ref(String key) {
    Type T = get(key).runtimeType;
    return QuickReference(key, T);
  }

  static void clear() {
    _quicks.clear();
  }

  static void clearWithout(List<String> keys) {
    keys.addAll(_lockedKeys);
    _quicks.removeWhere((key, value) => !keys.contains(key));
  }

  static void lock(String key) {
    _lockedKeys.add(key);
  }

  static void unlock(String key) {
    if (_lockedKeys.contains(key)) {
      _lockedKeys.remove(key);
    }
  }

  static String on(
      String key, Function(dynamic params, Function(dynamic) setStatus) work) {
    _workers[key] = QuickWorker(work, key);

    return key;
  }

  static void off(String key) {
    _workers.remove(key);
  }

  static void call(String key, {dynamic params}) {
    _workers[key]?.work(((newStatus) {
      _workers[key] = newStatus;
    }), params);
  }

  static void Function()? caller(String key, {dynamic params}) {
    return () => _workers[key]?.work(((newStatus) {
          _workers[key]?.status = newStatus;
        }), params);
  }

  static bind(dynamic obj) {
    String key = obj.runtimeType.toString();
    if (_binds.containsKey(key)) {
      return _binds[key];
    } else {
      _binds[key] = obj;
      return obj;
    }
  }

  static dispose(dynamic obj) {
    _binds.remove(obj.runtimeType.toString());
  }

  static Widget watcher(
    Widget Function() build, {
    List<dynamic> dependencies = const [Null],
  }) {
    QuickWatcher watcher = QuickWatcher(
      bindDependencies: dependencies,
      builder: (context) => build(),
    );

    return watcher;
  }

  static Widget builder({
    required Widget Function(BuildContext context) builder,
    List<dynamic> dependencies = const [Null],
  }) {
    QuickWatcher watcher = QuickWatcher(
      bindDependencies: dependencies,
      builder: builder,
    );

    return watcher;
  }

  static Widget switcher({
    required dynamic status,
    required Map<dynamic, Widget> cases,
    List<dynamic> dependencies = const [Null],
  }) {
    QuickWatcher watcher = QuickWatcher(
      bindDependencies: dependencies,
      builder: (context) =>
          cases[status] ??
          ErrorWidget.withDetails(
            message: "Case not implemented...",
          ),
    );

    return watcher;
  }

  // static void to(Widget widget) {
  //   Navigator.push(
  //       BuildContext.,
  //       PageRouteBuilder(
  //         pageBuilder: (context, a1, a2) => widget,
  //       ));
  // }

  // static void toNamed(String name) {
  //   Navigator.pushNamed(Quick.get(context), name);
  // }
}
