import 'package:flutter/material.dart';

class BluetoothSettingsScreen extends StatefulWidget {
  const BluetoothSettingsScreen({super.key});

  @override
  State<BluetoothSettingsScreen> createState() => _BluetoothSettingsScreenState();
}

class _BluetoothSettingsScreenState extends State<BluetoothSettingsScreen> {
  bool _isBluetoothEnabled = true;
  bool _isScanning = false;
  String? _connectedDevice;
  
  final List<Map<String, dynamic>> _availableDevices = [
    {
      'name': 'POS Printer TM-T20',
      'address': '00:11:22:33:44:55',
      'type': 'Printer',
      'rssi': -45,
      'isConnected': true,
      'isPaired': true,
    },
    {
      'name': 'Bluetooth Speaker',
      'address': '00:11:22:33:44:56',
      'type': 'Audio',
      'rssi': -65,
      'isConnected': false,
      'isPaired': true,
    },
    {
      'name': 'Thermal Printer 80mm',
      'address': '00:11:22:33:44:57',
      'type': 'Printer',
      'rssi': -55,
      'isConnected': false,
      'isPaired': false,
    },
    {
      'name': 'Cash Drawer',
      'address': '00:11:22:33:44:58',
      'type': 'Accessory',
      'rssi': -40,
      'isConnected': false,
      'isPaired': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _connectedDevice = _availableDevices.firstWhere(
      (device) => device['isConnected'],
      orElse: () => {},
    )['name'];
  }

  void _toggleBluetooth() {
    setState(() {
      _isBluetoothEnabled = !_isBluetoothEnabled;
      if (!_isBluetoothEnabled) {
        _connectedDevice = null;
        for (var device in _availableDevices) {
          device['isConnected'] = false;
        }
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bluetooth ${_isBluetoothEnabled ? 'enabled' : 'disabled'}'),
        backgroundColor: _isBluetoothEnabled ? const Color(0xFF10B981) : const Color(0xFFE91E63),
      ),
    );
  }

  void _startScanning() {
    if (!_isBluetoothEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable Bluetooth first'),
          backgroundColor: Color(0xFFE91E63),
        ),
      );
      return;
    }

    setState(() {
      _isScanning = true;
    });

    // Simulate scanning for 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isScanning = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scanning completed'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    });
  }

  void _connectToDevice(Map<String, dynamic> device) {
    if (!_isBluetoothEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable Bluetooth first'),
          backgroundColor: Color(0xFFE91E63),
        ),
      );
      return;
    }

    setState(() {
      // Disconnect all other devices
      for (var d in _availableDevices) {
        d['isConnected'] = false;
      }
      
      // Connect to selected device
      device['isConnected'] = true;
      device['isPaired'] = true;
      _connectedDevice = device['name'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connected to ${device['name']}'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _disconnectDevice(Map<String, dynamic> device) {
    setState(() {
      device['isConnected'] = false;
      if (_connectedDevice == device['name']) {
        _connectedDevice = null;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Disconnected from ${device['name']}'),
        backgroundColor: const Color(0xFF6B7280),
      ),
    );
  }

  void _unpairDevice(Map<String, dynamic> device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unpair Device'),
        content: Text('Are you sure you want to unpair ${device['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                device['isConnected'] = false;
                device['isPaired'] = false;
                if (_connectedDevice == device['name']) {
                  _connectedDevice = null;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${device['name']} unpaired'),
                  backgroundColor: const Color(0xFF6B7280),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
            ),
            child: const Text('Unpair'),
          ),
        ],
      ),
    );
  }

  void _showDeviceDetails(Map<String, dynamic> device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(device['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Device Type:', device['type']),
            _buildDetailRow('MAC Address:', device['address']),
            _buildDetailRow('Signal Strength:', '${device['rssi']} dBm'),
            _buildDetailRow('Status:', device['isConnected'] ? 'Connected' : 'Disconnected'),
            _buildDetailRow('Pairing:', device['isPaired'] ? 'Paired' : 'Not Paired'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (device['isPaired'] && !device['isConnected'])
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _connectToDevice(device);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
              ),
              child: const Text('Connect'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        
        return Padding(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 3 : 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: isSmallScreen ? 100 : 120,
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getSignalColor(int rssi) {
    if (rssi >= -50) return const Color(0xFF10B981);
    if (rssi >= -70) return const Color(0xFFFF805D);
    return const Color(0xFFE91E63);
  }

  IconData _getDeviceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'printer':
        return Icons.print;
      case 'audio':
        return Icons.speaker;
      case 'accessory':
        return Icons.devices_other;
      default:
        return Icons.bluetooth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildBluetoothStatus(),
            _buildQuickActions(),
            Expanded(child: _buildDevicesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF5777B5), Color(0xFF26344F)],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 16 : 20, 
                isSmallScreen ? 14 : 18, 
                isSmallScreen ? 16 : 20, 
                isSmallScreen ? 18 : 24
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios, 
                      color: Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Expanded(
                    child: Text(
                      'Bluetooth Settings',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16.0 : 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Transform.scale(
                    scale: isSmallScreen ? 0.9 : 1.0,
                    child: Switch(
                      value: _isBluetoothEnabled,
                      onChanged: (value) => _toggleBluetooth(),
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xFF10B981),
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

  Widget _buildBluetoothStatus() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        
        return Container(
          margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                decoration: BoxDecoration(
                  color: (_isBluetoothEnabled ? const Color(0xFF10B981) : const Color(0xFF6B7280)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bluetooth,
                  color: _isBluetoothEnabled ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                  size: isSmallScreen ? 28 : 32,
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bluetooth Status',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF26344F),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _isBluetoothEnabled ? 'Enabled' : 'Disabled',
                      style: TextStyle(
                        color: _isBluetoothEnabled ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                        fontSize: isSmallScreen ? 13 : 14,
                      ),
                    ),
                    if (_connectedDevice != null)
                      Text(
                        'Connected to: $_connectedDevice',
                        style: TextStyle(
                          color: const Color(0xFF6B7280),
                          fontSize: isSmallScreen ? 11 : 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        
        return Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isSmallScreen
              ? Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isScanning ? null : _startScanning,
                        icon: _isScanning 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.search, size: 18),
                        label: Text(
                          _isScanning ? 'Scanning...' : 'Scan Devices',
                          style: const TextStyle(fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5777B5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isBluetoothEnabled ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Making device discoverable...'),
                              backgroundColor: Color(0xFF10B981),
                            ),
                          );
                        } : null,
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text(
                          'Make Discoverable',
                          style: TextStyle(fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF805D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isScanning ? null : _startScanning,
                        icon: _isScanning 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.search, size: 20),
                        label: Text(_isScanning ? 'Scanning...' : 'Scan Devices'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5777B5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isBluetoothEnabled ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Making device discoverable...'),
                              backgroundColor: Color(0xFF10B981),
                            ),
                          );
                        } : null,
                        icon: const Icon(Icons.visibility, size: 20),
                        label: const Text('Make Discoverable'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF805D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildDevicesList() {
    final pairedDevices = _availableDevices.where((device) => device['isPaired']).toList();
    final availableDevices = _availableDevices.where((device) => !device['isPaired']).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        
        return Container(
          margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pairedDevices.isNotEmpty) ...[
                Text(
                  'Paired Devices',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF26344F),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                ...pairedDevices.map((device) => _buildDeviceCard(device, isPaired: true, isSmallScreen: isSmallScreen)),
              ],
              if (availableDevices.isNotEmpty) ...[
                SizedBox(height: isSmallScreen ? 12 : 16),
                Text(
                  'Available Devices',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF26344F),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                ...availableDevices.map((device) => _buildDeviceCard(device, isPaired: false, isSmallScreen: isSmallScreen)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device, {required bool isPaired, bool isSmallScreen = false}) {
    return Card(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 6 : 8),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
          decoration: BoxDecoration(
            color: const Color(0xFF5777B5).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getDeviceIcon(device['type']),
            color: const Color(0xFF5777B5),
            size: isSmallScreen ? 18 : 20,
          ),
        ),
        title: Text(
          device['name'],
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF26344F),
            fontSize: isSmallScreen ? 13 : 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              device['address'],
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: isSmallScreen ? 10 : 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Icon(
                  Icons.signal_cellular_alt,
                  size: isSmallScreen ? 10 : 12,
                  color: _getSignalColor(device['rssi']),
                ),
                SizedBox(width: isSmallScreen ? 2 : 4),
                Text(
                  '${device['rssi']} dBm',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 9 : 10,
                    color: _getSignalColor(device['rssi']),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 6 : 8),
                if (device['isConnected'])
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 4 : 6, 
                      vertical: 2
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Connected',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 9 : 10,
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'connect':
                _connectToDevice(device);
                break;
              case 'disconnect':
                _disconnectDevice(device);
                break;
              case 'unpair':
                _unpairDevice(device);
                break;
              case 'details':
                _showDeviceDetails(device);
                break;
            }
          },
          itemBuilder: (context) => [
            if (isPaired && !device['isConnected'])
              PopupMenuItem(
                value: 'connect',
                child: Row(
                  children: [
                    Icon(Icons.link, size: isSmallScreen ? 14 : 16),
                    SizedBox(width: isSmallScreen ? 6 : 8),
                    Text(
                      'Connect',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            if (device['isConnected'])
              PopupMenuItem(
                value: 'disconnect',
                child: Row(
                  children: [
                    Icon(Icons.link_off, size: isSmallScreen ? 14 : 16),
                    SizedBox(width: isSmallScreen ? 6 : 8),
                    Text(
                      'Disconnect',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            if (isPaired)
              PopupMenuItem(
                value: 'unpair',
                child: Row(
                  children: [
                    Icon(Icons.bluetooth_disabled, size: isSmallScreen ? 14 : 16),
                    SizedBox(width: isSmallScreen ? 6 : 8),
                    Text(
                      'Unpair',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 'details',
              child: Row(
                children: [
                  Icon(Icons.info, size: isSmallScreen ? 14 : 16),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Text(
                    'Details',
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          if (!isPaired) {
            // Pair new device
            setState(() {
              device['isPaired'] = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${device['name']} paired successfully'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
          } else if (!device['isConnected']) {
            _connectToDevice(device);
          }
        },
      ),
    );
  }
}