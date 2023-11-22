import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/favorite_provider.dart';

class FavoriteSampleButton extends StatefulWidget {
  final Map<String, dynamic> sampleData;

  const FavoriteSampleButton({super.key, required this.sampleData});

  @override
  State<FavoriteSampleButton> createState() => _FavoriteSampleButtonState();
}

class _FavoriteSampleButtonState extends State<FavoriteSampleButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, provider, child) {
        return TextButton(
          onPressed: () {
            provider.addRemoveFavoriteSample(widget.sampleData, context);
          },
          child: SizedBox(
            // width: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.science),
                provider.favSamplesIds.contains(widget.sampleData["id"])
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_border),
              ],
            ),
          )
        );
      },
    );
  }
}
