import 'package:diacritic/diacritic.dart';
import '../../../models/models.dart';

class ProductsQuerier {
  List<Product> query(List<Product> products, String query) {
    if (products.isNotEmpty) {
      if (query.isNotEmpty) {
        return products
            .where((element) =>
                (removeDiacritics(element.name.toLowerCase()) + element.code)
                    .contains(removeDiacritics(query).toLowerCase()))
            .toList();
      }
    }
    return products;
  }
}
