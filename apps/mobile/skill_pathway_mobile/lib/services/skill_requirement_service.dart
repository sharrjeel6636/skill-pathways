class SkillRequirementService {
  // Map of Roadmap Stage Title to list of required Course IDs
  final Map<String, List<String>> _roadmapStageSkills = {
    "Fundamentals": ["1", "2"],
    "Data Structures": ["3", "4"],
    "System Design": ["5"],
  };

  List<String> getRequiredSkillsForStage(String stageTitle) {
    return _roadmapStageSkills[stageTitle] ?? [];
  }
}
