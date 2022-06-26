import 'package:flutter/material.dart';

enum PriorityEnum {
  low("low", Colors.green),
  medium("medium", Colors.yellow),
  high("high", Colors.red);

  final String value;
  final Color color;

  const PriorityEnum(this.value, this.color);

  static PriorityEnum getPriorityEnumFromString(String value) {
    switch (value) {
      case "low":
        return PriorityEnum.low;
      case "medium":
        return PriorityEnum.medium;
      case "high":
        return PriorityEnum.high;
      default:
        return PriorityEnum.low;
    }
  }
}
