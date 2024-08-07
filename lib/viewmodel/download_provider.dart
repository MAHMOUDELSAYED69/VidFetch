import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vid_fetch/service/download_service.dart';

final downloadStateProvider =
    StateNotifierProvider<DownloadStateNotifier, DownloadState>(
  (ref) => DownloadStateNotifier(),
);

class DownloadState {
  final bool isVideoDownloading;
  final bool isAudioDownloading;

  final String? message;

  DownloadState({
    this.isVideoDownloading = false,
    this.isAudioDownloading = false,
    this.message,
  });

  DownloadState copyWith({
    bool? isVideoDownloading,
    bool? isAudioDownloading,
    String? filePath,
    String? message,
  }) {
    return DownloadState(
      isVideoDownloading: isVideoDownloading ?? this.isVideoDownloading,
      isAudioDownloading: isAudioDownloading ?? this.isAudioDownloading,
      message: message ?? this.message,
    );
  }
}

class DownloadStateNotifier extends StateNotifier<DownloadState> {
  DownloadStateNotifier() : super(DownloadState());

  Future<void> downloadVideo(String url) async {
    state = state.copyWith(
        isVideoDownloading: true, message: "Downloading Video File...");
    final message = await VideoDownloadService().downloadVideo(url);

    state = state.copyWith(isVideoDownloading: false, filePath: message);
  }

  Future<void> downloadAudio(String url) async {
    state = state.copyWith(
        isAudioDownloading: true, message: "Downloading Audio File...");
    final message = await VideoDownloadService().downloadAudio(url);

    state = state.copyWith(isAudioDownloading: false, filePath: message);
  }
}
