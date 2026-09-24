import 'package:connectivity_plus/connectivity_plus.dart';

/// Wraps `connectivity_plus` behind a simple `bool`-based API.
///
/// Widgets/blocs should depend on this, not on `connectivity_plus`
/// directly — if the connectivity strategy changes later (e.g. adding an
/// actual reachability ping, not just "is a network interface up"), only
/// this file needs to change.
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Emits `true`/`false` whenever connectivity changes. Note: this
  /// reflects whether a network interface is up, not necessarily that the
  /// internet is reachable.
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection);
  }

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _hasConnection(result);
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }
}
