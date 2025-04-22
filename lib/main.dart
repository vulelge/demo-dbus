import 'package:demo_dbus/dbus_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debus Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> availableService = [];
  List<String> networkConfig = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'List available service dbus',
                  style: TextStyle(fontSize: 22),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: availableService.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(availableService[index],
                            textAlign: TextAlign.center),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      availableService = await DbusHelper().getAvailableService();
                      setState(() {});
                    },
                    child: const Text(
                      "Get available service",
                    )),
                    const SizedBox(height: 32,)
              ],
            ),
          ),
             Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Network config property',
                  style: TextStyle(fontSize: 22),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: networkConfig.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(availableService[index],
                            textAlign: TextAlign.center),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      networkConfig = await DbusHelper().getNetworkConfig();
                      setState(() {});
                    },
                    child: const Text(
                      "Get getwork config property",
                    )),
                    const SizedBox(height: 32,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
