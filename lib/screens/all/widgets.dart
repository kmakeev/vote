import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class WaitWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
          SpinKitThreeBounce(color: Colors.white54, size: 160),
        ])
      ],
    );
  }
}

class RestorePasswordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Необходимо восстановить доступ!',
              style: TextStyle(color: Colors.white, fontSize: 50)),
        ]),
      ],
    );
  }
}