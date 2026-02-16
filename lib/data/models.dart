import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final double? originalPrice;
  final int discountPercent;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> galleryUrls;
  final String description;
  final bool freeShipping;
  final String? deliveryDate;
  final int maxInstallments;
  final double installmentPrice;
  final bool isNew;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    this.originalPrice,
    this.discountPercent = 0,
    required this.rating,
    this.reviewCount = 0,
    required this.imageUrl,
    this.galleryUrls = const [],
    this.description = '',
    this.freeShipping = false,
    this.deliveryDate,
    this.maxInstallments = 1,
    this.installmentPrice = 0,
    this.isNew = false,
  });

  Product copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    double? price,
    double? originalPrice,
    int? discountPercent,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    List<String>? galleryUrls,
    String? description,
    bool? freeShipping,
    String? deliveryDate,
    int? maxInstallments,
    double? installmentPrice,
    bool? isNew,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      description: description ?? this.description,
      freeShipping: freeShipping ?? this.freeShipping,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      maxInstallments: maxInstallments ?? this.maxInstallments,
      installmentPrice: installmentPrice ?? this.installmentPrice,
      isNew: isNew ?? this.isNew,
    );
  }
}

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class UserProfile {
  final String name;
  final String email;
  final String avatarUrl;
  final double magaluPayBalance;
  final double carneDigitalLimit;
  final double carneDigitalUsed;
  final int creditScore;

  const UserProfile({
    required this.name,
    required this.email,
    this.avatarUrl = '',
    this.magaluPayBalance = 0,
    this.carneDigitalLimit = 0,
    this.carneDigitalUsed = 0,
    this.creditScore = 0,
  });

  double get carneDigitalAvailable => carneDigitalLimit - carneDigitalUsed;
}

enum PaymentMethod {
  magaluPay,
  creditCard,
  pix,
  carneDigital,
  boleto,
}

class PaymentOption {
  final PaymentMethod method;
  final String label;
  final String? subtitle;
  final String iconName;
  final bool isAvailable;

  const PaymentOption({
    required this.method,
    required this.label,
    this.subtitle,
    required this.iconName,
    this.isAvailable = true,
  });
}

class CategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final String? imageUrl;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    this.imageUrl,
  });
}

class BannerItem {
  final String id;
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? actionUrl;

  const BannerItem({
    required this.id,
    required this.imageUrl,
    this.title = '',
    this.subtitle,
    this.actionUrl,
  });
}
