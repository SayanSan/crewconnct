import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

/// A listenable that triggers when the auth state changes
class AuthListenable extends ChangeNotifier {
  AuthListenable(Ref ref, ProviderBase provider) {
    ref.listen(provider, (_, __) => notifyListeners());
  }
}

final authListenableProvider = Provider<AuthListenable>((ref) {
  // We don't watch the provider here, we just use it to create the listenable
  return AuthListenable(ref, authProvider);
});

// Import auth_provider if needed, but it's already used in app_router.dart
