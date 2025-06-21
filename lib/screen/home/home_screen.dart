import 'package:bizcopilot_flutter/provider/example/example_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../static/state/example_api_result_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // ini contoh trigger hit api di page start
    context.read<ExampleApiProvider>().addRestaurantReview(
      "id",
      "name",
      "review",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<ExampleApiProvider>(
          builder: (context, value, child) {
            return switch (value.resultState) {
              // nanti di isi UI nya
              ExampleApiLoadingState() => const Text("Loading"),
              ExampleApiLoadedState(data: var data) => Text(data),
              ExampleApiErrorState(error: var message) => Text(message),
              _ => const SizedBox(),
            };
          },
        ),
      ),
    );
  }
}
