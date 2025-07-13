import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class SettingsContentScreen extends ConsumerStatefulWidget {
  const SettingsContentScreen({super.key});

  @override
  ConsumerState<SettingsContentScreen> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<SettingsContentScreen> {
  @override
  void initState() {
    super.initState();
    // Future(() => ref.read(settingsControllerProvider.notifier).fetchHomeBlocks());
  }

  @override
  Widget build(BuildContext context) {
    // final homeState = ref.watch(settingsControllerProvider);

    return Scaffold(
      // body: homeState.homeStates == RequestStates.loaded
      //     ? _buildContent(homeState.homeBlock!)
      //     : homeState.homeStates == RequestStates.loading
      //     ? const Center(child: FadeCircleLoadingIndicator())
      //     : homeState.homeStates == RequestStates.error
      //     ? AppErrorWidget(
      //         onTap: () => Future(
      //           () =>
      //               ref.read(settingsControllerProvider.notifier).fetchHomeBlocks(),
      //         ),
      //       )
      //     : SizedBox.shrink(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 75.h,
        ), //+ 25.h vetrical padding in buildContentItem
        child: Column(children: [Center(child: Text('SEttings'))]),
      ),
    );
  }
}
