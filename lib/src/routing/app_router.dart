import 'package:ecommerce_app/src/features/account/account_screen.dart';
import 'package:ecommerce_app/src/features/orders_list/orders_list_screen.dart';
import 'package:ecommerce_app/src/features/product_page/product_screen.dart';
import 'package:ecommerce_app/src/features/products_list/products_list_screen.dart';
import 'package:ecommerce_app/src/features/shopping_cart/shopping_cart_screen.dart';
import 'package:ecommerce_app/src/features/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/sign_in/email_password_sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home('/'),
  cart('cart'),
  orders('orders'),
  account('account'),
  signIn('signIn'),
  product('product/:id');

  const AppRoute(this.path);
  final String path;
}

final goRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: AppRoute.home.path,
  routes: [
    GoRoute(
      path: AppRoute.home.path,
      name: AppRoute.home.name,
      builder: (context, state) => ProductsListScreen(),
      routes: [
        GoRoute(
          path: AppRoute.product.path,
          name: AppRoute.product.name,
          pageBuilder: (context, state) {
            final productID = state.pathParameters["id"];
            return MaterialPage(
              fullscreenDialog: true,
              key: state.pageKey,
              child: ProductScreen(
                productId: productID!,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoute.cart.path,
          name: AppRoute.cart.name,
          pageBuilder: (context, state) => MaterialPage(
            fullscreenDialog: true,
            key: state.pageKey,
            child: ShoppingCartScreen(),
          ),
        ),
        GoRoute(
          path: AppRoute.orders.path,
          name: AppRoute.orders.name,
          pageBuilder: (context, state) => MaterialPage(
            fullscreenDialog: true,
            key: state.pageKey,
            child: OrdersListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoute.account.path,
          name: AppRoute.account.name,
          pageBuilder: (context, state) => MaterialPage(
            fullscreenDialog: true,
            key: state.pageKey,
            child: AccountScreen(),
          ),
        ),
        GoRoute(
          path: AppRoute.signIn.path,
          name: AppRoute.signIn.name,
          pageBuilder: (context, state) => MaterialPage(
            fullscreenDialog: true,
            key: state.pageKey,
            child: EmailPasswordSignInScreen(
              formType: EmailPasswordSignInFormType.signIn,
            ),
          ),
        )
      ],
      
    ),
  ],
);

final routingProvider = Provider<GoRouter>((ref) {
  return goRouter;
});
