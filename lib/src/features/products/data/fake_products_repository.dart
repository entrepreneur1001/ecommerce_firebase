import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  final List<Product> _products = kTestProducts;

  List<Product> getProductList() {
    return _products;
  }

  Product? getProduct(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> fetchProductList() async {
    await Future.delayed(Duration(seconds: 1));
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductList() async* {
    await Future.delayed(Duration(seconds: 1));
    yield* Stream.value(_products);
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productListStreamProvider = StreamProvider<List<Product>>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.watchProductList();
});

final productListFutureProvider = FutureProvider<List<Product>>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.fetchProductList();
});

final productStreamProvider =
    StreamProvider.family<Product?, String>((ref, id) {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.watchProduct(id);
});
