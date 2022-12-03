import 'package:flutter/material.dart';
import 'package:todo_with_api/core/service/general_service.dart';
import 'package:todo_with_api/core/service/model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ProjectLoading<HomeView> {
  late final IService service;
  List<ProductModel>? items;
  @override
  void initState() {
    super.initState();
    service = GeneralService();
    fetchItem();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
  }

  void sendItem(ProductModel model) {
    changeLoading();
    service.sendItemToApi(model);
    changeLoading();
  }

  Future<void> fetchItem() async {
    changeLoading();
    items = await service.fetchItemFromApi();
    changeLoading();
  }

  TextEditingController productController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchItem,
      key: _refreshIndicatorKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('To Do'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Column(
                    children: [
                      TextField(
                        controller: productController,
                      ),
                      TextField(
                        controller: colorController,
                      ),
                      TextField(
                        controller: numberController,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            final model = ProductModel(
                              productName: productController.text,
                              color: colorController.text,
                              number: int.tryParse(numberController.text),
                            );
                            sendItem(model);
                            _refreshIndicatorKey.currentState?.show();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Send'))
                    ],
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 4,
              child: ListView.builder(
                itemCount: items?.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Color(items?[index].changeColorValue ?? 0),
                    child: ListTile(
                      title: Text(items?[index].productName ?? ''),
                      subtitle: Text(items?[index].number.toString() ?? ''),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class ProjectLoading<T extends StatefulWidget> extends State<T> {
  bool isLoading = false;
  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
