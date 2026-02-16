import 'package:flutter/material.dart';
import 'models.dart';

class MockData {
  MockData._();

  // ─── User ──────────────────────────────────────────────
  static const user = UserProfile(
    name: 'Manoel',
    email: 'manoel@email.com',
    magaluPayBalance: 1250.80,
    carneDigitalLimit: 6638.80,
    carneDigitalUsed: 1200.00,
    creditScore: 742,
  );

  // ─── Products ──────────────────────────────────────────
  static const products = <Product>[
    Product(
      id: 'p1',
      name: 'Notebook Lenovo IdeaPad 3i Intel Core i5 8GB 256GB SSD 15.6"',
      brand: 'Lenovo',
      category: 'Informática',
      price: 2699.00,
      originalPrice: 3499.00,
      discountPercent: 23,
      rating: 4.6,
      reviewCount: 1847,
      imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
      galleryUrls: [
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800',
        'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=800',
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800',
      ],
      description: 'Notebook com processador Intel Core i5, 8GB de RAM e SSD de 256GB. Tela Full HD de 15.6 polegadas, ideal para trabalho e estudos.',
      freeShipping: true,
      deliveryDate: '20 de fev',
      maxInstallments: 12,
      installmentPrice: 224.92,
    ),
    Product(
      id: 'p2',
      name: 'Smart TV LG 55" 4K UHD NanoCell ThinQ AI',
      brand: 'LG',
      category: 'TV e Vídeo',
      price: 2899.00,
      originalPrice: 3999.00,
      discountPercent: 28,
      rating: 4.7,
      reviewCount: 2103,
      imageUrl: 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400',
      galleryUrls: [
        'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=800',
        'https://images.unsplash.com/photo-1461151304267-38535e780c79?w=800',
      ],
      description: 'Smart TV 4K com tecnologia NanoCell para cores mais puras. Inteligência artificial ThinQ AI, HDR10 Pro e Bluetooth Surround.',
      freeShipping: true,
      deliveryDate: '21 de fev',
      maxInstallments: 12,
      installmentPrice: 241.58,
    ),
    Product(
      id: 'p3',
      name: 'Fone de Ouvido JBL Tune 520BT Bluetooth',
      brand: 'JBL',
      category: 'Áudio',
      price: 199.90,
      originalPrice: 299.90,
      discountPercent: 33,
      rating: 4.5,
      reviewCount: 3245,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
      galleryUrls: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
        'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=800',
      ],
      description: 'Fone sem fio com JBL Pure Bass Sound. Até 57h de bateria, conexão multipoint e design dobrável para facilitar o transporte.',
      freeShipping: true,
      deliveryDate: '18 de fev',
      maxInstallments: 6,
      installmentPrice: 33.32,
    ),
    Product(
      id: 'p4',
      name: 'iPhone 15 128GB Apple',
      brand: 'Apple',
      category: 'Celulares',
      price: 4999.00,
      originalPrice: 5999.00,
      discountPercent: 17,
      rating: 4.9,
      reviewCount: 892,
      imageUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=400',
      galleryUrls: [
        'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=800',
        'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800',
      ],
      description: 'iPhone 15 com Dynamic Island, câmera principal de 48 MP, chip A16 Bionic e USB-C. Resistente à água e poeira (IP68).',
      freeShipping: true,
      deliveryDate: '19 de fev',
      maxInstallments: 12,
      installmentPrice: 416.58,
      isNew: true,
    ),
    Product(
      id: 'p5',
      name: 'Placa de Vídeo RTX 4060 8GB GDDR6 MSI Ventus',
      brand: 'MSI',
      category: 'Informática',
      price: 2199.00,
      originalPrice: 2799.00,
      discountPercent: 21,
      rating: 4.8,
      reviewCount: 567,
      imageUrl: 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=400',
      galleryUrls: [
        'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=800',
      ],
      description: 'GPU NVIDIA GeForce RTX 4060 com 8GB GDDR6. Ray Tracing, DLSS 3 e Ada Lovelace para games em alta performance.',
      freeShipping: true,
      deliveryDate: '22 de fev',
      maxInstallments: 12,
      installmentPrice: 183.25,
    ),
    Product(
      id: 'p6',
      name: 'Máquina de Lavar Brastemp 12kg BWK12A9',
      brand: 'Brastemp',
      category: 'Eletrodomésticos',
      price: 1899.00,
      originalPrice: 2399.00,
      discountPercent: 21,
      rating: 4.4,
      reviewCount: 1230,
      imageUrl: 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=400',
      galleryUrls: [
        'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=800',
      ],
      description: 'Lavadora com 12kg de capacidade, ciclo edredom, 12 programas de lavagem e sistema de água quente.',
      freeShipping: true,
      deliveryDate: '25 de fev',
      maxInstallments: 12,
      installmentPrice: 158.25,
    ),
    Product(
      id: 'p7',
      name: 'Cafeteira Nespresso Vertuo Pop',
      brand: 'Nespresso',
      category: 'Eletrodomésticos',
      price: 499.90,
      originalPrice: 699.90,
      discountPercent: 29,
      rating: 4.6,
      reviewCount: 456,
      imageUrl: 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=400',
      galleryUrls: [
        'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=800',
      ],
      description: 'Cafeteira com tecnologia Centrifusion™. Prepara café, espresso e café com leite. Design compacto e moderno.',
      freeShipping: false,
      deliveryDate: '19 de fev',
      maxInstallments: 6,
      installmentPrice: 83.32,
    ),
    Product(
      id: 'p8',
      name: 'Console PlayStation 5 Slim 1TB',
      brand: 'Sony',
      category: 'Games',
      price: 3799.00,
      originalPrice: 4499.00,
      discountPercent: 16,
      rating: 4.9,
      reviewCount: 2891,
      imageUrl: 'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=400',
      galleryUrls: [
        'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=800',
      ],
      description: 'PS5 Slim com SSD de 1TB, saída 4K a 120fps, retrocompatibilidade com PS4 e controle DualSense incluso.',
      freeShipping: true,
      deliveryDate: '20 de fev',
      maxInstallments: 12,
      installmentPrice: 316.58,
      isNew: true,
    ),
  ];

  // ─── Categories ────────────────────────────────────────
  static const categories = <CategoryItem>[
    CategoryItem(id: 'c1', name: 'Celulares', icon: Icons.smartphone),
    CategoryItem(id: 'c2', name: 'Informática', icon: Icons.computer),
    CategoryItem(id: 'c3', name: 'TVs', icon: Icons.tv),
    CategoryItem(id: 'c4', name: 'Áudio', icon: Icons.headphones),
    CategoryItem(id: 'c5', name: 'Games', icon: Icons.sports_esports),
    CategoryItem(id: 'c6', name: 'Eletro', icon: Icons.kitchen),
    CategoryItem(id: 'c7', name: 'Casa', icon: Icons.home),
    CategoryItem(id: 'c8', name: 'Moda', icon: Icons.checkroom),
    CategoryItem(id: 'c9', name: 'Beleza', icon: Icons.face),
    CategoryItem(id: 'c10', name: 'Cupons', icon: Icons.local_offer),
  ];

  // ─── Banners ───────────────────────────────────────────
  static const banners = <BannerItem>[
    BannerItem(
      id: 'b1',
      imageUrl: 'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=800',
      title: 'Oferta do Dia',
      subtitle: 'Até 50% OFF em Eletrônicos',
    ),
    BannerItem(
      id: 'b2',
      imageUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800',
      title: 'MagaluPay',
      subtitle: 'Cashback de até 10%',
    ),
    BannerItem(
      id: 'b3',
      imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
      title: 'Frete Grátis',
      subtitle: 'Para todo o Brasil',
    ),
  ];

  // ─── Payment Options ──────────────────────────────────
  static const paymentOptions = <PaymentOption>[
    PaymentOption(
      method: PaymentMethod.magaluPay,
      label: 'Saldo MagaluPay',
      subtitle: 'R\$ 1.250,80 disponível',
      iconName: 'account_balance_wallet',
    ),
    PaymentOption(
      method: PaymentMethod.creditCard,
      label: 'Cartão de Crédito',
      subtitle: 'Visa •••• 4321',
      iconName: 'credit_card',
    ),
    PaymentOption(
      method: PaymentMethod.pix,
      label: 'Pix',
      subtitle: 'Aprovação imediata',
      iconName: 'qr_code',
    ),
    PaymentOption(
      method: PaymentMethod.carneDigital,
      label: 'Carnê Digital',
      subtitle: 'R\$ 5.438,80 de limite',
      iconName: 'receipt_long',
    ),
    PaymentOption(
      method: PaymentMethod.boleto,
      label: 'Boleto Bancário',
      subtitle: 'Vence em 3 dias úteis',
      iconName: 'description',
    ),
  ];

  // ─── Recently Viewed ──────────────────────────────────
  static List<Product> get recentlyViewed => products.sublist(2, 5);

  // ─── Recommended ──────────────────────────────────────
  static List<Product> get recommended => products;
}
