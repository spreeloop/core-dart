import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import '../spreeloop_analytics.dart';

/// The firebase implementation of the analytics interface.
class CustomRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final ScreenNameExtractor _nameExtractor;

  /// This is the analytics that will be used to register the events.
  /// It can be a firebase implementation or another one.
  final Analytics _analytics;

  final _log = Logger('AnalyticsObserverFirebaseImplementation');

  /// Class constructor.
  CustomRouteObserver({
    required analytics,
    nameExtractor = defaultNameExtractor,
  })  : _nameExtractor = nameExtractor,
        _analytics = analytics;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  /// This method registers each new displayed screen.
  void _sendScreenView(PageRoute route) {
    final String? screenName = _nameExtractor(route.settings);
    if (screenName != null) {
      _analytics.setCurrentScreen(screenName: screenName).catchError(
        (error) {
          _log.severe(
            'FirebaseAnalyticsObserver error caught: $error',
            null,
            StackTrace.current,
          );
        },
        test: (error) => error is PlatformException,
      );
    }
  }
}
