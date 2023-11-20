import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/favorite_provider.dart';

class FavoriteProviderButton extends StatefulWidget {
  final Map<String, dynamic> providerData;

  const FavoriteProviderButton({super.key, required this.providerData});

  @override
  State<FavoriteProviderButton> createState() => _FavoriteProviderButtonState();
}

class _FavoriteProviderButtonState extends State<FavoriteProviderButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, provider, child) {
        return ElevatedButton(
          onPressed: () {
            provider.addRemoveFavoriteProvider(widget.providerData, context);
          },
          child: const Row(
            children: [
              Text("Fav. prov."),
            ],
          )
        );
      },
    );
  }
}
