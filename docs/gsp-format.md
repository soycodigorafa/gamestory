# GameStory Project Format (.gsp)

## Overview

A `.gsp` file is a **GameStory Project** archive — a single JSON document that captures a complete project, including all its NPCs, dialogue graphs, requirement flags, and reward flags. It is used for backup, sharing, and migration between devices.

## File Extension & MIME Type

| Property   | Value                |
|------------|----------------------|
| Extension  | `.gsp`               |
| MIME type  | `application/json`   |
| Encoding   | UTF-8                |

## Top-Level Fields

| Field           | Type     | Required | Description                                           |
|-----------------|----------|----------|-------------------------------------------------------|
| `schemaVersion` | `int`    | Yes      | Format version. Currently `1`.                        |
| `exportedAt`    | `string` | Yes      | ISO-8601 UTC timestamp of when the file was created.  |
| `project`       | object   | Yes      | Project metadata. See [Project Object](#project-object). |
| `npcs`          | array    | Yes      | List of NPC objects. See [NPC Object](#npc-object).   |

## Project Object

| Field         | Type     | Required | Description                     |
|---------------|----------|----------|---------------------------------|
| `name`        | `string` | Yes      | Human-readable project name.    |
| `description` | `string` | No       | Optional project description.   |

## NPC Object

| Field         | Type     | Required | Description                                         |
|---------------|----------|----------|-----------------------------------------------------|
| `id`          | `string` | Yes      | Original NPC ID (used for internal cross-references).|
| `name`        | `string` | Yes      | NPC display name.                                   |
| `description` | `string` | No       | Optional NPC description.                           |
| `colorHex`    | `string` | Yes      | Accent colour in `#RRGGBB` format.                  |
| `canvasX`     | `number` | Yes      | Horizontal canvas position.                         |
| `canvasY`     | `number` | Yes      | Vertical canvas position.                           |
| `nodes`       | array    | Yes      | Dialogue node objects. See [Node Object](#node-object). |
| `choices`     | array    | Yes      | Dialogue choice objects. See [Choice Object](#choice-object). |
| `requirementFlags` | array | Yes  | Requirement flag objects. See [RequirementFlag Object](#requirementflag-object). |
| `rewardFlags` | array    | Yes      | Reward flag objects. See [RewardFlag Object](#rewardflag-object). |

## Node Object

| Field          | Type      | Required | Description                                     |
|----------------|-----------|----------|-------------------------------------------------|
| `id`           | `string`  | Yes      | Original node ID.                               |
| `speakerName`  | `string`  | Yes      | Name of the character speaking.                 |
| `dialogueText` | `string`  | Yes      | The spoken dialogue line.                       |
| `isStart`      | `boolean` | Yes      | Whether this is the entry point of the dialogue.|
| `layoutX`      | `number`  | Yes      | Horizontal position on the dialogue canvas.     |
| `layoutY`      | `number`  | Yes      | Vertical position on the dialogue canvas.       |

## Choice Object

| Field        | Type            | Required | Description                                        |
|--------------|-----------------|----------|----------------------------------------------------|
| `id`         | `string`        | Yes      | Original choice ID.                                |
| `fromNodeId` | `string`        | Yes      | ID of the source node.                             |
| `toNodeId`   | `string\|null`  | No       | ID of the destination node, or `null` if unlinked. |
| `choiceText` | `string`        | Yes      | The player-facing choice label.                    |
| `sortOrder`  | `int`           | Yes      | Display order among sibling choices (0-indexed).   |

## RequirementFlag Object

| Field           | Type      | Required | Description                                             |
|-----------------|-----------|----------|---------------------------------------------------------|
| `id`            | `string`  | Yes      | Original flag ID.                                       |
| `choiceId`      | `string`  | Yes      | ID of the choice this flag gates.                       |
| `flagName`      | `string`  | Yes      | Name of the game flag to check.                         |
| `requiredValue` | `boolean` | Yes      | The value the flag must have for the choice to appear.  |

## RewardFlag Object

| Field      | Type      | Required | Description                                      |
|------------|-----------|----------|--------------------------------------------------|
| `id`       | `string`  | Yes      | Original flag ID.                                |
| `nodeId`   | `string`  | Yes      | ID of the node that triggers this reward.        |
| `flagName` | `string`  | Yes      | Name of the game flag to set.                    |
| `setValue` | `boolean` | Yes      | The value the flag is set to when node is reached.|

## Version Compatibility

| `schemaVersion` | Supported | Notes                       |
|-----------------|-----------|-----------------------------|
| `1`             | ✅ Yes    | Current version.            |
| Other           | ❌ No     | Import will throw `FormatException`. |

On import, if `schemaVersion` is missing or not `1`, a `FormatException` is thrown with a descriptive message.

## Annotated Example

```json
{
  "schemaVersion": 1,
  "exportedAt": "2025-06-01T12:00:00.000Z",
  "project": {
    "name": "Fantasy RPG",
    "description": "A classic high-fantasy adventure."
  },
  "npcs": [
    {
      "id": "npc-abc123",
      "name": "Village Elder",
      "description": "A wise and weathered guide.",
      "colorHex": "#7B61FF",
      "canvasX": 120.0,
      "canvasY": 80.0,
      "nodes": [
        {
          "id": "node-001",
          "speakerName": "Village Elder",
          "dialogueText": "Welcome, traveller. The path ahead is dangerous.",
          "isStart": true,
          "layoutX": 80.0,
          "layoutY": 80.0
        },
        {
          "id": "node-002",
          "speakerName": "Village Elder",
          "dialogueText": "Safe travels. May fortune favour you.",
          "isStart": false,
          "layoutX": 80.0,
          "layoutY": 320.0
        }
      ],
      "choices": [
        {
          "id": "choice-001",
          "fromNodeId": "node-001",
          "toNodeId": "node-002",
          "choiceText": "I understand. I'll be careful.",
          "sortOrder": 0
        }
      ],
      "requirementFlags": [
        {
          "id": "req-001",
          "choiceId": "choice-001",
          "flagName": "received_map",
          "requiredValue": true
        }
      ],
      "rewardFlags": [
        {
          "id": "rew-001",
          "nodeId": "node-002",
          "flagName": "elder_spoken",
          "setValue": true
        }
      ]
    }
  ]
}
```

## Notes

- **IDs are remapped on import**: all `id` fields in the file are original export-time IDs used only for internal cross-references during import. New UUIDs are assigned to every entity when the file is imported into a project.
- **Multiple NPCs**: the `npcs` array can contain any number of NPC objects; all are imported into the same new project.
- **Empty projects**: a `.gsp` file with an empty `npcs` array is valid and creates an empty project.
