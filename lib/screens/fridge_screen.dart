import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/items/sort_type_provider.dart';
import 'package:share_fridge_app/screens/add_item_screen.dart';
import 'package:share_fridge_app/widgets/item_card.dart';
import 'package:share_fridge_app/modules/items/item_list_provider.dart';
import '../widgets/fridge_drop_down.dart';

class FridgeScreen extends ConsumerStatefulWidget {
  const FridgeScreen({super.key});

  @override
  FridgeState createState() => FridgeState();
}

class FridgeState extends ConsumerState<FridgeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  // AddItemScreenへの画面遷移
  void toAddItemScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(itemListProvider.notifier).fetchNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemList = ref.watch(itemListProvider);
    final sortType = ref.watch(sortTypeProvider);

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(child: FridgeDropdown()),
              SizedBox(
                child: DropdownButton<SortType>(
                  value: sortType,
                  items:
                      SortType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.label),
                        );
                      }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      ref.read(sortTypeProvider.notifier).set(newValue);
                    }
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: itemList.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data:
                  (items) => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: 2
                    ),
                    controller: _scrollController,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      // スライドして削除するためのクラス
                      return Dismissible(
                        // item.id がユニークであることを確認
                        key: Key(item.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          try {
                            await ref
                                .read(itemListProvider.notifier)
                                .removeItem(item.id);
                          } catch (e) {
                            // エラー処理（例: SnackBar）
                            // print('削除に失敗: $e');
                          }
                        },
                        child: ItemCard(item: item),
                      );
                    },
                  ),
            ),
          ),
        ],
      ),
      // 画面右下に出るフローティングボタンの設定
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          toAddItemScreen();
        },
      ),
    );
  }
}
