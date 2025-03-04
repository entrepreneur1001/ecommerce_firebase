import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:ecommerce_app/src/features/authentication/repository/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_screen.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/checkout_screen/checkout_screen.dart';
import 'package:ecommerce_app/src/features/orders/presentation/orders_list/orders_list_screen.dart';
import 'package:ecommerce_app/src/features/products/presentation/product_screen/product_screen.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/products_list_screen.dart';
import 'package:ecommerce_app/src/features/reviews/presentation/leave_review_screen/leave_review_screen.dart';
import 'package:ecommerce_app/src/routing/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home('/', false),
  product('product/:id', false),
  leaveReview('review', false),
  cart('cart', false),
  checkout('checkout', false),
  orders('orders', true),
  account('account', true),
  signIn('signIn', false);

  final String path;
  final bool isAuthRequired;
  const AppRoute(this.path, this.isAuthRequired);
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  String? redirectLocation; // Store intended route
  return GoRouter(
    overridePlatformDefaultLocation: true,
    initialLocation: AppRoute.home.path,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final matchedRoute = AppRoute.values.firstWhere(
        (route) {
          print("route.name ${route.name}");
          print("route.path ${route.path}");
          print("route.isAuthRequired ${route.isAuthRequired}");
          return state.matchedLocation.contains(route.path.split(':').first);
        },
        orElse: () => AppRoute.home,
      );

      if (!isLoggedIn && matchedRoute.isAuthRequired) {
        // Store the original location before redirecting to login
        redirectLocation = state.matchedLocation;
        return AppRoute.signIn.path;
      }

      // If user just logged in, redirect them to the stored location
      if (isLoggedIn && state.matchedLocation == AppRoute.signIn.path) {
        final destination = redirectLocation ?? AppRoute.home.path;
        redirectLocation = null; // Clear stored location
        return destination;
      }
      return null; // No redirect if conditions are not met
    },
    routes: [
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (context, state) => const ProductsListScreen(),
        routes: [
          GoRoute(
            path: AppRoute.product.path,
            name: AppRoute.product.name,
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              return ProductScreen(productId: productId);
            },
            routes: [
              GoRoute(
                path: AppRoute.leaveReview.path,
                name: AppRoute.leaveReview.name,
                pageBuilder: (context, state) {
                  final productId = state.pathParameters['id']!;
                  return MaterialPage(
                    fullscreenDialog: true,
                    child: LeaveReviewScreen(productId: productId),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.cart.path,
            name: AppRoute.cart.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: ShoppingCartScreen(),
            ),
            routes: [
              GoRoute(
                path: AppRoute.checkout.path,
                name: AppRoute.checkout.name,
                pageBuilder: (context, state) => const MaterialPage(
                  fullscreenDialog: true,
                  child: CheckoutScreen(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.orders.path,
            name: AppRoute.orders.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: OrdersListScreen(),
            ),
          ),
          GoRoute(
            path: AppRoute.account.path,
            name: AppRoute.account.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: AccountScreen(),
            ),
          ),
          GoRoute(
            path: AppRoute.signIn.path,
            name: AppRoute.signIn.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: EmailPasswordSignInScreen(
                formType: EmailPasswordSignInFormType.signIn,
              ),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
