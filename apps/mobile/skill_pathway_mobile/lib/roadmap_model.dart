class RoadmapStageDetail {
  final String parentStageName;
  final int stageIndex; // 1-6
  final String title;
  final String description;
  final List<ActionItem> actionItems;
  final List<ResourceLink> resources;

  RoadmapStageDetail({
    required this.parentStageName,
    required this.stageIndex,
    required this.title,
    required this.description,
    required this.actionItems,
    required this.resources,
  });
}

class ActionItem {
  final String label;
  bool done;

  ActionItem({required this.label, this.done = false});
}

class ResourceLink {
  final String label;
  final String url;
  final bool isExternal;

  ResourceLink({required this.label, required this.url, this.isExternal = true});
}

class RoadmapState {
  static final Map<String, List<bool>> _actionItemProgress = {};

  static void saveProgress(String stageTitle, List<ActionItem> items) {
    _actionItemProgress[stageTitle] = items.map((e) => e.done).toList();
  }

  static void loadProgress(String stageTitle, List<ActionItem> items) {
    if (_actionItemProgress.containsKey(stageTitle)) {
      final progress = _actionItemProgress[stageTitle]!;
      for (int i = 0; i < items.length && i < progress.length; i++) {
        items[i].done = progress[i];
      }
    }
  }
}
