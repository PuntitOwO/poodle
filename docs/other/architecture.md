# Architecture

## Overview

This document describes the architecture of the system. It is intended to provide a high-level overview of the system's components and their interactions.

## Components

The system consists of the following components:
* Class File: Is a file with `.poodle` extension that contains all the files for a class to be read by the POODLE Player. It is internally a `zip` file that contains the class files and the resources. See [Class File](class_file.md) for more information on the file format.
* Parser: Reads the class file and creates a class Resource that can be used by the POODLE Player.
* Class Resource: Represents a class that can be played by the POODLE Player. It contains all the resources and entities needed to play the class.
* Class Scene: Represents the playable class as a scene in the POODLE Player. It contains all the nodes ready to play the class.
* Class Player: Plays the class scene in the POODLE Player. It is responsible for managing the class scene and the player's interactions with it.

## Interactions and flow

### Flow Overview

The following diagram shows an overview of the interactions between the components of the system to load and play a class:

```mermaid
---
title: Class loading and playing flow
---
%%{init: {"flowchart": {"htmlLabels": false}} }%%
flowchart TD
    subgraph ci[ClassIndex]
        direction LR
        resource[ClassIndex Resource] --> e(Entities) & g(Groups)
    end
    subgraph scene[ClassScene]
        direction LR
        s[Class Scene] 
        -. Sections<br>and Slides .-> w(Widgets)
    end
    file["`class.poodle file`"]
    index["`index.clsindex file`"]
    files[resource folders]
    
    file --> |ZIPReader.open|index & files
    index --> |ClassIndexResourceLoader._load|ci
    --> |ClassScene._instantiate|scene

```

This way, the flow of the system is as follows:
* The `class.poodle` file is read by the `ZIPReader` to get the `index.clsindex` file and the resource folders.
* The `index.clsindex` file is loaded by the `ClassIndexResourceLoader` to create a `ClassIndex` Resource object.
* The `ClassScene` is instantiated and receives the `ClassIndex` Resource, then uses it to instantiate the needed `Widgets` that are used to play the class.

### Detailed Flow

To explain a bit more the flow of the system, the following sections shows the detailed interactions in each step:

#### Class File Loading

The `class.poodle` file is a zip file that contains all the resources and files needed to play a class. The file is read by the [`ZIPReader` class](https://docs.godotengine.org/en/stable/classes/class_zipreader.html) that exposes functions that can extract individual files inside the zip archive.
The `ZIPReader` is used to extract the `index.clsindex` file first and it is sent to the resource loader step. The `ZipReader` instance is stored as it is used in a further step.

#### Class Index Resource Loading

