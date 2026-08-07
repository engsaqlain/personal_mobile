import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';

// Simple model for one suggested outfit item, matching the documented
// AI Outfit Generator response shape (Section 10.2)
class OutfitItem {
  final String name;
  final int matchPercent;
  final String reason;

  OutfitItem({required this.name, required this.matchPercent, required this.reason});
}

class AiOutfitScreen extends StatefulWidget {
  const AiOutfitScreen({super.key});

  @override
  State<AiOutfitScreen> createState() => _AiOutfitScreenState();
}

class _AiOutfitScreenState extends State<AiOutfitScreen> {
  String _selectedOccasion = 'Casual';
  String _selectedSeason = 'Summer';

  bool _isLoading = false;
  List<OutfitItem>? _generatedOutfit;

  final List<String> _occasions = ['Casual', 'Business', 'Wedding', 'Party'];
  final List<String> _seasons = ['Summer', 'Winter', 'Spring', 'Autumn'];

  // Generates an outfit suggestion.
  // TODO: Replace this placeholder with a real call to
  // POST /api/ai/generate-outfit (Section 10.2) once Saman shares the
  // live API URL. Request should send { occasion, season }.
  void _generateOutfit() async {
    setState(() {
      _isLoading = true;
      _generatedOutfit = null;
    });

    // Placeholder delay to simulate an API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        // Placeholder suggestions - structure matches the real API response
        _generatedOutfit = [
          OutfitItem(name: 'Classic Blazer', matchPercent: 95, reason: 'Perfect for a $_selectedOccasion look'),
          OutfitItem(name: 'Tailored Trousers', matchPercent: 90, reason: 'Great $_selectedSeason pairing'),
          OutfitItem(name: 'Leather Loafers', matchPercent: 85, reason: 'Completes the outfit elegantly'),
        ];
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.elegantBlack),
        title: Text(
          'AI Outfit Generator',
          style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.elegantBlack),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Occasion',
                  style: GoogleFonts.inter(fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.elegantBlack)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children: _occasions.map((occasion) {
                  final bool isSelected = _selectedOccasion == occasion;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedOccasion = occasion),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.elegantBlack : Colors.transparent,
                        border: Border.all(color: AppColors.elegantBlack),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                          occasion,
                          style: GoogleFonts.inter(color: isSelected ? AppColors.white : AppColors.elegantBlack)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              Text('Season',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.elegantBlack)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _seasons.map((season) {
                  final bool isSelected = _selectedSeason == season;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSeason = season),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.elegantBlack : Colors.transparent,
                        border: Border.all(color: AppColors.elegantBlack),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(season,
                          style: GoogleFonts.inter(color: isSelected ? AppColors.white : AppColors.elegantBlack)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                    foregroundColor: AppColors.elegantBlack,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isLoading ? null : _generateOutfit,
                  child: _isLoading
                      ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.elegantBlack))
                      : Text('Generate Outfit', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 28),

              // Results
              if (_generatedOutfit != null) ...[
                Text('Suggested Outfit',
                    style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.elegantBlack)),
                const SizedBox(height: 12),
                ..._generatedOutfit!.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.softGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(item.reason,
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.darkGray)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.goldAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('${item.matchPercent}%',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.goldAccent)),
                      ),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}