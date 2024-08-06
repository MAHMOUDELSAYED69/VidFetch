import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vid_fetch/utils/constants/images.dart';
import 'package:vid_fetch/utils/extentions/extentions.dart';

import '../../utils/constants/routes.dart';
import '../../viewmodel/download_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class VideoDownloaderScreen extends StatefulWidget {
  const VideoDownloaderScreen({super.key});

  @override
  State<VideoDownloaderScreen> createState() => _VideoDownloaderScreenState();
}

class _VideoDownloaderScreenState extends State<VideoDownloaderScreen> {
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  late GlobalKey<FormState> _formKey;
  String? _url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(ImageManager.logo, width: 40),
            const SizedBox(width: 5),
            const Text("Vid Fetch"),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer(
            builder: (context, ref, child) {
              final downloadState = ref.watch(downloadStateProvider);
              return Column(
                children: [
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        ImageManager.youtube,
                        width: 100,
                      ),
                      SizedBox(width: 20.w),
                      Image.asset(ImageManager.shorts, width: 100),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  Text(
                    "Youtube Video Downloader",
                    style: context.textTheme.bodyLarge,
                  ),
                  SizedBox(height: 10.h),
                  Form(
                    key: _formKey,
                    child: MyTextFormField(
                      onSaved: (data) {
                        _url = data;
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  MyElevatedButton(
                    isDisabled: downloadState.isDownloading,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState!.save();
                        log("$_url");

                        ref
                            .read(downloadStateProvider.notifier)
                            .downloadVideo(_url!);
                      }
                    },
                    title: "Download",
                  ),
                  if (downloadState.isDownloading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        downloadState.message!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 20.h),
                  MyElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteManager.audioDownloader);
                    },
                    title: 'Youtube To MP3',
                  ),
                  SizedBox(height: 20.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
