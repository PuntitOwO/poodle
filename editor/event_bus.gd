class_name EditorEventBus
extends Node

#region class changed notification

## Emitted when a new [ClassIndex] is loaded.
signal class_index_changed(new_index: ClassIndex)

## Emitted when a new [ClassMetadata] is loaded.
signal class_metadata_changed(new_metadata: ClassMetadata)

## Emitted when a new script for the class is loaded.
signal class_script_changed(new_script: Array[ScriptEntry])

## Emitted when the list of entities in the editor changes.
## The new list of [Entity] objects is passed as an argument.
signal class_entities_changed(new_entities: Array[Entity])

## Emitted when the list of class sections changes.
## The new list of [ClassSection]s is passed as an argument.
signal class_sections_changed(new_sections: Array[ClassSection])

#endregion

#region class change request notification

## Emit when a new [ClassIndex] is requested to be loaded.
signal class_index_change_requested(new_index: ClassIndex)

## Emit when a new [ClassMetadata] is requested to be set.
signal class_metadata_change_requested(new_metadata: ClassMetadata)

## Emit when a new script for the class is requested to be set.
signal class_script_change_requested(new_script: Array[ScriptEntry])

## Emit when entities are requested to be added to the class.
## The [Entity] objects to be added are passed as an argument.
signal class_entities_add_requested(new_entities: Array[Entity])

## Emit when entities are requested to be removed from the class.
## The [Entity] objects to be removed are passed as an argument.
signal class_entities_remove_requested(remove_entities: Array[Entity])

## Emit when the list of class sections is requested to be set.
## The new list of [ClassSection]s is passed as an argument.
signal class_sections_change_requested(new_sections: Array[ClassSection])

#endregion
