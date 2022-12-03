import 'package:dio/dio.dart';
import 'package:todo_with_api/core/service/model.dart';

abstract class IService {
  Future<void> sendItemToApi(ProductModel model);
  Future<List<ProductModel>?> fetchItemFromApi();
}

class GeneralService implements IService {
  Dio dio = Dio(BaseOptions(baseUrl: 'https://rtr-rrtrt-r-default-rtdb.firebaseio.com/'));
  @override
  Future<void> sendItemToApi(ProductModel model) async {
    final response = await dio.post('product.json', data: model);
    return response.data;
  }

  @override
  Future<List<ProductModel>?> fetchItemFromApi() async {
    final response = await dio.get('product.json');
    final jsonResponse = response.data;
    if (response.statusCode == 200) {
      final productList = ProductList.fromJsonList(jsonResponse);
      return productList.products;
    }
    return null;
  }
}
