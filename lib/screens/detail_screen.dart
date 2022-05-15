import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_apps/data/local/database_provider.dart';
import 'package:restaurant_apps/data/remote/api_service.dart';
import 'package:restaurant_apps/models/detail.dart';
import 'package:restaurant_apps/models/restaurants.dart';
import 'package:restaurant_apps/widget/menu_card.dart';

import '../data/remote/provider/detail_provider.dart';
import '../models/result_state.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = "/detail_screen";

  final String id;

  const DetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailProvider>(
        create: (_) => DetailProvider(apiService: ApiService(), id: id),
        child: const DetailScreenPage());
  }
}

class DetailScreenPage extends StatelessWidget {
  const DetailScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DetailProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.Success) {
            return _buildPage(context, state.result.restaurant);
          } else if (state.state == ResultState.Error) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error,
                  size: 80,
                ),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  onPressed: () {
                    state.reload();
                  },
                  child: const Text(
                    "Coba Lagi",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text(''));
          }
        },
      ),
    );
  }

  SafeArea _buildPage(BuildContext context, DetailRestaurant restaurant) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            sliverAppBar(restaurant),
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(13),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  restaurant.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Row(
                  children: [
                    const Icon(Icons.star),
                    Text(
                      restaurant.rating.toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_pin),
                Text(
                  restaurant.address + ", " + restaurant.city,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Description",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              restaurant.description,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Foods",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: restaurant.menus.foods.map((food) {
                    return MenuCard(
                      name: food.name,
                      image:
                          "https://mariettasquaremarket.com/wp-content/uploads/2018/12/Pita-Mediterranean-5.jpg",
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Drinks",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: restaurant.menus.drinks.map((drink) {
                    return MenuCard(
                      name: drink.name,
                      image:
                          "https://img.favpng.com/8/12/20/beer-fizzy-drinks-wine-cooler-wine-cooler-png-favpng-xYMSKmg4NF6DYX8nK7W4A7Rit.jpg",
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Customer Review",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Column(
              children: restaurant.customerReviews.map((review) {
                return _reviewItem(review, context, restaurant);
              }).toList(),
            ),
          ]),
        ),
      ),
    );
  }

  Consumer sliverAppBar(DetailRestaurant restaurant) {
    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      return FutureBuilder<bool>(
        future: provider.isFavorite(restaurant.id),
        builder: (context, snapshot) {
          var isFavorite = snapshot.data ?? false;
          return SliverAppBar(
            actions: [
              CircleAvatar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: isFavorite
                    ? IconButton(
                        icon: const Icon(Icons.favorite),
                        onPressed: () => provider.removeData(restaurant.id),
                      )
                    : IconButton(
                        icon: const Icon(Icons.favorite_outline),
                        onPressed: () => provider.addData(
                          Restaurant(
                              id: restaurant.id,
                              name: restaurant.name,
                              description: restaurant.description,
                              pictureId: restaurant.pictureId,
                              city: restaurant.city,
                              rating: restaurant.rating),
                        ),
                      ),
              ),
            ],
            pinned: true,
            expandedHeight: 200,
            flexibleSpace:  FlexibleSpaceBar(
              background:  Image.network(
                "https://restaurant-api.dicoding.dev/images/medium/" +
                    restaurant.pictureId,
                fit: BoxFit.fitWidth,
              ),
            ),
          );
        },
      );
    });
  }

  Material _reviewItem(CustomerReview review, BuildContext context,
      DetailRestaurant restaurant) {
    return Material(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(review.name),
            Text(
              review.date,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
        subtitle: Text(review.review),
      ),
    );
  }
}
