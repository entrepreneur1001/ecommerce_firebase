import 'package:ecommerce_app/src/features/authentication/repository/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository authRepository;

  AccountScreenController({required this.authRepository})
      : super(AsyncValue.data(null));

  Future<void> signOut() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}

final accountScreenControllerProvider =
    StateNotifierProvider<AccountScreenController, AsyncValue<void>>((ref) {
  return AccountScreenController(
      authRepository: ref.watch(authRepositoryProvider));
});
