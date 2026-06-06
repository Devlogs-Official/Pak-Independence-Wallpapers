import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/models/category_ui_model.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/widgets/category_card.dart';

void main() {
  testWidgets('category card shows category title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 180,
            height: 220,
            child: CategoryCard(
              category: const CategoryUiModel(
                id: 1,
                title: 'Pakistani Flag Wallpapers',
                imagePath: 'assets/images/paki_flag.png',
              ),
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Pakistani Flag Wallpapers'), findsOneWidget);
  });
}
