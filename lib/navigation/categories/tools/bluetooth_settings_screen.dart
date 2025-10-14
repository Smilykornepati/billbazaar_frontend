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
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scanning completed'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
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
        backgroundColor: const Color(0xFFFF9800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          
          return Column(
            children: [
              _buildHeader(isSmallScreen),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildBluetoothStatus(isSmallScreen),
                      _buildQuickActions(isSmallScreen),
                      _buildDevicesList(isSmallScreen),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
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
            isSmallScreen ? 12 : 16,
            isSmallScreen ? 8 : 12,
            isSmallScreen ? 12 : 16,
            isSmallScreen ? 12 : 16,
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
              IconButton(
                onPressed: _startScanning,
                icon: _isScanning
                    ? SizedBox(
                        width: isSmallScreen ? 20 : 24,
                        height: isSmallScreen ? 20 : 24,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(
                        Icons.search,
                        color: Colors.white,
                        size: isSmallScreen ? 20 : 24,
                      ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBluetoothStatus(bool isSmallScreen) {
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
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.bluetooth,
                color: _isBluetoothEnabled ? const Color(0xFF10B981) : Colors.grey,
                size: isSmallScreen ? 28 : 32,
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bluetooth',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF26344F),
                      ),
                    ),
                    Text(
                      _isBluetoothEnabled ? 'Enabled' : 'Disabled',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: _isBluetoothEnabled ? const Color(0xFF10B981) : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isBluetoothEnabled,
                onChanged: (value) => _toggleBluetooth(),
                activeColor: const Color(0xFF10B981),
              ),
            ],
          ),
          if (_connectedDevice != null) ...[
            SizedBox(height: isSmallScreen ? 12 : 16),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: const Color(0xFF10B981),
                    size: isSmallScreen ? 16 : 18,
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Expanded(
                    child: Text(
                      'Connected to $_connectedDevice',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF10B981),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              'Scan Devices',
              Icons.search,
              _isScanning ? null : _startScanning,
              _isScanning,
              isSmallScreen,
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: _buildActionButton(
              'Pair Device',
              Icons.add,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pairing mode activated'),
                    backgroundColor: Color(0xFF5777B5),
                  ),
                );
              },
              false,
              isSmallScreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback? onPressed,
    bool isLoading,
    bool isSmallScreen,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? SizedBox(
                width: isSmallScreen ? 16 : 18,
                height: isSmallScreen ? 16 : 18,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                icon,
                size: isSmallScreen ? 16 : 18,
                color: Colors.white,
              ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5777B5),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 12 : 16,
            horizontal: isSmallScreen ? 8 : 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildDevicesList(bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Text(
              'Available Devices',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF26344F),
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _availableDevices.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              final device = _availableDevices[index];
              return _buildDeviceItem(device, isSmallScreen);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(Map<String, dynamic> device, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Row(
        children: [
          // Device Icon
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
            decoration: BoxDecoration(
              color: _getDeviceColor(device['type']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getDeviceIcon(device['type']),
              color: _getDeviceColor(device['type']),
              size: isSmallScreen ? 20 : 24,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          
          // Device Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        device['name'],
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF26344F),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (device['isConnected'])
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 6 : 8,
                          vertical: isSmallScreen ? 2 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Connected',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 9 : 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  device['address'],
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: Colors.grey[600],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.signal_cellular_alt,
                      size: isSmallScreen ? 12 : 14,
                      color: _getSignalColor(device['rssi']),
                    ),
                    SizedBox(width: isSmallScreen ? 4 : 6),
                    Text(
                      '${device['rssi']} dBm',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 10 : 11,
                        color: Colors.grey[500],
                      ),
                    ),
                    if (device['isPaired']) ...[
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Icon(
                        Icons.link,
                        size: isSmallScreen ? 12 : 14,
                        color: const Color(0xFF5777B5),
                      ),
                      SizedBox(width: isSmallScreen ? 2 : 4),
                      Text(
                        'Paired',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10 : 11,
                          color: const Color(0xFF5777B5),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Action Button
          if (_isBluetoothEnabled)
            device['isConnected']
                ? IconButton(
                    onPressed: () => _disconnectDevice(device),
                    icon: Icon(
                      Icons.link_off,
                      color: const Color(0xFFE91E63),
                      size: isSmallScreen ? 20 : 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                : IconButton(
                    onPressed: () => _connectToDevice(device),
                    icon: Icon(
                      Icons.link,
                      color: const Color(0xFF5777B5),
                      size: isSmallScreen ? 20 : 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(String type) {
    switch (type) {
      case 'Printer':
        return Icons.print;
      case 'Audio':
        return Icons.speaker;
      case 'Accessory':
        return Icons.inventory;
      default:
        return Icons.device_unknown;
    }
  }

  Color _getDeviceColor(String type) {
    switch (type) {
      case 'Printer':
        return const Color(0xFF5777B5);
      case 'Audio':
        return const Color(0xFF10B981);
      case 'Accessory':
        return const Color(0xFFFF9800);
      default:
        return Colors.grey;
    }
  }

  Color _getSignalColor(int rssi) {
    if (rssi > -50) {
      return const Color(0xFF10B981); // Strong signal
    } else if (rssi > -70) {
      return const Color(0xFFFF9800); // Medium signal
    } else {
      return const Color(0xFFE91E63); // Weak signal
    }
  }
}