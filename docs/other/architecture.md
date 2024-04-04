# Architecture

## Overview

This document describes the architecture of the system. It is intended to provide a high-level overview of the system's components and their interactions.

## Components

The system consists of the following components:
* Class File: Is a file with `.poodle` extension that contains all the files for a class to be read by the POODLE Player. It is internally a `.pck` file that contains the class files and the resources. See [Class File](class_file.md) for more information on the file format.
* Parser: Reads the class file and creates a class Resource that can be used by the POODLE Player.
* Class Resource: Represents a class that can be played by the POODLE Player. It contains all the resources and entities needed to play the class.
* Class Scene: Represents the playable class as a scene in the POODLE Player. It contains all the nodes ready to play the class.
* Class Player: Plays the class scene in the POODLE Player. It is responsible for managing the class scene and the player's interactions with it.

## Interactions and flow

The following diagram shows the interactions between the components of the system to load and play a class:
