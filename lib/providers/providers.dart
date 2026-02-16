import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../data/mock_data.dart';

// ─── Cart Provider ───────────────────────────────────────
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(Product product) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      final updated = [...state];
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + 1,
      );
      state = updated;
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    state = state.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
  }

  void clear() {
    state = [];
  }

  double get totalPrice =>
      state.fold(0, (sum, item) => sum + item.total);

  int get totalItems =>
      state.fold(0, (sum, item) => sum + item.quantity);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.total);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});

// ─── Payment Provider ────────────────────────────────────
class PaymentState {
  final PaymentMethod? selectedMethod;
  final int installments;

  const PaymentState({this.selectedMethod, this.installments = 1});

  PaymentState copyWith({PaymentMethod? selectedMethod, int? installments}) {
    return PaymentState(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      installments: installments ?? this.installments,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier() : super(const PaymentState());

  void selectMethod(PaymentMethod method) {
    state = state.copyWith(selectedMethod: method, installments: 1);
  }

  void selectInstallments(int count) {
    state = state.copyWith(installments: count);
  }

  void reset() {
    state = const PaymentState();
  }
}

final paymentProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier();
});

// ─── User Provider ───────────────────────────────────────
class UserState {
  final UserProfile user;
  final bool balanceVisible;

  const UserState({required this.user, this.balanceVisible = true});

  UserState copyWith({UserProfile? user, bool? balanceVisible}) {
    return UserState(
      user: user ?? this.user,
      balanceVisible: balanceVisible ?? this.balanceVisible,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(user: MockData.user));

  void toggleBalanceVisibility() {
    state = state.copyWith(balanceVisible: !state.balanceVisible);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

// ─── Navigation Provider ─────────────────────────────────
final selectedNavIndexProvider = StateProvider<int>((ref) => 0);

// ─── Shipping Provider ──────────────────────────────────
final shippingMethodProvider = StateProvider<String>((ref) => 'delivery');
final cepProvider = StateProvider<String>((ref) => '');

// ─── Order success ──────────────────────────────────────
final orderCompleteProvider = StateProvider<bool>((ref) => false);
