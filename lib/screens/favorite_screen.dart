import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_apps/data/local/db/database_helper.dart';
import 'package:restaurant_apps/data/local/db/database_provider.dart';
import 'package:restaurant_apps/models/restaurants.dart';
import '../models/result_state.dart';
import '../widget/platform_widget.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  static const routeName = "/favorite_screen";

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite"),
      ),
      body: (_buildList(context)),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Favorite'),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.HasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.favorite.length,
            itemBuilder: (context, index) {
              var restaurant = state.favorite[index];
              return _buildFavoriteItem(context, restaurant);
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
    );
  }

  Widget _buildFavoriteItem(BuildContext context, Restaurant restaurant) {
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
}
