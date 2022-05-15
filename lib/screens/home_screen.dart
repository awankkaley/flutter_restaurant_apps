import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_apps/screens/detail_screen.dart';
import 'package:restaurant_apps/screens/search_screen.dart';
import 'package:restaurant_apps/widget/platform_widget.dart';
import 'package:restaurant_apps/models/restaurants.dart';
import '../data/remote/provider/restaurant_provider.dart';
import '../models/result_state.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home_screen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return ListView.builder(
            shrinkWrap: true,
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
        title: const Text("My Restaurant"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, SearchScreen.routeName);
                },
                child: const Icon(
                  Icons.search,
                  size: 26.0,
                ),
              ))
        ],
      ),
      body: (_buildList(context)),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('My Restaurant'),
        trailing: GestureDetector(
          child: const Icon(CupertinoIcons.search),
          onTap: () {
            Navigator.pushNamed(context, SearchScreen.routeName);
          },
        ),
      ),
      child: _buildList(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
