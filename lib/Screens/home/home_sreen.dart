import 'package:flutter/material.dart';
import 'package:money_app/Screens/add_transaction/screen_add_transaction.dart';
import 'package:money_app/Screens/category/category_add_popup.dart';
import 'package:money_app/Screens/category/screen_category.dart';
import 'package:money_app/Screens/home/Widgets/bottom_navigation.dart';
import 'package:money_app/Screens/transactions/screen_transaction.dart';
import 'package:money_app/db/category/category_db.dart';
import 'package:money_app/model/category/category_model.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedInedexNotifier = ValueNotifier(0);

  final _pages = const [
    ScreenTransactions(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('MONEY MANAGER'),
        centerTitle: true,
      ),
      bottomNavigationBar: const MoneyAppBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedInedexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedInedexNotifier.value == 0) {
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          } else {
            showCategoryPopup(context);

            // final _sample = CatergoryModel(
            //   id: DateTime.now().millisecondsSinceEpoch.toString(),
            //   name: 'Travel',
            //   type: CategoryType.expense,
            // );
            // CategoryDB().insertCategory(_sample);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
