import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface Item { 'id' : bigint, 'name' : string, 'completed' : boolean }
export interface _SERVICE {
  'addItem' : ActorMethod<[string], bigint>,
  'deleteItem' : ActorMethod<[bigint], boolean>,
  'getAllItems' : ActorMethod<[], Array<Item>>,
  'updateItemStatus' : ActorMethod<[bigint, boolean], boolean>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
