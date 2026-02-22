import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:ai_heracle_fit/core/theme.dart';

class FoodAnalysisScreen extends StatefulWidget {
  const FoodAnalysisScreen({super.key});

  @override
  State<FoodAnalysisScreen> createState() => _FoodAnalysisScreenState();
}

class _FoodAnalysisScreenState extends State<FoodAnalysisScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  XFile? _capturedImage;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isAnalyzing = false;
  String? _analysisResult;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      setState(() {
        _capturedImage = image;
      });
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<void> _analyzeFood() async {
    if (_capturedImage == null) return;

    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          _capturedImage!.path,
          filename: 'food_image.webp',
        ),
        'description': _descriptionController.text.isEmpty
            ? 'food item'
            : _descriptionController.text,
      });

      final response = await dio.post(
        'http://localhost:3000/api/calai/analyze',
        data: formData,
        options: Options(headers: {'accept': '*/*'}),
      );

      setState(() {
        _analysisResult = response.data.toString();
      });
    } catch (e) {
      setState(() {
        _analysisResult = "Error: $e";
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Food Analysis',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _capturedImage == null
          ? _buildCameraPreview()
          : _buildAnalysisView(),
    );
  }

  Widget _buildCameraPreview() {
    return Stack(
      children: [
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(child: CameraPreview(_controller!));
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: HeracleTheme.primaryPurple,
                ),
              );
            }
          },
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _takePicture,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              File(_capturedImage!.path),
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _descriptionController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Describe the food (e.g., Red Apple)',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isAnalyzing ? null : _analyzeFood,
            style: ElevatedButton.styleFrom(
              backgroundColor: HeracleTheme.primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isAnalyzing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Analyze Food',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => setState(() => _capturedImage = null),
            child: const Text(
              'Retake Photo',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          if (_analysisResult != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _analysisResult!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
