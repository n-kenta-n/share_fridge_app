import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modules/fridges/current_fridge_provider.dart';
import '../modules/fridges/fridge_list_provider.dart';

class FridgeDropdown extends ConsumerStatefulWidget {
  const FridgeDropdown({super.key});

  @override
  FridgeDropdownState createState() => FridgeDropdownState();
}

class FridgeDropdownState extends ConsumerState<FridgeDropdown> {
  final TextEditingController fridgeController = TextEditingController();
  String? selectedFridge;

  @override
  Widget build(BuildContext context) {
    final fridgeList = ref.watch(fridgeListProvider);
    final currentFridge = ref.watch(currentFridgeProvider);
    selectedFridge = currentFridge;

    return fridgeList.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => Text('Error: $e'),
      data: (fridges) {
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DropdownMenu<String>(
                  initialSelection: selectedFridge,
                  controller: fridgeController,
                  requestFocusOnTap: true,
                  label: const Text('誰の冷蔵庫？'),
                  onSelected: (String? fridgeId) {
                    setState(() {
                      selectedFridge = fridgeId;
                      ref
                          .read(currentFridgeProvider.notifier)
                          .setFridgeId(fridgeId!);
                    });
                  },
                  dropdownMenuEntries:
                      fridges.map((fridge) {
                        return DropdownMenuEntry<String>(
                          value: fridge.fridgeId,
                          label: fridge.userName,
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
