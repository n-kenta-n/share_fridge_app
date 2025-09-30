import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class PickImageSheet extends ConsumerStatefulWidget {
  const PickImageSheet({super.key});

  @override
  AcceptBottomSheetState createState() => AcceptBottomSheetState();

  static Future<File?> show(BuildContext context) {
    return showModalBottomSheet<File?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const PickImageSheet(),
    );
  }
}

class AcceptBottomSheetState extends ConsumerState<PickImageSheet> {
  final ImagePicker _picker = ImagePicker();

  // 画像を取得するメソッド
  // 引数の数字によってギャラリー or カメラを分岐する
  Future<File?> _pickImage(int num) async {
    XFile? pickedFile;
    File? selectedImage;

    if (num == 0) {
      pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, // サムネイル用途に軽量化
      );
    } else {
      pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800, // サムネイル用途に軽量化
      );
    }

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'トリミング',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            statusBarColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true, // 比率を固定（Android）
          ),
          IOSUiSettings(
            title: 'トリミング',
            aspectRatioLockEnabled: true, // 比率を固定（IOS）
          ),
        ],
      );

      if (croppedFile != null) {
        selectedImage = File(croppedFile.path);
      }
    }
    return selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () async {
              // 先に変数に格納しておくことでDon't use 'BuildContext's across async gaps.のエラーを回避する
              final navigator = Navigator.of(context);
              final picked = await _pickImage(0);
              navigator.pop(picked); // 選択した画像を前の画面に返す
            },
            icon: const Icon(Icons.photo),
            iconSize: MediaQuery.of(context).size.width * 0.125,
          ),
          IconButton(
            onPressed: () async {
              // 先に変数に格納しておくことでDon't use 'BuildContext's across async gaps.のエラーを回避する
              final navigator = Navigator.of(context);
              final picked = await _pickImage(1);
              navigator.pop(picked); // 選択した画像を前の画面に返す
            },
            icon: const Icon(Icons.camera_alt),
            iconSize: MediaQuery.of(context).size.width * 0.125,
          ),
        ],
      ),
    );
  }
}
