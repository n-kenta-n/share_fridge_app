import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_fridge_app/modules/auth/current_user_provider.dart';
import 'package:share_fridge_app/modules/items/item.dart';
import 'package:share_fridge_app/widgets/keyboard_aware.dart';
import 'package:intl/intl.dart';
import '../modules/items/item_list_provider.dart';

class UpdateItemScreen extends ConsumerStatefulWidget {
  const UpdateItemScreen({super.key, required this.item});

  final Item item;

  @override
  UpdateItemState createState() => UpdateItemState();
}

class UpdateItemState extends ConsumerState<UpdateItemScreen> {
  final TextEditingController _intController = TextEditingController();
  final TextEditingController _decimalController = TextEditingController();
  double _amount = 0;
  final DateTime _nowTime = DateTime.now();
  final DateFormat _outputFormat = DateFormat('yyyy/MM/dd');
  String? _limitDate;
  String _displayDate = 'なし';
  SnackBar? mySnackBar;
  static List<String> unitList = <String>['個', 'ｇ', '㎖', 'パック'];
  String _unit = '';

  @override
  void initState() {
    super.initState();
    _intController.text = widget.item.amount.toString().split('.')[0];
    if (widget.item.amount == widget.item.amount.toInt()) {
      _decimalController.text = '0';
    } else {
      _decimalController.text = widget.item.amount.toString().split('.')[1];
    }
    _unit = widget.item.unit;
    _setDisplayDate();
  }

  void _setDisplayDate() {
    if (widget.item.limitDate == null) {
      _displayDate = 'なし';
      _limitDate = null;
    } else {
      _displayDate = _outputFormat.format(widget.item.limitDate!);
      _limitDate = widget.item.limitDate!.toIso8601String().split('T').first;
    }
  }

  @override
  void dispose() {
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

  // アイテムを登録する際に出るダイアログ
  Future<void> _updateItemDialog(String itemName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text('更新しました')]),
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

  void _updateItem() async {
    if (_amount <= 0) return;
    final currentUser = ref.watch(currentUserProvider);
    await ref
        .read(itemListProvider.notifier)
        .updateItem(widget.item.id, _amount, _unit, _limitDate, currentUser!);
    setState(() {
      _setDisplayDate();
    });
    _updateItemDialog(widget.item.itemName);
  }

  void _validation() {
    if (_intController.text == '') {
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
        _updateItem();
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
              // StatefulWidgetの場合、引数で渡された値を参照するにはwidgetを付ける
              child: Text(widget.item.itemName, style: textTheme.titleLarge),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Row(
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
                    child: Text(_displayDate),
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
              onPressed: _intController.text == '' ? null : _validation,
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
              child: const Text('更新', style: TextStyle(color: Colors.white)),
            ),
            // 余白
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ref.read(itemListProvider.notifier).removeItem(widget.item.id);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('削除', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
