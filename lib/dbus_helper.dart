import 'package:dbus/dbus.dart';

class DbusHelper {
  Future<List<String>> getAvailableService() async {
    List<String> result = [];
    // Connect to either session or system bus
    final client = DBusClient.system(); // or DBusClient.system()

    try {
      // Call ListNames on the DBus interface
      final response = await client.callMethod(
        destination: 'org.freedesktop.DBus',
        path: DBusObjectPath('/org/freedesktop/DBus'),
        interface: 'org.freedesktop.DBus',
        name: 'ListNames',
      );

      final names = response.returnValues.first as DBusArray;

      print('Available D-Bus services:');
      for (final name in names.children) {
        if (name.toString().contains('org')) {
          result.add(name.toNative());
        }
        // print('- ${name.toNative()}');
      }
      for (final s in result) {
        print('- $s');
      }
    } catch (e) {
      print('Failed to list services: $e');
    } finally {
      await client.close();
    }
    return result;
  }

  Future<void> getDesktopService() async {
    final client = DBusClient.session();

    final response = await client.callMethod(
      destination: 'org.freedesktop.portal.Desktop',
      path: DBusObjectPath('/org/freedesktop/portal/desktop'),
      interface: 'org.freedesktop.DBus.Introspectable',
      name: 'Introspect',
    );

    final xml = (response.returnValues.first as DBusString).value;
    print('📄 Introspection XML:\n$xml');
  }

  Future<List<String>> getNetworkConfig() async {
    List<String> result = [];
    var client = DBusClient.system();
    var object = DBusRemoteObject(client,
        name: 'org.freedesktop.NetworkManager',
        path: DBusObjectPath('/org/freedesktop/NetworkManager'));

    var properties =
        await object.getAllProperties('org.freedesktop.NetworkManager');
    properties.forEach((name, value) {
      print('$name: ${value.toNative()}');
      result.add('$name: ${value.toNative()}');
    });

    print('Hardware addresses:');
    var devicePaths = properties['Devices']?.asObjectPathArray() ?? [];
    for (var path in devicePaths) {
      var device = DBusRemoteObject(client,
          name: 'org.freedesktop.NetworkManager', path: path);
      var address = await device.getProperty(
          'org.freedesktop.NetworkManager.Device', 'HwAddress');
      print('${address.toNative()}');
      result.add(address.toNative());
    }

    object.propertiesChanged.listen((signal) {
      signal.changedProperties.forEach((name, value) {
        print('$name: ${value.toNative()}');
        result.add('$name: ${value.toNative()}');
      });
    });
    return result;
  }
}
