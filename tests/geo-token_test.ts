import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Test location recording",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "geo-token",
        "record-location",
        [types.uint(1), types.int(40000000), types.int(-74000000)],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    
    block.receipts[0].result.expectOk().expectBool(true);
  }
});

Clarinet.test({
  name: "Test access control",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    const wallet_2 = accounts.get("wallet_2")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "geo-token", 
        "grant-access",
        [types.principal(wallet_2.address)],
        wallet_1.address
      )
    ]);

    assertEquals(block.receipts.length, 1);
    block.receipts[0].result.expectOk().expectBool(true);
    
    let canView = chain.callReadOnlyFn(
      "geo-token",
      "can-view-location",
      [
        types.principal(wallet_1.address),
        types.principal(wallet_2.address)
      ],
      wallet_1.address
    );
    
    canView.result.expectBool(true);
  }
});
