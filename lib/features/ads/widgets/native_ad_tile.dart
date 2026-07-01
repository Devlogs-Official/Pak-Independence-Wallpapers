import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pakistani_independence_wallpapers/services/ad_service.dart';

class NativeAdTile extends StatefulWidget {
  const NativeAdTile({super.key, this.height = 360});

  final double height;

  @override
  State<NativeAdTile> createState() => _NativeAdTileState();
}

class _NativeAdTileState extends State<NativeAdTile> {
  NativeAd? _ad;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  Future<void> _loadAd() async {
    final ad = await AppAdService.instance.loadNativeAd();
    if (!mounted) {
      ad?.dispose();
      return;
    }

    if (ad == null) return;
    setState(() {
      _ad = ad;
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _ad == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x22000000)),
          ),
          child: AdWidget(ad: _ad!),
        ),
      ),
    );
  }
}
