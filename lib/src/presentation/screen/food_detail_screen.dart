import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_japanese_restaurant_app/core/app_icon.dart';
import 'package:flutter_japanese_restaurant_app/core/app_color.dart';
import 'package:flutter_japanese_restaurant_app/core/app_extension.dart';
import 'package:flutter_japanese_restaurant_app/src/data/model/food.dart';
import 'package:flutter_japanese_restaurant_app/src/presentation/widget/counter_button.dart';
import 'package:flutter_japanese_restaurant_app/src/business_logic/cubits/food/food_cubit.dart';
import 'package:flutter_japanese_restaurant_app/src/presentation/animation/scale_animation.dart';
import 'package:flutter_japanese_restaurant_app/src/business_logic/cubits/theme/theme_cubit.dart';

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({Key? key, required this.food}) : super(key: key);

  final Food food;

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Food Detail Screen",
        style: TextStyle(
          color: context.read<ThemeCubit>().isLightTheme
              ? Colors.black
              : Colors.white,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final List<Food> foodList = context.watch<FoodCubit>().state.foodList;

    Widget fab(VoidCallback onPressed) {
      return FloatingActionButton(
        elevation: 0.0,
        backgroundColor: LightThemeColor.accent,
        onPressed: onPressed,
        child: foodList[foodList.getIndex(food)].isFavorite
            ? const Icon(AppIcon.heart)
            : const Icon(AppIcon.outlinedHeart),
      );
    }

    return Scaffold(
      appBar: _appBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: fab(
        () => context
            .read<FoodCubit>()
            .isFavorite(foodList[foodList.getIndex(food)]),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: SizedBox(
          height: height * 0.5,
          child: Container(
            decoration: BoxDecoration(
              color: context.read<ThemeCubit>().isLightTheme
                  ? Colors.white
                  : DarkThemeColor.primaryLight,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RatingBar.builder(
                          itemPadding: EdgeInsets.zero,
                          itemSize: 20,
                          initialRating: food.score,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          glow: false,
                          ignoreGestures: true,
                          itemBuilder: (_, __) => const FaIcon(
                            FontAwesomeIcons.solidStar,
                            color: LightThemeColor.yellow,
                          ),
                          onRatingUpdate: (_) {},
                        ),
                        const SizedBox(width: 15),
                        Text(
                          food.score.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "(${food.voter})",
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ).fadeAnimation(0.4),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${food.price}",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: LightThemeColor.accent),
                        ),
                        BlocBuilder<FoodCubit, FoodState>(
                          builder: (context, state) {
                            return CounterButton(
                              onIncrementSelected: () => context
                                  .read<FoodCubit>()
                                  .increaseQuantity(food),
                              onDecrementSelected: () => context
                                  .read<FoodCubit>()
                                  .decreaseQuantity(food),
                              label: Text(
                                state.foodList[state.foodList.getIndex(food)]
                                    .quantity
                                    .toString(),
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            );
                          },
                        )
                      ],
                    ).fadeAnimation(0.6),
                    const SizedBox(height: 15),
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.displayMedium,
                    ).fadeAnimation(0.8),
                    const SizedBox(height: 15),
                    Text(
                      food.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ).fadeAnimation(0.8),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                        child: ElevatedButton(
                          onPressed: () =>
                              context.read<FoodCubit>().addToCart(food),
                          child: const Text("Add to cart"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: ScaleAnimation(
        child: Center(child: Image.asset(food.image, scale: 2)),
      ),
    );
  }
}
