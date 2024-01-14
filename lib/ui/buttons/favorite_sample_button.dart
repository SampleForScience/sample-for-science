import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/sample_provider.dart';

class FavoriteSampleButton extends StatefulWidget {
  final Map<String, dynamic> sampleData;

  const FavoriteSampleButton({super.key, required this.sampleData});

  @override
  State<FavoriteSampleButton> createState() => _FavoriteSampleButtonState();
}

class _FavoriteSampleButtonState extends State<FavoriteSampleButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SampleProvider>(
      builder: (context, provider, child) {
        return TextButton(
          onPressed: () {
            provider.addRemoveFavoriteSample(widget.sampleData["id"], context);
          },
          child: Container(
            
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.science, color: Colors.black,),
                  provider.favSamplesIds.contains(widget.sampleData["id"])
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
