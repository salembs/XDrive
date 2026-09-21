import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/unlock_screen.dart';
import 'package:flutter_application_1/services/car_control_service.dart';

class ControlScreen extends StatefulWidget {
  final CarControlService service;
  const ControlScreen({super.key, required this.service});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool _engineStarted = false;
  bool _rightDoorClosed = true;
  bool _leftDoorClosed = true;
  bool _trunkClosed = true;
  bool _climateOn = false;
  bool _lightsOn = false; // New state for lights

  @override
  void initState() {
    super.initState();
    // Initialize state from the first Firebase data
    widget.service.getCarState().first.then((data) {
      setState(() {
        _engineStarted = data['engine'] == 'on';
        _rightDoorClosed = data['right_door'] == 'locked';
        _leftDoorClosed = data['left_door'] == 'locked';
        _trunkClosed = data['trunk'] == 'closed';
        _climateOn = data['ac'] == 'on';
        _lightsOn = data['lights'] == 'on'; // Initialize lights state
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building ControlScreen'); // Debug print
    return StreamBuilder<Map<String, dynamic>>(
      stream: widget.service.getCarState(),
      builder: (context, snapshot) {
        print(
          'StreamBuilder state: hasData=${snapshot.hasData}, hasError=${snapshot.hasError}, error=${snapshot.error}',
        );
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 4.0,
            ),
          );
        }
        if (snapshot.hasError) {
          print('StreamBuilder error: ${snapshot.error}');
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No data available from Firebase',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final data = snapshot.data!;
        if (_lightsOn != (data['lights'] == 'on')) {
          setState(() {
            _lightsOn = data['lights'] == 'on';
          });
        }

        return Container(
          color: const Color(0xFF0A1622),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Porsche',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '718 Cayman GT4',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UnlockScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_open,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      'assets/ctrl_Img.jpg',
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        print('Image load error: $error');
                        return Container(color: Colors.red, height: 200);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Controls',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: [
                        _buildControlTile(
                          title: 'Engine',
                          subtitle: _engineStarted ? 'Started' : 'Stopped',
                          isActive: _engineStarted,
                          icon: Icons.power_settings_new,
                          onChanged: (value) async {
                            setState(() => _engineStarted = value);
                            await widget.service.toggleEngine(value);
                          },
                        ),
                        _buildControlTile(
                          title: 'Right Door',
                          subtitle: _rightDoorClosed ? 'Closed' : 'Open',
                          isActive: !_rightDoorClosed,
                          icon: Icons.lock,
                          onChanged: (value) async {
                            setState(() => _rightDoorClosed = !value);
                            await widget.service.toggleDoors(!value);
                          },
                        ),
                        _buildControlTile(
                          title: 'Trunk',
                          subtitle: _trunkClosed ? 'Closed' : 'Open',
                          isActive: !_trunkClosed,
                          icon: Icons.work,
                          onChanged: (value) async {
                            setState(() => _trunkClosed = !value);
                            await widget.service.toggleTrunk(!value);
                          },
                        ),
                        _buildControlTile(
                          title: 'Left Door',
                          subtitle: _leftDoorClosed ? 'Closed' : 'Open',
                          isActive: !_leftDoorClosed,
                          icon: Icons.lock,
                          onChanged: (value) async {
                            setState(() => _leftDoorClosed = !value);
                            await widget.service.toggleLeftDoor(!value);
                          },
                        ),
                        _buildControlTile(
                          title: 'Lights',
                          subtitle: _lightsOn ? 'On' : 'Off',
                          isActive: _lightsOn,
                          icon: Icons.lightbulb_outline,
                          onChanged: (value) async {
                            setState(() => _lightsOn = value);
                            await widget.service.toggleLights(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlTile({
    required String title,
    required String subtitle,
    required bool isActive,
    required IconData icon,
    required Function(bool) onChanged,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      color:
          isActive
              ? Theme.of(context).primaryColor
              : Colors.black.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          onChanged(!isActive);
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isActive,
                  onChanged: onChanged,
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.white,
                  activeTrackColor: Colors.white.withOpacity(0.4),
                  inactiveTrackColor: Colors.grey.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
