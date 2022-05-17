import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_apps/screens/detail_screen.dart';
import 'package:restaurant_apps/widget/platform_widget.dart';

import '../data/remote/provider/search_provider.dart';
import '../models/restaurants.dart';
import '../models/result_state.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search_screen";

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Widget _buildList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter keywords",
              ),
              onSubmitted: (text) {
                if (text.isNotEmpty) {
                  Provider.of<SearchProvider>(context, listen: false)
                      .search(text);
                }
              }),
        ),
        Consumer<SearchProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.HasData) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.result.restaurants.length,
                itemBuilder: (context, index) {
                  var restaurant = state.result.restaurants[index];
                  return _buildRestaurantItem(context, restaurant);
                },
              );
            } else if (state.state == ResultState.NoData) {
              return Center(
                child: Text(state.message),
              );
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
                ],
              );
            } else {
              return const Center(child: Text(''));
            }
          },
        )
      ]),
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return Material(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        leading: Hero(
          tag: restaurant.pictureId,
          child: Image.network(
            "https://restaurant-api.dicoding.dev/images/small/" +
                restaurant.pictureId,
            width: 100,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(restaurant.name),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 14,
                ),
                Text(restaurant.rating.toString())
              ],
            ),
          ],
        ),
        subtitle: Row(
          children: [
            const Icon(
              Icons.location_pin,
              size: 14,
            ),
            Text(restaurant.city)
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, DetailScreen.routeName,
              arguments: restaurant.id);
        },
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Restaurant"),
      ),
      body: (_buildList(context)),
    );
  }

  Widget _buildIos(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Restaurant"),
      ),
      body: (_buildList(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: PlatformWidget(
        androidBuilder: _buildAndroid,
        iosBuilder: _buildIos,
      ),
    );
  }
}
