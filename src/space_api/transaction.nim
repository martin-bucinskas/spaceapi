import db_postgres, strutils

type
  Transaction* = object
    id*: int
    tx_ref*: string
    tx_amount*: float
    tx_date*: string
    tx_log_id*: int

#[
  createNewTransaction:
    id: int - id of transaction
    tx_date: string - date of transaction
    tx_amount: float - amount of transaction
    tx_ref: string - reference of transaction
    tx_log_id: int - log id that transaction is assigned to
  returns:
    tx: Transaction - returns a transaction data type.

  A helper function to create a transaction.
]#
proc createNewTransaction*(id: int, tx_date: string, tx_amount: float, tx_ref: string, tx_log_id: int): Transaction =
    result = Transaction(
        id: id,
        tx_date: tx_date,
        tx_amount: tx_amount,
        tx_ref: tx_ref,
        tx_log_id: tx_log_id
    )

#[
  rowToTransaction:
    row: Row - row representation of a transaction
  returns:
    tx: Transaction - returns a transaction data type.

  A helper function to parse a row to a transaction type.
]#
proc rowToTransaction(row: Row): Transaction =
  result = createNewTransaction(parseInt(row[0]), row[1], parseFloat(row[2]), row[3], parseInt(row[4]))

#[
  tx_getAll:
    db: DbConn - database connection
  returns:
    rows: seq[Transaction] - returns all transactions as a sequence.

  Retrieves all transactions from the database.
]#
proc tx_getAll*(db: DbConn): seq[Transaction] =
  var rows: seq[Row] = db.getAllRows(sql"SELECT * FROM space_core.transaction")

  for row in rows:
    result.add(rowToTransaction(row))

#[
  tx_getTransactionById:
    db: DbConn - database connection
    id: int - id of the row to fetch
  returns:
    tx: Transaction - returns a transaction.

  Retrieves a transaction by id from the database.
]#
proc tx_getTransactionById*(db: DbConn, id: int): Transaction =
  var row: Row = db.getRow(sql"SELECT * FROM space_core.transaction WHERE (id = ?)", id)
  result = rowToTransaction(row)

#[
  tx_insertTransaction:
    db: DbConn - database connection
    tx: Transaction - transaction to insert
  returns:
    id: int64 - returns either the inserted row id or if it fails returns a -1.

  Inserts a transaction row to the database.
]#
proc tx_insertTransaction*(db: DbConn, tx: Transaction): int64 =
  var id: int64 = db.tryInsertID(
    sql"INSERT INTO space_core.transaction(tx_date, tx_amount, tx_ref, tx_log_id) VALUES (?, ?, ?, ?)",
    tx.tx_date, tx.tx_amount, tx.tx_ref, tx.tx_log_id
  )
  return id
