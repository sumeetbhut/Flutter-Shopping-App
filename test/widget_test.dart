import 'package:flutter_test/flutter_test.dart';
import 'package:shopappdemo/data/product.dart';

void main() {
  test('parses product fields from the catalog response', () {
    final product = Product.fromJson({
      'id': 1,
      'title': 'Everyday bag',
      'description': 'A useful bag',
      'category': 'Accessories',
      'price': 24.5,
      'discountPercentage': 10,
      'rating': 4.7,
      'stock': 12,
      'brand': 'Daily',
      'thumbnail': 'https://example.com/bag.jpg',
      'images': ['https://example.com/bag.jpg'],
    });

    expect(product.title, 'Everyday bag');
    expect(product.price, 24.5);
    expect(product.images, ['https://example.com/bag.jpg']);
  });
}
