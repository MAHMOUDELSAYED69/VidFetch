import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vid_fetch/utils/extentions/extentions.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoDownloadService {
  final YoutubeExplode _youtubeExplode = YoutubeExplode();

  Future<String> downloadVideo(String videoUrl,
      {String quality = 'high'}) async {
    try {
      final videoId = VideoId(videoUrl);
      final video = await _youtubeExplode.videos.get(videoId);
      final manifest =
          await _youtubeExplode.videos.streamsClient.getManifest(videoId);

      StreamInfo? streamInfo;
      switch (quality) {
        case '1080p':
          streamInfo = manifest.muxed.firstWhereOrNull(
              (stream) => stream.videoQuality == VideoQuality.high1080);
          break;
        case '720p':
          streamInfo = manifest.muxed.firstWhereOrNull(
              (stream) => stream.videoQuality == VideoQuality.high720);
          break;
        case '480p':
          streamInfo = manifest.muxed.firstWhereOrNull(
              (stream) => stream.videoQuality == VideoQuality.medium480);
          break;
        case '360p':
          streamInfo = manifest.muxed.firstWhereOrNull(
              (stream) => stream.videoQuality == VideoQuality.medium360);
          break;
        case '240p':
          streamInfo = manifest.muxed.firstWhereOrNull(
              (stream) => stream.videoQuality == VideoQuality.low240);
          break;
        case '144p':
          streamInfo = manifest.muxed.firstWhereOrNull(
              (stream) => stream.videoQuality == VideoQuality.low144);
          break;
        case 'highest':
        default:
          streamInfo = manifest.muxed.withHighestBitrate();
          break;
      }

      streamInfo ??= manifest.muxed.withHighestBitrate();

      final filePath = await _getFilePath(video.title, 'mp4');
      if (filePath == null) {
        return "File path not selected";
      }

      final fileStream = File(filePath).openWrite();
      final videoStream = _youtubeExplode.videos.streamsClient.get(streamInfo);

      await videoStream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();

      if (Platform.isAndroid) {
        await ImageGallerySaver.saveFile(filePath);
        log('Video downloaded and saved to gallery: $filePath');
        return "Downloaded and saved to gallery";
      } else {
        log('Video downloaded: $filePath');
        return "Downloaded to $filePath";
      }
    } on YoutubeExplodeException catch (err) {
      log(err.toString());
      return "Invalid YouTube video ID or URL";
    } catch (err) {
      log(err.toString());
      return "Failed to download video";
    }
  }

  Future<String> downloadAudio(String videoUrl,
      {String quality = 'high'}) async {
    try {
      final videoId = VideoId(videoUrl);
      final video = await _youtubeExplode.videos.get(videoId);
      final manifest =
          await _youtubeExplode.videos.streamsClient.getManifest(videoId);

      StreamInfo? streamInfo;
      switch (quality) {
        case 'high':
          streamInfo = manifest.audioOnly.withHighestBitrate();
          break;
        case 'medium':
          streamInfo = manifest.audioOnly.withHighestBitrate();
          break;
        case 'low':
          streamInfo = manifest.audioOnly.withHighestBitrate();
          break;
        default:
          streamInfo = manifest.audioOnly.withHighestBitrate();
          break;
      }

      final filePath = await _getAudioFilePath(video.title, 'mp3');
      if (filePath == null) {
        return "File path not selected";
      }

      final fileStream = File(filePath).openWrite();
      final audioStream = _youtubeExplode.videos.streamsClient.get(streamInfo);

      await audioStream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();
      log('Audio downloaded: $filePath');
      return "Audio downloaded and saved to $filePath";
    } on YoutubeExplodeException catch (err) {
      log(err.toString());
      return "Invalid YouTube video ID or URL";
    } catch (err) {
      log(err.toString());
      return "Failed to download audio";
    }
  }

  Future<String?> _getAudioFilePath(String title, String extension) async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      final musicDir = Directory('${directory?.path}/Music');
      if (!await musicDir.exists()) {
        await musicDir.create(recursive: true);
      }
      return '${musicDir.path}/Vid_Fetch_${title.replaceAll(' ', '_')}.$extension';
    } else if (Platform.isWindows) {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'Vid_Fetch_${title.replaceAll(' ', '_')}.$extension',
      );

      if (result != null) {
        return result;
      } else {
        log('User canceled the picker');
        return null;
      }
    } else {
      throw UnsupportedError('This platform is not supported');
    }
  }

  Future<String?> _getFilePath(String title, String extension) async {
    if (Platform.isAndroid) {
      final directory = await getTemporaryDirectory();
      return '${directory.path}/Vid_Fetch_${title.replaceAll(' ', '_')}.$extension';
    } else if (Platform.isWindows) {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'Vid_Fetch_${title.replaceAll(' ', '_')}.$extension',
      );

      if (result != null) {
        return result;
      } else {
        log('User canceled the picker');
        return null;
      }
    } else {
      throw UnsupportedError('This platform is not supported');
    }
  }
}
