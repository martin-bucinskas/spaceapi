import space_api/transaction, space_api/database

proc loadTransactions(): Transaction =
  var transactions: Transaction = createNewTransaction(1, "deliveroo payment for pizza", 23.33, "05/06/20")
  return transactions

when isMainModule:
  echo("Space API started...")
  let space_core_database: auto = db_init()

  echo(loadTransactions())
  let version: string = db_get_version(space_core_database)
  
  echo(version)

  db_close(space_core_database)
