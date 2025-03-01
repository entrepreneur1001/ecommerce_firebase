import 'package:ecommerce_app/src/features/products_list/products_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ProductsListScreen(),
    )
  ],
);

final routingProvider = Provider<GoRouter>((ref) {
  return goRouter;
});
