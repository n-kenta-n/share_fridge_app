import 'package:flutter/material.dart';
import 'package:share_fridge_app/modules/items/item.dart';
import 'package:intl/intl.dart';
import 'package:share_fridge_app/screens/update_item_screen.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final DateFormat outputFormat = DateFormat('yyyy/MM/dd');
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return UpdateItemScreen(item: item);
              },
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(7),
              child: Text(item.itemName, style: textTheme.titleLarge),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    '数量：${item.amount.toString()}',
                    style: textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:
                      item.limitDate != null
                          ? Text(
                            '期限：${outputFormat.format(item.limitDate!)}',
                            style: textTheme.titleMedium,
                          )
                          : Text('期限：なし', style: textTheme.titleMedium),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
