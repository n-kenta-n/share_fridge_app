import 'package:flutter/material.dart';
import 'package:share_fridge_app/modules/items/item.dart';
import 'package:intl/intl.dart';
import 'package:share_fridge_app/screens/update_item_screen.dart';

final DateFormat outputFormat = DateFormat('yyyy/MM/dd');

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return UpdateItemScreen(item: item);
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(7.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 10),
                child: Text(item.itemName, style: textTheme.bodyMedium),
              ),
              Padding(
                padding: const EdgeInsets.all(3),
                child:
                    // 少数がない場合は整数表示
                    item.amount == item.amount.toInt()
                        ? Text(
                          '${item.amount.toStringAsFixed(0)} ${item.unit}',
                          style: textTheme.bodySmall,
                        )
                        : Text(
                          '${item.amount.toString()} ${item.unit}',
                          style: textTheme.bodySmall,
                        ),
              ),
              Padding(
                padding: const EdgeInsets.all(3),
                child:
                    item.limitDate != null
                        ? Text(
                          '${outputFormat.format(item.limitDate!)} まで',
                          style: textTheme.bodySmall,
                        )
                        : Text('期限なし', style: textTheme.bodySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
