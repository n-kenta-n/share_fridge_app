import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';
import 'package:share_fridge_app/modules/fridges/current_fridge_provider.dart';
import 'package:share_fridge_app/modules/items/item_list_provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../widgets/pick_image_sheet.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  AddItemState createState() => AddItemState();
}

class AddItemState extends ConsumerState<AddItemScreen> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _intController = TextEditingController();
  final TextEditingController _decimalController = TextEditingController();
  double _amount = 0;
  final DateTime _nowTime = DateTime.now();
  final DateFormat _outputFormat = DateFormat('yyyy/MM/dd');
  String? _limitDate;
  String _displayDate = 'なし';
  SnackBar? mySnackBar;
  static List<String> unitList = <String>['個', 'ｇ', '㎖', 'パック'];
  String _unit = unitList.first;
  File? _selectedImage;

  @override
  void dispose() {
    _itemController.dispose();
    _intController.dispose();
    _decimalController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picker = await showDatePicker(
      context: context,
      initialDate: _nowTime, // 最初に表示する日付
      // 選択できる日付の最小値
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
  Future<void> _addItemDialog(String itemName) async {
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

    // 完了ダイアログが表示されるまでローディングダイアログを表示
    showDialog(
      context: context,
      barrierDismissible: false, // タップで閉じられない
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final currentUser = ref.read(currentUserProvider);
      final fridgeId = ref.read(currentFridgeProvider);

      await ref
          .read(itemListProvider.notifier)
          .addItem(
            _itemController.text,
            _amount,
            _unit,
            _limitDate,
            currentUser!,
            fridgeId!,
            _selectedImage,
          );

      // 非同期処理の後にmountedを確認
      // awaitで待っている間にStatefulWidgetが破棄される可能性があり
      // 破棄された後にcontextを使うとクラッシュする恐れがある
      if (!mounted) return;

      setState(() {
        _displayDate = 'なし';
        _unit = unitList.first;
        _selectedImage = null;
      });
      // ローディングダイアログを閉じる
      Navigator.of(context).pop();
      _addItemDialog(_itemController.text);
      _itemController.clear();
      _intController.clear();
      _decimalController.clear();
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('食材の追加に失敗しました: $e')));
    }
  }

  void _validation() {
    if (_itemController.text == '') {
      mySnackBar = SnackBar(content: Text('食材を入力してください'));
      ScaffoldMessenger.of(context).showSnackBar(mySnackBar!);
    } else if (_intController.text == '') {
      mySnackBar = SnackBar(content: Text('数量を入力してください'));
      ScaffoldMessenger.of(context).showSnackBar(mySnackBar!);
    } else {
      if (_decimalController.text.isEmpty) {
        _amount = double.parse(_intController.text);
      } else {
        _amount = double.parse(
          '${_intController.text}.${_decimalController.text}',
        );
      }
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
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: InkWell(
                onTap: () async {
                  final picked = await PickImageSheet.show(context);
                  setState(() {
                    _selectedImage = picked;
                  });
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    child:
                        _selectedImage != null
                            ? Image.file(_selectedImage!)
                            : const Center(child: Text('画像が選択されていません')),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                });
              },
              child: const Text('画像をクリア'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                decoration: InputDecoration(labelText: '食材'),
                controller: _itemController,
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(labelText: '整数'),
                    controller: _intController,
                  ),
                ),
                Text(' . ', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(labelText: '小数'),
                    controller: _decimalController,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: DropdownButtonFormField(
                    value: _unit,
                    items:
                        unitList.map<DropdownMenuItem<String>>((String value) {
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
            const SizedBox(height: 24),
            Row(
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
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed:
                  (_itemController.text.isEmpty || _intController.text.isEmpty)
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
