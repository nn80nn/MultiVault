import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/route_constants.dart';
import '../di/providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/setup_screen.dart';
import '../../features/categories/presentation/screens/categories_management_screen.dart';
import '../../features/import_export/presentation/screens/export_screen.dart';
import '../../features/import_export/presentation/screens/import_screen.dart';
import '../../features/password_generator/presentation/screens/generator_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/vault/presentation/screens/add_edit_entry_screen.dart';
import '../../features/vault/presentation/screens/entry_detail_screen.dart';
import '../../features/vault/presentation/screens/vault_list_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final lockStatus = ref.watch(lockStatusProvider);

  return GoRouter(
    initialLocation: RouteConstants.login,
    redirect: (context, state) {
      final isSetup = state.matchedLocation == RouteConstants.setup;
      final isLogin = state.matchedLocation == RouteConstants.login;

      if (lockStatus == LockStatus.setupRequired && !isSetup) {
        return RouteConstants.setup;
      }
      if (lockStatus == LockStatus.locked && !isLogin && !isSetup) {
        return RouteConstants.login;
      }
      if (lockStatus == LockStatus.unlocked && (isLogin || isSetup)) {
        return RouteConstants.vault;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteConstants.setup,
        builder: (context, state) => const SetupScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.vault,
        builder: (context, state) => const VaultListScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const AddEditEntryScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => EntryDetailScreen(
              entryId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => AddEditEntryScreen(
                  entryId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteConstants.generator,
        builder: (context, state) => const GeneratorScreen(),
      ),
      GoRoute(
        path: RouteConstants.settings,
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'import',
            builder: (context, state) => const ImportScreen(),
          ),
          GoRoute(
            path: 'export',
            builder: (context, state) => const ExportScreen(),
          ),
          GoRoute(
            path: 'categories',
            builder: (context, state) => const CategoriesManagementScreen(),
          ),
        ],
      ),
    ],
  );
});
