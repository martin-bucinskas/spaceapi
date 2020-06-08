import space_api/models/transaction, space_api/database

when isMainModule:
  echo("Space API started...")
  let space_core_database: auto = db_init()

  var tx: Transaction = tx_getTransactionById(space_core_database, 1)
  echo(tx)

  var test_insert_tx: Transaction = createNewTransaction(10, "08/06/2020", 29.99, "Pizza Hut", 1)
  var inserted_id: int64 = tx_insertTransaction(space_core_database, test_insert_tx)

  if inserted_id == -1:
    echo("Failed to insert")
  else:
    echo(inserted_id)

  db_close(space_core_database)
