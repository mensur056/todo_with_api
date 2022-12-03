class ProductModel {
  String? productName;
  String? color;
  int? number;
  String? key;

  ProductModel({
    this.productName,
    this.color,
    this.number,
  });
  int get changeColorValue {
    var newColor = color?.replaceFirst('#', '0xFF');
    return int.parse(newColor ?? '');
  }

  ProductModel.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    color = json['color'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productName'] = productName;
    data['color'] = color;
    data['number'] = number;
    return data;
  }
}

class ProductList {
  List<ProductModel> products = [];

  ProductList.fromJsonList(Map value) {
    value.forEach((key, value) {
      var product = ProductModel.fromJson(value);
      product.key = key;
      products.add(product);
    });
  }
}
