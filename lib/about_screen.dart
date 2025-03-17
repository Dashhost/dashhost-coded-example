import 'package:dashhost_flutter/dashhost_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DashText("About Dashhost"),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DashMetaTag.title('About Page'),
              DashMetaTag.description(
                "Example of the utilization of the revolutionary package and dashhost_flutter for the implementation of an App in the Dashhost environment",
              ),
              DashText("DISCLAIMER:", style: TextStyle(fontSize: 24)),
              DashText(
                'Example of the utilization of the revolutionary package and dashhost_flutter for the implementation of an App in the Dashhost environment',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
