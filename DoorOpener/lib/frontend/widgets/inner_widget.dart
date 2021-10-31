import 'package:flutter/material.dart';
import 'package:raspberry_pi_door_opener/utils/tcp/tcp_connection.dart';

class InnerWidget extends StatefulWidget {
  final double value;

  const InnerWidget(this.value);

  @override
  _InnerWidgetState createState() => _InnerWidgetState();
}

class _InnerWidgetState extends State<InnerWidget> {
  final size = 200.0;
  Color keyColor = Colors.red;

  Future<void> _pressed(int time) async {
    TCP().openDoor(time, context);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      keyColor = Colors.green;
    });
    await Future.delayed(Duration(milliseconds: time));
    setState(() {
      keyColor = Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: size - 40,
                  height: size - 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.vpn_key_outlined,
                          color: keyColor,
                          size: 40,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${widget.value.ceil()}',
                          style: Theme.of(context).textTheme.headline1.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.normal,
                                color: Colors.white.withOpacity(.55),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          _pressed((widget.value.ceil()) * 1000);
        },
        onLongPress: () {
          _pressed((widget.value.ceil()) * 1000);
        },
      ),
    );
  }
}
