import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/sample_provider.dart';

class FavoriteProviderButton extends StatefulWidget {
  final Map<String, dynamic> providerData;

  const FavoriteProviderButton({super.key, required this.providerData});

  @override
  State<FavoriteProviderButton> createState() => _FavoriteProviderButtonState();
}

class _FavoriteProviderButtonState extends State<FavoriteProviderButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SampleProvider>(
      builder: (context, provider, child) {
        return TextButton(
          onPressed: () {
            provider.addRemoveFavoriteProvider(widget.providerData, context);
          },
          child: Container(
            
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.person, color: Colors.black,),
                  provider.favProvidersIds.contains(widget.providerData["id"])
                    ? const Stack(
                        children: [
                          Icon(Icons.star, color: Colors.yellow,),
                          Icon(Icons.star_border, color: Colors.black,),
                        ],
                      )
                    : const Icon(Icons.star_border, color: Colors.black,),
                ],
              ),
            ),
          )
        );
      },
    );
  }
}
