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
      margin: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
        /*
        boxShadow: const [
          BoxShadow(
            //color: Colors.grey,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(1, 1),
          ),
        ],
        */
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
                padding: const EdgeInsets.all(7),
                child: Text(item.itemName, style: textTheme.titleLarge),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:
                        // 少数がない場合は整数表示
                        item.amount == item.amount.toInt()
                            ? Text(
                              '${item.amount.toStringAsFixed(0)} ${item.unit}',
                              style: textTheme.titleLarge,
                            )
                            : Text(
                              '${item.amount.toString()} ${item.unit}',
                              style: textTheme.titleLarge,
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
      ),
    );
  }
}
