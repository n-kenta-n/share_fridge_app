import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';
import 'package:share_fridge_app/modules/items/item_list_provider.dart';
import 'package:share_fridge_app/widgets/keyboard_aware.dart';
import 'package:intl/intl.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  AddItemState createState() => AddItemState();
}

class AddItemState extends ConsumerState<AddItemScreen> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  double _amount = 0;
  final DateTime _nowTime = DateTime.now();
  final DateFormat _outputFormat = DateFormat('yyyy/MM/dd');
  String? _limitDate;
  String _displayDate = 'なし';
  SnackBar? mySnackBar;
  static List<String> unitList = <String>['個', 'ｇ', '㎖', 'パック'];
  String _unit = unitList.first;

  @override
  void dispose() {
    _itemController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picker = await showDatePicker(
      context: context,
      initialDate: _nowTime, // 最初に表示する日付
      // firstDate: DateTime(_nowTime.day), // 選択できる日付の最小値
      firstDate: DateTime(_nowTime.year, _nowTime.month, _nowTime.day),
      lastDate: DateTime(_nowTime.year + 5), // 選択できる日付の最大値
    );
    if (picker != null) {
      setState(() {
        // 選択された日付を_displayDateに代入
        _displayDate = _outputFormat.format(picker);
        _limitDate = picker.toIso8601String().split('T').first;
      });
    }
  }

  // アイテムを登録した際に出るダイアログ
  Future<void> _showDialog(String itemName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text('$itemName を登録しました')]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addItem() async {
    if (_itemController.text == '' || _amount <= 0) return;
    final currentUser = ref.watch(currentUserProvider);
    await ref
        .read(itemListProvider.notifier)
        .addItem(
          _itemController.text,
          _amount,
          _unit,
          _limitDate,
          currentUser!,
        );
    setState(() {
      _displayDate = 'なし';
      _unit = unitList.first;
    });
    _showDialog(_itemController.text);
    _itemController.clear();
    _amountController.clear();
  }

  void _validation() {
    if (_itemController.text == '') {
      mySnackBar = SnackBar(content: Text('食材を入力してください'));
      ScaffoldMessenger.of(context).showSnackBar(mySnackBar!);
    } else if (_amountController.text == '') {
      mySnackBar = SnackBar(content: Text('数量を入力してください'));
      ScaffoldMessenger.of(context).showSnackBar(mySnackBar!);
    } else if (_amountController.text.endsWith('.')) {
      mySnackBar = SnackBar(content: Text('値が不正です'));
      ScaffoldMessenger.of(context).showSnackBar(mySnackBar!);
    } else {
      _amount = double.parse(_amountController.text);
      if (_amount <= 0) {
        mySnackBar = SnackBar(content: Text('数量には０より大きい値を入力してください'));
        ScaffoldMessenger.of(context).showSnackBar(mySnackBar!);
      } else {
        _addItem();
      }
    }
  }

  // ここから画面描画
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: false, // 左に自動で出る、戻るアイコンを無効にする
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: KeyboardAware(
        child: Column(
          children: [
            // 余白
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                decoration: InputDecoration(labelText: '食材'),
                controller: _itemController,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d(\d*|\d*\.\d*)$'), // 数字と小数点のみ許可
                        ),
                      ],
                      decoration: InputDecoration(labelText: '数量'),
                      controller: _amountController,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: DropdownButtonFormField(
                      value: _unit,
                      items:
                          unitList.map<DropdownMenuItem<String>>((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _unit = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('期限', style: textTheme.bodyLarge),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(_displayDate, style: textTheme.bodyLarge),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _displayDate = 'なし';
                        _limitDate = null;
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed:
                  (_itemController.text == '' || _amountController.text == '')
                      ? null
                      : _validation,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.grey;
                  }
                  return Colors.black;
                }),
              ),
              child: const Text('登録', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
