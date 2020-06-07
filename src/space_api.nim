import space_api/transaction

proc loadTransactions(): void =
  var transactions: Transaction = createNewTransaction(1, "deliveroo payment for pizza", 23.33, "05/06/20")
  echo(transactions)

when isMainModule:
  echo("Space API started...")
  loadTransactions()
