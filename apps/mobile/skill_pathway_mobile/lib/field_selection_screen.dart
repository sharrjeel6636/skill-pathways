import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'quiz_model.dart';
import 'inter_guidance_screen.dart';

class FieldOption {
  final String name;
  final String careersText;
  final bool isRecommended;

  FieldOption({
    required this.name,
    required this.careersText,
    this.isRecommended = false,
  });
}

class FieldSelectionScreen extends StatefulWidget {
  final String recommendedField;

  const FieldSelectionScreen({
    super.key,
    required this.recommendedField,
  });

  @override
  State<FieldSelectionScreen> createState() => _FieldSelectionScreenState();
}

class _FieldSelectionScreenState extends State<FieldSelectionScreen> {
  late List<FieldOption> _options;
  int _selectedFieldIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // Define the 5 fields + 1 Vocational
    final fields = [
      {"name": "Pre-Engineering", "careers": "Engineering, Computer Science, Architecture", "match": "Science"},
      {"name": "Pre-Medical", "careers": "MBBS, Pharm-D, Nursing, Allied Health", "match": "Medicine"}, // Or Science
      {"name": "ICS (Computer Science)", "careers": "BSCS, Software Engineering, IT", "match": "ICS"}, // Or Science
      {"name": "Commerce", "careers": "BBA, ACCA, Banking, Business", "match": "Commerce"},
      {"name": "Arts / Humanities", "careers": "Law, Media, Psychology, Design", "match": "Arts"},
      {"name": "Vocational / Technical Training", "careers": "Leads to: Electrician, Plumbing, HVAC, Automotive, Tailoring, IT Support, Beautician and more — skilled trade certifications", "match": "Vocational"},
    ];

    _options = fields.map((f) {
      // Check if this field matches the recommended one from quiz
      // We'll do a simple match or check if the recommendedField contains keywords
      bool isRec = f['name'] == widget.recommendedField || 
                   (f['match'] != null && widget.recommendedField.contains(f['match']!));
      
      // If quiz says "Science", we recommend "Pre-Engineering" by default in this logic
      if (widget.recommendedField == "Science" && f['name'] == "Pre-Engineering") isRec = true;

      return FieldOption(
        name: f['name']!,
        careersText: "Leads to: ${f['careers']}",
        isRecommended: isRec,
      );
    }).toList();

    // Default selection to the recommended field
    _selectedFieldIndex = _options.indexWhere((opt) => opt.isRecommended);
    if (_selectedFieldIndex == -1) _selectedFieldIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadmapColors.bgLight,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                children: List.generate(_options.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildFieldCard(index),
                  );
                }),
              ),
            ),
          ),
          _buildBottomCTA(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(24, 56, 24, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose your Intermediate group",
          style: GoogleFonts.inter(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: RoadmapColors.textDark,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 20),
        Text(
          "Based on your quiz, we recommend ${widget.recommendedField}",
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: RoadmapColors.textMuted,
          ),
        ),
      ],
    ),
  );

  Widget _buildFieldCard(int index) {
    final option = _options[index];
    final isSelected = _selectedFieldIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedFieldIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? RoadmapColors.lightTeal : RoadmapColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? RoadmapColors.primaryTeal : RoadmapColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  option.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: RoadmapColors.textDark,
                  ),
                ),
                if (option.isRecommended)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: RoadmapColors.accentAmber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "RECOMMENDED",
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              option.careersText,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: RoadmapColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCTA() => Container(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
    child: GestureDetector(
      onTap: () {
        // Persist selection
        QuizState.fieldOfInterest = _options[_selectedFieldIndex].name;
        
        // Route to correct screen
        if (_options[_selectedFieldIndex].name == "Vocational / Technical Training") {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => VocationalPathScreen())
          );
        } else {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const InterGuidanceScreen())
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: RoadmapColors.primaryTeal,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            "Confirm Selection",
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}
