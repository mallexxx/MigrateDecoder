# MigrateDecoder

MigrateDecoder is an implementation of the [Schema Migration](https://en.wikipedia.org/wiki/Schema_migration) for [Swift 4 Codable](https://developer.apple.com/documentation/swift/codable) protocol.

## Background

Suppose you've had a JSON data model in your app. You store the model in a JSON file, you use the new gorgeous Swift Codable protocol for serialization/deserialization and everything is beautiful.
But one day you want to modify your model structure, here comes a tough choice:
- To throw away all the user's data and begin from scratch
- To introduce some Optional values in your new model and live with that
- To use Schema Migration

If you go with the third option, it also introduces several ways to go:
- To parse your old JSON into a dictionary and update the structure manually, then save it back and read into the new structure
- To implement some kind of Schema Migration Tool
- To use the MigrateDecoder framework 😀

## Usage

1. Add MigrateDecoder framework to your project

2. When you make changes to your Model, save the old one with some modified name e.g. MyOldModel

3. Add migration extension to your Old Model and the New Model:
```swift
import ModelMigrate

extension MyOldModel: NotMigratable {}

extension NewModel: Migratable {
    typealias MigratableFrom = MyOldModel

    init(migrating old: MyOldModel) throws {
        // Do the migration here
    }
}
```

4. That's it!

See the tests included for a Demo!
