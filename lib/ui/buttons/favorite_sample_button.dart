import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/favorite_provider.dart';

class FavoriteSampleButton extends StatefulWidget {
  final Map<String, dynamic> providerData;

  const FavoriteSampleButton({super.key, required this.providerData});

  @override
  State<FavoriteSampleButton> createState() => _FavoriteSampleButtonState();
}

class _FavoriteSampleButtonState extends State<FavoriteSampleButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, provider, child) {
        return ElevatedButton(
            onPressed: () {
              provider.addRemoveFavoriteSample(widget.providerData, context);
            },
            child: const Row(
              children: [
                Text("Fav. sample"),
              ],
            )
        );
      },
    );
  }
}
