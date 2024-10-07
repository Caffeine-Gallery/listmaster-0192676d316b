import Bool "mo:base/Bool";
import Hash "mo:base/Hash";
import List "mo:base/List";

import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Text "mo:base/Text";

actor ShoppingList {
  // Define the structure for a shopping list item
  public type Item = {
    id: Nat;
    name: Text;
    completed: Bool;
  };

  // Stable variable to store the next item ID
  private stable var nextId: Nat = 0;

  // Stable variable to store the items
  private stable var itemsEntries: [(Nat, Item)] = [];

  // Create a HashMap to store the items
  private var items = HashMap.HashMap<Nat, Item>(0, Nat.equal, Nat.hash);

  // Initialize the items HashMap from stable storage
  private func initItems() {
    items := HashMap.fromIter<Nat, Item>(itemsEntries.vals(), 0, Nat.equal, Nat.hash);
  };
  initItems();

  // Add a new item to the shopping list
  public func addItem(name: Text) : async Nat {
    let id = nextId;
    nextId += 1;
    let newItem: Item = {
      id = id;
      name = name;
      completed = false;
    };
    items.put(id, newItem);
    id
  };

  // Get all items in the shopping list
  public query func getAllItems() : async [Item] {
    Iter.toArray(items.vals())
  };

  // Update an item's completion status
  public func updateItemStatus(id: Nat, completed: Bool) : async Bool {
    switch (items.get(id)) {
      case (null) { false };
      case (?item) {
        let updatedItem: Item = {
          id = item.id;
          name = item.name;
          completed = completed;
        };
        items.put(id, updatedItem);
        true
      };
    }
  };

  // Delete an item from the shopping list
  public func deleteItem(id: Nat) : async Bool {
    switch (items.remove(id)) {
      case (null) { false };
      case (?_) { true };
    }
  };

  // System functions for upgrades
  system func preupgrade() {
    itemsEntries := Iter.toArray(items.entries());
  };

  system func postupgrade() {
    itemsEntries := [];
  };
}
