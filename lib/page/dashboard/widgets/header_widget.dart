import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/core/models/user_profile.dart';
import 'package:ai_heracle_fit/core/services/user_service.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  UserProfile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await UserService.instance.fetchProfile();
    if (mounted) {
      setState(() {
        _profile = profile;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Avatar ──────────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                HeracleTheme.primaryPurple,
                HeracleTheme.primaryPurple.withOpacity(0.5),
              ],
            ),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: HeracleTheme.primaryPurple.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: _loading
              ? const _SkeletonCircle(radius: 26)
              : CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFE8E4FD),
                  backgroundImage: (_profile?.avatarUrl?.isNotEmpty == true)
                      ? NetworkImage(_profile!.avatarUrl!)
                      : null,
                  child:
                      (_profile?.avatarUrl == null ||
                          _profile!.avatarUrl!.isEmpty)
                      ? Text(
                          _profile?.name.isNotEmpty == true
                              ? _profile!.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: HeracleTheme.primaryPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      : null,
                ),
        ),
        const SizedBox(width: 16),

        // ── Name + HERACLE tag + subtitle ───────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _loading
                      ? const _SkeletonBox(width: 120, height: 18)
                      : Flexible(
                          child: Text(
                            _toTitleCase(_profile?.name ?? ''),
                            overflow: TextOverflow.ellipsis,
                            style: HeracleTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                  letterSpacing: -1,
                                ),
                          ),
                        ),
                  const SizedBox(width: 8),
                  // HERACLE Branding Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1B20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'HERACLE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              _loading
                  ? const _SkeletonBox(width: 140, height: 12)
                  : Text(
                      _profile?.subtitle ?? '',
                      style: const TextStyle(
                        color: HeracleTheme.textGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ],
          ),
        ),

        // ── Notification bell ───────────────────────────────────────────────
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: HeracleTheme.textBlack,
                  size: 26,
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD600),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Converts "SANJAY SAGAR" → "Sanjay Sagar"
  String _toTitleCase(String text) => text
      .split(' ')
      .map(
        (w) => w.isEmpty
            ? ''
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}',
      )
      .join(' ');
}

// ── Skeleton placeholders ─────────────────────────────────────────────────────

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  const _SkeletonBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(6),
    ),
  );
}

class _SkeletonCircle extends StatelessWidget {
  final double radius;
  const _SkeletonCircle({required this.radius});

  @override
  Widget build(BuildContext context) =>
      CircleAvatar(radius: radius, backgroundColor: Colors.black12);
}
