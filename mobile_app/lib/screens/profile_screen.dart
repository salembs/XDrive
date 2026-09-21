import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/car_control_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CarControlService _service = CarControlService();
  late int _red = 0;
  late int _green = 0;
  late int _blue = 0;
  double _sliderValue = 0;

  @override
  void initState() {
    super.initState();
    _service.getCarState().first.then((data) {
      setState(() {
        _red = data['r'] ?? 0;
        _green = data['g'] ?? 0;
        _blue = data['b'] ?? 0;
        _sliderValue = (_red + _green + _blue) / 3 / 255;
      });
    });
  }

  void _updateColor(double sliderValue) {
    // Convert slider value (0 to 1) to a hue (0 to 360)
    final hue = sliderValue * 360;
    final color = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    final newRed = color.red;
    final newGreen = color.green;
    final newBlue = color.blue;

    setState(() {
      _red = newRed;
      _green = newGreen;
      _blue = newBlue;
      _sliderValue = sliderValue;
    });

    _service.setRed(newRed);
    _service.setGreen(newGreen);
    _service.setBlue(newBlue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A1622),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: const Color(0xFF101B2D),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, size: 80, color: Colors.white54),
                    const SizedBox(height: 20),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildInfoItem('Name', 'John Doe'),
                    _buildInfoItem('Email', 'nom.prenom@gmail.com'),
                    _buildInfoItem('Car', 'Porsche 718 Cayman GT4'),
                    _buildInfoItem('Date of Buying', 'May 12, 2023'),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Color: RGB($_red, $_green, $_blue)',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackShape: GradientSliderTrackShape(),
                        thumbColor: Color.fromRGBO(_red, _green, _blue, 1),
                        overlayColor: Colors.transparent,
                        trackHeight: 10.0,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8.0,
                        ),
                      ),
                      child: SizedBox(
                        height: 40,
                        child: Slider(
                          value: _sliderValue,
                          min: 0,
                          max: 1,
                          divisions: 255,
                          onChanged: (value) {
                            _updateColor(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class GradientSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = true,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackBounds = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint paint =
        Paint()
          ..shader = const LinearGradient(
            colors: [
              Colors.red,
              Colors.yellow,
              Colors.green,
              Colors.cyan,
              Colors.blue,
              Colors.purple,
              Colors.red, // Loop back to red
            ],
            stops: [0.0, 0.17, 0.33, 0.5, 0.67, 0.83, 1.0],
          ).createShader(trackBounds);

    final RRect trackRRect = RRect.fromRectAndRadius(
      trackBounds,
      Radius.circular(sliderTheme.trackHeight! / 2),
    );

    context.canvas.drawRRect(trackRRect, paint);
  }
}
