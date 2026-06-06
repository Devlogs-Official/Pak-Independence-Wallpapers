import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/models/category_ui_model.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/widgets/category_card.dart';
import '../../../category/presentation/screens/category_detail_screen.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key, required this.categories});

  final List<CategoryUiModel> categories;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final ratio =  width < 380 ? 0.82 : 0.78;

    return GridView.builder(
      itemCount: categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: ratio,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];

        return CategoryCard(
          category: category,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => category.id == 0
                    ? const FavoritesScreen()
                    : CategoryDetailScreen(categoryId: category.id),
              ),
            );
          },
        );
      },
    );
  }
}
