import db_postgres, strutils

type
  TransactionLog* = object
    id*: int
    bank_account_id*: int
    credit_account_id*: int
    savings_account_id*: int

proc createNewTransactionLog*(id: int, bank_account_id: int, credit_account_id: int, savings_account_id: int): TransactionLog =
    result = TransactionLog(
        id: id,
        bank_account_id: bank_account_id,
        credit_account_id: credit_account_id,
        savings_account_id: savings_account_id
    )

proc rowToTransactionLog(row: Row): TransactionLog =
  result = createNewTransactionLog(parseInt(row[0]), parseInt(row[1]), parseInt(row[2]), parseInt(row[3]))

proc tx_log_getAll*(db: DbConn): seq[TransactionLog] =
  var rows: seq[Row] = db.getAllRows(sql"SELECT * FROM space_core.transaction_log")

  for row in rows:
    result.add(rowToTransactionLog(row))

proc tx_log_getTransactionLogById*(db: DbConn, id: int): TransactionLog =
  var row: Row = db.getRow(sql"SELECT * FROM space_core.transaction_log WHERE (id = ?)", id)
  result = rowToTransactionLog(row)

proc tx_log_insertTransactionLog*(db: DbConn, tx_log: TransactionLog): int64 =
  var id: int64 = db.tryInsertID(
    sql"INSERT INTO space_core.transaction_log(bank_account_id, credit_account_id, savings_account_id) VALUES (?, ?, ?)",
    tx_log.bank_account_id, tx_log.credit_account_id, tx_log.savings_account_id
  )
  return id
