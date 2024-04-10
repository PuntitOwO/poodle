# Class Files

This document describes the class files used by the POODLE Player. A class file is a file with `.poodle` extension that contains all the files for a class to be read by the POODLE Player. It is internally a `zip` file that contains the class files and the resources.

## File structure

A class file has the following structure:

```
class.poodle:
├── index.json
└── resources/
    ├─ audio/
    ├─ video/
    └─ custom/
```

The `.poodle` file is a `zip` file that contains an `index.json` file and a `resources` directory. The `resources` directory contains folders for the audio, video, and custom resources used by the class.

## Index file

The `index.json` file is a JSON file that contains the metadata of the class. The schema of the `index.json` file is available in the [Class Index Schema](index_schema.json) file. A summary of the schema is as follows:

```json

{
  "entities": [...],
  "metadata": {...},
  "sections": [...],
}

```
Where `metadata` is the metadata of the class. A sample `metadata` object is as follows:

```json
{
  "author_description": "The author of Poodle\nhttps://puntito.cl",
  "author_name": "Christopher Marin",
  "course": "CC0000 Sample course",
  "date": 1711065600,
  "description": "A sample class",
  "editor_version": "v1.0.0",
  "file_version": "v1.0.0",
  "license": "res://concept/resources/LICENSE.md",
  "name": "Sample class"
}
```

`entities` is a list of the entities used in the class. An entity is a resource used in the class, such as text, an audio file, an image, or other custom resources. A sample `entities` object is as follows:

```json
[
  {
    "audio_path": "resources/audio/0.ogg",
    "entity_type": "AudioEntity"
  },
  {
    "entity_type": "ImageEntity",
    "image_path": "resources/video/1.png"
  },
  {
    "entity_type": "LineEntity",
    "points": [
      {
        "x": 25,
        "y": 0
      },
      {
        "x": 25,
        "y": 50
      }
    ]
  },
  {
    "entity_type": "PausePlaybackControlEntity"
  },
]
```

This sample `entities` object has an audio entity, an image entity, a line entity, and a  playback control entity.
Entities in `entities` object SHOULD be unique, as they can be pointed to by many `EntityPointers` (`ContentRootEntity` in the schema).

`sections` is a list of the sections in the class. A section is a part of the class that contains slides. A sample `sections` object is as follows:

```json
[
  {
    "name": "First section",
    "slides": [...]
  },
  {
    "name": "Second section",
    "slides": [...]
  }
]
```

A slide is a part of the section that contains entities. A sample `slides` object is as follows:

```json
{
  "content_root": {...},
  "name": "First slide"
}
```

A slide has a `name` and a `content_root` object. The `content_root` object is a `group` object. A group is a container of other groups or EntityPointers. A group MUST NOT have both groups and entities. A sample `group` object is as follows:

```json
{
  "entities": [...],
  "group_type": "ClassChainGroup",
  "groups": [...]
}
```

This `entities` object is a list of EntityPointers. An EntityPointer is a reference to an entity in the main `entities` object. A sample `entities` object is as follows:

```json
[
  {
    "entity_id": 0,
    "entity_properties": [...]
  },
  {
    "entity_id": 1,
    "entity_properties": [...]
  }
]
```

An EntityPointer has an `entity_id` that points to an entity in the main `entities` object and `entity_properties` that are the properties of the entity. `entity_properties` CAN be empty or can contain properties that modify the entity. A sample `entity_properties` object is as follows:

```json
[
  {
    "position:x": 300,
    "position:y": 100,
    "property_type": "PositionEntityProperty"
  },
  {
    "property_type": "SizeEntityProperty",
    "size:x": 300,
    "size:y": 300
  }
]
```

This sample `entity_properties` object has a `PositionEntityProperty` and a `SizeEntityProperty` that modify the properties this ``entity`` has in the current `group`.