import 'package:flutter/material.dart';
import 'package:sample/ui/buttons/circular_avatar_button.dart';

class BetaBanner extends StatelessWidget {
  const BetaBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 120,
      child: Stack(
        children: [
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Container(
              color: Colors.red,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'BETA TEST',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
              top: 0.0,
              right: 0.0,
              child: CircularAvatarButton()
          ),
        ],
      ),
    );
  }
}
